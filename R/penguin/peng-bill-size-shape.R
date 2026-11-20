#' ---
#' title: Penguin bills -- replacing length & depth by size & shape
#' author: Michael Friendly
#' ---

# Idea: bill_length and bill_depth are both "how big is the bill" measures, strongly
# correlated within species. A more interpretable pair might be
#   size  = length * depth   (roughly the area of the bill profile)
#   shape = length / depth   (elongation: long & thin vs short & stubby)
# On the log scale these are
#   log size  = log(L) + log(D)
#   log shape = log(L) - log(D)
# i.e., just a 45 degree rotation (times sqrt(2)) of the (log L, log D) space.
# So multivariate tests are unchanged; what changes is what the *axes* mean, and whether
# the within-group variation lines up with them.

library(dplyr)
library(tidyr)
library(ggplot2)
library(patchwork)
library(car)
library(heplots)

data(peng, package = "heplots")
source("R/penguin/penguin-colors.R")

theme_set(theme_bw(base_size = 14))

peng <- peng |>
  mutate(
    size       = bill_length * bill_depth,
    shape      = bill_length / bill_depth,
    log_length = log(bill_length),
    log_depth  = log(bill_depth),
    log_size   = log_length + log_depth,
    log_shape  = log_length - log_depth,
    log_mass   = log(body_mass)
  )

peng |>
  group_by(species) |>
  summarise(across(c(size, shape, log_size, log_shape), mean))

# Direct labels for species, placed at the species means of x & y.
# `by` adds any faceting variables so each panel gets its own labels.
species_labels <- function(x, y, data = peng, by = NULL, size = 5) {
  means <- data |>
    group_by(species, across(all_of(by))) |>
    summarise(x = mean({{ x }}), y = mean({{ y }}), .groups = "drop")
  geom_label(data = means, aes(x = x, y = y, label = species, color = species),
             fill = "white", alpha = 0.75, size = size, fontface = "bold",
             inherit.aes = FALSE)
}

# A common plot template: points, 68% & 95% data ellipses, within-species lm lines,
# plus the pooled (ignoring species) lm line, dashed. Species are labeled directly.
peng_plot <- function(x, y, data = peng, pooled = TRUE, by = NULL) {
  p <- ggplot(data, aes(x = {{ x }}, y = {{ y }},
                        color = species, shape = species, fill = species)) +
    geom_point(size = 1.5, alpha = 0.6) +
    stat_ellipse(geom = "polygon", level = 0.68, alpha = 0.15) +
    stat_ellipse(geom = "polygon", level = 0.95, alpha = 0.10) +
    geom_smooth(method = "lm", formula = y ~ x, se = FALSE, linewidth = 1.5) +
    theme_penguins("dark") +
    theme(legend.position = "none")
  if (pooled)
    p <- p + geom_smooth(aes(x = {{ x }}, y = {{ y }}), inherit.aes = FALSE,
                         method = "lm", formula = y ~ x,
                         se = FALSE, color = "black", linetype = "dashed",
                         linewidth = 1)
  p + species_labels({{ x }}, {{ y }}, data = data, by = by)
}

#' ## 1. The original space vs. the size/shape space

p1 <- peng_plot(bill_length, bill_depth) +
  labs(x = "Bill length (mm)", y = "Bill depth (mm)", title = "Length & depth")

p2 <- peng_plot(log_size, log_shape) +
  labs(x = "log Size = log(L x D)", y = "log Shape = log(L / D)",
       title = "Size & shape (log scale)")

p1 + p2

# Raw (unlogged) version: nearly the same picture over this range
peng_plot(size, shape) +
  labs(x = "Size = L x D (mm^2)", y = "Shape = L / D",
       title = "Size & shape (raw scale)")

