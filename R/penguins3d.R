#' ---
#' title: Penguins data with 3D ellipsoids
#' ---

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
#shapes <- 1:3
colors <- c("red", "blue", "darkgreen")
names(colors) <- levels(peng$species)

colMax <- function(data) sapply(data, max, na.rm = TRUE)

open3d()
par3d(windowRect = c(0, 0, 800, 800) + 50)
rgl.bringtotop()

plot3d(peng[,-1], type = "n")
pch3d(peng[,-1],
      pch = shapes,
      col = adjustcolor(colors[peng$species], alpha=0.4),
      cex = 0.2)

offset <- 0.01
for (sp in levels(peng$species)) {
  xyz <- subset(peng, species == sp)[, 2:4]

# ellipsoids
  mu <- apply(xyz, 2, mean)
  sigma <- cov(xyz)
  ell <- ellipse3d(sigma, centre = mu, level = 0.68)

  shade3d(ell, 
          alpha = 0.2, color = colors[sp])

# find location to label the ellipse
  max <- colMax(xyz)
  bbox <- matrix(rgl::par3d("bbox"), nrow=2)
  ranges <- apply(bbox, 2, diff)
  texts3d(mu, adj = 0, text = sp, color = colors[sp], cex = 1.5)
}

grid3d('z')

# https://stackoverflow.com/questions/50027798/in-r-rgl-how-to-print-shadows-of-points-in-plot3d
show2d({
  par(mar=c(0,0,0,0))
  plot(# x = df$x, y = df$y, 
    peng[, 1:2],
       col = colors)
})

rgl::decorate3d( # xlim=xlim, ylim=ylim, zlim=zlim, 
                box=FALSE, axes=FALSE, 
                xlab=NULL, ylab=NULL, zlab=NULL, top=FALSE)
