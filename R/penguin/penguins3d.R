#' ---
#' title: Penguins data with 3D ellipsoids
#' ---

#library(ggplot2)
library(dplyr)
library(tidyr)
library(rgl)
library(car)

data(penguins, package = "palmerpenguins")

penguins <- penguins |>
  drop_na()

#' Select variables
peng <- penguins |>
  select(species, starts_with("bill"), body_mass_g) |>
  rename_with(~ stringr::str_remove(., '_mm$|_g$'))
str(peng)
#' 

load(here::here("data", "peng.RData"))
# just keep bill dimensions and body_mass
#species <- peng[,1]
peng <- peng[, c(1,3,4,6)]
names(peng)
#levels(species)

shapes <- c(15, 17, 18)
#shapes <- 1:3
# colors <- c("red", "blue", "darkgreen")
# names(colors) <- levels(peng$species)
source("R/penguin/penguin-colors.R")
colors <- peng.colors("dark")

colMax <- function(data) sapply(data, max, na.rm = TRUE)


open3d()
par3d(windowRect = c(0, 0, 800, 800) + 80)
rgl.bringtotop()

plot3d(peng[,-1], 
       type = "n", axes = FALSE)

# plot points
# pch3d(peng[,-1],
#       pch = shapes,
#       col = adjustcolor(colors[peng$species], alpha=0.4),
#       cex = 0.2)

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
  texts3d(mu, adj = 0, text = sp, 
          color = colors[sp], 
          font = 2,
          cex = 1.8)
}

box3d()
#grid3d('z')

# https://stackoverflow.com/questions/50027798/in-r-rgl-how-to-print-shadows-of-points-in-plot3d
show2d({
  par(mar=c(0,0,0,0))
  dataEllipse(x=peng$bill_length, y=peng$bill_depth, 
              groups = peng$species, 
              ellipse.label = peng$species,
              label.pos = 0,
              plot.points = FALSE, add = FALSE,
              levels = 0.68,
              col = colors,
              fill = TRUE, fill.alpha = 0.2,
              xlab = "", ylab= "", yaxt = "n", xaxt = "n")
  
  }, face = "z-")
show2d({
  par(mar=c(0,0,0,0))
  boxplot(body_mass ~ species, data = peng,   # was bill_depth
          col = adjustcolor(colors, alpha = 0.5),
          at = 3:1)
  }, face = "x-")


# rotate manually, then save rgl coordinates
userMatrix <- par3d()$userMatrix

uM <- dput(userMatrix)
structure(c(0.906833529472351, -0.0781354010105133, 0.41418331861496, 
            0, 0.421430557966232, 0.151753112673759, -0.89407342672348, 0, 
            0.00700519979000092, 0.985325217247009, 0.170543491840363, 0, 
            0, 0, 0, 1), dim = c(4L, 4L))

#(zoom <- par3d()$zoom)
#(windowRect <- par3d()$windowRect)

# rgl::decorate3d( # xlim=xlim, ylim=ylim, zlim=zlim, 
#                 box=FALSE, axes=FALSE, 
#                 xlab=NULL, ylab=NULL, zlab=NULL, top=FALSE)


# test data ellipses
library(car)
op <- par(mar=c(0,0,0,0))
dataEllipse(x=peng$bill_length, y=peng$bill_depth, 
            groups = peng$species, 
#            group.labels = NULL,
            ellipse.label = peng$species,
            label.pos = 0,
            plot.points = FALSE, add = FALSE,
            levels = 0.68,
            col = colors,
            fill = TRUE, fill.alpha = 0.2,
            xlab = "", ylab= "", yaxt = "n", xaxt = "n")
par(op)