# Show that size/shape is a rotation of log L, log D: draw the size & shape
# axes as iso-lines in the (log L, log D) plot, at round values of L x D and L / D
iso_size  <- tibble(size  = seq(400, 1200, by = 100), k = log(size))   # log size contours
iso_shape <- tibble(shape = seq(1.5, 4, by = 0.5),   k = log(shape))   # log shape contours

# label a couple of lines of each kind, placed (by y) in empty space near the
# top edge (size) and lower left (shape)
lab_size  <- iso_size  |> filter(size %in% c(800, 1000)) |>
  mutate(y = 3.06, x = k - y, label = paste0("L x D = ", size))
lab_shape <- iso_shape |> filter(shape %in% c(2.5, 3)) |>
  mutate(y = c(2.60, 2.55), x = k + y, label = paste0("L / D = ", shape))

peng_plot(log_length, log_depth, pooled = FALSE) +
  geom_abline(data = iso_size, aes(intercept = k, slope = -1),
              color = "gray50", linewidth = 0.7, inherit.aes = FALSE) +
  geom_abline(data = iso_shape, aes(intercept = -k, slope = 1),
              color = "gray50", linewidth = 0.7, linetype = "dashed",
              inherit.aes = FALSE) +
  geom_label(data = lab_size, aes(x = x, y = y, label = label), angle = -45,
             size = 3.5, color = "gray30", fill = "white", linewidth = 0,
             inherit.aes = FALSE) +
  geom_label(data = lab_shape, aes(x = x, y = y, label = label), angle = 45,
             size = 3.5, color = "gray30", fill = "white", linewidth = 0,
             inherit.aes = FALSE) +
  coord_equal(xlim = c(3.44, 4.12), ylim = c(2.50, 3.10), expand = FALSE) +
  labs(x = "log Bill length", y = "log Bill depth",
       title = "Solid gray: constant size;  dashed: constant shape")

#' ## 2. Within-species correlations
# In (L, D) the within-species correlations are positive, overall correlation negative
# (Simpson's paradox). Does size/shape make the within-species variables closer to
# uncorrelated, i.e., more nearly separate dimensions?

within_r <- function(x, y)
  peng |>
    group_by(species) |>
    summarise(r = cor({{ x }}, {{ y }})) |>
    bind_rows(tibble(species = "(pooled)", r = cor(pull(peng, {{ x }}), pull(peng, {{ y }}))))

full_join(within_r(bill_length, bill_depth) |> rename(r_LD = r),
          within_r(log_size, log_shape)     |> rename(r_SizeShape = r),
          by = "species")

# Within-species PCA of (log L, log D): if PC1 lies near (1, 1)/sqrt(2), the
# dominant within-species variation is "size" and size/shape is a natural basis
peng |>
  group_by(species) |>
  group_modify(~ {
    e <- eigen(cov(cbind(.x$log_length, .x$log_depth)))
    v <- e$vectors[, 1] * sign(e$vectors[1, 1])
    tibble(PC1_L = v[1], PC1_D = v[2],
           pct_var = 100 * e$values[1] / sum(e$values),
           angle = atan2(v[2], v[1]) * 180 / pi)   # 45 = pure size direction
  })

# Show this: center each species at its means, so only within-species variation
# remains. Draw 68% data ellipses and each species' PC1 axis (+/- 2 SD) against
# the size direction (slope +1, dashed as in the rotation plot) and the shape
# direction (slope -1, solid)
peng_c <- peng |>
  group_by(species) |>
  mutate(c_length = log_length - mean(log_length),
         c_depth  = log_depth  - mean(log_depth)) |>
  ungroup()

pc1 <- peng_c |>
  group_by(species) |>
  group_modify(~ {
    e <- eigen(cov(cbind(.x$c_length, .x$c_depth)))
    v <- e$vectors[, 1] * sign(e$vectors[1, 1])
    r <- 2 * sqrt(e$values[1])
    tibble(x = -r * v[1], y = -r * v[2], xend = r * v[1], yend = r * v[2],
           angle = atan2(v[2], v[1]) * 180 / pi)
  }) |>
  ungroup() |>
  mutate(label = sprintf("%s: %.0f°", species, angle),
         # the PC1 axes nearly coincide, so stack their labels in the lower right
         lab_x = 0.15, lab_y = -0.04 - 0.035 * (row_number() - 1))

