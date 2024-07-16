#' ---
#' title: Duncan data Confidence ellipse
#' ---

data(Duncan, package = "carData")
car::some(Duncan)

duncan.mod <- lm(prestige ~ income + education, data=Duncan)


op <- par(mar = c(4,4, 1, 0)+ .3)
confidenceEllipse(duncan.mod, col = "blue",
                  levels = 0.95,
                  fill = TRUE, fill.alpha = 0.2,
                  xlim = c(-.4, 1),
                  ylim = c(-.4, 1), asp = 1,
                  cex.lab = 1.3,
                  xlab = expression(paste("Income coefficient, ", beta[Inc])),
                  ylab = expression(paste("Education coefficient, ", beta[Educ])))
# confidenceEllipse(duncan.mod, col = "darkgreen",
#                   levels = 0.68,
#                   fill = TRUE, fill.alpha = 0.2,
#                   add = TRUE                  )

abline(h=0, v=0, lwd = 2)
coefs <- lmtest::coeftest(duncan.mod)
b <- coefs[2:3, 1]
se <- coefs[2:3, 2]
# segments(b[1] - (1:2)*se[1], c(0.025, 0), 
#          b[1] + (1:2)*se[1], c(0.025, 0), lwd=c(8, 5), col = c("darkgreen", "blue"))
# segments(c(0.025, 0), b[2] - (1:2)*se[2],
#          c(0.025, 0), b[2] + (1:2)*se[2], lwd=c(8, 5), col = c("darkgreen", "blue"))

beta <- coef( duncan.mod )[-1]
confint( duncan.mod )  # confidence intervals
lines( y = c(0,0), x = confint(duncan.mod)["income",] , lwd = 5, col = 'blue')
lines( x = c(0,0), y = confint(duncan.mod)["education",] , lwd = 5, col = 'blue')
points(rbind(beta), col = 'black', pch = 16, cex=1.5)
points(diag(beta) , col = 'black', pch = 16, cex=1.4)
arrows(beta[1], beta[2], beta[1], 0, angle=8, len=0.2)
arrows(beta[1], beta[2], 0, beta[2], angle=8, len=0.2)



# add line for equal slopes
abline(a=0, b = 1, lwd = 2)
#text(0.25, 0.25, expression(beta[Educ] == beta[Inc]), srt=45, pos=3, cex = 1.5)
text(0.8, 0.8, expression(beta[Educ] == beta[Inc]), 
     srt=45, pos=3, cex = 1.5)

spida2::wald(duncan.mod, c(0, -1, 1))

col <- "darkred"
x <- c(-1.5, .5)
lines(x=x, y=-x)
text(-.1, -.1, expression(~beta["Educ"] - ~beta["Inc"]), 
     col=col, cex=1.5, srt=-45)


# wald test for b1 - b2
wf <-spida2::wald(duncan.mod, c(0, -1, 1))[[1]]
#str(wf)
lower <- wf$estimate$Lower /2
upper <- wf$estimate$Upper / 2
lines(-c(lower, upper), c(lower,upper), lwd=6, col=col)
# projection of (b1, b2) on b1-b2 axis
beta <- coef( duncan.mod )[-1]
bdiff <- beta %*% c(1, -1)/2
points(bdiff, -bdiff, pch=16, cex=1.3)
arrows(beta[1], beta[2], bdiff, -bdiff, angle=8, len=0.2, col=col, lwd = 2)

par(op)
