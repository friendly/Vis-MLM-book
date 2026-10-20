#' ---
#' title: Penguin bodies -- is there a size & shape for flipper length & body mass?
#' author: Michael Friendly
#' ---

# Companion to peng-bill-size-shape.R. For the bill, (log L, log D) rotated by 45 degrees gave
#   log size  = log L + log D,  log shape = log L - log D.
# Flipper length and body mass are not in the same units: length is a length, mass ~ volume ~ length^3.
# Put them on a common footing first: M^(1/3) is a length-like quantity, so use
#   log F  and  log M / 3
# and rotate those by 45 degrees:
#   log body size  = log F + log M / 3    = log(F * M^(1/3))
#   log stoutness  = log M / 3 - log F    = log(M^(1/3) / F)
# Stoutness is (the cube root of) mass per flipper-length cubed: heavy for its length, or lean.
# It is the penguin version of Fulton's condition factor K = W / L^3 for fish, or of the ponderal index.
# Under isometric growth (all dimensions scale together) log M ~ 3 log F, the within-species
# variation lies along the size direction, and stoutness is free of size.

library(dplyr)
library(tidyr)
library(ggplot2)
library(patchwork)
library(car)
library(heplots)
library(candisc)

data(peng, package = "heplots")
source("R/penguin/penguin-colors.R")

theme_set(theme_bw(base_size = 14))

peng <- peng |>
  mutate(
    log_flipper = log(flipper_length),
    log_mass3   = log(body_mass) / 3,             # log of the cube root of mass
    body_size   = log_flipper + log_mass3,
    stoutness   = log_mass3 - log_flipper,
    K           = body_mass / (flipper_length / 10)^3,   # raw stoutness, g / cm^3
    # the bill variables, as in peng-bill-size-shape.R
    log_length  = log(bill_length),
    log_depth   = log(bill_depth),
    bill_size   = log_length + log_depth,
    bill_shape  = log_length - log_depth
  )

peng |>
  group_by(species) |>
  summarise(across(c(flipper_length, body_mass, K, body_size, stoutness), mean))

# Helpers, as in peng-bill-size-shape.R
# `nudge`: optional data frame of species, dx, dy, to move labels that would overlap
species_labels <- function(x, y, data = peng, by = NULL, size = 5, nudge = NULL) {
  means <- data |>
    group_by(species, across(all_of(by))) |>
    summarise(x = mean({{ x }}), y = mean({{ y }}), .groups = "drop")
  if (!is.null(nudge))
    means <- means |>
      left_join(nudge, by = "species") |>
      mutate(x = x + coalesce(dx, 0), y = y + coalesce(dy, 0))
  geom_label(data = means, aes(x = x, y = y, label = species, color = species),
             fill = "white", alpha = 0.75, size = size, fontface = "bold",
             inherit.aes = FALSE)
}

peng_plot <- function(x, y, data = peng, pooled = TRUE, by = NULL, nudge = NULL) {
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
  p + species_labels({{ x }}, {{ y }}, data = data, by = by, nudge = nudge)
}

#' ## 1. The original space vs. the size/stoutness space
# Unlike the bill, there is no Simpson's paradox here: mass and flipper length are
# positively related both within and across species (pooled r = 0.87).

# Adelie & Chinstrap means nearly coincide: move their labels apart
p1 <- peng_plot(flipper_length, body_mass,
                nudge = tibble(species = c("Adelie", "Chinstrap"),
                               dx = c(-6, 7), dy = c(450, -500))) +
  labs(x = "Flipper length (mm)", y = "Body mass (g)", title = "Flipper & mass")

# coord_equal: both axes are in log-length units, so equal scales show that the
# within-species variation is mostly along size
p2 <- peng_plot(body_size, stoutness,
                nudge = tibble(species = c("Adelie", "Chinstrap"),
                               dx = c(-0.04, 0.03), dy = c(0.07, -0.07))) +
  coord_equal() +
  labs(x = "log Size = log(F x M^(1/3))", y = "log Stoutness\n= log(M^(1/3) / F)",
       title = "Size & stoutness (log scale)")

