library(tidyverse)
library(broom)  # devtools::install_github("tidymodels/broom")
library(cowplot)
library(ggrepel)
library(glue)

crime <- read_csv(here::here("data", "crime.csv"))

crime <- crime |>
  bind_cols(region = state.region)

pca_fit <- crime |> 
  select(where(is.numeric)) |> # retain only numeric columns
  scale() |> # scale data
  prcomp(rank. = 2) # do PCA

dim_labels <- pca_fit |>
  tidy(matrix = "eigenvalues") |>
  select(PC, percent) |>
  slice(1:2) |>
  glue::glue_data("Dimension {PC} ({round(100 * percent, 2)} %)")


# plot points
p1 <- pca_fit |>
  augment(crime) |> # add original dataset back in
  rename(PC1 = .fittedPC1, 
         PC2 = .fittedPC2) |>
  ggplot(aes(PC1, PC2, color = region)) + 
  geom_point(size = 1.5) +
  labs(x = dim_labels[1], 
       y = dim_labels[2])

p1 + stat_ellipse(level = 0.68, aes(label=region))

# define arrow style for plotting
arrow_style <- arrow(
  angle = 20, ends = "first", type = "closed", length = grid::unit(8, "pt")
)

vecscale <- 1.6
pca_fit |>
  tidy(matrix = "rotation") |>
  mutate(value = vecscale * value) |>
  pivot_wider(names_from = "PC", names_prefix = "PC", values_from = "value") |>
  ggplot(aes(PC1, PC2)) +
  geom_segment(xend = 0, yend = 0, 
               linewidth = 1.2,
               arrow = arrow_style) +
  geom_text(
    aes(label = column),
    hjust = 1, nudge_x = -0.02, 
    color = "#904C2F"
  ) +
  xlim(-1.25, .5) + ylim(-.5, 1) +
  coord_fixed()  # fix aspect ratio to 1:1
  
# put these together

points <- pca_fit |>
  augment(crime) |> # add original dataset back in
  rename(PC1 = .fittedPC1, 
         PC2 = .fittedPC2)

vecscale = 4
vectors <- pca_fit |>
  tidy(matrix = "rotation") |>
  mutate(value = vecscale * value) |>
  pivot_wider(names_from = "PC", names_prefix = "PC", values_from = "value") 

ggplot(data = points, aes(PC1, PC2)) + 
  geom_point(aes(color = region), size = 1.5) +
  labs(x = dim_labels[1], 
       y = dim_labels[2]) +
  stat_ellipse(aes(color = region), level = 0.68) +
  geom_segment(data = vectors,
               aes(PC1, PC2),
               xend = 0, yend = 0, 
               linewidth = 1.2,
               arrow = arrow_style) +
  geom_text(data = vectors,
    aes(label = column),
    hjust = 1, nudge_x = -0.02, 
    color = "#904C2F"
  ) +
  coord_equal() +
  theme_bw() +
  theme(legend.position = "top")


