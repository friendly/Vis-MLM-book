#' ---
#' title: Diabetes data, multidimensional scaling (MDS)
#' ---

library(MASS)
library(ggpubr)
library(ggbiplot)
library(dplyr)
source("R/common.R")    # legend_inside()

data(Diabetes, package="heplots")

# mds <- Diabetes |>
#   dplyr::select(where(is.numeric)) |>
#   dist() |>          
#   isoMDS() |>
#   purrr::pluck("points") 

diab.dist <- dist(Diabetes[, 1:5])
mds <- diab.dist |>
  isoMDS(k = 2, trace = FALSE) |>
  purrr::pluck("points") 



colnames(mds) <- c("Dim1", "Dim2")
mds <- bind_cols(mds, group = Diabetes$group)
mds |> sample_n(6)

# Plot MDS solution
cols <- scales::hue_pal()(3) |> rev()
mplot <-
ggscatter(mds, x = "Dim1", y = "Dim2", 
          color = "group",
          shape = "group",
          palette = cols,
          size = 2,
          ellipse = TRUE,
          ellipse.level = 0.5,
          ellipse.type = "t") +
  geom_hline(yintercept = 0, color = "gray") +
  geom_vline(xintercept = 0, color = "gray") 
  
mplot

# project variables into this space

vectors <- cor(Diabetes[, 1:5], mds[, 1:2])
scale_fac <- 500
mplot + 
  coord_fixed() +
  geom_segment(data=vectors,
               aes(x=0, xend=scale_fac*Dim1, y=0, yend=scale_fac*Dim2),
               arrow = arrow(length = unit(0.2, "cm"), type = "closed"),
               linewidth = 1.1) +
  geom_text(data = vectors,
            aes(x = 1.15*scale_fac*Dim1, y = 1.07*scale_fac*Dim2, 
                label=row.names(vectors)),
            nudge_x = 4,
            size = 4) +
  theme(legend.position = "inside",
        legend.position.inside = c(.8, .8))

# same plot, using ggbiplot::ggvector() instead of geom_segment()+geom_text()
# -- simpler (no manual nudge/angle), and draws nicer arrowheads via ggarrow

mplot +
  coord_fixed(clip = "off") +
  ggvector(x = vectors[, "Dim1"], y = vectors[, "Dim2"],
           label = rownames(vectors),
           scale = scale_fac,
           linewidth = 1.1,
           angle = 0,
           size = 6) +
  legend_inside(c(.8, .8))

# ggvector() for the arrows (nicer arrowheads), but with horizontal labels --
# ggvector()'s own text layer always angles labels along the vector, with no
# option to override this, so draw the labels separately instead

mplot +
  coord_fixed(clip = "off") +
  ggvector(x = vectors[, "Dim1"], y = vectors[, "Dim2"],
           geom.var = "arrow",
           scale = scale_fac,
           linewidth = 1.1) +
  geom_text(data = as.data.frame(vectors),
            aes(x = 1.15*scale_fac*Dim1, y = 1.07*scale_fac*Dim2,
                label = rownames(vectors)),
            size = 6) +
  legend_inside(c(.8, .8))


# find stress over several dimensions

diab.dist <- dist(Diabetes[, 1:5])

stress <- vector(length = 5)
for(k in 1:5){
  res <- MASS::isoMDS(diab.dist, k=k)
  stress[k] <- res$stress
}
round(stress, 3)

op <- par(mar = c(5, 4, 1, 1)+0.1)
plot(stress, type = "b", pch = 16, cex = 2,
     xlab = "Number of dimensions",
     ylab = "Stress (%)")
par(op)


# try vegan::metaMDS  
library(vegan)
diab.mds <- metaMDS(diab.dist, distance="euclidean", k=2, trace = 0)
names(diab.mds)
stressplot(diab.mds)
plot(diab.mds)

points <- data.frame(diab.mds$points, group = Diabetes$group)
species <- data.frame(diab.mds$species)

(fit <- envfit(diab.mds, Diabetes[, 1:5]))

plot(diab.mds)
plot(fit)
points(points[, 1:2], col = Diabetes$group)
car::dataEllipse(MDS2 ~ MDS1 | group, data=points, 
                 col = cols,
                 levels = 0.5, add=TRUE)

scores(fit, "vectors")


cols <- scales::hue_pal()(3) |> rev()
ggplot(data=points, aes(x = MDS1, y = MDS2, 
                        color = group, shape = group)) +
  geom_point(size = 2) +
  stat_ellipse(level = 0.68, linewidth=1.1) +
  geom_hline(yintercept = 0) +
  geom_vline(xintercept = 0) +
  scale_color_manual(values = cols) +
  geom_segment(data = vectors, aes(x=0, xend=MDS1, y=0, yend=MDS2,),
               arrow = arrow(length = unit(0.2, "cm"), type = "closed"),
               colour="black",
               linewidth = 1.2,
               inherit.aes = FALSE) +
  geom_text(data=vectors, aes(x=MDS1, y=MDS2, label=rownames(vectors)), 
            size=5,
            vjust = "outward",
            inherit.aes = FALSE) +
  coord_cartesian(clip = "off") +
  theme_bw(base_size = 14) +
  theme(legend.position = "inside",
        legend.position.inside = c(.8, .8))


