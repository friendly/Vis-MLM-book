#' ---
#' title: Penguins data with 3D ellipsoids
#' ---

#library(ggplot2)
library(dplyr)
library(tidyr)
library(rgl)
library(car)


data(peng, package="heplots")
# just keep bill dimensions and body_mass
#species <- peng[,1]
peng <- peng[, c(1,3,4,6)]
names(peng)

# Use Adélie
peng$species <- factor(peng$species, labels = c("Adélie", "Chinstrap", "Gentoo"))

#levels(species)

DSQ <- heplots::Mahalanobis(peng[, -1])
noteworthy <- order(DSQ, decreasing = TRUE)[1:2] |> print()

pengnote <- cbind(ID=noteworthy, peng[noteworthy,]) |> print()




shapes <- c(15, 17, 18)
#shapes <- 1:3
# colors <- c("red", "blue", "darkgreen")
# names(colors) <- levels(peng$species)
source("R/penguin/penguin-colors.R")
col <- peng.colors("dark")

colMax <- function(data) sapply(data, max, na.rm = TRUE)


open3d()
par3d(windowRect = c(0, 0, 800, 800) + 80)
rgl.bringtotop()

plot3d(peng[,-1], 
       type = "n", 
       axes = FALSE, labels = FALSE)

# noteworthy points
pch3d(pengnote[,-(1:2)],
      col = col[pengnote$species], 
      pch = shapes[pengnote$species],
      cex = 1)


offset <- 0.01
for (sp in levels(peng$species)) {
  xyz <- subset(peng, species == sp)[, 2:4]

# ellipsoids
  mu <- apply(xyz, 2, mean)
  sigma <- cov(xyz)
  ell <- ellipse3d(sigma, centre = mu, level = 0.68,)

  shade3d(ell, 
          alpha = 0.2, color = col[sp])

# find location to label the ellipse
  max <- colMax(xyz)
  bbox <- matrix(rgl::par3d("bbox"), nrow=2)
  ranges <- apply(bbox, 2, diff)
  texts3d(mu, adj = .5, text = sp, 
          color = col[sp], 
          font = 2,
          cex = 1.8)
}


box3d(labels = FALSE)
#grid3d('z')

# https://stackoverflow.com/questions/50027798/in-r-rgl-how-to-print-shadows-of-points-in-plot3d
show2d({
  par(mar=c(0,0,0,0))
dataEllipse(x=peng$bill_length, y=peng$bill_depth, 
  groups = peng$species, 
  #   group.labels = NULL,
  ellipse.label = peng$species,
  label.pos = 0,
  plot.points = FALSE, add = FALSE,
  levels = 0.68,
  col = col,
  label.cex = 2,
  center.pch = "",
  fill = TRUE, fill.alpha = 0.2,
  xlab = "", ylab= "", yaxt = "n", xaxt = "n")
points(x=pengnote$bill_length, 
       y=pengnote$bill_depth,
       col = col[pengnote$species], 
       pch = shapes[pengnote$species],
       cex = 4)
# text(x=pengnote$bill_length, 
#      y=pengnote$bill_depth,
#      label=pengnote$ID,
#      cex = 2, pos = c(1, 4, 1))
}, face = "z-")

show2d({
  par(mar=c(0,0,0,0))
  boxplot(body_mass ~ species, data = peng,   # was bill_depth
          col = adjustcolor(col, alpha = 0.5),
          at = 3:1)
  }, face = "x-")


# rotate manually, then save rgl coordinates
userMatrix <- par3d()$userMatrix

uM <- dput(userMatrix)

par3d(userMatrix =
structure(c(0.906833529472351, -0.0781354010105133, 0.41418331861496, 
            0, 0.421430557966232, 0.151753112673759, -0.89407342672348, 0, 
            0.00700519979000092, 0.985325217247009, 0.170543491840363, 0, 
            0, 0, 0, 1), dim = c(4L, 4L))
)
# > (zoom <- par3d()$zoom)
# [1] 0.677
par3d(zoom = 0.655)

outfile <- "images/peng3d-cover.png"
snapshot3d(outfile)

library(magick)
img <- image_read(outfile)
summary(img)
# it's 800 x 800
img <- image_crop(img, 
           geometry_area(width=770, height=770,
                         x_off=0, y_off=30)
  )
image_write(img, "images/peng3d-cover-crop.png")

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
  #   group.labels = NULL,
  ellipse.label = peng$species,
  label.pos = 0,
  plot.points = FALSE, add = FALSE,
  levels = 0.68,
  col = col,
  label.cex = 2,
  center.pch = "",
  fill = TRUE, fill.alpha = 0.2,
  xlab = "", ylab= "", yaxt = "n", xaxt = "n")
points(x=pengnote$bill_length, 
       y=pengnote$bill_depth,
       col = col[pengnote$species], 
       pch = shapes[pengnote$species],
       cex = 4)
text(x=pengnote$bill_length, 
     y=pengnote$bill_depth,
     label=pengnote$ID,
     cex = 2, pos = c(1, 4, 1))
par(op)
