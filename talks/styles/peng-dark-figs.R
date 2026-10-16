# Contour v2 swatch: two penguin figures re-drawn on the dark slide palette.
# Same calls as talks/R/peng-HE-overview.R and talks/R/peng-talk-figs.R, with
# the background, axes and text in the Contour colors and the species in the
# "medium" penguin shades, which read better than "dark" on a dark ground.
# Run from the project root:  Rscript talks/styles/peng-dark-figs.R <output dir>

library(heplots)
library(candisc)

out <- commandArgs(trailingOnly = TRUE)[1]
data(peng, package = "heplots")
source("R/penguin/penguin-colors.R")

bg    <- "#0F151C"   # night
ice   <- "#E6EBEF"
muted <- "#8A97A3"
col <- peng.colors("medium")
pch <- 15:17

dark.par <- function(mar) {
  par(bg = bg, fg = muted, col.axis = muted, col.lab = ice, col.main = ice,
      mar = mar)
}

# ---- data ellipses, with the points (as peng-HE-overview-1-ellipses.png) ----
xlim <- c(34, 55)
ylim <- c(13.2, 20.4)
png(file.path(out, "dark-peng-ellipses.png"), width = 4.5, height = 4.75, units = "in", res = 300, bg = bg)
dark.par(c(4, 4, 1, 1) + 0.1)
covEllipses(cbind(bill_length, bill_depth) ~ species, data = peng,
            pooled = FALSE, col = col,
            fill = TRUE, fill.alpha = 0.15, lwd = 2,
            cex = 1.5, cex.lab = 1.25,
            xlim = xlim, ylim = ylim)
points(bill_depth ~ bill_length, data = peng,
       col = col[species], pch = pch[species], cex = 0.6)
covEllipses(cbind(bill_length, bill_depth) ~ species, data = peng,
            pooled = FALSE, col = col, lwd = 2, cex = 1.5, add = TRUE)
dev.off()

# ---- canonical discriminant plot (as peng-candisc.png) ----
peng.mlm <- lm(cbind(bill_length, bill_depth, flipper_length, body_mass) ~ species, data = peng)
peng.can <- candisc(peng.mlm, data = peng)
var.labels <- c("bill\nlength", "bill\ndepth", "flipper\nlength", "body\nmass")

png(file.path(out, "dark-peng-candisc.png"), width = 7.5, height = 6, units = "in", res = 300, bg = bg)
dark.par(c(4, 4, 1, 1) + 0.1)
par(lheight = 0.8)
plot(peng.can,
     col = col, pch = pch,
     ellipse = TRUE, fill.alpha = 0.15,
     rev.axes = c(TRUE, FALSE),   # Can1's sign comes out flipped with current packages; match talks/images/peng-candisc.png
     var.labels = var.labels,
     var.pos = c(4, 2, 1, 3),
     var.col = ice, var.lwd = 2, var.cex = 1.8,
     scale = 4,
     xlim = c(-7, 8.5), ylim = c(-7, 4.5),
     cex = 0.8, cex.lab = 1.5, cex.axis = 1.2)
dev.off()
