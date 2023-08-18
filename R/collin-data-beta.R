#' ---
#' title: collinearity in data and beta space
#' ---
#' 
library(MASS)
library(car)
library(dplyr)
library(tibble)

set.seed{42}
N <- 100
mu <- c(0, 0)
s <- c(1, 1)
rho <- c(0, 0.6, 0.98)

# covariance matrix, with standard deviations s[1], s[2] and correlation r
Cov <- function(s, r){
  matrix(c(s[1], r * prod(s),
         r * prod(s), s[2]), nrow = 2, ncol = 2)
}

X <- mvrnorm(N, mu, Sigma = Cov(s, rho[1]))
colnames(X) <- c("x1", "x2")
y <- 2 * X[,1] + 2 * X[,2] + rnorm(N, 0, 10)

dataEllipse(X,
            levels= 0.95,
            xlim = c(-3, 3),
            ylim = c(-3, 3), asp = 1)

mod <- lm(y ~ X[,1] + X[,2])

confidenceEllipse(mod)
