#' ## Load packages and the data
library(car)
library(heplots)
library(reshape2)
library(ggplot2)
library(tidyr)
library(broom)
data(Parenting, package="heplots")

#' ## Initial view: side-by-side boxplots for a multivariate response

parenting_long <- Parenting |>
  tidyr::pivot_longer(cols=caring:play)

ggplot(parenting.long, aes(x=group, y=value, fill=group)) +
  geom_boxplot(outlier.size=2.5, alpha=.5) + 
  stat_summary(fun=mean, colour="white", geom="point", size=2) +
  facet_wrap(~ variable) +
  theme_bw() + 
  theme(legend.position="top") +
  theme(axis.text.x = element_text(angle = 15, hjust = 1)) 

ggplot(parenting.long, aes(x=group, y=value, fill=group)) +
  geom_violin(scale = "width", alpha = 0.5) +
  geom_boxplot(width = 0.4, fill = "white", outlier.size=3, alpha=.6) + 
  stat_summary(fun=mean, colour="black", geom="point", size=4, shape = "+") +
  facet_wrap(~ variable) +
  theme_bw() + 
  theme(legend.position="top") +
  theme(axis.text.x = element_text(angle = 15, hjust = 1)) 

#' One-way ANOVAs for each response
glance(parenting.mod)

glance(parenting.mod) |>
  select(response, r.squared, fstatistic, p.value)


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
parenting.can

heplot(parenting.can)

#' ## Figure 6
op <- par(mar=c(5,4,1,1)+.1)
pos <- c(4, 3, 3)

heplot(parenting.can, 
       fill=TRUE, fill.alpha=.1,  scale=6.5,
       cex.lab=1.5, var.cex=1.2, 
       var.lwd=2, var.col="brown",  var.pos=pos,
       label.pos=c(4, 3, 3), 
       cex=1.2, 
       xlim=c(-6,6), ylim=c(-6,6),
       prefix="Canonical dimension ")
par(op)
#dev.copy2pdf(file="parenting-hecan.pdf")
