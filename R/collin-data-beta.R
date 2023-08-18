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
rho <- c(0, 0.6, 0.97)

# covariance matrix, with standard deviations s[1], s[2] and correlation r
Cov <- function(s, r){
  matrix(c(s[1], r * prod(s),
         r * prod(s), s[2]), nrow = 2, ncol = 2)
}

do_plots <- function(X, y, r) {
  dataEllipse(X,
              levels= 0.95,
              fill = TRUE, fill.alpha = 0.05,
              xlim = c(-3, 3),
              ylim = c(-3, 3), asp = 1)
  text(-3, -3, expression(paste(rho, " = ", r )))
  mod <- lm(y ~ X[,1] + X[,2])
  
  confidenceEllipse(mod,
                    col = "pink",
                    fill = TRUE, fill.alpha = 0.1,
                    xlab = "x1 coefficient",
                    ylab = "x2 coefficient",
                    asp = 1)
  abline(v=0, h=0, lwd=2)
}

X <- mvrnorm(N, mu, Sigma = Cov(s, rho[1]))
colnames(X) <- c("x1", "x2")
y <- 2 * X[,1] + 2 * X[,2] + rnorm(N, 0, 10)
mod <- lm(y ~ X[,1] + X[,2])

dataEllipse(X,
            levels= 0.95,
            col = "darkgreen",
            fill = TRUE, fill.alpha = 0.05,
            xlim = c(-3, 3),
            ylim = c(-3, 3), asp = 1)
text(-3, 2.5, bquote(rho == .(rho[1])), cex = 2, pos = 4)

confidenceEllipse(mod,
                  col = "pink",
                  fill = TRUE, fill.alpha = 0.1,
                  xlab = "x1 coefficient",
                  ylab = "x2 coefficient",
                  asp = 1)
abline(v=0, h=0, lwd=2)

do_plots(X, y, rho[1])

X <- mvrnorm(N, mu, Sigma = Cov(s, rho[2]))
colnames(X) <- c("x1", "x2")
y <- 2 * X[,1] + 2 * X[,2] + rnorm(N, 0, 10)
do_plots(X, y)

X <- mvrnorm(N, mu, Sigma = Cov(s, rho[3]))
colnames(X) <- c("x1", "x2")
y <- 2 * X[,1] + 2 * X[,2] + rnorm(N, 0, 10)
do_plots(X, y)



op <- par(mar = c(4,4,1,1)+0.1,
          mfcol = c(3, 2))
for (r in seq_along(rho)) {
  X <- mvrnorm(N, mu, Sigma = Cov(s, r))
  colnames(X) <- c("x1", "x2")
  y <- 2 * X[,1] + 2 * X[,2] + rnorm(N, 0, 10)
  
  dataEllipse(X,
              levels= 0.95,
              fill = TRUE, fill.alpha = 0.05,
              xlim = c(-3, 3),
              ylim = c(-3, 3), asp = 1)
  
  mod <- lm(y ~ X[,1] + X[,2])
  
  confidenceEllipse(mod,
                    fill = TRUE, fill.alpha = 0.1,
                    xlab = "x1 coefficient",
                    ylab = "x2 coefficient",
                    asp = 1)
  abline(v=0, h=0, lwd=2)
  
}

par(op)
