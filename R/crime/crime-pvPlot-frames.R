#' ---
#' title: "Crime partial variables plots: high-resolution image for the PDF (04-multivariate_plots.qmd)"
#' ---
#' Re-renders images/crime-pvPlot-1-2.png (@fig-crime-pvPlots) at 3x the original
#' pixel size, along with its two single panels, images/crime-pvPlot1.png and
#' crime-pvPlot2.png.
#'
#' The original images (Oct. 2024) were drawn with the book's own pvPlot() of that
#' time (git 713f707e:R/pvPlot.R), which called car::scatterplot(). That function
#' has since moved to heplots::pvPlot(), which draws differently (axis titles
#' "x | others", black labels, ...), so the 2024 drawing code is copied below as
#' pvPlot_2024() to keep the printed figure unchanged.
#'
#' Two adjustments are needed with current car (3.1.5) to match the 2024 output:
#' - car::dataEllipse() now marks the ellipse centre (center.pch = 19), and
#'   scatterplot() has no way to turn it off, so its default is set to FALSE
#'   for this script only.
#' - The state labels are passed in explicitly via id = list(labels = ...);
#'   otherwise scatterplot() labels points by row number.
#'
#' The originals were 500x500 per panel at 72 ppi (png() default); here each panel
#' is 1500x1500 at res = 216, so text and symbols keep the same relative size.
#' Combined image: 3000x1500, eff. ~548 dpi at 5.5in.

library(car)
library(magick)

k <- 3   # scale factor relative to the 2024 images

# car >= 3.1-? draws the ellipse centre by default; the 2024 images did not
de <- car:::dataEllipse.default
formals(de)$center.pch <- FALSE
assignInNamespace("dataEllipse.default", de, "car")

# Drawing code of pvPlot() as of git 713f707e:R/pvPlot.R (Oct. 2024), trimmed to
# what these plots use
pvPlot_2024 <- function(X, vars, labels = rownames(X), ellipse = FALSE,
                        col = "black", pch = 16, cex = par("cex"), ...) {
  others <- setdiff(names(X), vars)
  res <- X[, vars]
  res[, 1] <- lsfit(X[, others], X[, vars[1]])$residuals
  res[, 2] <- lsfit(X[, others], X[, vars[2]])$residuals

  car::scatterplot(res[, 1], res[, 2],
    xlab = paste(vars[1], "residual"), ylab = paste(vars[2], "residual"),
    pch = pch, col = col, cex = cex,
    ellipse = ellipse,
    smooth = FALSE, boxplots = FALSE,
    grid = FALSE,
    id = list(n = 5, labels = labels),
    ...)
  abline(h = 0, v = 0, col = "gray")

  pcor <- round(cor(res[, 1], res[, 2]), 3)
  usr <- par("usr")
  par(usr = c(0, 1, 0, 1))
  text(0.025, 0.95, label = paste("partial r =", pcor), pos = 4, cex = 1.25)
  par(usr = usr)
  invisible(res)
}

data(crime, package = "ggbiplot")
crime.num <- crime |>
  tibble::column_to_rownames("st") |>
  dplyr::select(where(is.numeric))

ellipse.args <- list(levels = 0.68, fill.alpha = 0.1, robust = FALSE)

panel <- function(file, vars) {
  png(filename = file, height = 500 * k, width = 500 * k, res = 72 * k)
  op <- par(mar = c(5, 5, 1, 1) + .5)
  pvPlot_2024(crime.num, vars = vars, ellipse = ellipse.args, cex.lab = 1.5)
  par(op)
  dev.off()
}

panel("images/crime-pvPlot1.png", c("burglary", "larceny"))
panel("images/crime-pvPlot2.png", c("robbery", "auto"))

# combine them side by side
p12 <- image_append(c(image_read("images/crime-pvPlot1.png"),
                      image_read("images/crime-pvPlot2.png")), stack = FALSE)
image_write(p12, path = "images/crime-pvPlot-1-2.png", format = "png")
