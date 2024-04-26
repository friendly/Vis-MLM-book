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

avPlot(fit.both, variable="Stress", xlim=c(-60,60), ylim=c(-60,60))

#########################################
### standard avPlots + data ellipses

lev <- 0.5

png(file="coffee-avplot1.png", width=7, height=7, res=200, units="in")
#pdf(file="coffee-avplot1.pdf", width=7, height=7)
op <- par(mar=c(4, 4, 1, 1) + 0.4)
avPlot(fit.both, variable="Stress",  xlim=c(-35,35), ylim=c(-35,35), pch=16, cex=1.2, cex.lab=1.5,
	main="Added variable plot: Stress",
#	labels=coffee$Occupation, id.n=2, id.method="mahal",
#	ellipse=TRUE, ellipse.args=list(levels=lev, fill=TRUE, fill.alpha=0.2)
  ellipse=list(levels=lev, fill=TRUE, fill.alpha=0.2)
)
par(op)
dev.off()

png(file="coffee-avplot2.png", width=7, height=7, res=200, units="in")
#pdf(file="coffee-avplot2.pdf", width=7, height=7)
op <- par(mar=c(4, 4, 1, 1) + 0.4)
avPlot(fit.both, variable="Coffee",  xlim=c(-35,35), ylim=c(-35,35), pch=16,  cex=1.2, cex.lab=1.5,
	main="Added variable plot: Coffee",
#	labels=coffee$Occupation, id.n=2, id.method="mahal",
  ellipse=list(levels=lev, fill=TRUE, fill.alpha=0.2)
)
par(op)
dev.off()


#########################################
# add data ellipse + marginal data ellipse 'manually'

png(file="coffee-avplot3.png", width=7, height=7, res=200, units="in")
#pdf(file="coffee-avplot3.pdf", width=7, height=7)

op <- par(mar=c(4, 4, 1, 1) + 0.4)
avPlot(fit.both, variable="Stress", xlim=c(-70,70), ylim=c(-70,70), pch=16, cex=1.2, cex.lab=1.5,
	main="Added variable + Marginal plot: Stress")
res <- lsfit(mod.mat[, -3], cbind(mod.mat[, 3], coffee$Heart), 
        intercept = FALSE)$residuals
dataEllipse(res[,1], res[,2], level=lev, add=TRUE, fill=TRUE, fill.alpha=0.2)
with(coffee, marginalEllipse(Stress, Heart, col="blue", lwd=2, add=TRUE, levels=lev))
with(coffee, arrows(dev(Stress), dev(Heart), res[,1], res[,2], col="darkgray", angle=15, length=.1))
par(op)
dev.off()


png(file="coffee-avplot4.png", width=7, height=7, res=200, units="in")
#pdf(file="coffee-avplot4.pdf", width=7, height=7)

op <- par(mar=c(4, 4, 1, 1) + 0.4)
avPlot(fit.both, variable="Coffee", xlim=c(-70,70), ylim=c(-70,70), pch=16, cex=1.2, cex.lab=1.5,
	main="Added variable + Marginal plot: Coffee")
res <- lsfit(mod.mat[, -2], cbind(mod.mat[, 2], coffee$Heart), 
        intercept = FALSE)$residuals
dataEllipse(res[,1], res[,2], level=lev, add=TRUE, fill=TRUE, fill.alpha=0.2)
with(coffee, marginalEllipse(Coffee, Heart, col="blue", lwd=2, add=TRUE, levels=lev))
 vpar(op)
dev.off()


#########################################
# modified avPlots.R to allow ellipse=

#source("c:/R/fox/avPlots.R")
avPlot(fit.both, variable="Stress", xlim=c(-60,60), ylim=c(-60,60),  pch=16,
	main="Added variable + Marginal plot: Stress",
	ellipse=list(levels=lev, fill=TRUE, fill.alpha=0.2))
with(coffee, marginalEllipse(Stress, Heart, col="blue", lwd=2, add=TRUE, levels=lev))

avPlot(fit.both, variable="Coffee", xlim=c(-60,60), ylim=c(-60,60), pch=16,
	main="Added variable + Marginal plot: Coffee",
	ellipse=list(levels=lev, fill=TRUE, fill.alpha=0.2))
with(coffee, marginalEllipse(Coffee, Heart, col="blue", lwd=2, add=TRUE, levels=lev))

