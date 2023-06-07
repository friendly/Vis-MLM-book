library(heplots)
library(candisc)
data(SocialCog, package="heplots")

str(SocialCog)

#' ## Boxplots

#' Reshape from wide to long
SC_long <- SocialCog |>
  tidyr::gather(key = response, value = "value", MgeEmotions:PersBias)

ggplot(SC_long, aes(x=Dx, y=value, fill=Dx)) +
  geom_jitter(shape=1, size=0.8, width=0.2) +
  geom_boxplot(width=0.5,  alpha=0.4, outlier.alpha=1, outlier.size = 3, outlier.color = "red") +
  scale_x_discrete(labels = c("Schizo", "SchizAff", "Control")) +
  facet_wrap(~response, scales = "free_y", as.table = FALSE) +
  theme_bw() +
  theme(legend.position="bottom",
        axis.title = element_text(size = rel(1.2)),
        axis.text  = element_text(face = "bold"),
        strip.text = element_text(size = rel(1.2)))

#' Fit the MLM
SC.mlm <-  lm(cbind(MgeEmotions,ToM, ExtBias, PersBias) ~ Dx,
               data=SocialCog)

Anova(SC.mlm)

# control vs. patients
print(linearHypothesis(SC.mlm, "Dx1"), SSP=FALSE)

# Schizo vs. SchizAff
print(linearHypothesis(SC.mlm, "Dx2"), SSP=FALSE)

#' ## HE plots

op <- par(mar=c(5,4,1,1)+.1)
heplot(SC.mlm, 
       hypotheses=list("Dx1"="Dx1", "Dx2"="Dx2"),
       fill=TRUE, fill.alpha=.1,
       cex.lab=1.5, cex=1.2)
par(op)
dev.copy2pdf(file="SC-heplot.pdf")

	
pairs(SC.mlm, fill=c(TRUE,FALSE), fill.alpha=.1) 

pairs(SC.mlm, fill=c(TRUE,FALSE), fill.alpha=.1,
	hypotheses=list("Dx1"="Dx1", "Dx2"="Dx2")) 
dev.copy2pdf(file="SC-pairs.pdf")

#' ## Canonical discriminant analysis

SC.can <- candisc(SC.mlm)
SC.can

#' the plot shows the canonical scores with data ellipses and variable vectors
#' indicating how they relate to the canonical dimensions. 
#plot(SC.can, ellipse=TRUE)

op <- par(mar=c(5,4,1,1)+.1)
col <- c("red", "darkgreen", "blue")
plot(SC.can, ellipse=TRUE, pch=c(7,9,10),
	var.cex=1.2, cex.lab=1.5, var.lwd=2,  col=col,
	var.col="black", # var.pos=pos,
	prefix="Canonical dimension ")
par(op)
dev.copy2pdf(file="SC-can.pdf")


#' equivalent plot, as an HE plot
heplot(SC.can, 
	fill=TRUE, fill.alpha=.1, 
	var.lwd=2, var.col="black", label.pos=c(3,1), 
	cex=1.25, cex.lab=1.2,
	prefix="Canonical dimension ")


op <- par(mar=c(5,4,1,1)+.1)
cqplot(SC.mlm, id.n=1, main="", cex.lab=1.25)
par(op)
dev.copy2pdf(file="SC-cqplot.pdf")

# using MVE shows 4 possible outliers!
cqplot(SC.mlm, method="mve", id.n=4, main="", cex.lab=1.25)


#' one extreme outlier spoils the pie!
library(mvinfluence)
influencePlot(SC.mlm, scale=20, fill.alpha.max=.4, cex.lab=1.5, id.cex=1.5)
 
op <- par(mar=c(5,4,1,1)+.1)
influencePlot(SC.mlm, type="LR", scale=20, fill.alpha.max=.4, id.cex=1.5)
par(op)
dev.copy2pdf(file="SC-LRplot.pdf")

SC.can <- candisc(SC.mlm)
SC.can


#' refit, deleting that case
SC.mlm1 <- update(SC.mlm, subset=rownames(SocialCog)!="15")
SC.mlm1
Anova(SC.mlm1)

print(linearHypothesis(SC.mlm1, "Dx1"), SSP=FALSE)
print(linearHypothesis(SC.mlm1, "Dx2"), SSP=FALSE)

#' ## HE plots

op <- par(mar=c(5,4,1,1)+.1)
heplot(SC.mlm1, hypotheses=list("Dx1"="Dx1", "Dx2"="Dx2"),
	fill=TRUE, fill.alpha=.1,
	cex.lab=1.5, cex=1.2)
par(op)

	
pairs(SC.mlm1, fill=c(TRUE,FALSE), fill.alpha=.1) 

#' ## Canonical discriminant analysis

SC.can1 <- candisc(SC.mlm1)
SC.can1

#' the plot shows the canonical scores with data ellipses and variable vectors
#' indicating how they relate to the canonical dimensions. 
plot(SC.can1, ellipse=TRUE)

#' equivalent plot, as an HE plot

op <- par(mar=c(5,4,1,1)+.1)
heplot(SC.can1, 
	fill=TRUE, fill.alpha=.1,
	hypotheses=list("Dx1"="Dx1", "Dx2"="Dx2"),
	lwd = c(1, 2, 3, 3),
	col=c("red", "blue", "darkgreen", "darkgreen"),
	var.lwd=2, var.col="black", label.pos=c(3,1), var.cex=1.2, 
	cex=1.25, cex.lab=1.2, scale=2.8,
	prefix="Canonical dimension ")
par(op)

dev.copy2pdf(file="SC1-hecan.pdf")

#' ## Robust MLM

# SC.rlm <- robmlm(cbind( MgeEmotions, ToM, ExtBias, PersBias) ~ Dx,
#                data=SocialCog,
#               subset=rownames(SocialCog)!="15")

SC.rlm <- robmlm(cbind( MgeEmotions, ToM, ExtBias, PersBias) ~ Dx,
               data=SocialCog)

Anova(SC.rlm)
print(linearHypothesis(SC.rlm, "Dx1"), SSP=FALSE)
print(linearHypothesis(SC.rlm, "Dx2"), SSP=FALSE)

pairs(SC.rlm, fill=c(TRUE,FALSE), fill.alpha=.1) 

Dx <- SocialCog$Dx
bad <- SC.rlm$weights < .6
col <- c("red", "darkgreen", "blue")
png(filename="SC-rlm-weights.png", width=480, height=480 )
op <- par(mar=c(5,4,1,1)+.1)
plot(SC.rlm$weights, 
	xlab="Case index", ylab="Weight in robust MANOVA", pch=(15:17)[Dx],
	col=col[Dx], ylim=c(0,1), cex = ifelse(bad, 1.4, .9),
	cex.lab = 1.25)

breaks <-cumsum(table(SocialCog$Dx))
ctr <- c(0,breaks[1:2]) + diff(c(0, breaks))/2
abline(v=breaks[1:2]+.5, col="grey")
text(ctr, 0.05+c(0, -.04, 0), levels(Dx), cex=1.2)
# choose some points (arbitrarily) to label individually as "outliers"
text((1:nrow(SocialCog))[bad], SC.rlm$weights[bad], labels=rownames(SocialCog)[bad], pos=c(2,4,4))
par(op)
dev.off()

#dev.copy2pdf(file="SC-rlm-weights.pdf")


#n <- nrow(SocialCog)
#segments( (1:n)[bad], 1, (1:n)[bad], SC.rlm$weights[bad],
#	col=c("red", "green", "blue")[SocialCog$Dx][bad] )

heplot(SC.mlm)
heplot(SC.rlm, add=TRUE)
