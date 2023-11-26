# PCA projection plot with ggplot2
# from: https://stackoverflow.com/questions/25123845/pca-projection-plot-with-ggplot2

# Simulate data
library(mvtnorm)
set.seed(2014)
Sigma <- matrix(data = c(4, 2, 2, 3), ncol=2)
mu <- c(1, 2)
n <- 20
X <- rmvnorm(n = n, mean = mu, sigma = Sigma)

# Run PCA
pca <- princomp(X)
load <- loadings(pca)
slope <- load[2, ] / load[1, ]
cmeans <- apply(X, 2, mean)
intercept <- cmeans[2] - (slope * cmeans[1])

# Plot data & 1st principal component
plot(X, pch = 20, asp = 1)
abline(intercept[1], slope[1])

# Plot perpendicular segments
x1 <- (X[, 2] - intercept[1]) / slope[1]
y1 <- intercept[1] + slope[1] * X[, 1]
x2 <- (x1 + X[, 1]) / 2
y2 <- (y1 + X[, 2]) / 2
segments(X[, 1], X[, 2], x2, y2, col = "red")

# Answer:

df<-data.frame(X,x2,y2)

library(ggplot2)
ggplot(df,aes(X1,X2))+
  geom_point(size = 3)+
  geom_abline(intercept=intercept[1], slope=slope[1], linewidth=2) +
  geom_segment(aes(xend=x2, yend=y2), color="red") +
  stat_ellipse() +
  coord_fixed()

