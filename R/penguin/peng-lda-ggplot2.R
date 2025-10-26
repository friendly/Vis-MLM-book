#' ---
#' title: Penguin data discriminant boundaries

library(MASS)
#library(ggord)
library(ggplot2)
library(patchwork)
library(marginaleffects)   # for datagrid

data(peng, package="heplots")
source("R/penguin/penguin-colors.R")
source("R/predict_discrim.R")

peng.lda <- lda(species ~ bill_length + bill_depth + flipper_length + body_mass, 
                data = peng)


# make a grid of values for prediction
range80 = \(x) seq(min(x), max(x), length.out = 80)
grid <- marginaleffects::datagrid(bill_length = range80, 
                                  bill_depth = range80, newdata = peng)
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
             size =2) +
  labs(title = "LDA Decision Boundaries") +
  geom_label(data=means, aes(label = species, color = species),
             size =5) +
  theme_penguins() +
  theme_minimal(base_size = 16) +
  theme(legend.position = "none")
p1

# -----------------------------------------
# Do the same for flipper_length, body_mass

grid <- marginaleffects::datagrid(flipper_length = range80, 
                                  body_mass = range80, newdata = peng)
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
