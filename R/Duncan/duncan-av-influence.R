#' ---
#' title: "Duncan data: annotated added-variable plots (Figure 7.27)"
#' ---
#' Shows the joint influence of minister and conductor via AV plots for income
#' and education. Green arrows show residuals for those two cases; red line
#' shows the regression when they are deleted (duncan.mod2).

library(car)

data(Duncan, package = "carData")

duncan.mod  <- lm(prestige ~ income + education, data = Duncan)
duncan.mod2 <- update(duncan.mod, subset = -c(6, 16))   # delete minister, conductor

op <- par(mar = c(4, 5, 4, 1) + .1, mfrow = c(1, 2))

# --- income panel -----------------------------------------------------------
res <- avPlot(duncan.mod, "income",
              ellipse = list(levels = 0.68),
              id = list(method = "mahal", n = 3, cex = 1.2),
              pch = 16, cex.lab = 1.5) |>
  as.data.frame()
fit  <- lm(prestige ~ income, data = res)
info <- cbind(res,
              fitted = fitted(fit),
              resids = residuals(fit),
              hat    = hatvalues(fit),
              cookd  = cooks.distance(fit))
big <- which(info$cookd > 0.20)
with(info, {
  arrows(income[big], fitted[big], income[big], prestige[big],
         angle = 12, length = 0.18, lwd = 3, col = "darkgreen")
})
bs <- coef(duncan.mod2)["income"]
abline(a = 0, b = bs, col = "red", lwd = 2)

# --- education panel --------------------------------------------------------
res <- avPlot(duncan.mod, "education",
              ellipse = list(levels = 0.68),
              id = list(method = "mahal", n = 3, cex = 1.2),
              pch = 16, cex.lab = 1.5) |>
  as.data.frame()
fit  <- lm(prestige ~ education, data = res)
info <- cbind(res,
              fitted = fitted(fit),
              resids = residuals(fit),
              hat    = hatvalues(fit),
              cookd  = cooks.distance(fit))
big <- which(info$cookd > 0.2)
with(info, {
  arrows(education[big], fitted[big], education[big], prestige[big],
         angle = 12, length = 0.18, lwd = 3, col = "darkgreen")
})
bs <- coef(duncan.mod2)["education"]
abline(a = 0, b = bs, col = "red", lwd = 2)

par(op)
