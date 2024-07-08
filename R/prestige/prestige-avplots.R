data(Prestige, package="carData")
library(car)
#' `type` is really an ordered factor. Make it so.
Prestige$type <- ordered(Prestige$type, levels=c("bc", "wc", "prof")) # reorder levels

#' Main effects model
mod0 <- lm(prestige ~ education + income + women + type,
           data=Prestige)

#' ## avPlots
avPlots(mod0, terms = ~education + income,
        ellipse = TRUE,
        pch = 19,
        id = list(n = 3, cex = 0.7,
                  method = abs(residuals(mod0))),
        main = "Added-variable plots for prestige"
)

avPlot3d(mod0, "education", "income")

mod1 <- lm(prestige ~ education + income + women,
           data=Prestige)

#' ## avPlots
avPlots(mod1, #terms = ~education + income + women,
        ellipse = list(levels = 0.68, fill = TRUE, fill.alpha = 0.1),
        id = list(n = 2, cex = 1.2),
        pch = 19,
        cex.lab = 1.5,
        main = "Added-variable plots for prestige"
)

# add loess.smooth to each
op <- par(mar=c(4, 4, 1, 0) + 0.5)

res <- avPlot(mod1, "education",
              ellipse = list(levels = 0.68),
              pch = 19,
              cex.lab = 1.5)
smooth <- loess.smooth(res[,1], res[,2])
lines(smooth, col = "red", lwd = 2.5)

res <- avPlot(mod1, "income",
              ellipse = list(levels = 0.68),
              pch = 19,
              cex.lab = 1.5)
smooth <- loess.smooth(res[,1], res[,2])
lines(smooth, col = "red", lwd = 2.5)
par(op)

# Component + Residual plot

crPlots(mod1, terms = ~education + income + women,
        smooth = TRUE,
        pch = 19,
        id = list(n=2),
        layout = c(2,2))

crPlot(mod1, "income",
       smooth = TRUE,
       pch = 19,
       col.lines = c("blue", "red"),
       id = list(n=2, cex = 1.2),
       cex.lab = 1.5)

crPlot(mod1, "income",
       smooth = TRUE,
       order = 2,
       pch = 19,
       col.lines = c("blue", "red"),
       id = list(n=2, cex = 1.2),
       cex.lab = 1.5)


crPlot(mod1, "women",
       order = 2,
       pch = 19,
       col.lines = c("blue", "red"),
       id = list(n=2, cex = 1.2),
       cex.lab = 1.5)