ggplot(peng_c, aes(x = c_length, y = c_depth, color = species, fill = species)) +
  geom_abline(slope =  1, intercept = 0, color = "gray50", linewidth = 0.7,
              linetype = "dashed") +
  geom_abline(slope = -1, intercept = 0, color = "gray50", linewidth = 0.7) +
  annotate("text", x = -0.15, y = -0.15, label = "size direction", angle = 45,
           vjust = -0.5, color = "gray30", size = 4.5) +
  annotate("text", x = -0.13, y = 0.13, label = "shape direction", angle = -45,
           vjust = -0.5, color = "gray30", size = 4.5) +
  geom_point(size = 1, alpha = 0.5) +
  stat_ellipse(geom = "polygon", level = 0.68, alpha = 0.05, linewidth = 1) +
  geom_segment(data = pc1, aes(x = x, y = y, xend = xend, yend = yend),
               linewidth = 1.5, inherit.aes = FALSE,
               color = peng.colors("dark")[as.character(pc1$species)]) +
  geom_label(data = pc1, aes(x = lab_x, y = lab_y, label = label, color = species),
             fill = "white", size = 4.5, fontface = "bold",
             hjust = 0, inherit.aes = FALSE) +
  annotate("text", x = 0.15, y = -0.04 + 0.035, label = "PC1 angle",
           hjust = 0, color = "gray30", size = 4.5) +
  coord_equal(xlim = c(-0.2, 0.25), ylim = c(-0.2, 0.2)) +
  theme_penguins("dark") +
  theme(legend.position = "none") +
  labs(x = "log Bill length (centered within species)",
       y = "log Bill depth (centered within species)",
       title = "Within-species PC1 axes lie along the size direction")

#' ## 3. Univariate views: which variable separates the species?

peng_long <- peng |>
  select(species, bill_length, bill_depth, log_size, log_shape) |>
  pivot_longer(-species, names_to = "variable") |>
  mutate(variable = factor(variable,
                           levels = c("bill_length", "bill_depth", "log_size", "log_shape")))

# label each density curve at its peak
dens_peaks <- peng_long |>
  group_by(variable, species) |>
  summarise(d = list(density(value)), .groups = "drop") |>
  mutate(x = sapply(d, \(d) d$x[which.max(d$y)]),
         y = sapply(d, \(d) max(d$y)))

ggplot(peng_long, aes(x = value, fill = species, color = species)) +
  geom_density(alpha = 0.4) +
  geom_label(data = dens_peaks, aes(x = x, y = y, label = species, color = species),
             fill = "white", alpha = 0.75, size = 3.5, fontface = "bold",
             vjust = 0, inherit.aes = FALSE) +
  facet_wrap(~ variable, scales = "free", nrow = 1) +
  scale_y_continuous(expand = expansion(mult = c(0.02, 0.15))) +
  labs(x = NULL, y = "Density") +
  theme_penguins("dark") +
  theme(legend.position = "none")

# Shape seems to separate Gentoo (long, thin bills) from Adelie & Chinstrap;
# size separates Adelie (small) from Chinstrap (big) -- a cleaner story than L & D?

# Effect sizes: one-way ANOVA eta^2 for each variable
eta2 <- function(v) {
  a <- anova(lm(reformulate("species", v), data = peng))
  a[1, "Sum Sq"] / sum(a[, "Sum Sq"])
}
sapply(c("bill_length", "bill_depth", "log_size", "log_shape"), eta2) |> round(3)

#' ## 4. Sex differences: is dimorphism mainly in size?

