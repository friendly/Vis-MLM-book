# avPlots with dataEllipses

#library(spida2)
library(car)
# modified avPlots.R to allow ellipse=
#source("c:/R/fox/avPlots.R")
load(here::here("data", "coffee.RData"))

scatterplotMatrix(~ Heart + Coffee + Stress, 
                  data=coffee,
                  smooth = FALSE,
                  ellipse = list(levels=0.68, fill.alpha = 0.1),
                  pch = 19, cex.labels = 2.5)

fit.stress <- lm(Heart ~ Stress, data=coffee)
fit.coffee <- lm(Heart ~ Coffee, data=coffee)
fit.both   <- lm(Heart ~ Coffee + Stress, data=coffee)

lmtest::coeftest(fit.both)

# basic AV plot

avPlots(fit.both,
        ellipse = list(levels = 0.68, fill=TRUE, fill.alpha = 0.1),
        pch = 19,
        id = list(n = 2, cex = 1),
        cex.lab = 1.5,
        main = "Added-variable plots for Coffee data")


# show the conditional relations

mod.mat <- model.matrix(fit.both)

# utility functions
dev <- function(x) {x-mean(x)}

marginalEllipse <- function(x, y, col, lwd, ...) {
	dataEllipse(dev(x), dev(y), col=col, lwd=lwd, ...)
	abline(lm(dev(y) ~ dev(x)), col=col, lwd=lwd) 
}

# draw and label lines to show a coefficient in a plot
show.beta <- function(
    model, var, x1, x2, 
    label = paste("b =", round(coef(model)[2], 2)),
    line = FALSE,
    col="black", 
    ...) {
  if(line) abline(model, col=col, lwd=2)
  xs <- data.frame(c(x1, x2, x2))
  colnames(xs) <- substitute(var)
  ys <- predict(model, xs)
  lines(cbind(xs,ys[c(1,1,2)]), col=col)
  text(x2, mean(ys[1:2]), label, col=col, ...)
}


# basic avplot
res <- avPlot(fit.both, variable="Stress", xlim=c(-60,60), ylim=c(-60,60)) |> data.frame()
res.mod <- lm(Heart ~ Stress, data=res)
show.beta(res.mod, "Stress", -50, -30, pos = 4, font = 2)
#########################################
### standard avPlots + data ellipses

lev <- 0.68

#png(file="images/coffee-avplot1.png", width=14, height=7, res=200, units="in")
op <- par(mar=c(4, 4, 1, 1) + 0.4,
          mfrow = c(1,2))
res <- avPlot(fit.both, variable="Coffee",  
       xlim=c(-35,35), ylim=c(-35,35), 
       pch=16,  cex=1.2, cex.lab=1.5,
       main="Added variable plot: Coffee",
       id = list(n=2),
       ellipse=list(levels=lev, fill=TRUE, fill.alpha=0.2, col = "blue"),
       col.lines = "blue", lwd = 2.5)
res.mod <- lm(Heart ~ Coffee, data=as.data.frame(res))
show.beta(res.mod, "Coffee", -35, -25, col = "blue", pos = 4, font = 2)

res <- avPlot(fit.both, variable="Stress",  
       xlim=c(-35,35), ylim=c(-35,35), 
       pch=16, cex=1.2, cex.lab=1.5,
	     main="Added variable plot: Stress",
    	 id = list(n=2),
       ellipse=list(levels=lev, fill=TRUE, fill.alpha=0.2, col = "blue"),
       col.lines = "blue", lwd = 2.5)
res.mod <- lm(Heart ~ Stress, data=as.data.frame(res))
show.beta(res.mod, "Stress", -30, -20, pos = 4, col = "blue", font = 2)

par(op)
#dev.off()


#########################################
# add data ellipse + marginal data ellipse 'manually'

# png(file="coffee-avplot3.png", width=7, height=7, res=200, units="in")
# png(file="coffee-avplot4.png", width=7, height=7, res=200, units="in")


png(file="images/coffee-av-marginal.png", width=14, height=7, res=200, units="in")

op <- par(mar=c(4, 4, 1, 1) + 0.4,
          mfrow = c(1,2))
res <- avPlot(fit.both, variable="Coffee", 
       xlim=c(-70,70), ylim=c(-70,70), 
       pch=16, cex=1.4, cex.lab=1.5,
       main="AV + Marginal plot: Coffee",
       col.lines = "blue", lwd = 2.5)
