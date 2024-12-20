# R tSNE with 3D plots
# https://www.appsilon.com/post/r-tsne

library(dplyr)
library(Rtsne)
library(ggplot2)
library(plotly)

# https://github.com/pjreddie/mnist-csv-png?tab=readme-ov-file
digits <- read.csv("mnist_train.csv", header = FALSE)
colnames(digits) <- c("digit", paste0("pixel", 1:784))

# print first row as a matrix
first_digit <- matrix(digits[1, ] |> 
	select(-digit) |> unlist(), nrow = 28, ncol = 28, byrow = TRUE)
first_digit

# visualize the digit
rotate <- function(x) t(apply(x, 2, rev))
image(rotate(first_digit), col = (gray(255:0 / 255)))

# Or, if you want to get a glimpse into a larger portion of the dataset, run the following snippet:
par(mfrow = c(5, 5))

for (i in sample(1:nrow(digits), 25)) {
  digit_matrix <- matrix(digits[i, ] |> 
  	select(-digit) |> 
  	unlist(), nrow = 28, ncol = 28, byrow = TRUE)
  image(rotate(digit_matrix), col = gray(255:0 / 255), axes = FALSE, xlab = "", ylab = "")
}
par(mfrow = c(1, 1))

# That’s too much to include in a single chart, so we’ll reduce the per-class sample size to 100:
data_sample <- digits |>
  group_by(digit) |>
  sample_n(100) |>
  ungroup()

data_sample |>
  group_by(digit) |>
  count()

#  let’s also make a feature/target split:
X <- data_sample |> select(-digit)
y <- data_sample |> select(digit)

# Run tSNE

tsne_results <- Rtsne(X, dims = 2, perplexity = 25, verbose = TRUE, max_iter = 1500)

tsne_df <- data.frame(
  X = tsne_results$Y[, 1],
  Y = tsne_results$Y[, 2],
  digit = y
)
colors <- c("#E6194B", "#3CB44B", "#FFE119", "#4363D8", "#F58231", "#911EB4", "#46F0F0", "#F032E6", "#BCF60C", "#FABEBE")

ggplot(tsne_df, aes(x = X, y = Y, color = factor(digit))) +
  geom_point(size = 1.5) +
  scale_color_manual(values = colors) +
  labs(
    title = "t-SNE 2-Dimensional Digit Visualization",
    x = "t-SNE Dimension 1",
    y = "t-SNE Dimension 2"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 20)
  )

# Plotting t-SNE Results in 3 Dimensions

tsne_results <- Rtsne(features, dims = 3, perplexity = 30, verbose = TRUE, max_iter = 1500)

tsne_df <- data.frame(
  X = tsne_results$Y[, 1],
  Y = tsne_results$Y[, 2],
  Z = tsne_results$Y[, 3],
  digit = factor(labels)
)
head(tsne_df)

colors <- c("#E6194B", "#3CB44B", "#FFE119", "#4363D8", "#F58231", "#911EB4", "#46F0F0", "#F032E6", "#BCF60C", "#FABEBE")
hover_text <- paste(
  "Digit:", tsne_df$digit, "",
  "Dimension 1:", round(tsne_df$X, 3),
  "Dimension 2:", round(tsne_df$Y, 3),
  "Dimension 3:", round(tsne_df$Z, 3)
)

plot_ly(
  data = tsne_df,
  x = ~X,
  y = ~Y,
  z = ~Z,
  type = "scatter3d",
  mode = "markers",
  marker = list(size = 6),
  text = hover_text,
  hoverinfo = "text",
  color = ~digit,
  colors = colors
) |>
  layout(
    title = "t-SNE 3-Dimensional Digit Visualization",
    scene = list(
      xaxis = list(title = "t-SNE Dimension 1"),
      yaxis = list(title = "t-SNE Dimension 2"),
      zaxis = list(title = "t-SNE Dimension 3")
    )
  )

# Perplexity Tuning

# Unlike PCA, the results of t-SNE will often vary (sometimes significantly) because of the tweakable parameters and the nature of gradient descent.

# This section demonstrates how to tweak the most important parameter - perplexity - and shows you just how different the results are. 
# The values for this parameter typically range from 5 to 50, so we’ll go over this entire range with the step size of 5.

library(gganimate)

perplexity_values <- c(5, 10, 15, 20, 25, 30, 35, 40, 45, 50)

tsne_results_list <- lapply(perplexity_values, function(perp) {
  tsne <- Rtsne(X, dims = 2, perplexity = perp, verbose = TRUE, max_iter = 1500)
  data.frame(
    X = tsne$Y[, 1],
    Y = tsne$Y[, 2],
    digit = y,
    perplexity = perp
  )
})

tsne_df <- do.call(rbind, tsne_results_list)

plot <- ggplot(tsne_df, aes(x = X, y = Y, color = factor(digit))) +
  geom_point(size = 1.5) +
  scale_color_manual(values = colors) +
  labs(
    title = "t-SNE 2-Dimensional Digit Visualization",
    subtitle = "Perplexity: {closest_state}", # This will display the perplexity value
    x = "t-SNE Dimension 1",
    y = "t-SNE Dimension 2"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 20),
    plot.subtitle = element_text(size = 16)
  ) +
  transition_states(perplexity, transition_length = 2, state_length = 1) +
  ease_aes("linear")

animate(
  plot,
  width = 800,
  height = 600,
  res = 100,
  nframes = 300,
  fps = 30,
  renderer = gifski_renderer(file = "tsne-2d-animated.gif")
)

