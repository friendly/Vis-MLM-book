# avPlots with dataEllipses

library(spida2)
library(car)
# modified avPlots.R to allow ellipse=
#source("c:/R/fox/avPlots.R")


fit.stress <- lm(Heart ~ Stress, data=coffee)
fit.coffee <- lm(Heart ~ Coffee, data=coffee)
fit.both   <- lm(Heart ~ Coffee + Stress, data=coffee)

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

#show.beta(between, -5, -3, expression(~beta[between]), col="red", cex=1.4, pos=4, offset=-.1)


# basic avplot
res <- avPlot(fit.both, variable="Stress", xlim=c(-60,60), ylim=c(-60,60)) |> data.frame()
res.mod <- lm(Heart ~ Stress, data=res)
#show.beta(res.mod, "Stress", -50, -30, paste("b =", round(coef(res.mod)[2], 2)), pos = 4)
show.beta(res.mod, "Stress", -50, -30, pos = 4, font = 2)
#########################################
### standard avPlots + data ellipses

lev <- 0.5

png(file="images/coffee-avplot1.png", width=14, height=7, res=200, units="in")
#pdf(file="coffee-avplot1.pdf", width=7, height=7)
op <- par(mar=c(4, 4, 1, 1) + 0.4,
          mfrow = c(1,2))
res <- avPlot(fit.both, variable="Stress",  
       xlim=c(-35,35), ylim=c(-35,35), 
       pch=16, cex=1.2, cex.lab=1.5,
	     main="Added variable plot: Stress",
    	 id = list(n=4, method="mahal"),
       ellipse=list(levels=lev, fill=TRUE, fill.alpha=0.2, col = "red"),
       col.lines = "red", lwd = 2.5)
res.mod <- lm(Heart ~ Stress, data=as.data.frame(res))
show.beta(res.mod, "Stress", -30, -20, pos = 4, col = "red", font = 2)
par(op)
# dev.off()

#png(file="coffee-avplot2.png", width=7, height=7, res=200, units="in")
#pdf(file="coffee-avplot2.pdf", width=7, height=7)
#op <- par(mar=c(4, 4, 1, 1) + 0.4)
res <- avPlot(fit.both, variable="Coffee",  
       xlim=c(-35,35), ylim=c(-35,35), 
       pch=16,  cex=1.2, cex.lab=1.5,
       main="Added variable plot: Coffee",
       id = list(n=4, method="mahal"),
       ellipse=list(levels=lev, fill=TRUE, fill.alpha=0.2, col = "red"),
       col.lines = "red", lwd = 2.5)
res.mod <- lm(Heart ~ Coffee, data=as.data.frame(res))
show.beta(res.mod, "Coffee", -35, -25, col = "red", pos = 4, font = 2)
#show.beta(res.mod, "Coffee", 15, 25, col = "red", pos = 4)

par(op)
dev.off()


#########################################
# add data ellipse + marginal data ellipse 'manually'

png(file="coffee-avplot3.png", width=7, height=7, res=200, units="in")
#pdf(file="coffee-avplot3.pdf", width=7, height=7)

op <- par(mar=c(4, 4, 1, 1) + 0.4)
avPlot(fit.both, variable="Stress", 
       xlim=c(-70,70), ylim=c(-70,70), 
       pch=16, cex=1.2, cex.lab=1.5,
	     main="Added variable + Marginal plot: Stress",
       col.lines = "red", lwd = 2.5
)
res <- lsfit(mod.mat[, -3], cbind(mod.mat[, 3], coffee$Heart), 
             intercept = FALSE) |> residuals()
dataEllipse(res[,1], res[,2], level=lev, 
            add=TRUE, fill=TRUE, fill.alpha=0.2, 
            col = "red", cex = 1, plot.points = FALSE)
with(coffee, marginalEllipse(Stress, Heart, 
                             col="blue", lwd=2, add=TRUE, levels=lev))
with(coffee, arrows(dev(Stress), dev(Heart), res[,1], res[,2], 
                    col = grey(.10), angle=15, length=.1))
par(op)
dev.off()


png(file="coffee-avplot4.png", width=7, height=7, res=200, units="in")
#pdf(file="coffee-avplot4.pdf", width=7, height=7)

op <- par(mar=c(4, 4, 1, 1) + 0.4)
avPlot(fit.both, variable="Coffee", 
       xlim=c(-70,70), ylim=c(-70,70), 
       pch=16, cex=1.4, cex.lab=1.5,
       main="Added variable + Marginal plot: Coffee",
       col.lines = "red", lwd = 2.5)
res <- lsfit(mod.mat[, -2], cbind(mod.mat[, 2], coffee$Heart), 
        intercept = FALSE) |> residuals()
dataEllipse(res[,1], res[,2], level=lev, 
            add=TRUE, fill=TRUE, fill.alpha=0.2, 
            col = "red", cex = 1, plot.points = FALSE)
with(coffee, marginalEllipse(Coffee, Heart, col="blue", lwd=2, add=TRUE, levels=lev))
with(coffee, arrows(dev(Coffee), dev(Heart), res[,1], res[,2], 
                    col = grey(.10), angle=15, length=.1))
par(op)
dev.off()


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

