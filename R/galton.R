data(Galton, package = "HistData")

sunflowerplot(parent ~ child, data=Galton, 
      xlim=c(61,75), 
      ylim=c(61,75), 
      seg.col="black", 
    	xlab="Child height", 
      ylab="Mid Parent height")

y.x <- lm(parent ~ child, data=Galton)     # regression of y on x
abline(y.x, lwd=2)
x.y <- lm(child ~ parent, data=Galton)     # regression of x on y
cc <- coef(x.y)
abline(-cc[1]/cc[2], 1/cc[2], lwd=2, col="gray")

with(Galton, 
     car::dataEllipse(child, parent, 
         plot.points=FALSE, 
         levels=c(0.40, 0.68, 0.95), 
         lty=1:3)
    )
