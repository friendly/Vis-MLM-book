
# This relies on latest commit in marginal effects
remotes::install_github("vincentarelbundock/marginaleffects")

library(MASS)
library(ggplot2)
library(marginaleffects)
data(iris)
iris.lda <- lda(Species ~ ., data = iris)

means <- aggregate(cbind(Petal.Length, Petal.Width) ~ Species,
    data = iris, FUN = mean
)

range100 <- \(x) seq(min(x), max(x), length.out = 100)

prediction_data <- predictions(iris.lda,
    type = "class",
    newdata = datagrid(Petal.Width = range100, Petal.Length = range100)
    )

# generalize this -- doesn't work
seq_range <- \(x, n=100) seq(min(x), max(x), length.out = n)
pred_data <- predictions(iris.lda,
    type = "class",
#    newdata = datagrid(Petal.Width = seq_range(_, n=50), Petal.Length = seq_range(_, n=50))
    newdata = datagrid(Petal.Width = seq_range(Petal.Width, n=50), Petal.Length = seq_range(Petal.Length, n=50))
    )



ggplot(data = iris, aes(x = Petal.Length, y = Petal.Width)) +
    # Plot original data points
    geom_point(aes(color = Species, shape = Species), size = 2) +
    # Plot decision regions
    geom_tile(data = prediction_data, aes(fill = estimate), alpha = 0.2) +
    stat_ellipse(aes(color = Species), level = 0.68, linewidth = 1.2) +
    # Labels
    labs(title = "LDA Decision Boundaries") +
    geom_label(data = means, aes(label = Species, color = Species), size = 5) +
    theme_minimal(base_size = 14) +
    theme(legend.position = "none")

# Do for Sepal variables
# 
means <- aggregate(cbind(Sepal.Length, Sepal.Width) ~ Species,
    data = iris, FUN = mean
)

prediction_data <- predictions(iris.lda,
    type = "class",
    newdata = datagrid(Sepal.Width = range100, Sepal.Length = range100)
)

table(prediction_data$estimate)

ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width)) +
    # Plot original data points
    geom_point(aes(color = Species, shape = Species), size = 2) +
    # Plot decision regions
    geom_tile(data = prediction_data, aes(fill = estimate), alpha = 0.2) +
    stat_ellipse(aes(color = Species), level = 0.68, linewidth = 1.2) +
    # Labels
    labs(title = "LDA Decision Boundaries") +
    geom_label(data = means, aes(label = Species, color = Species), size = 5) +
    theme_minimal(base_size = 14) +
    theme(legend.position = "none")
