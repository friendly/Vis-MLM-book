data(Prestige, package="carData")
#' `type` is really an ordered factor. Make it so.
Prestige$type <- ordered(Prestige$type, levels=c("bc", "wc", "prof")) # reorder levels

#' Main effects model
mod0 <- lm(prestige ~ education + income + women + type,
           data=Prestige)

#' ## avPlots
library(car)
avPlots(mod0, terms = ~education + income,
        ellipse = TRUE,
        pch = 19,
        id = list(n = 3, cex = 0.7,
                  method = abs(residuals(mod0))),
        main = "Added-variable plots for prestige"
)

avPlot3d(mod0, "education", "income")

mod1 <- lm(prestige ~ education + income + type,
           data=Prestige)

#' ## avPlots
avPlots(mod1, terms = ~education + income,
        ellipse = TRUE,
        pch = 19,
        id = list(n = 2, cex = 0.7),
        main = "Added-variable plots for prestige"
)

# add loess.smooth to each
res <- avPlot(mod1, "education",
              ellipse = TRUE,
              pch = 19,
              cex.lab = 1.5)
smooth <- loess.smooth(res[,1], res[,2])
lines(smooth, col = "red", lwd = 2)

res <- avPlot(mod1, "income",
              ellipse = TRUE,
              pch = 19,
              cex.lab = 1.5)
smooth <- loess.smooth(res[,1], res[,2])
lines(smooth, col = "red", lwd = 2)




