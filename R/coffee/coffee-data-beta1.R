# demo of data ellipse vs. beta ellipse

setwd("c:/sasuser/datavis/manova/ellipses/fig")

require(spida2)   # coffee data
require(p3d)     # ellipse functions
require(car)     # dataEllipse, etc.  (needs car 2.0+)

###########
# fig 14: Scatterplot matrix
###########
# need to modify margins for tighter bounding boxes
opar <- par(mar=c(4,3,3,1)+0.1)

scatterplotMatrix(~Heart+Coffee+Stress, coffee, smooth=FALSE, ellipse=TRUE, levels=0.68, pch=19, col=rep("blue", 2), lwd=2)
par(opar)
dev.copy2eps(file="vis-reg-coffee11.eps")

fit.mult <- lm( Heart ~ Coffee + Stress, coffee)
fit.simple <- lm( Heart ~ Coffee, coffee)
fit.stress <- lm( Stress ~ Coffee, coffee)

# data ellipse vs confidence ellipse

###########
# fig 15a : Data space
###########
opar <- par(mar=c(4,4,1,1)+0.1)
with(coffee, dataEllipse(Coffee, Stress, level=0.40, col="blue", cex=1.2, cex.lab=1.5))
text(40,190, "Data space", cex=1.5)
abline(fit.stress)
dev.copy2eps(file="vis-reg-coffee12a.eps")
par(opar)


     # Confidence intervals, beta space
###########
# fig 15b   
###########
par(mar=c(4,4.2,1,1)+0.1)

plot( 0, 0, xlim = c( -2,2), ylim = c(-2,2)+1, type = 'n', cex.lab=1.7,
        xlab = list(~beta["Coffee"]),
        ylab = list(~beta["Stress"])
        )
text(1.5,2.85, "Beta space", cex=1.5)

abline( h = 0, lty="dashed")
abline( v = 0, lty="dashed" )

summary( fit.mult )
beta <- coef( fit.mult )[-1]
confint( fit.mult )  # confidence intervals

points( rbind(beta) , col = 'black', pch = 16, cex=1.5)

lines( y = c(0,0), x = confint(fit.mult)["Coffee",] , lwd = 5, col = 'red')
lines( x = c(0,0), y = confint(fit.mult)["Stress",] , lwd = 5, col = 'red')
points( diag( beta ), col = 'black', pch = 16, cex=1.3)

arrows(beta[1], beta[2], beta[1], 0, angle=8, len=0.2)
arrows(beta[1], beta[2], 0, beta[2], angle=8, len=0.2)

     # where do they come from? estimating two slopes simultaneously

lines( ce <-cell( fit.mult, dfn = 1 ), col = 'red' , lwd = 2)  # confidence ellipse
lines( cell( fit.mult, dfn = 2), col = 'green3' , lwd = 2)

text( -1.5, 1.9, "Joint 95% CE (d=2)", col = 'green4', adj = 0, cex=1.2)
text( 0.2, .78, "95% CI shadow ellipse (d=1)", col = 'red', adj = 0, cex=1.2)

cep <- attr(ce, 'parms')

# ell.conj generates lines for conjugate axes of an ellipse
#ell.conj(cep$center, cep$shape))

# abline2 not found (p3d?)

ax.down <- do.call( ell.conj, c( cep, list( dir = c(0,1), len=.5)))
abline2( ax.down$tan3, col = 'red', lty="dotted")
abline2( ax.down$tan4, col = 'red', lty="dotted")

dev.copy2eps(file="vis-reg-coffee12b.eps")


# What about marginal (simple regression) model

############
# fig 16: Beta space plus marginal confidence interval + CI for b1-b2
############

library(MASS)   # could use plot(..., asp=1) instead

op <- par(mar=c(4,4.2,1,1)+0.1)     
eqscplot( 0, 0, xlim = c( -2,2), ylim = c(-2,2)+1, type = 'n',  cex.lab=1.7,
        xlab = list(~beta["Coffee"]),
        ylab = list(~beta["Stress"])
        )
text(1.5,2.85, "Beta space", cex=1.5)

abline( h = 0, lty="dashed")
abline( v = 0, lty="dashed" )

summary( fit.mult )
beta <- coef( fit.mult )[-1]
confint( fit.mult )  # confidence intervals

points( rbind(beta) , col = 'black', pch = 16, cex=1.5)

lines( y = c(0,0), x = confint(fit.mult)["Coffee",] , lwd = 5, col = 'red')
lines( x = c(0,0), y = confint(fit.mult)["Stress",] , lwd = 5, col = 'red')
points( diag( beta ), col = 'black', pch = 16, cex=1.3)

     # where do they come from? estimating two slopes simultaneously

lines( ce <-cell( fit.mult, dfn = 1 ), col = 'red' , lwd = 2)  # confidence ellipse
lines( cell( fit.mult, dfn = 2), col = 'green3' , lwd = 2)

#text( -1.2, 1.9, "Joint 95% CE (d=2)", col = 'green4', adj = 0)
#text( -0.9, 1.7, "95% CI shadow ellipse (d=1)", col = 'red', adj = 0)
text( 0.2, .78, "95% CI shadow ellipse (d=1)", col = 'red', adj = 0, cex=1.2)

cep <- attr(ce, 'parms')

ax.down <- do.call( ell.conj, c( cep, list( dir = c(0,1), len=.5)))
abline2( ax.down$tan3, col = 'red', lty="dotted")
abline2( ax.down$tan4, col = 'red', lty="dotted")

lines ( y = c(0,0), x = confint( fit.simple )["Coffee",], lwd = 5, col = 'blue')
points( y =0, x = coef( fit.simple)[2], col = 'black', pch = 16, cex=1.3)
ax.oblique <- do.call( ell.conj, c( cep, list( dir = c(1,0))))
abline2( ax.oblique$v, col = 'blue')
#abline2( ax.oblique$tan4, col = 'blue')
abline2( ax.oblique$tan1, col = 'blue', lty=2)
abline2( ax.oblique$tan2, col = 'blue', lty=2)

text(1.0, .20, "95% marginal CI", col="blue", adj=c(0,.5), cex=1.2)

# note relationship between data ellipse for coffee and stress and
# confidence intervals for coffee and stress

#visual test of b1=b2 

col <- "darkcyan"
x <- c(-1.5, .5)
lines(x=x, y=-x)
text(-1.5,1.0, expression(~beta["Stress"] - ~beta["Coffee"]), col="black", cex=1.2, srt=-45)

# wald test for b1 - b2
wf <-wald(fit.mult, c(0, -1, 1))[[1]]
#str(wf)
lower <- wf$estimate$Lower /2
upper <- wf$estimate$Upper / 2
lines(-c(lower, upper), c(lower,upper), lwd=5, col=col)

# projection of (b1, b2) on b1-b2 axis
bdiff <- beta %*% c(1, -1)/2
points(bdiff, -bdiff, pch=16, cex=1.3)
arrows(beta[1], beta[2], bdiff, -bdiff, angle=8, len=0.2, col=col)

# calibrate the diff axis
ticks <- seq(-1.5, 0.5, by=0.5)
ticklen <- 0.03
segments(ticks, -ticks, ticks-sqrt(2)*ticklen, -ticks-sqrt(2)*ticklen)
text(ticks-2.4*ticklen, -ticks-2.4*ticklen, ticks, srt=-45)
par(op)

dev.copy2eps(file="vis-reg-coffee13.eps")

