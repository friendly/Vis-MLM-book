# correlated bivariate data with 2 outliers
library(car)
library(ggplot2)
library(patchwork)

set.seed(123345)
x <- c(rnorm(100),             1.5, -1.5)
y <- c(x[1:100] + rnorm(100), -1.5, 1.5)

# basic tests
XY <- data.frame(x=x, y=y)
rownames(XY) <- seq_along(x)
XY <- scale(XY, center=TRUE, scale=FALSE) |> as.data.frame()
#XY$type =  c(rep("OK", 100), rep("out", 2))

# show one-D plots
p1 <- ggplot(data=XY, mapping=aes(x=x, fill = type)) +
  geom_dotplot(method = "histodot") + 
  scale_fill_manual(values = c("black", "red"), guid = "none") +
  theme(axis.title.y=element_blank(),
        axis.text.y=element_blank(), 
        axis.ticks.y=element_blank())
p1


op <- par(mar = c(4,4,0,1)+0.5,
          mfcol = c(1, 2))
dataEllipse(XY[,1], XY[,2], pch=16,
            levels=0.68, 
            id = list(n=2, cex = 1.5), 
            grid = FALSE,
            cex.lab = 1.5,
            xlab = "x", ylab = "y", asp=1)
points(XY[101:102,], pch=16, col = "red")
points(XY[101:102,], cex=3, col = "red")
mod <- lm(y~x, data=as.data.frame(XY))
abline(mod, col="red", lwd=3)
arrows(XY[101:102,1], XY[101:102,2], 
       XY[101:102,1], par("usr")[3], angle=15, length=.15, lty=2)
arrows(XY[101:102,1], XY[101:102,2], 
       par("usr")[1], XY[101:102,2], angle=15, length=.15, lty=2)
#par(op)

# rotate to principal components
pca <- princomp(XY[, 1:2], cor=TRUE)
scores <- as.data.frame(pca$scores)

#op <- par(mar = c(4,4,0,1)+0.5)
dataEllipse(scores[,1], scores[,2], pch=16, 
            levels=0.68, 
            id = list(n=2, cex = 1.5), 
            grid = FALSE,
            cex.lab = 1.5,
            xlab = expression(PC[1]), 
            ylab = expression(PC[2]), 
            asp = 1)
points(scores[101:102,], pch=16, col = "red")
points(scores[101:102,], cex=3, col = "red")
abline(lm(Comp.2 ~ Comp.1, data=scores), lwd=2, col="red")
arrows(scores[101:102,1], scores[101:102,2], 
       par("usr")[1], scores[101:102,2], angle=15, length=.15, lty=2)
par(op)


#source("c:/R/functions/interpPlot.R")
library(heplots)

#	lims <- apply(rbind(XY, scores),2,range)
	alpha <- seq(0,1,.1)
	for (alp in alpha) {
		main <- if(alp==0) "Original data"
			else if(alp==1) "PCA scores"
			else paste(round(100*alp,1), "% interpolation")
		xlab <- if(alp==0) "X"
			else if(alp==1) "PCA.1"
			else paste("X +", alp, "(X - PCA.1)")
		ylab <- if(alp==0) "Y"
			else if(alp==1) "PCA.2"
			else paste("Y +", alp, "(Y - PCA.2)")
		interpPlot(XY, scores, alp, 
#			xlim=lims[,1], ylim=lims[,2], 
			pch=16,
			main = main,
			xlab = xlab,
			ylab = ylab,
			ellipse=TRUE, ellipse.args=(list(levels=0.68, fill=TRUE, fill.alpha=(1-alp)/2)), 
			abline=TRUE, id.n=2, id.cex=1.2, cex.lab=1.25, segments=TRUE)
		Sys.sleep(1)
		}


# generalize

main <- function(alpha) {if(alpha==0) "Original data" 
	else if(alpha==1) "PCA scores"
	else paste(round(100*alpha,1), "% interpolation")}
xlab <- function(alpha) {if(alpha==0) "X"
	else if(alpha==1) "PCA.1"
	else paste("X +", alpha, "(X - PCA.1)")}
ylab <- function(alpha) {if(alpha==0) "Y"
	else if(alpha==1) "PCA.2"
	else paste("Y +", alpha, "(Y - PCA.2)")}
			

interpPCA <- function(XY, alpha = seq(0,1,.1)) {
	XY <- scale(XY, center=TRUE, scale=FALSE)
	if (is.null(rownames(XY))) rownames(XY) <- 1:nrow(XY)
	pca <- princomp(XY, cor=TRUE)
	scores <- pca$scores

	for (alp in alpha) {
		interpPlot(XY, scores, alp, 
			pch=16,
			main = main(alp),
			xlab = xlab(alp),
			ylab = ylab(alp),
			ellipse=TRUE, ellipse.args=(list(levels=0.68, fill=TRUE, fill.alpha=(1-alp)/2)), 
			abline=TRUE, id.n=2, id.cex=1.2, cex.lab=1.25, segments=TRUE)
		if(alp==0) {
			arrows(XY[101:102,1], XY[101:102,2], XY[101:102,1], par("usr")[3], angle=15, length=.15)
			arrows(XY[101:102,1], XY[101:102,2], par("usr")[1], XY[101:102,2], angle=15, length=.15)
		}
	
		Sys.sleep(1)
	}
	dataEllipse(scores, pch=16, levels=0.68, 
	            id = list(n=2), 
	            xlab=xlab(1), ylab=ylab(1), 
	            main="Outliers stand out on PCA.2",
	            asp = 1)
	points(scores[101:102,], cex=3)
	arrows(scores[101:102,1], scores[101:102,2], 
	       par("usr")[1], scores[101:102,2], angle=15, length=.15, lty = 2)
}

# show in R console
interpPCA(XY)


library(animation)

ani.options(outdir="C:/R/animation/outlier-demo")
saveGIF({
	interpPCA(XY, alpha <- seq(0,1,.1))
	},
	movie.name="outlier-demo.gif", ani.width=480, ani.height=480, interval=1.5)

saveHTML({
	# suppress display of source code in HTML
	ani.options(interval = 1.5, verbose=FALSE)
	interpPCA(XY, alpha <- seq(0,1,.1))
	}, 
	img.name = "outlier-demo", htmlfile = "outlier-demo.html", 
		single.opts = "'controls': ['first', 'previous', 'play', 'next', 'last', 'loop', 'speed']",
		title = "Outlier demo", 
    description = c("Demonstrating outlier detection by rotation to PCA")
  )


##### try saveLatex
#  -- doesn't work as given in example: too many \\
ani.options(outdir="c:/temp")
saveLatex({
#    par(mar = c(3, 3, 1, 0.5), mgp = c(2, 0.5, 0), tcl = -0.3, cex.axis = 0.8, cex.lab = 0.8, cex.main = 1)
	interpPCA(XY, alpha <- seq(0,1,.1))
}, 
	img.name = "outl", 
	ani.opts = "controls,loop,width=0.95\\textwidth", 
	latex.filename = ifelse(interactive(), "outliers.tex", ""), 
    interval = 0.1, ani.dev = "pdf", ani.type = "pdf", 
    ani.width = 7, ani.height = 7, 
    documentclass = paste("\\documentclass{article}", 
        "\\usepackage[papersize={7in,7in},margin=0.3in]{geometry}", sep = "\n"))

## the PDF graphics output is often too large because it is uncompressed; try
## the option ani.options('pdftk') or ani.options('qpdf') to compress the PDF
## graphics; see ?pdftk or ?qpdf and ?ani.options


