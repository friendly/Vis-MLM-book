#' ---
#' title: Workers data - pca
#' ---
#' 

library(car)
library(spida2)

load(here::here("data", "workers.RData"))
str(workers)

dataEllipse(Income ~ Experience, data=workers,
            pch = 16, cex = 2, 
            center.pch = "+", center.cex = 2,
            levels = 0.68,
            xlim = c(-10, 40),
            ylim = c(0, 80))


plot(Income ~ Experience, data=workers,
     pch = 16, cex = 2)


# ell.lines <- dellplus(workers$Experience, workers$Income,
#      radius = qchisq(0.68, 2),
#      ellipse = FALSE
#     )
# lines(ell.lines)

S <- cov(workers[, 3:2])
mu <- colMeans(workers[, 3:2])
lines(ellplus(mu, S))

# show conjugate axes for PCA factorization
pca.fac <- function(x) {
  xx <- svd(x)
  ret <- t(xx$v) * sqrt(pmax( xx$d,0))
  ret
}

lines( ellplus(mu, shape = S, box=TRUE, diameters=TRUE, fac=pca.fac ), col = 'red')

      