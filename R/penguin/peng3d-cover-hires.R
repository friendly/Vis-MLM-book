#' ---
#' title: High-resolution cover artwork, penguins with 3D ellipsoids
#' ---
#'
#' The same scene as R/penguin/penguins3d.R (which made images/cover/peng3d-cover-crop.png
#' at 770 x 770 px, from an 800 x 800 window), rendered at print resolution for the
#' publisher's cover designer. Run from the project root.
#'
#' Three changes from penguins3d.R make the higher resolution possible:
#'  * the 3D scene is rendered through headless Chrome (webshot2) at `size` px,
#'    rather than captured from the on-screen window;
#'  * the 2D plots on the floor and back wall (show2d) are drawn into textures `k` times
#'    the default 480 px, with res = 72 * k so their text and lines keep the same proportions;
#'  * the WebGL renderer draws all lines 1 px wide and sizes text in px, so the box
#'    edges are drawn as thin tubes and the 3D labels' cex is scaled by size / 800.
#'    For round tubes, each variable is rescaled to [0, 1]; plot3d() shows the data in
#'    a cube anyway (aspect = TRUE), so the picture is unchanged.

library(rgl)
library(car)
library(magick)

size <- 3000          # rendered image, px (square)
k    <- 6             # texture scale: 480 * k px
out  <- "images/cover/peng3d-cover-hires.png"

data(peng, package = "heplots")
peng <- peng[, c(1, 3, 4, 6)]       # species, bill_length, bill_depth, body_mass
# "Adelie", as on the current cover: rgl's texts3d() rejects the "é" of "Adélie" here

DSQ <- heplots::Mahalanobis(peng[, -1])     # on the original scales
noteworthy <- order(DSQ, decreasing = TRUE)[1:2]

# 3D coordinates, each variable rescaled to [0, 1]
peng3 <- peng
peng3[, -1] <- lapply(peng[, -1], \(v) (v - min(v)) / diff(range(v)))
pengnote  <- cbind(ID = noteworthy, peng[noteworthy, ])    # for the 2D floor plot
pengnote3 <- cbind(ID = noteworthy, peng3[noteworthy, ])   # for the 3D points

shapes <- c(15, 17, 18)
source("R/penguin/penguin-colors.R")
col <- peng.colors("dark")

# 2D plots for the floor and back wall, drawn at k x the default texture size
texture <- function(expr, file = tempfile(fileext = ".png")) {
  png(file, width = 480 * k, height = 480 * k, res = 72 * k)
  expr
  dev.off()
  file
}

floor_png <- texture({
  par(mar = c(0, 0, 0, 0))
  dataEllipse(x = peng$bill_length, y = peng$bill_depth,
              groups = peng$species,
              ellipse.label = peng$species,
              label.pos = 0,
              plot.points = FALSE, add = FALSE,
              levels = 0.68,
              col = col,
              label.cex = 2,
              center.pch = "",
              fill = TRUE, fill.alpha = 0.2,
              xlab = "", ylab = "", yaxt = "n", xaxt = "n")
  points(x = pengnote$bill_length, y = pengnote$bill_depth,
         col = col[pengnote$species], pch = shapes[pengnote$species], cex = 4)
})

wall_png <- texture({
  par(mar = c(0, 0, 0, 0))
  boxplot(body_mass ~ species, data = peng,
          col = adjustcolor(col, alpha = 0.5),
          at = 3:1)
})

# --- the 3D scene, as in penguins3d.R
open3d()
par3d(windowRect = c(0, 0, 800, 800) + 80)

plot3d(peng3[, -1], type = "n", axes = FALSE,
       xlab = "", ylab = "", zlab = "")   # titles would enlarge the bounding box

# pch3d's sprites would otherwise stretch the bounding box well beyond the unit cube
save <- par3d(ignoreExtent = TRUE)
pch3d(pengnote3[, -(1:2)],
      col = col[pengnote3$species],
      pch = shapes[pengnote3$species],
      cex = 0.5)      # 1 in penguins3d.R, where the sprites were sized from a larger box
par3d(save)

for (sp in levels(peng$species)) {
  xyz <- subset(peng3, species == sp)[, 2:4]
  mu <- colMeans(xyz)
  shade3d(ellipse3d(cov(xyz), centre = mu, level = 0.68),
          alpha = 0.2, color = col[sp])
  texts3d(mu, adj = 0.5, text = sp, color = col[sp], font = 2,
          cex = 1.8 * size / 800)
}

# box edges as tubes (box3d() lines would be 1 px wide at this size)
# at the unit cube expanded by 3%, where show2d() puts the floor and wall, so the
# frames of those 2D plots coincide with the box
lim <- 0.5 + c(-1, 1) * 1.03 / 2
corners <- expand.grid(x = lim, y = lim, z = lim)
# an edge joins two corners that differ in exactly one coordinate
ndiff <- Reduce(`+`, lapply(corners, \(v) outer(v, v, "!=")))
edges <- which(ndiff == 1 & upper.tri(ndiff), arr.ind = TRUE)   # 12 edges
save <- par3d(ignoreExtent = TRUE)
for (e in seq_len(nrow(edges)))
  shade3d(cylinder3d(as.matrix(corners[edges[e, ], ]), radius = 0.0012, sides = 12),
          color = "gray20", lit = FALSE)
par3d(save)
show2d(filename = floor_png, face = "z-")
show2d(filename = wall_png,  face = "x-")

par3d(userMatrix =
  structure(c(0.906833529472351, -0.0781354010105133, 0.41418331861496,
              0, 0.421430557966232, 0.151753112673759, -0.89407342672348, 0,
              0.00700519979000092, 0.985325217247009, 0.170543491840363, 0,
              0, 0, 0, 1), dim = c(4L, 4L)),
      zoom = 0.655)

tmp <- tempfile(fileext = ".png")
snapshot3d(tmp, width = size, height = size, webshot = TRUE)

# same crop as penguins3d.R (770 x 770 from 800 x 800, 30 px off the top), scaled
img <- image_read(tmp)
s <- image_info(img)$width / 800
img <- image_crop(img, geometry_area(width = round(770 * s), height = round(770 * s),
                                     x_off = 0, y_off = round(30 * s)))
image_write(img, out, density = 300)
print(image_info(image_read(out)))