p1 / p2 + plot_layout(heights = c(1.4, 1))

# Species differ in size; their stoutness is about the same: a Gentoo is, roughly,
# a scaled-up Adelie. Within species, size and stoutness are only weakly related.

#' ## 2. Is the cube law right? Within-species allometry
# Slope of log M on log F: OLS is attenuated by the error in log F; the standardized
# major axis (SMA) slope, sd(log M) / sd(log F), is the usual allometric estimate.
# Isometry: slope = 3. The PC1 angle in (log F, log M / 3) is 45 degrees under isometry.

allometry <- function(data)
  data |>
    summarise(n = n(),
              r     = cor(log_flipper, log_mass3),
              b_ols = coef(lm(I(3 * log_mass3) ~ log_flipper))[2],
              b_sma = 3 * sd(log_mass3) / sd(log_flipper),
              angle = {
                v <- eigen(cov(cbind(log_flipper, log_mass3)))$vectors[, 1]
                v <- v * sign(v[1])
                atan2(v[2], v[1]) * 180 / pi
              },
              .groups = "drop")

peng |> group_by(species) |> allometry()
peng |> group_by(species, sex) |> allometry()

# The pooled within-species PC1 angle
W <- cov(resid(lm(cbind(log_flipper, log_mass3) ~ species, data = peng)))
v <- eigen(W)$vectors[, 1]; v <- v * sign(v[1])
atan2(v[2], v[1]) * 180 / pi    # about 50 degrees: close to the size direction

# Show it, as for the bill: center each species, draw 68% ellipses and each species'
# PC1 axis (+/- 2 SD) against the size (slope +1) and stoutness (slope -1) directions
peng_c <- peng |>
  group_by(species) |>
  mutate(c_flipper = log_flipper - mean(log_flipper),
         c_mass3   = log_mass3   - mean(log_mass3)) |>
  ungroup()

pc1 <- peng_c |>
  group_by(species) |>
  group_modify(~ {
    e <- eigen(cov(cbind(.x$c_flipper, .x$c_mass3)))
    v <- e$vectors[, 1] * sign(e$vectors[1, 1])
    r <- 2 * sqrt(e$values[1])
    tibble(x = -r * v[1], y = -r * v[2], xend = r * v[1], yend = r * v[2],
           angle = atan2(v[2], v[1]) * 180 / pi)
  }) |>
  ungroup() |>
  mutate(label = sprintf("%s: %.0f°", species, angle),
         lab_x = 0.05, lab_y = -0.06 - 0.01 * (row_number() - 1))

ggplot(peng_c, aes(x = c_flipper, y = c_mass3, color = species, fill = species)) +
  geom_abline(slope =  1, intercept = 0, color = "gray50", linewidth = 0.7,
              linetype = "dashed") +
  geom_abline(slope = -1, intercept = 0, color = "gray50", linewidth = 0.7) +
  annotate("text", x = -0.07, y = -0.07, label = "size direction", angle = 45,
           vjust = -0.5, color = "gray30", size = 4.5) +
  annotate("text", x = -0.065, y = 0.065, label = "stoutness direction", angle = -45,
           vjust = -0.5, color = "gray30", size = 4.5) +
  geom_point(size = 1, alpha = 0.5) +
  stat_ellipse(geom = "polygon", level = 0.68, alpha = 0.05, linewidth = 1) +
  geom_segment(data = pc1, aes(x = x, y = y, xend = xend, yend = yend),
               linewidth = 1.5, inherit.aes = FALSE,
               color = peng.colors("dark")[as.character(pc1$species)]) +
  geom_label(data = pc1, aes(x = lab_x, y = lab_y, label = label, color = species),
             fill = "white", size = 4.5, fontface = "bold",
             hjust = 0, inherit.aes = FALSE) +
  annotate("text", x = 0.05, y = -0.06 + 0.01, label = "PC1 angle",
           hjust = 0, color = "gray30", size = 4.5) +
  coord_equal(xlim = c(-0.1, 0.1), ylim = c(-0.1, 0.1)) +
  theme_penguins("dark") +
  theme(legend.position = "none") +
  labs(x = "log Flipper length (centered within species)",
       y = "log Body mass / 3 (centered within species)",
       title = "Within-species PC1 axes lie near the size direction")

