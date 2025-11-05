#' ---
#' title: Penguin data discriminant boundaries
#' ---

library(MASS)
#library(ggord)
library(ggplot2)
library(patchwork)
library(marginaleffects)   # for datagrid

data(peng, package="heplots")
source(here::here("R/penguin/penguin-colors.R"))
source(here::here("R/predict_discrim.R"))

peng.lda <- lda(species ~ bill_length + bill_depth + flipper_length + body_mass, 
                data = peng)

# classification accuracy
class_table <- table(peng$species,
                     predict(peng.lda)$class,
                     dnn = c("actual", "predicted")) |>
  print()
# overall rates
accuracy <- sum(diag(class_table))/sum(class_table) * 100
error <- 100 - accuracy
c(accuracy, error)

# which ones are misclassified?

data.frame(id = row.names(peng),
           peng[, c(1, 3:6)],
           predicted = predict(peng.lda)$class) |>
  filter(species != predicted) |>
  relocate(predicted, .after = species)


# make a grid of values for prediction
#range80 = \(x) seq(min(x), max(x), length.out = 80)
seq.range = \(n) \(x) seq(min(x), max(x), length.out = n)

grid <- marginaleffects::datagrid(bill_length = seq.range(80), 
                                  bill_depth = seq.range(80), 
                                  newdata = peng)
head(grid)


pred_grid <- predict_discrim(peng.lda, newdata = grid) 
head(pred_grid)

means <- peng |>
  group_by(species) |>
  summarise(across(c(bill_length, bill_depth), \(x) mean(x, na.rm = TRUE) ))

p1 <- ggplot(data = peng, aes(x = bill_length, y = bill_depth)) +
  # Plot decision regions
  geom_tile(data = pred_grid, aes(fill = species), alpha = 0.2) +
  stat_ellipse(aes(color=species), level = 0.68, linewidth = 1.2) +
  # Plot original data points
  geom_point(aes(color = species, shape=species),
             size = 2) +
#  labs(title = "LDA Decision Boundaries") +
  geom_label(data=means, aes(label = species, color = species),
             size =5) +
  theme_penguins() +
  theme_minimal(base_size = 16) +
  theme(legend.position = "none")
p1

# -----------------------------------------
# Do the same for flipper_length, body_mass

grid <- marginaleffects::datagrid(flipper_length = seq.range(80), 
                                  body_mass = seq.range(80), newdata = peng)
head(grid)


pred_grid <- predict_discrim(peng.lda, newdata = grid) 

means <- peng |>
  group_by(species) |>
  summarise(across(c(flipper_length, body_mass), \(x) mean(x, na.rm = TRUE) ))

p2 <- ggplot(data = peng, aes(x = flipper_length, y = body_mass)) +
  # Plot decision regions
  geom_tile(data = pred_grid, aes(fill = species), alpha = 0.2) +
  stat_ellipse(aes(color=species), level = 0.68, linewidth = 1.2) +
  # Plot original data points
  geom_point(aes(color = species, shape=species),
             size =2) +
  labs(title = "LDA Decision Boundaries") +
  geom_label(data=means, aes(label = species, color = species),
             size =5) +
  theme_penguins() +
  theme_minimal(base_size = 16) +
  theme(legend.position = "none")

p1 + p2

# ------------------------------------------------------
# Do it in discrim  space, using LD1 & LD2 as predictors
# 

peng_scored <- predict_discrim(peng.lda, scores=TRUE, 
                               posterior = FALSE)
head(peng_scored)

peng.lda2 <- lda(species ~ LD1 + LD2, data=peng_scored)
peng.lda2

# coefficients
coef(peng.lda2)

# proportions of variance
peng.lda2$svd^2 / sum(peng.lda2$svd^2)


# NB: LD1 is flipped in signs - reflect it
# But this doesn't look right
# peng_scored <- peng_scored |>
#   mutate(LD1 = -LD1)


grid <- datagrid(LD1 = seq.range(80), 
                 LD2 = seq.range(80), newdata = peng_scored) 


pred_grid <- predict_discrim(peng.lda2, newdata = grid, posterior = FALSE) 
head(pred_grid)

svd <- peng.lda$svd
var <- 100 * round(svd^2/sum(svd^2), 3)
labs <- glue::glue("Discriminant dimension {1:2} ({var}%)") |>
  print()

means <- peng_scored |>
  group_by(species) |>
  summarise(across(LD1:LD2, \(x) mean(x, na.rm = TRUE) ))
means

ggplot(data = peng_scored, aes(x = LD1, y = LD2)) +
  # Plot decision regions
  geom_tile(data = pred_grid, aes(fill = species), alpha = 0.2) +
  stat_ellipse(aes(color=species), level = 0.68, linewidth = 1.2) +
  # Plot original data points
  geom_point(aes(color = species, shape=species),
             size =2) +
  geom_label(data=means, aes(label = species, color = species),
             size =5) +
  labs(x = labs[1], y = labs[2]) +
  theme_penguins() +
  theme_minimal(base_size = 16) +
  theme(legend.position = "none")

p <- last_plot()


# add variable vectors
# --------------------
# vecs <- peng.lda$scaling |>
#   as.data.frame()
# labs <- row.names(peng.lda$scaling) |>
#   stringr::str_replace("_", "\n")
# source(here::here("R/ggvectors.R"))
# 
# p + ggvectors(vecs[, "LD1"], vecs[, "LD2"],
#               label = labs,
#               scale = 3)

vecs <- peng.lda$scaling |>
  as.data.frame() |>
  tibble::rownames_to_column(var = "label") |>
  mutate(label = stringr::str_replace(label, "_", "\n"))

p + gggda::geom_vector(
  data = vecs,
  aes(x = 5*LD1, y = 5*LD2, label = label),
  lineheight = 0.8, linewidth = 1.25, size = 5
  ) +
  coord_equal()


# Compare to MANOVA, CDA
#
library(candisc)
peng.mlm <- lm(cbind(bill_length, bill_depth, flipper_length, body_mass) ~ species , 
                data = peng)

peng.can <- candisc(peng.mlm, data=peng)

# there should also be a formula method that fits the model first
# peng.can <- candisc(cbind(bill_length, bill_depth, flipper_length, body_mass) ~ species, 
#                     data = peng)


# candisc plot

op <- par(mar = c(4, 4, 1, 1)+.5)
plot(peng.can,
     col = peng.colors(),
     pch = 15:17,
     ellipse = TRUE,
     rev.axes = c(TRUE, FALSE),
     var.labels = vecs$label,
     var.col = "black", var.lwd = 2,
     scale = 7.3,
     cex.lab = 1.3)
par(op)

op <- par(mar = c(4, 4, 1, 1)+.5)
heplot(peng.can, 
       size="effect", 
       fill=c(TRUE, TRUE), fill.alpha = 0.1,
       rev.axes = c(TRUE, FALSE),
       var.labels = vecs$label,
       var.col = "black", var.lwd = 2, var.cex = 1.3,
       xlim = c(-8, 8), ylim = c(-8, 4),
       scale = 8.2,
       cex.lab = 1.3, cex = 1.3)
par(op)
