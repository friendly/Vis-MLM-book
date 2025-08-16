#' ---
#' title: "Iris data examples for EqCov paper"
#' author: "Michael Friendly and Matthew Sigal"
#' date: "21 Jun 2016"
#' ---

#' This script reproduces all of the analysis and graphs for the MANOVA of the `Iris` data 
#' in the paper and also includes other analyses not described there.  It is set up as an
#' R script that can be "compiled" to HTML, Word, or PDF using `knitr::knit()`.  This is most
#' convenient within R Studio via the `File -> Compile Notebook` option.

#+ echo=FALSE
knitr::opts_chunk$set(warning=FALSE, message=FALSE, R.options=list(digits=4))

#' ## Load packages and the data
library(heplots)
library(car)    # actually, loaded by heplots
data(iris)

iris.colors <- c("red", "darkgreen", "blue")

#' ## Initial scatterplots and data ellipses

op <- par(mfcol=c(1,2), mar=c(5,4,1,1)+.1)
scatterplot(Sepal.Width ~ Sepal.Length | Species, data=iris,
		ellipse=TRUE, levels=0.68, smoother=NULL, reg.line=FALSE, grid=FALSE,
		legend.coords=list(x=7, y=4.4), col=c("red", "blue", "black"))	

scatterplot(Sepal.Width ~ Sepal.Length | Species, data=iris,
		ellipse=TRUE, levels=0.68, smoother=NULL, grid=FALSE,
		reg.line=FALSE, cex=0, 
		legend.plot=FALSE, col=c("red", "blue", "black"))
par(op)



#' ## Using the covEllipse function

#' Uncentered and centered, first two variables
covEllipses(iris[,1:4], iris$Species, 
	fill=c(rep(FALSE,3), TRUE))

covEllipses(iris[,1:4], iris$Species, center=TRUE, 
	fill=c(rep(FALSE,3), TRUE), fill.alpha=.1, label.pos=c(1:3,0))

#' All pairs when more than two are specified
covEllipses(iris[,1:4], iris$Species, 
	fill=c(rep(FALSE,3), TRUE), variables=1:4, 
	fill.alpha=.1)

covEllipses(iris[,1:4], iris$Species, 
  variables=1:4, 
  fill = TRUE,
	fill.alpha=.1,
	col = c(iris.colors, "black"),
	label.pos=c(1:3,0))


#' ## view in PCA space   
#' NB: scale.=FALSE by default

iris.pca <- prcomp(iris[,1:4], scale = TRUE)
summary(iris.pca)

source(here::here("R/util/text.usr.R"))

op <- par(mfcol=c(1,2), mar=c(5,4,1,1)+.1)
covEllipses(iris.pca$x, iris$Species, 
  col = c(iris.colors, "black"),
	fill=TRUE, fill.alpha=.1,
  cex.lab = 1.5,
	label.pos = c(1, 3, 3, 0), asp=1)
text.usr(0.05, 0.95, "(a) Uncentered", pos = 4)

covEllipses(iris.pca$x, iris$Species,
  center=TRUE,        
  col = c(iris.colors, "black"),
  fill=TRUE, fill.alpha=.1,
  cex.lab = 1.5,
  label.pos = c(1, 3, 3, 0), asp=1)
text.usr(0.95, 0.95, "(b) Centered", pos = 2)
par(op)

# all variables
covEllipses(iris.pca$x, iris$Species, 
	fill=c(rep(FALSE,3), TRUE), variables=1:4, 
	label.pos=1:4, fill.alpha=.1)

covEllipses(iris.pca$x, iris$Species, center=TRUE,  
	fill=c(rep(FALSE,3), TRUE), variables=1:4, 
	label.pos=1:4, fill.alpha=.1)

# Plot the last two, PC 3,4
covEllipses(iris.pca$x, iris$Species, 
	fill=c(rep(FALSE,3), TRUE), variables=3:4, 
	label.pos=c(1:3,0), fill.alpha=.1, asp=1)

covEllipses(iris.pca$x, iris$Species, 
	fill=c(rep(FALSE,3), TRUE), center=TRUE, variables=3:4, 
	label.pos=c(1:3,0), fill.alpha=.1, asp=1)

