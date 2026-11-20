#' ---
#' title: Penguins data, HE plots replacing the iris examples of Figs 12.5, 12.7, 12.8
#' ---

# Draws the penguin versions of the three iris HE-plot slides:
#   talks/images/peng-HE-signif.png     -- "HE plots: is the effect significant, and how?" (effect vs significance scaling)
#   talks/images/peng-HE-contrasts.png  -- "Contrasts and linear hypotheses" (as in CARME slide 34)
#   talks/images/peng-HE-pairs.png      -- "HE plot matrices: all pairs of responses"
# E is red, H is blue and contrasts are green, as in the book; the species means are
# overplotted in the dark penguin colors.
# Run from the project root.

library(heplots)

data(peng, package = "heplots")
source("R/penguin/penguin-colors.R")

col <- peng.colors("dark")

# orthogonal contrasts: Adelie vs Chinstrap; Adelie & Chinstrap vs Gentoo
contrasts(peng$species) <- matrix(c(1, -1,  0,
                                    -1, -1, 2), nrow = 3, ncol = 2)

peng.mod <- lm(cbind(bill_length, bill_depth, flipper_length, body_mass) ~ species,
               data = peng)

means <- aggregate(peng[, c("bill_length", "bill_depth", "flipper_length", "body_mass")],
                   list(species = peng$species), mean)

# re-draw the group means of an HE plot in the penguin colors
species.points <- function(x, y) {
  points(means[, x], means[, y], pch = 16, cex = 2.2, col = col)
}

# ---- effect vs. significance scaling: bill depth vs bill length ----

# The species effect is so large that, with significance scaling, H dwarfs E; showing
# the same plot both ways makes the point of the slide.
png("talks/images/peng-HE-signif.png", width = 10, height = 5, units = "in", res = 300)
op <- par(mar = c(4, 4, 1, 1) + 0.5, mfrow = c(1, 2))
heplot(peng.mod, size = "effect",
       cex = 1.5, cex.lab = 1.5,
       fill = TRUE, fill.alpha = c(0.3, 0.1))
species.points("bill_length", "bill_depth")
title(main = "Effect scaling", line = -1.5, cex.main = 1.3, font.main = 1)
heplot(peng.mod, size = "evidence",
       cex = 1.5, cex.lab = 1.5,
       fill = TRUE, fill.alpha = c(0.3, 0.1))
species.points("bill_length", "bill_depth")
title(main = "Significance scaling", line = -1.5, cex.main = 1.3, font.main = 1)
par(op)
dev.off()

# ---- contrasts: bill depth vs bill length, effect scaling ----

hyp <- list("A:C" = "species1", "AC:G" = "species2")

png("talks/images/peng-HE-contrasts.png", width = 6, height = 6, units = "in", res = 300)
op <- par(mar = c(4, 4, 1, 1) + 0.5)
heplot(peng.mod, hypotheses = hyp,
       size = "effect",
       cex = 1.5, cex.lab = 1.5,
       fill = TRUE, fill.alpha = c(0.3, 0.1),
       col = c("red", "blue", "darkgreen", "darkgreen"),
       lwd = c(1, 2, 3, 3),
       label.pos = c(3, 3, 4, 2))
species.points("bill_length", "bill_depth")
par(op)
dev.off()

# ---- HE plot matrix ----

png("talks/images/peng-HE-pairs.png", width = 8, height = 8, units = "in", res = 300)
pairs(peng.mod, size = "effect",
      var.labels = sub("_", "\n", colnames(means)[-1]),
      fill = TRUE, fill.alpha = c(0.3, 0.1))
dev.off()
