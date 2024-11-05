#' ---
#' title: collinearity in data and beta space
#' ---
#' 
library(MASS)
library(car)
# library(dplyr)
# library(tibble)

set.seed(421)
N <- 200
mu <- c(0, 0)            # means
s <- c(1, 1)             # standard deviations
rho <- c(0, 0.8, 0.97)   # correlations
beta <- c(3, 3)          # true coefficients

# covariance matrix, with standard deviations s[1], s[2] and correlation r
Cov <- function(s, r){
  matrix(c(s[1],    r * prod(s),
         r * prod(s), s[2]), nrow = 2, ncol = 2)
}

# Generate a dataframe of X, y for each rho
# Fit the model for each
XY <- vector(mode ="list", length = length(rho))
mods <- vector(mode ="list", length = length(rho))
for (i in seq_along(rho)) {
  r <- rho[i]
  X <- mvrnorm(N, mu, Sigma = Cov(s, r))
  colnames(X) <- c("x1", "x2")
  y <- beta[1] * X[,1] + beta[2] * X[,2] + rnorm(N, 0, 10)

  XY[[i]] <- data.frame(X, y=y)
  mods[[i]] <- lm(y ~ x1 + x2, data=XY[[i]])
}

# coefficients
coefs <- sapply(mods, coef)
colnames(coefs) <- paste0("mod", 1:3, " (rho=", rho, ")")
coefs

# VIFs
vifs <- sapply(mods, car::vif)
colnames(vifs) <- paste("rho:", rho)
vifs

do_plots <- function(XY, mod, r) {
  X <- as.matrix(XY[, 1:2])
  dataEllipse(X,
              levels= 0.95,
              col = "darkgreen",
              fill = TRUE, fill.alpha = 0.05,
              xlim = c(-3, 3),
              ylim = c(-3, 3), asp = 1)
  text(0, 3, bquote(rho == .(r)), cex = 2, pos = NULL)

  confidenceEllipse(mod,
                    col = "red",
                    fill = TRUE, fill.alpha = 0.1,
                    xlab = "x1 coefficient",
                    ylab = "x2 coefficient",
                    xlim = c(-5, 10),
                    ylim = c(-5, 10),
                    asp = 1)
  points(beta[1], beta[2], pch = "+", cex=2)
  abline(v=0, h=0, lwd=2)
}

op <- par(mar = c(4,4,1,1)+0.1,
          mfcol = c(2, 3),
          cex.lab = 1.5)

for (i in seq_along(rho)) {
  do_plots(XY[[i]], mods[[i]], rho[i])
}
par(op)




