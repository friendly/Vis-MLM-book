library(car)
library(corrgram)
library(tidyr)
library(dplyr)
library(ggplot2)
library(ggrepel)
library(heplots)
library(candisc)

data(schooldata, package = "heplots")

# initial screening
scatterplotMatrix(schooldata)

corrgram(schooldata, 
         upper.panel=panel.ellipse, 
         lower.panel=panel.pts)

# multivariate outliers
res <- cqplot(schooldata, id.n = 5)
res
outliers <- rownames(res) |> as.numeric()

# plot predictors vs each response
xvars <- names(schooldata)[1:5]
yvars <- names(schooldata)[6:8]

school_long <- schooldata |>
  tibble::rownames_to_column(var = "site") |>
  pivot_longer(cols = all_of(xvars), names_to = "xvar", values_to = "x") |>
  pivot_longer(cols = all_of(yvars), names_to = "yvar", values_to = "y") |>
  mutate(xvar = factor(xvar, xvars), yvar = factor(yvar, yvars))

# make plots
# How to do this with noteworthy?
p1 <- ggplot(school_long, aes(x, y)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, formula = y ~ x) +
  stat_ellipse(geom = "polygon", 
               level = 0.95, fill = "blue", alpha = 0.2) +
  facet_grid(yvar ~ xvar, scales = "free") +
  labs(x = "predictor", y = "response") +
  theme_bw(base_size = 16)

#p1 + facet_grid(xvar ~ yvar, scales = "free")

p1 + geom_text_repel(data = school_long |> filter(site %in% outliers[1:3]), 
                     aes(label = site))




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
mvn(residuals)  # `hz` test default

mvn(residuals, 
    mvnTest = "mardia",
    multivariatePlot = "qq",
    showOutlier = TRUE
    )

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

coef(school.mod) - coef(school.rlm)



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
