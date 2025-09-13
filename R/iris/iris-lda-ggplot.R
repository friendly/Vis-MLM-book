#' ---
#' title: plot LDA boundaries with ggplot
#' ---

#' What would be nice is to plot LDA classification in
#' * space of two observed variables
#' * space of two discrim axes

library(MASS) # For lda() and qda()
library(ggplot2)
library(dplyr)
library(broom)

# Example data (e.g., iris dataset)
data(iris)
iris.lda <- lda(Species ~ Petal.Length + Petal.Width, data = iris)
# use all variables -- but this requires the grid account for them
iris.lda <- lda(Species ~ ., data = iris)

# Create a grid for prediction
x_range <- range(iris$Petal.Length)
y_range <- range(iris$Petal.Width)

grid_points <- expand.grid(
  Petal.Length = seq(x_range[1], x_range[2], length.out = 100),
  Petal.Width = seq(y_range[1], y_range[2], length.out = 100),
  Sepal.Length = mean(iris$Sepal.Length),
  Sepal.Width = mean(iris$Sepal.Width)
)

# Predict class for each grid point
grid_predictions <- predict(iris.lda, newdata = grid_points)$class
prediction_data <- cbind(grid_points, Species = grid_predictions)

# Plot with ggplot2: Use geom_tile() to plot the predicted classes on the grid, creating the decision regions, and geom_point() to overlay your original data points.

# legend_inside <- function(position) {          # simplify legend placement
#   theme(legend.position = "inside",
#         legend.position.inside = position)
# }

means <- iris |>
  group_by(Species) |>
  summarise(across(c(Petal.Length, Petal.Width), mean, 
                   na.rm = TRUE))

ggplot(data = iris, aes(x = Petal.Length, y = Petal.Width)) +
  # Plot decision regions
  geom_tile(data = prediction_data, aes(fill = Species), alpha = 0.2) +
  stat_ellipse(aes(color=Species), level = 0.68, linewidth = 1.2) +
  # Plot original data points
  geom_point(aes(color = Species, shape=Species),
             size =2) +
  labs(title = "LDA Decision Boundaries") +
  geom_label(data=means, aes(label = Species, color = Species),
             size =5) +
  theme_minimal(base_size = 14) +
  theme(legend.position = "none")

# see also https://www.thomaspuschel.com/post/decision_boundary_plot2/

### Try to generalize this example
### 

# NO tidiers for LDA!
# library(broom)
# tidy(iris.lda)
# augmented_data <- augment(iris.lda, data = iris)
# head(augmented_data)

# TODO: Make a data.frame method
make_grid <- function(x, y, 
                      names = NULL,
                      npoints = c(80, 80)) {

  XY <- grDevices::xy.coords(x, y)
  x <- XY["x"]
  y <- XY["y"]
  grid_points <- expand.grid(
  x = seq(min(x), max(x), length.out = npoints[1]),
  y = seq(min(y), max(y), length.out = npoints[2])
  )
if (!is.null(names)) {
  stopifnot(length(names) < 2)
  colnames(grid_points) <- names[1:2]
  }
else {
#browser()
  names <- c(deparse(substitute(x)),
             deparse(substitute(y)) )
  # data.frame columns
  names <- sub("^.*\\$", "", names, perl = TRUE)
  colnames(grid_points) <- names
}

grid_points
}

iris.grid <- make_grid(iris$Petal.Length, iris$Petal.Width, np = c(40,40))

# this should work too
#iris.grid <- make_grid(iris[, c("Petal.Length", "Petal.Width")])

head(iris.grid)

# Make a data frame with preditcted class & posterior for that class
#class <- predict(iris.lda, newdata=iris.grid)$class
pred <- predict(iris.lda, newdata=iris.grid, type = 'prob')
class <- pred$class
probs <- pred$posterior

maxp <- apply(probs, 1, max) |> as.numeric()

pred.data <- cbind(iris.grid, class, maxp)

pred_lda <- function(object, newdata, ...) {
  pred <- predict(object, newdata, type = "prob")
  class <- pred$class
  probs <- pred$posterior
  maxp <- apply(probs, 1, max)
  cbind(newdata, class, maxp)
}

# do the initial example, but at the means of Sepal vars

iris.pred <- pred_lda(iris.lda, grid_points) |>
  rename(Species = class)

ggplot(data = iris, aes(x = Petal.Length, y = Petal.Width)) +
  # Plot decision regions
  geom_tile(data = iris.pred, aes(fill = Species), alpha = 0.2) +
  # Plot original data points
  geom_point(aes(color = Species, shape=Species),
             size =2) +
  labs(title = "LDA Decision Boundaries") +
  geom_label(data=means, aes(label = Species, color = Species),
             size =5) +
  theme_minimal() +
  theme(legend.position = "none")

# try with raster
ggplot(data = iris, aes(x = Petal.Length, y = Petal.Width)) +
  # Plot decision regions
  geom_raster(data = iris.pred, aes(fill = Species,  alpha=maxp)) +

  geom_point(data = iris, aes(color = Species, shape=Species),
             size =3) +
  labs(title = "LDA Decision Boundaries") +
  geom_label(data=means, aes(label = Species, color = Species),
             size =5) +
  theme_minimal() +
  theme(legend.position = "none")



