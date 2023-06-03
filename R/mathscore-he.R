data(mathscore, package="heplots")

library(car)
library(heplots)

math.mod <- lm(cbind(BM, WP) ~ group, data=mathscore)
Anova(math.mod)

# HE plot

op <- par(mar=c(4,5,1,1)+.2)
hep <-
  heplot(math.mod, fill=TRUE, cex=2, cex.lab=1.8,
       xlab="Basic math", ylab="Word problems")
par(op)

options(digits=5)
## Multivariate tests: H & E matrices
math.aov <- Anova(math.mod)
(H <- math.aov$SSP)

(E <- math.aov$SSPE)

resids <- residuals(math.mod)
crossprod(resids)

fit <- fitted(math.mod)
ybar <- colMeans(mathscore[,2:3])
n <- nrow(mathscore)
crossprod(fit) - n * outer(ybar, ybar)

cols <- c("darkgreen", "blue", "red")
pch <- ifelse(mathscore$group==1, 15, 16)

png(filename="mathscore-resids.png", height=480, width=480)
op <- par(mar=c(4,5,1,1)+.2)
covEllipses(resids, mathscore$group, 
            pooled=TRUE, cex=2,
            xlab="Basic math", ylab="Word problems",
            fill = c(F, F, TRUE), fill.alpha=0.1,
            col = cols,
            asp=1,
            cex.lab=1.5)
points(resids, pch=pch, col=col, cex=1.25)
par(op)
dev.off()


png(filename="mathscore-fit.png", height=480, width=480)
op <- par(mar=c(4,5,1,1)+.2)
covEllipses(fit, mathscore$group, 
            pooled=FALSE, cex=2,
            xlab="Basic math", ylab="Word problems",
            fill = c(F, F, TRUE), fill.alpha=0.1,
            col = cols,
            asp=1,
            xlim = hep$xlim, ylim = hep$ylim,
            cex.lab=1.5)

points(jitter(fit), pch=pch, col=col, cex=1.25)
car::dataEllipse(fit[,1], fit[,2], add=TRUE, level=0.68, col="black", lwd=3)
par(op)
dev.off()


