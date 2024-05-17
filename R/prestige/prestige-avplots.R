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
