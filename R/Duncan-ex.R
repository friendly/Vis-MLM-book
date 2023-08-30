#' ---
#' title: Duncan data, regression diagnostics
#' ---
#' 

library(car)
data(Duncan, package = "carData")

head(Duncan)

duncan.mod <- lm(prestige ~ income + education, data=Duncan)

# regression quartet

op <- par(mfrow = c(2,2), 
          mar = c(4,4,3,1)+.1)
plot(duncan.mod, lwd=2, pch=16)
par(op)

# car versions
residualPlots(duncan.mod, layout = c(1,3), 
              id=list(n=3), 
              lwd=2)

spreadLevelPlot(duncan.mod, 
                id = list(n=2, location = "lr"),
                lwd=3
                )

qqPlot(duncan.mod, id = list(n=3))

# influence plot
inf <- influencePlot(duncan.mod, id = list(n=3))

# which are influential?
cbind(Duncan[row.names(Duncan) %in% rownames(inf),], inf)

merge(Duncan, inf, by="row.names", all.x = FALSE)

# how to do this with dplyr??
library(dplyr)


