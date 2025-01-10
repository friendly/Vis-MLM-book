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

# multivariate normality

library(heplots)
DSQ <- Mahalanobis(Galton)
alpha <- 0.01
cutoff <- (qchisq(p = 1 - alpha, df = ncol(Galton))) |> 
  print()
outliers <- which(DSQ > cutoff) |>
  print()

GaltonD <- cbind(Galton, DSQ = DSQ)
GaltonD[outliers,]

op <- par(mar = c(4,4,1,1)+.5)
set.seed(47)
dataEllipse(parent ~ child, data = GaltonD,
            levels = c(0.68, 0.95),
            add = FALSE, plot.points = FALSE,
            center.pch = "+", center.cex = 3,
            cex.lab = 1.5)
with(GaltonD,{
  points(jitter(child), jitter(parent),
         col = ifelse(DSQ > cutoff, "red", "black"),
         pch = ifelse(DSQ > cutoff, 16, 1),
         cex = ifelse(DSQ > cutoff, 2, 0.8))
  text(child[outliers], parent[outliers], labels = outliers, pos = 3)
  }
)
par(op)


# cqplot
out <- cqplot(Galton, id.n = 3) 



cqplot(Galton, id.n = 4, id.method = "r")

cqplot(Galton, id.n = 4, detrend = TRUE)
cqplot(Galton, id.n = 4, method = "mcd")