sex_fill <- scale_fill_discrete(labels = c(f = "Female", m = "Male"))
p3 <- ggplot(peng, aes(x = species, y = log_size, fill = sex)) +
  geom_boxplot(alpha = 0.6) +
  sex_fill +
  labs(x = NULL, y = "log Size", title = "Size") +
  theme(legend.position = "none")
# legend inside the right panel, lower right (empty: Gentoo shapes are high)
p4 <- ggplot(peng, aes(x = species, y = log_shape, fill = sex)) +
  geom_boxplot(alpha = 0.6) +
  sex_fill +
  labs(x = NULL, y = "log Shape", title = "Shape", fill = NULL) +
  theme(legend.position = "inside",
        legend.position.inside = c(0.98, 0.02),
        legend.justification = c(1, 0),
        legend.background = element_rect(color = "gray70"))
p3 + p4

# Size/shape ellipses, by species, faceted by sex
peng_plot(log_size, log_shape, pooled = FALSE, by = "sex") +
  facet_wrap(~ sex, labeller = as_labeller(c(f = "Female", m = "Male"))) +
  labs(x = "log Size", y = "log Shape")

#' ## 5. Allometry: bill size vs. body mass
# Bill size is an area (mm^2); body mass ~ volume. Under isometric scaling,
# log size ~ (2/3) log mass. Within-species slopes:

peng_plot(log_mass, log_size) +
  labs(x = "log Body mass", y = "log Bill size")

peng_plot(log_mass, log_shape) +
  labs(x = "log Body mass", y = "log Bill shape")

coef(lm(log_size ~ species / log_mass - 1, data = peng))   # slopes vs 2/3
coef(lm(log_shape ~ species / log_mass - 1, data = peng))  # shape ~ indep. of mass?

#' ## 6. MANOVA: identical tests, different HE plots

mod_LD <- lm(cbind(log_length, log_depth) ~ species + sex, data = peng)
mod_SS <- lm(cbind(log_size, log_shape)   ~ species + sex, data = peng)

# multivariate tests are invariant to the (nonsingular linear) transformation ...
Anova(mod_LD)
Anova(mod_SS)

# ... but the univariate ones are not
summary(aov(mod_SS))

op <- par(mfrow = c(1, 2), mar = c(4, 4, 1, 1) + 0.1)
cols <- c(peng.colors("dark"), "black")
covEllipses(cbind(log_length, log_depth) ~ species, data = peng,
            pooled = TRUE, fill = TRUE, fill.alpha = 0.1, col = cols,
            xlab = "log Bill length", ylab = "log Bill depth", asp = 1)
covEllipses(cbind(log_size, log_shape) ~ species, data = peng,
            pooled = TRUE, fill = TRUE, fill.alpha = 0.1, col = cols,
            xlab = "log Size", ylab = "log Shape", asp = 1)
par(op)

# TODO: In talk, include sex in the model

op <- par(mfrow = c(1, 2), mar = c(4, 4, 1, 1) + 0.1)
heplot(mod_LD, size = "effect", fill = TRUE, fill.alpha = 0.1, asp = 1,
       xlab = "log Bill length", ylab = "log Bill depth")
heplot(mod_SS, size = "effect", fill = TRUE, fill.alpha = 0.1, asp = 1,
       xlab = "log Size", ylab = "log Shape")
par(op)

# With asp = 1 the two HE plots are the same picture rotated by 45 degrees.
# In the size/shape version, does the sex effect line up with the Size axis
# (dimorphism = bigger bills, same shape)?

#' ## 7. Things to consider
# * Does the rotation buy enough interpretive value to justify a new pair of variables
#   in the book, vs. just *drawing* size & shape directions on the (L, D) plot?
# * Could pair with flipper_length & body_mass for a 4-variable MANOVA / canonical plot
#   using (log_size, log_shape, log flipper, log mass).
# * Natural tie-in to the Simpson's paradox discussion: in size/shape coordinates
#   the within/between contrast may disappear or change sign.
