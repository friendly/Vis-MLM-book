# ridge-demo

#cd("c:/sasuser/datavis/manova/ellipses")

library(ellipse)
beta <- c(3,4)
ell1 <- ellipse(.7, centre=beta, level=0.9)
ell2 <- ellipse(.7, centre=beta, level=0.6)
ell3 <- ellipse(.7, centre=beta, level=0.3)

circle <-function (radius = 1, segments=61) {
		angles <- (0:segments)*2*pi/segments
		radius * cbind( cos(angles), sin(angles))
}

# point closest to origin
min.pt <- function(XY) {
	pt <- which.min(apply(XY, 1, function(x) sum(x^2)))
	XY[pt,]
}

#cd("c:/sasuser/datavis/manova/ellipses/fig")
#eps(file="ridge-demo.eps", width=6, height=6)
#png(file="ridge-demo.png", width=6, height=6, res=200, units="in")
#pdf(file="ridge-demo.pdf", width=6, height=6)

op <- par(mar=c(1, 1, 1, 1)- 0.2)
plot(ell1, type='l', xlim=c(-1,5), ylim=c(-1,6), , lwd=1.5,
		xlab="", ylab="", col="red", asp=1, xaxt="n", yaxt="n")
points(beta[1], beta[2], pch=19, cex=2, col="red")
lines(ell2, col="red", lwd=1.5)
lines(ell3, col="red", lwd=1.5)

pts <- rbind(min.pt(ell1), min.pt(ell2), min.pt(ell3))
points(pts[,1], pts[,2])

#clrs <- trans.colors("lightblue", alpha=c(.2, .4, .6))
clrs <- c("#ADD8E633", "#ADD8E666", "#ADD8E699")

# what happened here? where is p1?
#rad1 <- sqrt(sum(p1^2))
rad1 <- 2.3
c1 <- circle(rad1)

polygon(    c1, col=clrs[1], border="lightblue") 
polygon(.67*c1, col=clrs[2], border="lightblue")
polygon(.33*c1, col=clrs[3], border="lightblue")

arrows(-1,  0, 5, 0, angle=10, length=.2, lwd=2, col="darkgray")
arrows( 0, -1, 0, 6, angle=10, length=.2, lwd=2, col="darkgray")
text(5, -.4, expression(~beta[1]), cex=2, pos=2)
text(-.2, 5.8, expression(~beta[2]), cex=2, pos=2)
text(beta[1], beta[2], expression(~widehat(beta)^OLS), cex=1.5, pos=4, offset=.1)
text(0, 0, "0", cex=2)
text(rad1, 0, expression(~sqrt(t)), cex=1.5)
text(pts[1,1], pts[1,2], expression(~widehat(beta)^RR), cex=1.5, pos=4, offset=.1)
par(op)
#dev.off()