# The angles (Adelie 56, Chinstrap 42, Gentoo 49; pooled 50) scatter around 45, and the
# SMA slopes (2.8 - 3.6) around 3: across the size range within a species, penguins scale
# roughly isometrically. But within species x sex, r(F, M) is only 0.23 - 0.67 and the PC1
# angles drop to 24 - 51: much of the within-species "size" axis is male vs. female.

#' ## 3. Univariate views: which variable separates the species?

peng_long <- peng |>
  select(species, log_flipper, log_mass3, body_size, stoutness) |>
  pivot_longer(-species, names_to = "variable") |>
  mutate(variable = factor(variable,
                           levels = c("log_flipper", "log_mass3", "body_size", "stoutness")))

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

# Proportion of variance due to species and sex, for each variable
eta2 <- function(v) {
  a <- anova(lm(reformulate(c("species", "sex"), v), data = peng))
  setNames(a[, "Sum Sq"] / sum(a[, "Sum Sq"]), c("species", "sex", "resid"))
}
sapply(c("log_flipper", "log_mass3", "body_size", "stoutness"), eta2) |> round(3)

# Size carries the species differences (eta^2 = 0.76); stoutness is mostly individual
# variation (resid = 0.79), i.e., it behaves like a body condition index.

#' ## 4. Sex differences: is dimorphism mainly in size?

sex_fill <- scale_fill_discrete(labels = c(f = "Female", m = "Male"))
p3 <- ggplot(peng, aes(x = species, y = body_size, fill = sex)) +
  geom_boxplot(alpha = 0.6) +
  sex_fill +
  labs(x = NULL, y = "log Size", title = "Size") +
  theme(legend.position = "none")
p4 <- ggplot(peng, aes(x = species, y = stoutness, fill = sex)) +
  geom_boxplot(alpha = 0.6) +
  sex_fill +
  labs(x = NULL, y = "log Stoutness", title = "Stoutness", fill = NULL) +
  theme(legend.position = "inside",
        legend.position.inside = c(0.98, 0.02),
        legend.justification = c(1, 0),
        legend.background = element_rect(color = "gray70"))
p3 + p4

# Males are bigger in every species. Stoutness differs by sex only for Adelie, where the
# males are heavier for their flipper length (a species x sex interaction).

peng_plot(body_size, stoutness, pooled = FALSE, by = "sex") +
  facet_wrap(~ sex, labeller = as_labeller(c(f = "Female", m = "Male"))) +
  labs(x = "log Size", y = "log Stoutness")

#' ## 5. Body vs. bill: size goes with size, shape with nothing?

# Within-species correlations (species removed), and within species x sex
vars <- c("bill_size", "bill_shape", "body_size", "stoutness")
within_cor <- function(groups)
  cor(resid(lm(reformulate(groups, "cbind(bill_size, bill_shape, body_size, stoutness)"),
               data = peng))) |> round(2)
within_cor("species")
within_cor("species * sex")

# The four cross plots: body (size, stoutness) x bill (size, shape)
p5 <- peng_plot(body_size, bill_size)  + labs(x = "log Body size", y = "log Bill size")
p6 <- peng_plot(stoutness, bill_size)  + labs(x = "log Stoutness", y = "log Bill size")
p7 <- peng_plot(body_size, bill_shape) + labs(x = "log Body size", y = "log Bill shape")
p8 <- peng_plot(stoutness, bill_shape) + labs(x = "log Stoutness", y = "log Bill shape")
(p5 + p6) / (p7 + p8)

# Allometry of the bill on the body: bill size is an area (~ length^2), body size here is
# (twice) a log length, so isometry predicts a slope of 2 / 2 = 1 for bill_size on body_size
coef(lm(bill_size  ~ species / body_size - 1, data = peng))
coef(lm(bill_shape ~ species / body_size - 1, data = peng))

