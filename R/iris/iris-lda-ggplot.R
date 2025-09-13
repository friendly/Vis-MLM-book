library(MASS) # For lda() and qda()
library(ggplot2)
library(dplyr)

# Example data (e.g., iris dataset)
data(iris)
lda_model <- lda(Species ~ Petal.Length + Petal.Width, data = iris)

# Create a grid for prediction
x_range <- range(iris$Petal.Length)
y_range <- range(iris$Petal.Width)

grid_points <- expand.grid(
  Petal.Length = seq(x_range[1], x_range[2], length.out = 100),
  Petal.Width = seq(y_range[1], y_range[2], length.out = 100)
)

# Predict class for each grid point
grid_predictions <- predict(lda_model, newdata = grid_points)$class
prediction_data <- cbind(grid_points, Species = grid_predictions)

# Plot with ggplot2: Use geom_tile() to plot the predicted classes on the grid, creating the decision regions, and geom_point() to overlay your original data points.

legend_inside <- function(position) {          # simplify legend placement
  theme(legend.position = "inside",
        legend.position.inside = position)
}

means <- iris |>
  group_by(Species) |>
  summarise(across(c(Petal.Length, Petal.Width), mean, 
                   na.rm = TRUE))

ggplot(data = iris, aes(x = Petal.Length, y = Petal.Width)) +
  # Plot decision regions
  geom_tile(data = prediction_data, aes(fill = Species), alpha = 0.2) +
  # Plot original data points
  geom_point(aes(color = Species, shape=Species),
             size =2) +
  labs(title = "LDA Decision Boundaries") +
  geom_label(data=means, aes(label = Species, color = Species),
             size =5) +
  theme_minimal() +
  theme(legend.position = "none")
#  legend_inside(c(0.8, 0.2))

# see also https://www.thomaspuschel.com/post/decision_boundary_plot2/

