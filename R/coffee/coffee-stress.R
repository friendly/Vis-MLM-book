# demonstrate effect of measurement error via data ellipses and confidence ellipses

#library(spida)	# for coffee data
#if (!require("spida")) install.packages("spida", repos="http://R-Forge.R-project.org", type = "source"); 
# remotes::install_github('gmonette/spida2')
library("spida2")   ## for coffee data 

library(car)		# for dataEllipse, confidenceEllipse

data(coffee, package="spida2")
coffee <- coffee[, -5]  # get old Stress2 example variable out of the way

fit.stress <- lm(Heart ~ Stress, data=coffee)
fit.coffee <- lm(Heart ~ Coffee, data=coffee)
fit.both   <- lm(Heart ~ Coffee + Stress, data=coffee)

SD <- sd(coffee$Stress)
n<-nrow(coffee)
mStress <- mean(coffee$Stress)
set.seed(12345)  # reproducability

# Add a N(0, SD) error, but keep the mean unchanged
add_error <- function(x, factor) {
  n <- length(x)
  mean <- mean(x)
  SD <- sd(x)
  x <- x + round(rnorm(n, sd=factor*SD))
  x <- mean + as.vector(scale(x, center=TRUE, scale=FALSE))
  x
}

# Create 3 copies of Stress, but adding N(0,sd) errors
# assure that the mean is unchanged
coffee$Stress1 <- coffee$Stress + round(rnorm(n, sd=.75*SD))
coffee$Stress1 <- mStress + as.vector(scale(coffee$Stress1, center=TRUE, scale=FALSE))
coffee$Stress2 <- coffee$Stress + round(rnorm(n, sd=1*SD))
coffee$Stress2 <- mStress + as.vector(scale(coffee$Stress2, center=TRUE, scale=FALSE))
coffee$Stress3 <- coffee$Stress + round(rnorm(n, sd=1.5*SD))
coffee$Stress3 <- mStress + as.vector(scale(coffee$Stress3, center=TRUE, scale=FALSE))

str(coffee)

#cd("c:/sasuser/datavis/manova/ellipses/fig")

#png(file="coffee-stress1.png", width=7, height=7, res=200, units="in")
#pdf(file="coffee-stress1.pdf", width=7, height=7)

### show effect of measurement error in data space

png(file="images/coffee-data-beta.png", width=12, height=6, res=200, units="in")

#op <- par(mar=c(4, 4, 1, 1) + 0.2)
op <- par(mar=c(4, 4, 1, 2) + 0.2,
          mfrow = c(1,2))
lev <- 0.68
with(coffee, dataEllipse(Stress, Heart, level=lev, col="black", 
                         xlim=c(-50, 250), grid=FALSE, fill=TRUE, 
                         center.cex=2, pch=16, cex.lab=1.5))
abline(fit.stress, col="black", lwd=3)
abline(h=mean(coffee$Heart))
text(190, predict(fit.stress, data.frame(Stress=190)), "0", cex=1.5, pos=2)
text(-50, 162, "Data space", cex=2, pos=4)

with(coffee, dataEllipse(Stress1, Heart, level=lev, col="blue", 
                         add=TRUE, plot.points=FALSE, 
                         fill=TRUE, fill.alpha=0.2, center.cex=0.2))
fit.stress1 <- lm(Heart ~ Stress1, data=coffee)
abline(fit.stress1, col="blue", lwd=2)
text(210, predict(fit.stress1, data.frame(Stress1=210)), ".75", cex=1.5, pos=2, col="blue")

with(coffee, dataEllipse(Stress2, Heart, level=lev, col="red", 
                         add=TRUE, fill=TRUE, fill.alpha=0.1, center.cex=0.1))
fit.stress2 <- lm(Heart ~ Stress2, data=coffee)
abline(lm(Heart ~ Stress2, data=coffee), col="red", lwd=2)
text(230, predict(fit.stress2, data.frame(Stress2=230)), "1.0", cex=1.5, pos=2, col="red")

with(coffee, dataEllipse(Stress3, Heart, level=lev, col="green3", 
                         add=TRUE, fill=TRUE, fill.alpha=0.05, center.cex=0.1))
