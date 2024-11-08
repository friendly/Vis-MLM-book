### R code producing the figures used in the Generalized Ridge Trace Plots paper
#
#  Figs 1-5

library(genridge)
library(VisCollin)
library(car)
data(longley)

longley.lm <- lm(Employed ~ GNP + Unemployed + Armed.Forces + 
                            Population + Year + GNP.deflator, 
                 data=longley)
vif(longley.lm)

colldiag(longley.lm) |> print(fuzz = .3)

lambda <- c(0, 0.005, 0.01, 0.02, 0.04, 0.08)
lridge <- ridge(Employed ~ GNP + Unemployed + Armed.Forces + 
                           Population + Year + GNP.deflator, 
                data=longley, lambda=lambda)
lridge

par(mar=c(4, 4, 1, 1)+ 0.1)
traceplot(lridge, 
          xlab = "Ridge constant (k)",
          xlim = c(-0.02, 0.08), cex.lab=1.25)

traceplot(lridge, 
          X = "df",
          xlim = c(4, 6.2), cex.lab=1.25)


# Ridge regression: Longley data
lambda <- c(0, 0.005, 0.01, 0.02, 0.04, 0.08)
lambdaf <- c(expression(~widehat(beta)^OLS), ".005", ".01", ".02", ".04", ".08")
lridge <- ridge(Employed ~ GNP + Unemployed + Armed.Forces + Population + Year + GNP.deflator, 
		data=longley, lambda=lambda)
plridge <- pca.ridge(lridge)


##############################
# Fig 1: ridge1.pdf
clr <-  c("black", "red", "darkgreen","blue", "cyan4", "magenta")
pch <- c(15:18, 7, 9)
matplot(lambda, lridge$coef, type='b', 
	xlab='Ridge constant (k)', ylab="Coefficient", xlim=c(0, 0.1), col=clr, pch=pch, cex=1.2,)
text(0.08, lridge$coef[6,], colnames(lridge$coef), pos=4)
abline(v=lridge$kLW, lty=3)
abline(v=lridge$kHKB, lty=3)
text(lridge$kLW, -3, "LW")
text(lridge$kHKB, -3, "HKB")
#dev.copy2pdf(file="ridge1.pdf")


# Alternative version, now produced in genridge package
traceplot(lridge, cex.lab=1.25, xlim=c(-.01, 0.08), col=clr, pch=pch)

##############################
# Fig 2
op <- par(mfrow=c(2,2), mar=c(4, 4, 1, 1)+ 0.1)
for (i in 2:5) {
	plot.ridge(lridge, variables=c(1,i), radius=0.5, cex.lab=1.5, col=clr, labels=NULL,, fill=TRUE, fill.alpha=0.2)
	text(lridge$coef[1,1], lridge$coef[1,i], expression(~widehat(beta)^OLS), cex=1.5, pos=4, offset=.1)
	text(lridge$coef[-1,c(1,i)], lambdaf[-1], pos=3, cex=1.3)
}
par(op)
#dev.copy2pdf(file="ridge2.pdf", width=6, height=6)

##############################
# Figure 3
op <- par(mar=c(4, 4, 1, 1) + 0.2)
biplot(plridge, radius=0.5, ref=FALSE, asp=1, var.cex=1.15, cex.lab=1.3, col=clr,
	fill=TRUE, fill.alpha=0.2, prefix="Dimension ")
text(plridge$coef[,5:6], lambdaf, pos=2, cex=1.3)
par(op)
#dev.copy2pdf(file="fig/ridge-pca56a.pdf")

##############################
# Fig 4
pairs(lridge, radius=0.5, diag.cex=1.75, col=clr, fill=TRUE, fill.alpha=0.2)
#dev.copy2pdf(file="ridge3.pdf")

##############################
# Figure 5
pairs(plridge, col=clr, radius=0.5)
#dev.copy2pdf(file="ridge-pca.pdf")

# Alternative version, using color fill
pairs(plridge, col=clr, radius=0.5, fill=TRUE, fill.alpha=0.1)

