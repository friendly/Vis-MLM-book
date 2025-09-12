#' ---
#' title: crime data - pca
#' ---

library(ggplot2)
library(ggbiplot)
library(dplyr)
library(corrplot)
library(patchwork)
library(broom)

data(crime, package = "ggbiplot")

crime |> 
  dplyr::select(where(is.numeric)) |> 
  cor() |> 
  corrplot(method = "ellipse", tl.srt = 0, tl.col = "black", mar = rep(.5, 4))

crime.pca <- 
  crime |> 
  dplyr::select(where(is.numeric)) |>
  prcomp(scale. = TRUE)

summary(crime.pca)

# show the eigenvalue decomposition
(crime.eig <- crime.pca |> 
    broom::tidy(matrix = "eigenvalues"))

# add fitted line for smallest eigenvalues
p1 <- ggscreeplot(crime.pca) +
  stat_smooth(data = crime.eig |> filter(PC>=4), 
              aes(x=PC, y=percent), method = "lm", 
              se = FALSE,
              fullrange = TRUE) +
  theme_bw(base_line_size = 14)

p2 <- ggscreeplot(crime.pca, type = "cev") +
  geom_hline(yintercept = c(0.8, 0.9), color = "blue") +
  theme_bw(base_size = 14)

p1 + p2

# tidy scores plot

scores <- crime.pca |> purrr::pluck("x") 
cov(scores) |> zapsmall()

crime.pca |>
  broom::augment(crime) |> # add original dataset back in
  ggplot(aes(.fittedPC1, .fittedPC2, color = region)) + 
  geom_hline(yintercept = 0) +
  geom_vline(xintercept = 0) +
  geom_point(size = 1.5) +
  geom_text(aes(label = st), nudge_x = 0.2) +
  stat_ellipse(color = "grey") +
  coord_fixed(ylim = c(-3,3), ratio = 1) +
  scale_color_brewer(palette = "Dark2") +
  labs(x = "PC Dimension 1", y = "PC Dimension 2") +
  theme_minimal(base_size = 14) +
  theme(legend.position = "top") 
  
# Dim 1 vs. Dim 3
crime.pca |>
  broom::augment(crime) |> 
  ggplot(aes(.fittedPC1, .fittedPC3, color = region, label = st)) + 
  geom_point(size = 1.5) +
  geom_text(nudge_x = 0.2) +
  geom_hline(yintercept = 0) +
  geom_vline(xintercept = 0) +
  stat_ellipse(color = "grey") +
  coord_fixed() +
  labs(x = "PC Dimension 1", y = "PC Dimnension 3") +
  theme_minimal(base_size = 14) +
  theme(legend.position = "top") 



# tidy variable vectors

crime.pca |> purrr::pluck("rotation")

crime.pca |>
  tidy(matrix = "rotation")



# define arrow style for plotting
arrow_style <- arrow(
  angle = 20, ends = "first", type = "closed", length = grid::unit(8, "pt")
)

# try to plot the unit circle
r <- 1
theta <- c(seq(-pi, pi, length = 100))
cir  <- data.frame(PC1 = r * cos(theta), PC2 = r * sin(theta))
circle <- geom_path(data = circle, color = "grey")

# plot rotation matrix
crime.pca |>
  tidy(matrix = "rotation") |>
  tidyr::pivot_wider(names_from = "PC", 
                     names_prefix = "PC", 
                     values_from = "value") |>
  ggplot(aes(PC1, PC2)) +
  geom_segment(xend = 0, yend = 0, arrow = arrow_style) +
  geom_text(
    aes(label = column),
    hjust = 1, nudge_x = -0.02, 
    color = "brown") +
  xlim(-0.8, .2) + ylim(-.7, 0.6) +
  coord_fixed() + # fix aspect ratio to 1:1
  theme_minimal(base_size = 14) 


# do this without pivot_wider

vectors <- crime.pca |> 
  purrr::pluck("rotation") |>
  as.data.frame() |>
  mutate(PC1 = -1 * PC1, PC2 = -1 * PC2) |>      # reflect axes
  tibble::rownames_to_column(var = "label") 
vectors

vectors |>
  ggplot(aes(PC1, PC2)) +
  geom_hline(yintercept = 0) +
  geom_vline(xintercept = 0) +
  geom_segment(xend = 0, yend = 0, linewidth=1, arrow = arrow_style) +
  geom_text(aes(label = label), 
            size = 5,
            hjust = "outward",
            nudge_x = 0.05, 
            color = "brown") +
  ggforce::geom_circle(aes(x0 = 0, y0 = 0, r = 0.5),  color = gray(.50)) +
  xlim(-0.5, 0.9) + ylim(-0.8, 0.8) +
  coord_fixed() + # fix aspect ratio to 1:1
  theme_minimal(base_size = 14)

# interpreting variable vectors
vectors[, 2:3]^2 |> rowSums() |> sqrt()
vectors |> select(label, PC1, PC2) |> mutate(length = sqrt(PC1^2 + PC2^2))

matlib::len(vectors)
matlib::len(t(vectors))

# correlations of
crime.pca |>
  broom::augment(crime)

# correlations
crime |> select(murder, burglary, larceny, auto) |> cor()
crime |> select(larceny, auto) |> cor()

# angles between vectors
vec <- vectors <- crime.pca |> 
  purrr::pluck("rotation")
vec <- vec[, 1:2]
vec %*% t(vec)
matlib::angle(vec[1,], vec[7,]) |> cos()
