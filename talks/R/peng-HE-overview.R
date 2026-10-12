#' ---
#' title: Penguins data, panels for the "HE plots - Visual overview" slide
#' ---

# Re-draws two panels of the CARME overview slide in the penguin colors:
#   talks/images/peng-HE-overview-1-ellipses.png  -- data ellipses, with the points
#   talks/images/peng-HE-overview-2-discrim.png   -- data ellipses and the pooled ellipse
# Run from the project root.

library(heplots)

data(peng, package = "heplots")
source("R/penguin/penguin-colors.R")

col <- peng.colors("dark")
pch <- 15:17

# same frame for both panels, so they can be overlaid or shown in sequence
xlim <- c(34, 55)
ylim <- c(13.2, 20.4)

# the originals were 450 x 475 px; keep that shape at a higher resolution
png.panel <- function(file) {
  png(file, width = 4.5, height = 4.75, units = "in", res = 300)
  par(mar = c(4, 4, 1, 1) + 0.1)
}

# data ellipses, with the points
png.panel("talks/images/peng-HE-overview-1-ellipses.png")
covEllipses(cbind(bill_length, bill_depth) ~ species, data = peng,
            pooled = FALSE,
            col = col,
            fill = TRUE, fill.alpha = 0.1,
            lwd = 2,
            cex = 1.5, cex.lab = 1.25,
            xlim = xlim, ylim = ylim)
points(bill_depth ~ bill_length, data = peng,
       col = col[species], pch = pch[species], cex = 0.6)
# draw the ellipses again, so the labels are on top of the points
covEllipses(cbind(bill_length, bill_depth) ~ species, data = peng,
            pooled = FALSE,
            col = col,
            lwd = 2, cex = 1.5,
            add = TRUE)
dev.off()

# data ellipses and the pooled within-group ellipse; the discriminant axes are drawn on the slide
png.panel("talks/images/peng-HE-overview-2-discrim.png")
covEllipses(cbind(bill_length, bill_depth) ~ species, data = peng,
            col = c(col, "black"),
            fill = TRUE, fill.alpha = 0.1,
            lwd = 2,
            cex = 1.5, cex.lab = 1.25,
            xlim = xlim, ylim = ylim)
dev.off()
