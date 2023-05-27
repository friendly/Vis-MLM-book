#' ---
#' title: Penguins data with 3D ellipsoids

library(ggplot2)
library(dplyr)
library(tidyr)
library(rgl)

data(penguins, package = "palmerpenguins")

penguins <- penguins |>
  drop_na()

#' Select variables
peng <- penguins |>
  select(species, starts_with("bill"), body_mass_g) |>
  rename_with(~ stringr::str_remove(., '_mm$|_g$'))

str(peng)

shapes <- c(15, 17, 18)
colors <- rainbow(3)

colMax <- function(data) sapply(data, max, na.rm = TRUE)

open3d()
par3d(windowRect = c(0, 0, 800, 800) + 50)
rgl.bringtotop()

plot3d(peng[,-1], type = "n")
# pch3d(peng[,-1], 
#       pch = shapes, 
#       col = adjustcolor(colors[peng$species], alpha=0.4), 
#       cex = 0.1,
#       decorate = FALSE)

offset <- 0.01
for (sp in levels(peng$species)) {
  cl <- subset(peng, species == sp)
  max <- colMax(cl[, 2:4])
  print(max)
  sigma <- cov(cl[,2:4])
  mu <- apply(cl[, 2:4], 2, mean)
  ell <- ellipse3d(sigma, centre = mu, level = 0.68)
  bbox <- matrix(rgl::par3d("bbox"), nrow=2)
  ranges <- apply(bbox, 2, diff)
  
  shade3d(ell, 
          alpha = 0.2, color = colors[sp])
  texts3d(max, adj = 0, text = sp, color = colors[sp], cex = 5)
  # texts3d(x[which.max(x[,2]),] + offset*ranges, 
  #         adj=0, texts=sp, color=col, lit=FALSE)
}
