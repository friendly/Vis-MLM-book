
library(here)


library(heplots)
library(candisc)
data(NeuroCog, package="heplots")

NC.mlm <- lm(cbind( Speed, Attention, Memory, Verbal, Visual, ProbSolv) ~ Dx,
               data=NeuroCog)
Anova(NC.mlm)

# test contrasts
contrasts(NeuroCog$Dx)
print(linearHypothesis(NC.mlm, "Dx1"), SSP=FALSE)
print(linearHypothesis(NC.mlm, "Dx2"), SSP=FALSE)

op <- par(mar=c(5,4,1,1)+.1)
heplot(NC.mlm, fill=TRUE, fill.alpha=0.1,
	cex.lab=1.3, cex=1.25)
par(op)

dev.copy2pdf(file="NC-heplot.pdf")


# pairwise HE plots
pairs(NC.mlm, var.cex=2, fill=TRUE, fill.alpha=0.1)
dev.copy2pdf(file="NC-pairs.pdf")

# canonical discriminant analysis                      
NC.can <- candisc(NC.mlm)
NC.can

# tweak var.pos
pos <- c(4, 1, 4, 4, 1, 3)
col <- c("red", "darkgreen", "blue")
op <- par(mar=c(5,4,1,1)+.1)
plot(NC.can, ellipse=TRUE, rev.axes=c(TRUE,FALSE), pch=c(7,9,10),
	var.cex=1.2, cex.lab=1.5, var.lwd=2,  scale=4.5, col=col,
	var.col="black", var.pos=pos,
	prefix="Canonical dimension ")
par(op)
dev.copy2pdf(file="NC-candisc.pdf")

#' equivalent plot, as an HE plot
op <- par(mar=c(5,4,1,1)+.1)
heplot(NC.can, 
	fill=TRUE, fill.alpha=.1,  scale=6,
	cex.lab=1.5, var.cex=1.2, 
	var.lwd=2, var.col="black",  var.pos=pos,
	label.pos=c(3,1), cex=1.1, rev.axes=c(TRUE,FALSE),
	prefix="Canonical dimension ")
par(op)
dev.copy2pdf(file="NC-hecan.pdf")


## fit a robust MLM, downweighting possible outliers

NC.rlm <- robmlm(cbind( Speed, Attention, Memory, Verbal, Visual, ProbSolv) ~ Dx,
               data=NeuroCog)
Anova(NC.rlm)
plot(NC.rlm)