# do these side-by-side, with iris colors
op <- par(mfcol=c(1,2), mar=c(5,4,1,1)+.1)
covEllipses(iris.pca$x, iris$Species, 
            variables = 3:4,
            col = c(iris.colors, "black"),
            fill=TRUE, fill.alpha=.1,
            cex.lab = 1.5,
            label.pos = c(1, 3, 3, 0), asp=1)

covEllipses(iris.pca$x, iris$Species,
            variables = 3:4,
            center=TRUE,        
            col = c(iris.colors, "black"),
            fill=TRUE, fill.alpha=.1,
            cex.lab = 1.5,
            label.pos = c(1, 3, 3, 0), asp=1)
par(op)

covEllipses(iris.pca$x, iris$Species,
  variables = 3:4,
  center=TRUE,        
  col = c(iris.colors, "black"),
  fill=TRUE, fill.alpha=.1,
  cex.lab = 1.5,
  label.pos = c(1, 3, 3, 4), asp=1)



#' ## compare classical and robust covariance estimates
covEllipses(iris[,1:4], iris$Species)
covEllipses(iris[,1:4], iris$Species, fill=TRUE, method="mve", add=TRUE, labels="")

#' Box's M test 
iris.mod <- lm(cbind(Sepal.Length + Sepal.Width + Petal.Length + Petal.Width) ~ Species,
               data = iris)	
iris.boxm <- boxM( cbind(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width) ~ Species, data=iris)

iris.boxm

op <- par(mar=c(4,5,1,1)+.1)
plot(iris.boxm, gplabel="Species", cex.lab = 1.5)
par(op)

op <- par(mfrow=c(2,2), mar=c(5,4,1,1))
plot(iris.boxm, which="product", gplabel="Species")
plot(iris.boxm, which="sum", gplabel="Species")
plot(iris.boxm, which="precision", gplabel="Species")
plot(iris.boxm, which="max", gplabel="Species")
par(op)

op <- par(mfrow=c(1,2), mar=c(5,4,1,1))
plot(iris.boxm, which="sum", gplabel="Species")
plot(iris.boxm, which="precision", gplabel="Species")
par(op)


#' covEllipses has a method for `"boxm"` objects
covEllipses(iris.boxm, fill=c(rep(FALSE,3), TRUE) )
covEllipses(iris.boxm, fill=c(rep(FALSE,3), TRUE), center=TRUE, label.pos=1:4 )

#' Boxplots of means, using `car::Boxplot`
op <- par(mfrow=c(1, 4), mar=c(5,4,1,1))
for (response in names(iris)[1:4]){
    Boxplot(iris[, response] ~ Species, data=iris,
            ylab=response, axes=FALSE, col=c("red", "blue", "gray"))
    box()
    axis(2)
    axis(1, at=1:3, labels=c("Setosa", "Vers.", "Virginca"))
    }
par(op)

#' ## models & plots

iris.mod <- lm(as.matrix(iris[, 1:4]) ~ Species, data=iris)
Anova(iris.mod)
iris.boxm <- boxM(iris.mod)
iris.boxm

#' ## canonical view of MANOVA test
library(candisc)
iris.can <- candisc(iris.mod)
op <- par(mar=c(5,4,1,1)+.1)
plot(iris.can, ellipse=TRUE)
par(op)


#' ## multivariate Levene test

irisdev <- abs( colDevs(iris[,1:4], iris$Species, median) )
irisdev.mod <- lm( irisdev ~ iris$Species)
Anova(irisdev.mod)

#' ## robust MLM
irisdev.rmod <- robmlm( irisdev ~ iris$Species)
Anova(irisdev.rmod)
pairs(irisdev.rmod, variables=1:4, fill=TRUE, fill.alpha=.1)


#' ## covariance ellipses of absolute deviations
covEllipses(irisdev, group=iris$Species,
	variables=1:4,
	fill=c(rep(FALSE,3), TRUE), fill.alpha=0.1, label.pos=c(1:3,0))

pairs(irisdev.mod, variables=1:4, fill=TRUE, fill.alpha=.1)

#' Canonical views for Levene's test
library(candisc)
irisdev.can <- candisc(irisdev.mod)
irisdev.can

plot(irisdev.can, which=1)
plot(irisdev.can, ellipse=TRUE)
