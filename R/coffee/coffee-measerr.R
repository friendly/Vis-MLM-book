# demonstrate effect of measurement error via data ellipses and confidence ellipses

#library(spida)	# for coffee data
#if (!require("spida")) install.packages("spida", repos="http://R-Forge.R-project.org", type = "source"); 
library("spida2")   ## for coffee data 

library(car)		# for dataEllipse, confidenceEllipse
data(coffee, package="matlib")

SD <- sd(coffee$Stress)
n<-nrow(coffee)
mStress <- mean(coffee$Stress)
set.seed(12347)  # reproducability

# Create 3 copies of Stress, but adding N(0,sd) errors
# assure that the mean is unchanged

#err <- c(.75, 1, 1.5)  # much too much
err <- c(.25, .5, .75)  # still too much
err <- c(.2, .4, .8)    # about right

coffee$Stress1 <- coffee$Stress + round(rnorm(n, sd=err[1]*SD))
coffee$Stress1 <- mStress+as.vector(scale(coffee$Stress1, center=TRUE, scale=FALSE))
coffee$Stress2 <- coffee$Stress + round(rnorm(n, sd=err[2]*SD))
coffee$Stress2 <- mStress+as.vector(scale(coffee$Stress2, center=TRUE, scale=FALSE))
coffee$Stress3 <- coffee$Stress + round(rnorm(n, sd=err[3]*SD))
coffee$Stress3 <- mStress+as.vector(scale(coffee$Stress3, center=TRUE, scale=FALSE))
str(coffee)


# simple regressions
fit.stress <- lm(Heart ~ Stress, data=coffee)
fit.coffee <- lm(Heart ~ Coffee, data=coffee)


## beta space, joint effect of error on both coefficients
### show effect on coeff of Coffee too

fit.both <- lm(Heart ~ Coffee + Stress, data=coffee)
fit.both1 <- lm(Heart ~ Coffee + Stress1, data=coffee)
fit.both2 <- lm(Heart ~ Coffee + Stress2, data=coffee)
fit.both3 <- lm(Heart ~ Coffee + Stress3, data=coffee)
coefs <- sapply(list(fit.both, fit.both1, fit.both2, fit.both3), coef)

png(file="coffee-measerr.png", width=7, height=7, res=200, units="in")
#pdf(file="coffee-measerr.pdf", width=7, height=7)

op <- par(mar=c(4, 4, 1, 1) + 0.1)
lev=0.68
confidenceEllipse(fit.both, levels=lev, col="black", 
	xlim=c(-1,1.5), 
	ylim=c(-.5,2), 
	grid=FALSE, fill=TRUE, cex.lab=1.5)
abline(h=0, v=0, col="gray")
text(1.5, 2, label="Beta space:", cex=1.7, pos=2)
text(1.5, 1.8, label=expression(group("(", list(beta[1], beta[2]), ")")),
cex=1.7, pos=2)
text(coef(fit.both)[2],  coef(fit.both)[3], "0", pos=4, cex=1.2)

confidenceEllipse(fit.both1, levels=lev, col="blue", add=TRUE, fill=TRUE, fill.alpha=0.2)
text(coef(fit.both1)[2], coef(fit.both1)[3], err[1], pos=4, cex=1.2)

# show marginal coefficients
abline(v=coef(fit.coffee)[2], lty=2)
abline(h=coef(fit.stress)[2], lty=2)
text(-0.9, coef(fit.stress)[2], "marginal", pos=1)
text(coef(fit.coffee)[2], -0.4, "marginal", pos=1, srt=90)

confidenceEllipse(fit.both2, levels=lev, col="red", add=TRUE, fill=TRUE, fill.alpha=0.1)
text(coef(fit.both2)[2], coef(fit.both2)[3], err[2], pos=4, cex=1.2)

confidenceEllipse(fit.both3, levels=lev, col="green3", add=TRUE, fill=TRUE, fill.alpha=0.1)
text(coef(fit.both3)[2], coef(fit.both3)[3], err[3], pos=4, cex=1.2)


par(op)
dev.off()

library(magick)
image_read("coffee-measerr*.png")
#convert -delay 100 coffee-measerr*.png -loop 0 coffee-measerr.gif


