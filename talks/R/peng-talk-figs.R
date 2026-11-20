#' ---
#' title: Penguins data, figures from the CARME talk re-drawn in the penguin colors
#' ---

# Re-draws, in the dark penguin colors:
#   talks/images/peng-scat-{1-points,2-ellipses,3-nopoints}.png  -- "Data ellipses: Sufficient visual summary"
#   talks/images/peng-biplot.png                                 -- "Biplot: The data juicer"
#   talks/images/peng-candisc.png, peng-candisc-HE.png           -- "Canonical discriminant plots: The MANOVA juicer"
# The scatterplots are those of talks/R/peng-scat.R.
# Run from the project root.

library(car)
library(ggplot2)
library(ggbiplot)
library(heplots)
library(candisc)

data(peng, package = "heplots")
source("R/penguin/penguin-colors.R")

col <- peng.colors("dark")
pch <- 15:17

# ---- scatterplot -> add data ellipses -> remove points ----

# the originals were 513 x 547 px; keep that shape at a higher resolution
png.scat <- function(file) {
  png(file, width = 4.5, height = 4.8, units = "in", res = 300)
  par(mar = c(5, 5, 1, 1) + 0.1)
}

png.scat("talks/images/peng-scat-1-points.png")
scatterplot(bill_length ~ body_mass | species, data = peng,
            smooth = FALSE, regLine = FALSE,
            grid = FALSE,
            legend = list(coords = "bottomright"),
            col = col, pch = pch, cex.lab = 1.5)
dev.off()

png.scat("talks/images/peng-scat-2-ellipses.png")
scatterplot(bill_length ~ body_mass | species, data = peng,
            smooth = FALSE, regLine = TRUE,
            ellipse = list(levels = 0.68),
            grid = FALSE,
            legend = list(coords = "bottomright"),
            col = col, pch = pch, cex.lab = 1.5)
dev.off()

# no legend here: with the points removed, it would show only empty symbols
png.scat("talks/images/peng-scat-3-nopoints.png")
scatterplot(bill_length ~ body_mass | species, data = peng,
            smooth = FALSE, regLine = TRUE,
            ellipse = list(levels = 0.68),
            grid = FALSE,
            legend = FALSE,
            col = col, cex = 0, cex.lab = 1.5)
dev.off()

# ---- biplot ----

peng.pca <- prcomp(~ bill_length + bill_depth + flipper_length + body_mass,
                   data = peng, scale. = TRUE)

# variable labels on two lines: "bill\nlength" rather than "bill_length"
var.labels <- sub("_", "\n", rownames(peng.pca$rotation))
rownames(peng.pca$rotation) <- var.labels

# label the species at their centroids, rather than in a legend
means <- aggregate(peng.pca$x[, 1:2], list(species = peng$species), mean)
# move the Gentoo label off its centroid, clear of the variable labels
means[means$species == "Gentoo", c("PC1", "PC2")] <- means[means$species == "Gentoo", c("PC1", "PC2")] + c(0.9, 0.75)

p <- ggbiplot(peng.pca, obs.scale = 1, var.scale = 1,
         groups = peng$species,
         ellipse = TRUE, circle = TRUE,
         varname.size = 7,
         var.factor = 1.5) +
  geom_label(data = means, aes(x = PC1, y = PC2, label = species, color = species),
             size = 5, inherit.aes = FALSE) +
  scale_shape_manual(values = pch) +
  scale_color_manual(values = col) +
  scale_fill_manual(values = col) +
  theme_minimal(base_size = 14) +
  theme(legend.position = "none")
# flipper length and body mass point the same way: move their labels apart, above and below the vectors
txt <- which(sapply(p$layers, function(l) inherits(l$geom, "GeomText")))[1]
vlab <- p$layers[[txt]]$data
shift <- c("flipper\nlength" = 0.33, "body\nmass" = -0.33)
i <- match(names(shift), vlab$label)
vlab$yend[i] <- vlab$yend[i] + shift
vlab$angle[i] <- 0
p$layers[[txt]]$data <- vlab
p

ggsave("talks/images/peng-biplot.png", width = 6.95, height = 6, dpi = 300, bg = "white")

# ---- canonical discriminant plot ----

# the same frame, vector scale and labels for this and the HE plot below

peng.mlm <- lm(cbind(bill_length, bill_depth, flipper_length, body_mass) ~ species, data = peng)
peng.can <- candisc(peng.mlm, data = peng)

png("talks/images/peng-candisc.png", width = 7.5, height = 6, units = "in", res = 300)
par(mar = c(4, 4, 1, 1) + 0.1, lheight = 0.8)
plot(peng.can,
     col = col, pch = pch,
     ellipse = TRUE,
     var.labels = var.labels,
     var.pos = c(4, 2, 1, 3),      # flipper length below, body mass above
     var.col = "blue", var.lwd = 2, var.cex = 1.8,
     scale = 4,
     xlim = c(-7, 8.5), ylim = c(-7, 4.5),
     cex = 0.8, cex.lab = 1.5, cex.axis = 1.2)
dev.off()

# ---- HE plot of the canonical scores ----

png("talks/images/peng-candisc-HE.png", width = 7.5, height = 6, units = "in", res = 300)
par(mar = c(4, 4, 1, 1) + 0.1, lheight = 0.8)
heplot(peng.can,
       size = "effect",
       fill = c(TRUE, TRUE), fill.alpha = 0.1,
       var.labels = var.labels,
       var.pos = c(4, 2, 1, 3),
       var.col = "blue", var.lwd = 2, var.cex = 1.8,
       scale = 4,
       xlim = c(-7, 8.5), ylim = c(-7, 4.5),
       cex = 1.4, cex.lab = 1.5, cex.axis = 1.2)
dev.off()
