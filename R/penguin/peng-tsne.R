# from: Rickert, Manifold Learning, https://rworks.dev/posts/manifold-learning/

library(tsne)
library(dplyr)
library(ggplot2)
library(threejs)

data(peng, package="heplots")
source("R/penguin/penguin-colors.R")

# use penguin colors
col <- peng.colors("medium")
pch <- 15:17
theme_set(theme_bw(base_size = 14))


df_p <- palmerpenguins::penguins
# glimpse(df_p)

# Prepare data frames for fitting the model and then for subsequent plotting.
df_p_fit <- df_p |> 
  mutate(island = as.integer(island), 
         sex = as.integer(sex)) |>
  select(c(-year, -species)) |> 
  na.omit()

df_p_plot <- df_p |> 
  select(-year) |> 
  na.omit() 

#peng_tsne_2D <- tsne(df_p_fit, perplexity=50)
#saveRDS(peng_tsne_2D, file = here::here("data", "peng_tsne_2D.rds"))
peng_tsne_2D <- readRDS(here::here("data", "peng_tsne_2D.rds"))

# Next, we add the coordinates fit by the model to our plotting data frame and plot. 
# As we would expect, the clusters identified by t-SNE line up very nicely with the penguin species, and island. 
# All of the Gentoo are on Biscoe Island.

df_p_plot <- df_p_plot |> 
  mutate(x = peng_tsne_2D[, 1], y = peng_tsne_2D[, 2])

df_p_plot |> 
  ggplot(aes(x, y, colour = species, shape = island)) +
  geom_point(size = 2.5) +
  scale_color_manual(values = c("blue", "red", "green")) +
  ggtitle("2D Embedding of Penguins Data") +
  theme_bw(base_size = 14)

# 3D
# Here is a projection onto a three-dimensional space.
peng_tsne_3D = tsne(df_p_fit, perplexity=50, k=3)
saveRDS(peng_tsne_3D, file = here::here("data", "peng_tsne_3D.rds"))
peng_tsne_3D <- readRDS("peng_tsne_3D")


x <- peng_tsne_3D[,1] 
y <- peng_tsne_3D[,2]
z <- peng_tsne_3D[,3]

# The threejs visualization emphasizes the single Chinstrap observation floating in space near 
# the Adelle clusters and the two Gentoos reaching the edge of Chinstrap Island.

df_p_plot <- df_p_plot |> 
  mutate(color = if_else(species == "Adelie", "blue", 
                 if_else( species == "Gentoo","green", "red")))

scatterplot3js(x,y,z, color=df_p_plot$color, cex.symbols = .3, 
               labels = df_p_plot$species)

