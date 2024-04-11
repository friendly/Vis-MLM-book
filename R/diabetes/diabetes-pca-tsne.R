#' ---
#' title: Animate transition from PCA <--> tsne
#' ---
# idea from: https://jef.works/genomic-data-visualization-2024/blog/2024/03/06/akwok1/

#' ## Load packages and data
library(ggplot2) 
library(gganimate) 
library(Rtsne) 
library(patchwork)

data(Diabetes, package="heplots")

#' ## PCA
diab.pca <- prcomp(Diabetes[, 1:5], scale = TRUE, rank.=2) 
df1 <- data.frame(diab.pca$x, group = Diabetes$group) 
colnames(df1) <- c("Dim1", "Dim2", "group")
df1 <- cbind(df1, method="PCA")

cols <- scales::hue_pal()(3) |> rev()
p1 <- ggplot(df1, aes(x=Dim1, y=Dim2, color=group, shape=group)) + 
  geom_point(size = 3) + 
  stat_ellipse(level = 0.68, linewidth=1.1) +
  geom_hline(yintercept = 0) +
  geom_vline(xintercept = 0) +
  scale_color_manual(values = cols) +
  labs(x = "Dimension 1",
       y = "Dimension 2") + 
  ggtitle("PCA") +
  theme_bw(base_size = 16) +
  theme(legend.position = "bottom") 
p1

#' ## tSNE: nonlinear dimensionality reduction 
set.seed(123) 
diab.tsne <- Rtsne(Diabetes[, 1:5], scale = TRUE)
df2 <- data.frame(diab.tsne$Y, group = Diabetes$group) 
colnames(df2) <- c("Dim1", "Dim2", "group")
df2 <- cbind(df2, method="tSNE")

p2 <- ggplot(df2, aes(x=Dim1, y=Dim2, color = group, shape=group)) + 
  geom_point(size = 3) + 
  stat_ellipse(level = 0.68, linewidth=1.1) +
  geom_hline(yintercept = 0) +
  geom_vline(xintercept = 0) +
  scale_color_manual(values = cols) +
  labs(x = "Dimension 1",
       y = "Dimension 2") + 
  ggtitle("tSNE") +
  theme_bw(base_size = 16) +
  theme(legend.position = "bottom") 
p2

both <- p1 + p2 & theme(legend.position = "bottom")
both + plot_layout(guides = "collect")

ggsave("images/diabetes-pca-tsne.png", width = 8, height = 4)

#' ## Make an animated plot showing transitions between the PCA representation and the tsne one

df3 <- rbind(df1, df2) 

animated_plot <- 
  ggplot(df3, aes(x=Dim1, y=Dim2, color=group, shape=group)) + 
  geom_point(size = 3) + 
  stat_ellipse(level = 0.68, linewidth=1.1) +
  geom_hline(yintercept = 0) +
  geom_vline(xintercept = 0) +
  scale_color_manual(values = cols) +
#  coord_fixed() +
  labs(title = "PCA vs. tSNE Dimension Reduction: {closest_state}",
       subtitle = "Frame {frame} of {nframes}",
       x = "Dimension 1",
       y = "Dimension 2") + 
  transition_states( method, transition_length = 3, state_length = 2 ) + 
  view_follow() + 
  theme_bw(base_size = 16) +
  theme(legend.position = "bottom") 

animated_plot

anim_save("diabetes-pca-tsne.gif", animated_plot, path="images/")

# try adding vectors

source("R/ggvectors.R")
vecs <- diab.pca$rotation
p1 + ggvectors(vecs[,1], vecs[,2], label = rownames(vecs),
               color = cols)

scale <- 5
p1 + geom_segment(data = vecs, 
                  aes(x = 0, xend = scale * PC1, 
                      y = 0, yend = scale * PC2),
                  inherit.aes = FALSE)

?ordr::geom_vector

#library(ordr)    # masks too much
arrow_style <- arrow(length = unit(1/2, 'picas'), 
                     type="closed", 
                     angle=20) 
p1 + ordr::geom_vector(data=vecs, 
                 aes(x=scale * PC1, y=scale * PC2),
                 arrow = arrow_style,
                 linewidth = 1.2,
                 inherit.aes = FALSE)

last_plot() + ordr::geom_text_radiate(
  data=vecs, 
  aes(x=scale * PC1, y=scale * PC2), 
  label = rownames(vecs),
  inherit.aes = FALSE)  
