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

school.mvn.hz <- mvn(residuals, mvn_test = "hz")  # `hz` test default
school.mvn.hz$multivariate_normality

school.mvn <- mvn(residuals, mvn_test = "mardia")
school.mvn$multivariate_normality
school.mvn$univariate_normality

# or
summary(school.mvn, select = "mvn")
summary(school.mvn, select = "univariate")

# try to fix
# mardia.result <- school.mvn.mardia$multivariateNormality
# mardia.result$Statistic <- as.numeric(mardia.result$Statistic)
# mardia.result$`p value` <- as.numeric(mardia.result$`p value`)
# mardia.result

univar.result <- school.mvn.mardia$univariate_normality
str(univar.result)


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

# Re-do HE plots
# also, reverse position of labels for counseling, teacher
heplot(school.mod2, 
       fill=TRUE, fill.alpha=0.1,
       cex = 1.5,
       cex.lab = 1.5,
       label.pos = c(rep("top", 4), "bottom", "bottom")
       )

pairs(school.mod2, 
      fill=TRUE, fill.alpha=0.1,
      var.cex = 2.5,
      cex = 1.3)



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

#------------------
# canonical correlation analysis

school.can <- cancor(cbind(reading, mathematics, selfesteem) ~ 
                           education + occupation + visit + counseling + teacher, 
                     data=schooldata)
school.can

redundancy(school.can)

# coef
school.can$coef$X |> round(3)

school.can$coef$Y |> round(3)


# plot canonical scores
plot(school.can, 
     pch=16, id.n = 3,
     cex.lab = 1.5, id.cex = 1.5,
     ellipse.args = list(fill = TRUE, fill.alpha = 0.1))
text(-5, 1, paste("Can R =", round(school.can$cancor[1], 3)), 
     cex = 1.4, pos = 4)

plot(school.can, which = 2, pch=16, id.n = 3)
text(-3, 3, paste("Can R =", round(school.can$cancor[2], 3)), pos = 4)

heplot(school.can, xpd=TRUE)

# -------------------------
# re-do, w/ out bad cases
school.can2 <- cancor(cbind(reading, mathematics, selfesteem) ~ 
                       education + occupation + visit + counseling + teacher, 
                     data=schooldata[OK, ],
                     set.names = c("Predictors", "Outcomes"))
school.can2

redundancy(school.can2)

# coef
# school.can2$coef$X |> round(3)
# 
# school.can2$coef$Y |> round(3)

coef(school.can2, type = "x", standardize = TRUE)

coef(school.can2, type="both", standardize=TRUE)

# correlations among canonical scores
scores(school.can2, type = "both") |> 
  as.data.frame() |> 
  cor() |> 
  zapsmall()


op <- par(mar = c(4,4,1,1) + .1,
          mfrow = c(1, 2))
plot(school.can2, 
     pch=16, id.n = 3,
     cex.lab = 1.5, id.cex = 1.5,
     ellipse.args = list(fill = TRUE, fill.alpha = 0.1))
text(-2, 1.5, paste("Can R =", round(school.can2$cancor[1], 3)), 
     cex = 1.4, pos = 4)

plot(school.can2, which = 2, 
     pch=16, id.n = 3,  id.cex = 1.5,
     ellipse.args = list(fill = TRUE, fill.alpha = 0.1))
text(-3, 3, paste("Can R =", round(school.can2$cancor[2], 3)), 
     cex = 1.4, pos = 4)
par(op)

# would be better to reflect dim 1
heplot(school.can2,
       fill = TRUE, fill.alpha = 0.2,
       var.col = "red", 
       asp = NA, scale = 0.25,
       cex.lab = 1.5, cex = 1.25,
       prefix="Y canonical dimension ")

