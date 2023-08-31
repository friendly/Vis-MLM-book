#' ---
#' title: leverage and the data ellipse
#' ---

#library(MASS)
library(car)
library(dplyr)

set.seed(421)
N <- 100
r <- 0.7
mu <- c(30, 30)
cov <- matrix(c(10,   10*r,
                10*r, 10), ncol=2)

X <- MASS::mvrnorm(N, mu, cov) |> as.data.frame()
colnames(X) <- c("x1", "x2")

# add 2 points
X <- rbind(X,
           data.frame(x1 = c(28, 38),
                      x2 = c(42, 35)))

# add a y variable to get hatvalues
X <- X |>
  mutate(Dsq = heplots::Mahalanobis(X)) |>
  mutate(y = 2*x1 + 3*x2 + rnorm(nrow(X), 0, 5),
         hat = hatvalues(lm(y ~ x1 + x2))) 

dataEllipse(X$x1, X$x2, 
            levels = c(0.40, 0.68, 0.95),
            fill = TRUE, fill.alpha = 0.05,
            col = "darkgreen",
            xlab = "X1", ylab = "X2")

# points(X[1:nrow(X) > N, 1:2], pch = 16, col=c("red", "blue"), cex = 2)
X |> slice_tail(n = 2) |> points(pch = 16, col=c("red", "blue"), cex = 2)

# demonstrate hat ~ D^2
plot(Dsq ~ hat, data = X,
     cex = c(rep(1, N), rep(2, 2)), 
     col = c(rep("black", N), "red", "blue"),
     pch = 16,
     xlab = "Hatvalue",
     ylab = "Mahalanobis Dsq")

# look at Dsq and hat values for these observation

X |> slice_tail(n=2)
