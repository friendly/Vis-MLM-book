library(car)
library(tidyr)
library(dplyr)
library(ggplot2)
library(heplots)
library(candisc)

data(schooldata, package = "heplots")




#fit the MMreg model
school.mod <- lm(cbind(reading, mathematics, selfesteem) ~ 
                       education + occupation + visit + counseling + teacher, 
                 data=schooldata)

# shorthand: fit all others
school.mod <- lm(cbind(reading, mathematics, selfesteem) ~ ., data=schooldata)
car::Anova(school.mod)

# check for MVN
res <- cqplot(school.mod, id.n = 5)
res

library(MVN)
residuals <- residuals(school.mod)
school.mvn.hz <- mvn(residuals, mvnTest = "hz")  # `hz` test default

school.mvn.hz$multivariateNormality

school.mvn.mardia <- mvn(residuals, mvnTest = "mardia")
school.mvn.mardia$multivariateNormality
school.mvn.mardia$univariateNormality

# HE plots
heplot(school.mod, 
       fill=TRUE, fill.alpha=0.1,
       cex = 1.5,
       cex.lab = 1.5)

pairs(school.mod, 
      fill=TRUE, fill.alpha=0.1,
      var.cex = 2.5,
      cex = 1.3)


## Multivariate influence
library(mvinfluence)

influencePlot(school.mod, id.n=4, type="stres")

influencePlot(school.mod, id.n=4, type="LR")


## Remove cases 44, 59
bad <- c(44, 59)
OK <- (1:nrow(schooldata)) |> setdiff(bad)
school.mod2 <- update(school.mod, data = schooldata[OK,])

Anova(school.mod2)

reldiff <- function(x, y, pct=TRUE) {
  res <- abs(x - y) / x
  if (pct) res <- 100 * res
  res
}

reldiff(coef(school.mod)[-1,], coef(school.mod2)[-1,]) |>
  round(1)


## Robust MLM

school.rlm <- robmlm(cbind(reading, mathematics, selfesteem) ~ 
                   education + occupation + visit + counseling + teacher, 
                 data=schooldata)

#plot(school.rlm)


wts <- school.rlm$weights
small <- 0.6
notable <- which(wts < small)
plot(wts, type = "h", col="gray", 
     ylab = "Observation weight",
     cex.lab = 1.5)
points(seq_along(wts), wts, 
       pch=16,
       col = ifelse(wts < small, "red", "black"))
text(notable, wts[notable],
     labels = notable,
     pos = 3,
     col = "red")

# compare coefficients


100 * abs(coef(school.mod) - coef(school.rlm)) / coef(school.mod)

library(candisc)

# canonical correlation analysis
school.can <- cancor(cbind(reading, mathematics, selfesteem) ~ 
                      education + occupation + visit + counseling + teacher, data=schooldata)
school.can

redundancy(school.can)

# coef
school.can$coef$X |> round(3)

school.can$coef$Y |> round(3)


# plot canonical scores
plot(school.can, pch=16, id.n = 3)
text(-5, 1, paste("Can R =", round(school.can$cancor[1], 3)), pos = 4)

plot(school.can, which = 2, pch=16, id.n = 3)
text(-3, 3, paste("Can R =", round(school.can$cancor[2], 3)), pos = 4)


heplot(school.can, xpd=TRUE, scale=0.3)
