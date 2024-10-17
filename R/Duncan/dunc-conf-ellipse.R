#' ---
#' title: Duncan data Confidence ellipse
#' ---

library(car)
data(Duncan, package = "carData")
car::some(Duncan)

duncan.mod <- lm(prestige ~ income + education, data=Duncan)

car::linearHypothesis(duncan.mod, "income = education")

wtest <- spida2::wald(duncan.mod, c(0, -1, 1))[[1]]
wtest$estimate

op <- par(mar = c(4,4, 1, 0)+ .3)
confidenceEllipse(duncan.mod, col = "blue",
  levels = 0.95, dfn = 1,
  fill = TRUE, fill.alpha = 0.2,
  xlim = c(-.4, 1),
  ylim = c(-.4, 1), asp = 1,
  cex.lab = 1.3,
  grid = FALSE,
  xlab = expression(paste("Income coefficient, ", beta[Inc])),
  ylab = expression(paste("Education coefficient, ", beta[Educ])))

# add line for equal slopes
abline(a=0, b = 1, lwd = 2, col = "green", lty = 3)
text(0.8, 0.8, expression(beta[Educ] == beta[Inc]), 
     srt=45, pos=3, cex = 1.5, col = "green")

# confidence intervals for each coefficient
beta <- coef( duncan.mod )[-1]
CI <- confint(duncan.mod)       # confidence intervals
lines( y = c(0,0), x = CI["income",] , lwd = 5, col = 'blue')
lines( x = c(0,0), y = CI["education",] , lwd = 5, col = 'blue')
points(rbind(beta), col = 'black', pch = 16, cex=1.5)
points(diag(beta) , col = 'black', pch = 16, cex=1.4)
arrows(beta[1], beta[2], beta[1], 0, angle=8, len=0.2)
arrows(beta[1], beta[2], 0, beta[2], angle=8, len=0.2)

# add line for equal slopes
abline(a=0, b = 1, lwd = 2)
text(0.8, 0.8, expression(beta[Educ] == beta[Inc]), 
     srt=45, pos=3, cex = 1.5)

# add line for difference in slopes
col <- "darkred"
x <- c(-1.5, .5)
lines(x=x, y=-x)
text(-.15, -.15, expression(~beta["Educ"] - ~beta["Inc"]), 
     col=col, cex=1.5, srt=-45)

# confidence interval for b1 - b2
wtest <- spida2::wald(duncan.mod, c(0, -1, 1))[[1]]
lower <- wtest$estimate$Lower /2
upper <- wtest$estimate$Upper / 2
lines(-c(lower, upper), c(lower,upper), lwd=6, col=col)

# projection of (b1, b2) on b1-b2 axis
beta <- coef( duncan.mod )[-1]
bdiff <- beta %*% c(1, -1)/2
points(bdiff, -bdiff, pch=16, cex=1.3)
arrows(beta[1], beta[2], bdiff, -bdiff, 
       angle=8, len=0.2, col=col, lwd = 2)

# calibrate the diff axis
ticks <- seq(-0.3, 0.3, by=0.2)
ticklen <- 0.02
segments(ticks, -ticks, ticks-sqrt(2)*ticklen, -ticks-sqrt(2)*ticklen)
text(ticks-2.4*ticklen, -ticks-2.4*ticklen, ticks, srt=-45)

par(op)
