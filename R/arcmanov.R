library(heplots)
library(candisc)
library(dplyr)
#library(ellipse)
#library(purrr)
library(MASS)

means <- tibble::tribble(
  ~group, ~y1, ~y2,
  1,  5,   7,
  2, 13,   6,
  3, 14,  16,
  4, 15,  28,
  5, 21,  13,
  6, 25,  25,
  7, 30,  23,
  8, 36,  34,
)
ng <- nrow(means)

set.seed(47)
means$s1 <- round(runif(ng, min =1.5, max = 4), digits=2)
means$s2 <- round(runif(ng, min =1.5, max = 4), digits=2)
#means$r <- round(runif(ng, min = 0.4, max =0.9), digits=2)
means$r <- round(runif(ng, min = -0.8, max = -0.4), digits=2)

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


plot(y2 ~ y1, data=means,
     pch = 16,
     xlim = c(0, 40),
     ylim = c(0, 40))

for (i in 1:ng) {
  g <- Grps[[i]]$group
  mu <- Grps[[i]]$mu
  S <- Grps[[i]]$Sigma
  # polygon(ellipse::ellipse(S, centre=mu, level=0.68),
  #       col = scales::alpha("red", .1), lwd=1.5)
  car::ellipse(mu, S, radius = sqrt(qchisq(0.68, 2)),
#               col = scales::alpha("red", .1), 
               col = "red",
               fill = TRUE, fill.alpha = 0.1,
               lwd=1.5)
}
text(means$y1, means$y2, 1:ng, pos = 3)

# library(purrr)
# map_depth(Grps, 2, ~ mean(.x)) %>% unlist


n <- 5
dat <- data.frame()
for (i in 1:ng) {
 Y <-  mvrnorm(n, Grps[[i]]$mu, Grps[[i]]$Sigma) 
 dat <- rbind(dat, cbind(group=i, Y))
}
dat$group <- factor(dat$group)

Grps.mod <- lm(cbind(y1, y2) ~ group, data = dat)
Grps.aov <- car::Anova(Grps.mod)
H <- Grps.aov$SSP$group 
E <- Grps.aov$SSPE
dfe <- Grps.aov$error.df
grand.mean <- colMeans(dat[, c("y1", "y2")])

heplot(Grps.mod,
       level = 0.40,
       cex = 1.5,
       fill = c(TRUE, FALSE), fill.alpha = 0.2,
       term.labels = c("H matrix"))
ellipse.axes(E, centre=grand.mean,
             radius = 0.4)

E_half <- matlib::mpower(E, -1/2)
HE_inv <- E_half %*% H %*% E_half
polygon(ellipse::ellipse(HE_inv, centre=grand.mean, level=0.68),
        lwd=1.5)

Grps.can <- candisc(Grps.mod) |> print()

heplot(Grps.can,
       level = 0.40,
       cex = 1.5,
       fill = c(TRUE, FALSE), fill.alpha = 0.2,
       var.lwd = 2, var.cex = 2,
       rev.axes = c(TRUE, FALSE),
       scale = 11)



