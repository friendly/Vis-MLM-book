#' ---
#' title: School data, distance plot and influence plot as a matched pair
#' ---

# Re-draws two figures of Ch. 11 for the school data model at the same size, with the same
# cases marked in the same colors, so they can be followed from one plot to the other:
#   talks/images/school-diag-1-distance.png   -- heplots::distancePlot()      (Fig. 11.18)
#   talks/images/school-diag-2-influence.png  -- mvinfluence::influencePlot() (Fig. 11.19)
# Also prints the sensitivity analysis quoted on the slide.
# Run from the project root.

library(heplots)
library(mvinfluence)
library(car)

data(schooldata, package = "heplots")
school.mod <- lm(cbind(reading, mathematics, selfesteem) ~ ., data = schooldata)

# cases to follow, colored by the role they turn out to play
cases <- c(influential = 44, influential = 59, between = 33, outlier = 35, leverage = 66)
role.col <- c(influential = "red", between = "black", outlier = "blue", leverage = "darkgreen")
case.col <- role.col[names(cases)]

png.panel <- function(file) {
  png(file, width = 6, height = 6, units = "in", res = 300)
  par(mar = c(4.5, 4.5, 1, 1) + 0.1)
}

# ---- distance plot ----

png.panel("talks/images/school-diag-1-distance.png")
# drawn directly, as heplots::distancePlot() does, to control the labels and colors
X <- schooldata[, 1:5]
E <- residuals(school.mod)
distX <- sqrt(Mahalanobis(X))
distY <- sqrt(Mahalanobis(E))
cutoffs <- sqrt(qchisq(0.975, c(ncol(X), ncol(E))))
out <- distX > cutoffs[1] | distY > cutoffs[2]
plot(distX, distY,
     pch = ifelse(out, 16, 1), col = "gray40",
     cex = 1.3, cex.lab = 1.5, cex.axis = 1.2,
     xlab = "Mahalanobis distance of predictors (leverage)",
     ylab = "Mahalanobis distance of residuals")
abline(v = cutoffs[1], h = cutoffs[2], col = "gray40")
# the other cases beyond the cutoffs
other <- setdiff(which(out), cases)
text(distX[other], distY[other], labels = other, pos = 2, cex = 1.2, col = "gray40")
points(distX[cases], distY[cases], pch = 16, cex = 2, col = case.col)
text(distX[cases], distY[cases], labels = cases, pos = 2, cex = 1.8, font = 2, col = case.col)
dev.off()

# ---- influence plot ----

infl <- as.data.frame(mlm.influence(school.mod, do.coef = FALSE))

png.panel("talks/images/school-diag-2-influence.png")
influencePlot(school.mod, type = "stres",
              infl = mlm.influence(school.mod, do.coef = FALSE),
              id.n = 0, id.cex = 0.001,     # its own labels are replaced below
              xlim = c(0, 0.68), ylim = c(0, 0.62),
              cex.lab = 1.5, cex.axis = 1.2)
# labels: inside the two large bubbles, beside the small ones
pos <- c(1, 1, 2, 4, 2)
inside <- cases %in% c(44, 59)
text(infl$H[cases][inside], infl$Q[cases][inside], labels = cases[inside],
     cex = 1.8, font = 2, col = case.col[inside])
points(infl$H[cases][!inside], infl$Q[cases][!inside], pch = 16, cex = 0.9, col = case.col[!inside])
text(infl$H[cases][!inside], infl$Q[cases][!inside], labels = cases[!inside],
     pos = pos[!inside], offset = 0.8, cex = 1.8, font = 2, col = case.col[!inside])
dev.off()

# ---- sensitivity: refit without the two most influential cases ----

round(infl[cases, c("H", "Q", "CookD")], 3)

school.mod2 <- update(school.mod, data = schooldata[-c(44, 59), ])
Anova(school.mod)
Anova(school.mod2)

# relative change in the coefficients, in percent
reldiff <- function(x, y) 100 * abs(x - y) / abs(x)
reldiff(coef(school.mod)[-1, ], coef(school.mod2)[-1, ]) |> round(1)
