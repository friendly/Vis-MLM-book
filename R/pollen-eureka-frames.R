#' ---
#' title: "Pollen data: the four EUREKA panels (@fig-pollen-eureka, 01-Prelude.qmd)"
#' ---
#' Re-renders images/pollen-eureka1.png ... pollen-eureka4.png: four views of the
#' pollen data, zooming in to reveal the word "EUREKA".
#'
#' - The view (userMatrix) is the one in R/pollen-animation.R, which made the
#'   original 2023 screenshots.
#' - The zoom for each panel was matched to those screenshots.
#' - Axis titles are left blank; tick labels are kept.
#' - Point size 3.7 matches the ink density of the original screenshots.
#' - Rendered with rgl's WebGL snapshot at 3x pixel density (webshot2's `zoom`),
#'   giving 1605 x 1593 px panels, about 585 dpi in the half-width panels of the PDF.
#'
#' Requires: rgl, animation (for the data), webshot2, and Chrome or Chromium.
#' Usage: Rscript R/pollen-eureka-frames.R [output directory, default images/]

options(rgl.useNULL = TRUE)   # render headless; snapshots go through webshot2 + Chrome
library(rgl)

args <- commandArgs(trailingOnly = TRUE)
out_dir <- if (length(args)) args[1] else here::here("images")

data(pollen, package = "animation")

# view from R/pollen-animation.R
uM <- matrix(c(-0.370919227600098, -0.513357102870941, -0.773877620697021, 0,
               -0.73050606250763,   0.675815105438232, -0.0981751680374146, 0,
                0.573396027088165,  0.528906404972076, -0.625681936740875, 0,
                0, 0, 0, 1), 4, 4)

# panels 1-4, shown clockwise from the upper left in the figure
zoom <- c(0.870, 0.510, 0.223, 0.084)

open3d(userMatrix = uM, windowRect = c(10, 10, 545, 541))
plot3d(pollen[, 1:3], xlab = "", ylab = "", zlab = "",
       size = 3.7, point_antialias = TRUE)

for (i in seq_along(zoom)) {
  par3d(zoom = zoom[i])
  snapshot3d(file.path(out_dir, sprintf("pollen-eureka%d.png", i)),
             webshot = TRUE, width = 535, height = 531, zoom = 3)
}