# Bill size tracks body size (within-species r = 0.70; slopes 1.1 - 1.7, near or above
# isometry). Bill shape is unrelated to either body variable (|r| < 0.05): it is purely
# a species trait. Stoutness is nearly unrelated to the bill once sex is removed.

#' ## 6. MANOVA and canonical view with all four re-expressed variables

mod4 <- lm(cbind(bill_size, bill_shape, body_size, stoutness) ~ species + sex, data = peng)
Anova(mod4)

pairs(mod4, fill = TRUE, fill.alpha = 0.1,
      var.labels = c("Bill\nsize", "Bill\nshape", "Body\nsize", "Stout-\nness"))

# Canonical discriminant analysis for species: the structure coefficients say
# which re-expressed variables define the two canonical dimensions
cd <- candisc(mod4, term = "species")
cd
cd$structure |> round(2)
plot(cd, ellipse = TRUE, col = peng.colors("dark"), var.col = "black", var.lwd = 2)

# Can1 (87%) is Gentoo vs. the others: big body, long thin bill. Can2 (13%) is Chinstrap
# vs. Adelie: bill size. A tidy two-dimensional story, each axis with a named meaning.

#' ## 7. Does stoutness vary by year?
# If stoutness is body condition, it might differ between good and bad years (2007 - 2009)

peng <- peng |> mutate(fyear = factor(year))
table(peng$species, peng$fyear)

m0 <- lm(stoutness ~ species * sex, data = peng)
m1 <- lm(stoutness ~ species * sex + fyear, data = peng)
m2 <- lm(stoutness ~ (species + sex) * fyear + species:sex, data = peng)
anova(m0, m1, m2)
Anova(m2)
etasq(m2, partial = FALSE)

# A year main effect (eta^2 = 0.08, R^2 0.27 -> 0.35), the same in all species and both
# sexes: penguins got less stout from 2007 to 2009. But which component changed?
for (v in c("flipper_length", "body_mass", "body_size"))
  print(Anova(lm(reformulate("(species + sex) * fyear + species:sex", v), data = peng)))

peng |>
  group_by(species, fyear) |>
  summarise(n = n(), flipper = mean(flipper_length), mass = mean(body_mass),
            K = mean(K), .groups = "drop")

year_long <- peng |>
  select(species, sex, fyear, flipper_length, body_mass, stoutness) |>
  pivot_longer(c(flipper_length, body_mass, stoutness), names_to = "variable") |>
  mutate(variable = factor(variable, levels = c("flipper_length", "body_mass", "stoutness"),
                           labels = c("Flipper length (mm)", "Body mass (g)", "log Stoutness")))

ggplot(year_long, aes(x = fyear, y = value, color = species, group = species)) +
  stat_summary(fun.data = mean_se, geom = "pointrange",
               position = position_dodge(width = 0.3)) +
  stat_summary(fun = mean, geom = "line", linewidth = 1,
               position = position_dodge(width = 0.3)) +
  facet_wrap(~ variable, scales = "free_y") +
  theme_penguins("dark") +
  theme(legend.position = "top") +
  labs(x = "Year", y = "Mean (+/- 1 SE)", color = NULL)

# Body mass shows no year effect at all (F = 0.02); flipper length rises by 3 - 6 mm
# from 2007 to 2008 in every species (F = 25). So the year effect on stoutness is
# entirely flipper length. Real growth in flipper length in one year seems unlikely for
# adult birds; a change in how (or by whom) flippers were measured after 2007 is a
# plausible alternative. Either way, it's not body condition, which would show in mass.

#' ## 8. Things to consider
# * Isometry holds only roughly; the empirical within-species SMA slope (~3.2) or PC1
#   could define stoutness instead (cf. the "scaled mass index", Peig & Green, 2009, Oikos).
# * Check the Palmer LTER documentation for a change in flipper measurement after 2007.
#   If it was a protocol change, adjust flipper length for year before computing stoutness.
# * Whether body_size is better as F x M^(1/3) or just as PC1 of the four log measures.
