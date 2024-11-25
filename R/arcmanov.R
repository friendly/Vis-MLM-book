library(heplots)
library(dplyr)

means <- tibble::tribble(
  ~group, ~y1, ~y2,
  1,  8,  10,
  2, 10,   5,
  3, 12,  14,
  4, 17,  20,
  5, 18,  11,
  6, 20,  16,
  7, 25,  20,
  8, 27,  26,
)
ng <- nrow(means)

set.seed(47)
means$s1 <- round(runif(ng, min =1.5, max = 4), digits=2)
means$s2 <- round(runif(ng, min =1.5, max = 4), digits=2)
means$r <- round(runif(ng, min =0.4, max =0.9), digits=2)

make_mu_sigma <- function(group, m1, m2, s1, s2, r, names = c("y1", "y2")) {
  if (missing(group)) group <- 1
  mu <- c(m1, m2)
  names(mu) <- names
  list(
    group = group,
    mu = mu,
    Sigma = matrix(c(s1^2, r*s1*s2,
                      r*s1*s2, s2^2),
                      nrow = 2, ncol = 2,
                      dimnames = list(names, names))
  )
}

make_mu_sigma(1, 10, 15, 1.5, 2, .5)

Grps <- list()
for (i in 1:ng) {
  Grps[[i]] <- make_mu_sigma(means$group[i], 
                             means$y1[i], means$y2[i],
                             means$s1[i], means$s2[i], means$r[i])
}