# res <- lsfit(mod.mat[, -2], cbind(mod.mat[, 2], coffee$Heart), 
#              intercept = FALSE) |> residuals()
dataEllipse(res[,1], res[,2], level=lev, 
            add=TRUE, fill=TRUE, fill.alpha=0.2, 
            col = "blue", cex = 1, plot.points = TRUE)
with(coffee, {
  marginalEllipse(Coffee, Heart, col="red", lwd=2, add=TRUE, levels=lev)
  points(dev(Coffee), dev(Heart), pch=16, col = "red")
  arrows(dev(Coffee), dev(Heart), res[,1], res[,2], 
         col = grey(.10), angle=15, length=.1)
  })

avPlot(fit.both, variable="Stress", 
       xlim=c(-70,70), ylim=c(-70,70), 
       pch=16, cex=1.2, cex.lab=1.5,
	     main="AV + Marginal plot: Stress",
       col.lines = "blue", lwd = 2.5
)
res <- lsfit(mod.mat[, -3], cbind(mod.mat[, 3], coffee$Heart), 
             intercept = FALSE) |> residuals()
dataEllipse(res[,1], res[,2], level=lev, 
            add=TRUE, fill=TRUE, fill.alpha=0.2, 
            col = "blue", cex = 1, plot.points = FALSE)
with(coffee, {
  marginalEllipse(Stress, Heart, col="red", lwd=2, add=TRUE, levels=lev)
  points(dev(Stress), dev(Heart), pch=16, col = "red")
  arrows(dev(Stress), dev(Heart), res[,1], res[,2], 
         col = grey(.10), angle=15, length=.1)
})

par(op)
dev.off()

# try again, simplifying code above

res <- avPlot(fit.both, variable="Coffee", 
  xlim=c(-70,70), ylim=c(-70,70), 
  pch=16, cex=1.4, cex.lab=1.5,
  main="AV + Marginal plot: Coffee",
  col.lines = "blue", lwd = 2.5,
  ellipse=list(levels=lev, fill=TRUE, fill.alpha=0.2, col = "blue"))
with(coffee, {
  marginalEllipse(Coffee, Heart, col="red", lwd=2, add=TRUE, levels=lev, cex=1.2)
  points(dev(Coffee), dev(Heart), pch=16, col = "red")
  arrows(dev(Coffee), dev(Heart), res[,1], res[,2],
         col = grey(.10), angle=12, length=.18)
  })

res <- avPlot(fit.both, variable="Stress", 
              xlim=c(-70,70), ylim=c(-70,70), 
              pch=16, cex=1.4, cex.lab=1.5,
              main="AV + Marginal plot: Stress",
              col.lines = "blue", lwd = 2.5,
              ellipse=list(levels=lev, fill=TRUE, fill.alpha=0.2, col = "blue"))
with(coffee, {
  marginalEllipse(Stress, Heart, col="red", lwd=2, add=TRUE, levels=lev, cex=1.2)
  points(dev(Stress), dev(Heart), pch=16, col = "red")
  arrows(dev(Stress), dev(Heart), res[,1], res[,2],
         col = grey(.10), angle=12, length=.18)
})




# shape::Arrows(dev(Stress), dev(Heart), .95*res[,1], .95*res[,2], 
#        col = grey(.10), #angle=12, 
#        arr.length=.15, arr.width = .3, arr.type="triangle")


#########################################
# modified avPlots.R to allow ellipse=

avPlot(fit.both, variable="Stress", 
       xlim=c(-70,70), ylim=c(-70,70), 
       pch=16,
       main="Added variable + Marginal plot: Stress",
       ellipse=list(levels=lev, fill=TRUE, fill.alpha=0.2, col = "red"),
       col.lines = "red")
with(coffee, marginalEllipse(Stress, Heart, col="blue", lwd=2, add=TRUE, levels=lev))

avPlot(fit.both, variable="Coffee", 
       xlim=c(-70,70), ylim=c(-70,70), 
       pch=16,
	main="Added variable + Marginal plot: Coffee",
	ellipse=list(levels=lev, fill=TRUE, fill.alpha=0.2, col = "red"),
	col.lines = "red")
with(coffee, marginalEllipse(Coffee, Heart, col="blue", lwd=2, add=TRUE, levels=lev))

