#' ---
#' title: Penguin data discriminant boundaries

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

# ------------------------------------------------------
# Do it in discrim  space, using LD1 & LD2 as predictors
# 

peng_scored <- predict_discrim(peng.lda, scores=TRUE, posterior = FALSE)
head(peng_scored)

peng.lda2 <- lda(species ~ LD1 + LD2, data=peng_scored)
peng.lda2

# Can't reflect and lda object!!!
# peng.lda2 <- ggbiplot::reflect(peng.lda2, columns = 1)
# peng.lda2

# NB: LD1 is flipped in signs
# maxp gets duplicated -- FIXED that
grid <- datagrid(LD1 = range80, 
                 LD2 = range80, newdata = peng_scored) 


pred_grid <- predict_discrim(peng.lda2, newdata = grid, posterior = FALSE) 
head(pred_grid)

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
  theme_penguins() +
  theme_minimal(base_size = 16) +
  theme(legend.position = "none")
