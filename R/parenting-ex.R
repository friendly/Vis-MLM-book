#' ---
#' title: "HE Plot Examples using Parenting Data"
#' author: "Michael Friendly and Matthew Sigal"
#' date: "18 Aug 2016"
#' ---

#' This script reproduces all of the analysis and graphs for the MANOVA of the parenting data 
#' in the paper and also includes other analyses not described there.  It is set up as an
#' R script that can be "compiled" to HTML, Word, or PDF using `knitr::knit()`.  This is most
#' convenient within R Studio via the `File -> Compile Notebook` option.

#+ echo=FALSE
library(knitr)
library(rgl)
knitr::opts_chunk$set(warning=FALSE, message=FALSE, R.options=list(digits=4))
knitr::knit_hooks$set(webgl = hook_webgl)
if(packageVersion("heplots") < "1.3.2") {
    warning("Installing package: heplots 1.3.2+ from R-Forge")
    install.packages("heplots", repos="http://R-Forge.R-project.org")
}

#' ## Load packages and the data
library(car)
library(heplots)
data(Parenting, package="heplots")

#' ## Initial view: side-by-side boxplots for a multivariate response
library(reshape2)
library(ggplot2)

parenting.long <- melt(Parenting)

ggplot(parenting.long, aes(x=group, y=value, fill=group)) +
		geom_boxplot(outlier.size=2.5, alpha=.5) + 
		stat_summary(fun.y=mean, colour="white", geom="point", size=2) +
		facet_wrap(~ variable) +
    theme_bw() + 
    theme(legend.position="top") +
    theme(axis.text.x = element_text(angle = 15, hjust = 1)) 

#' ## Run the MANOVA

# NB: order responses so caring, play are first
parenting.mod <- lm(cbind(caring, play, emotion) ~ group, data=Parenting)
Anova(parenting.mod)

#' test linear hypotheses (contrasts)
contrasts(Parenting$group)   # display the contrasts
print(linearHypothesis(parenting.mod, "group1"), SSP=FALSE)
print(linearHypothesis(parenting.mod, "group2"), SSP=FALSE)



#' ## Figure 4: compare effect and significance scaling

op <- par(mar=c(4,4,1,1)+0.1)
res <- heplot(parenting.mod,
		fill=TRUE, fill.alpha=c(0.3, 0.1),
		lty = c(0,1),
		cex=1.3, cex.lab=1.5)
label <- expression(paste("Significance scaling:", H / lambda[alpha], df[e]))
text(8.5, 11.5, label, cex=1.6)
par(op)
#dev.copy2pdf(file="parenting-HE2.pdf")

op <- par(mar=c(4,4,1,1)+0.1)
res <- heplot(parenting.mod, size="effect",
              fill=TRUE, fill.alpha=c(0.3, 0.1), 
              lty = c(0,1),
              cex=1.3, cex.lab=1.5, label.pos=c(1,2),
              xlim=res$xlim, ylim=res$ylim)
label <- expression(paste("Effect size scaling:", H / df[e]))
text(8.5, 11.5, label, cex=1.6)
par(op)
#dev.copy2pdf(file="parenting-HE1.pdf")

#' ## Figure 5: showing contrasts
# display tests of contrasts
hyp <- list("N:MP" = "group1", "M:P" = "group2")

# Fig 5: make a prettier heplot plot
op <- par(mar=c(4,4,1,1)+0.1)
heplot(parenting.mod, hypotheses=hyp, asp=1, 
       fill=TRUE, fill.alpha=c(0.3,0.1), 
       col=c("red", "blue"), 
       lty=c(0,0,1,1), label.pos=c(1,1,3,2),
       cex=1.4, cex.lab=1.4, lwd=3)
par(op)
#dev.copy2pdf(file="parenting-HE3.pdf")

#' ## other HE plots not shown in paper
pairs(parenting.mod, fill=TRUE, fill.alpha=c(0.3, 0.1))

# This 3D plot should be interactive: zoom and rotate under mouse control

#+ webgl=TRUE
heplot3d(parenting.mod, wire=FALSE)

#' ## Canonical discriminant analysis

library(candisc)
parenting.can <- candisc(parenting.mod)
heplot(parenting.can)

#' ## Figure 6
op <- par(mar=c(5,4,1,1)+.1)
pos <- c(4, 3, 3)

heplot(parenting.can, 
	fill=TRUE, fill.alpha=.1,  scale=6.5,
	cex.lab=1.5, var.cex=1.2, 
	var.lwd=2, var.col="black",  var.pos=pos,
	label.pos=c(4, 3, 3), 
	cex=1.2, 
	xlim=c(-6,6), ylim=c(-6,6),
	prefix="Canonical dimension ")
par(op)
#dev.copy2pdf(file="parenting-hecan.pdf")
