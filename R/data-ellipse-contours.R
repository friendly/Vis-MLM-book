#' ---
#' title: Contours of constant Mahalanobis distance
#' ---

library(ggplot2)

set.seed(42)
N <- 100
mu <- c(0, 0)
r <- 0.6
sigma <- matrix(c(1, r,
                  r, 1), nrow = 2)

df<-as.data.frame(MASS::mvrnorm(n=N, 
                                mu=mu, 
                                Sigma=sigma,
                                empirical = TRUE))
colnames(df) <- c("x", "y")

plot(df)

df$dsq <- mahalanobis(df[,1:2], 
                      center = colMeans(df[,1:2]), 
                      cov = cov(df[,1:2]))

head(df)

ggplot(data = df, aes(x = x, y = y)) +
  geom_point(size = 2, color = "black", alpha = 0.8) +
  stat_density2d(alpha = 0.3, show.legend = FALSE) +
  stat_density2d_filled(alpha = 0.3, show.legend = FALSE) +
  xlim(c(-3.5, 3.5)) +
  ylim(c(-3.5, 3.5))

ggplot(data = df, aes(x = x, y = y, z = dsq)) +
  geom_point(size = 2, color = "black", alpha = 0.8) +
  geom_contour(aes(color = after_stat(level)))