fit.stress3 <- lm(Heart ~ Stress3, data=coffee)
abline(lm(Heart ~ Stress3, data=coffee), col="green3", lwd=2)
text(255, predict(fit.stress3, data.frame(Stress3=255)), "1.5", cex=1.5, pos=2, col="darkgreen")
#par(op)

#dev.off()

### show effect of measurement error in beta space

#png(file="coffee-stress2.png", width=7, height=7, res=200, units="in")
#pdf(file="coffee-stress2.pdf", width=7, height=7)

#op <- par(mar=c(4, 4, 1, 1) + 0.2)
lev=0.68
confidenceEllipse(fit.stress, levels=lev, col="black", xlim=c(-20,80), ylim=c(0,1), 
	grid=FALSE, fill=TRUE, cex.lab=1.5)
abline(h=0, v=0, col="gray")
text(80, 1, "Beta space", cex=2, pos=2)
text(coef(fit.stress)[1],  coef(fit.stress)[2], "0", pos=4, cex=1.5)

confidenceEllipse(fit.stress1, levels=lev, col="blue", add=TRUE, fill=TRUE, fill.alpha=0.2)
text(coef(fit.stress1)[1], coef(fit.stress1)[2], "0.75", pos=4, cex=1.5)

confidenceEllipse(fit.stress2, levels=lev, col="red", add=TRUE, fill=TRUE, fill.alpha=0.1)
text(coef(fit.stress2)[1], coef(fit.stress2)[2], "1.0", pos=4, cex=1.5)

confidenceEllipse(fit.stress3, levels=lev, col="green3", add=TRUE, fill=TRUE, fill.alpha=0.1)
text(coef(fit.stress3)[1], coef(fit.stress3)[2], "1.5", pos=4, cex=1.5)
par(op)

dev.off()

########################
### added variable views

source("c:/R/fox/avPlots.R")

fit.both  <- lm(Heart ~ Coffee + Stress, data=coffee)
fit.both1 <- lm(Heart ~ Coffee + Stress1, data=coffee)
fit.both2 <- lm(Heart ~ Coffee + Stress2, data=coffee)
fit.both3 <- lm(Heart ~ Coffee + Stress3, data=coffee)

lev <- 0.68

res0 <- avPlot(fit.both, variable="Stress", xlim=c(-60,60), ylim=c(-60,60), 
	main="Measurement error in added variable: Stress",
	col="black", col.lines="black", pch=16,
	ellipse=TRUE, ellipse.args=list(levels=lev, col="black", fill=TRUE, fill.alpha=0.2))
#avPlot(fit.both1, variable="Stress1", add=TRUE,  
#	ellipse=TRUE, # ellipse.args=list(levels=lev, fill=TRUE, fill.alpha=0.2)
#	)

mod.mat1 <- model.matrix(fit.both1)
res1 <- lsfit(mod.mat1[, -3], cbind(mod.mat1[, 3], coffee$Heart), 
        intercept = FALSE)$residuals
dataEllipse(res1[,1], res1[,2], level=lev, col="blue", add=TRUE, fill=TRUE, fill.alpha=0.2)
abline(lsfit(res1[, 1], res1[, 2]), col = "blue", lwd = 2)
arrows(res0[,1], res0[,2], res1[,1], res1[,2], col="darkgray", angle=15, length=.1)


res0 <- avPlot(fit.both, variable="Coffee", xlim=c(-60,60), ylim=c(-60,60), 
#	main="Added variable + Marginal plot: Stress",
	col="black", col.lines="black", pch=16,
	ellipse=TRUE, ellipse.args=list(levels=lev, col="black", fill=TRUE, fill.alpha=0.2))
#avPlot(fit.both1, variable="Stress1", add=TRUE,  
#	ellipse=TRUE, # ellipse.args=list(levels=lev, fill=TRUE, fill.alpha=0.2)
#	)

mod.mat1 <- model.matrix(fit.both1)
res1 <- lsfit(mod.mat1[, -2], cbind(mod.mat1[, -2], coffee$Heart), 
        intercept = FALSE)$residuals
dataEllipse(res1[,1], res1[,2], level=lev, col="blue", add=TRUE, fill=TRUE, fill.alpha=0.2)
abline(lsfit(res1[, 1], res1[, 2]), col = "blue", lwd = 2)
arrows(res0[,1], res0[,2], res1[,1], res1[,2], col="darkgray", angle=15, length=.1)


