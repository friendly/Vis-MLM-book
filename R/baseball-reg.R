library(car)
library(effects)

data(baseball, package = "corrgram")
row.names(baseball) <- baseball$Name

bb.mod <- lm(logSal ~ Years + Atbatc + Hitsc + Homerc + Runsc + RBIc + Walksc,
               data=baseball)

op <- par(mfrow = c(2,2), 
          mar = c(4,4,3,1)+.1)
plot(bb.mod, lwd=2, pch=16)
par(op)

# car versions
residualPlots(bb.mod, terms = ~ Years, 
              id=list(n=3), 
              lwd=2)

spreadLevelPlot(bb.mod, 
                id = list(n=2, location = "lr"),
                lwd=3)


#' ## try years up to 7
baseball$Years7 <- pmin(baseball$Years,7)
bb.mod1 <- lm(logSal ~ Years7 + Atbatc + Hitsc + Homerc + Runsc + RBIc + Walksc,
             data=baseball)

op <- par(mfrow = c(2,2), 
          mar = c(4,4,3,1)+.1)
plot(bb.mod1, lwd=2, pch=16)
par(op)

# influence plot
inf <- influencePlot(bb.mod1, id = list(n=3))

# which are influential?
merge(baseball, inf, by="row.names", all.x = FALSE)
