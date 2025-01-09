library(car)
library(corrgram)
library(tidyr)
library(dplyr)
library(ggplot2)
library(ggrepel)
library(heplots)

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

p1 <- ggplot(school_long, aes(x, y)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, formula = y ~ x) +
  stat_ellipse(geom = "polygon", level = 0.95, fill = "blue", alpha = 0.2) +
  facet_grid(yvar ~ xvar, scales = "free") +
  labs(x = "predictor", y = "response") +
  theme_bw(base_size = 16)

p1 + geom_text_repel(data = school_long |> filter(site %in% outliers[1:3]), aes(label = site))




#fit the MMreg model
school.mod <- lm(cbind(reading, mathematics, selfesteem) ~ 
                   education + occupation + visit + counseling + teacher, data=schooldata)

# shorthand: fit all others
school.mod <- lm(cbind(reading, mathematics, selfesteem) ~ ., data=schooldata)
car::Anova(school.mod)

# HE plots
heplot(school.mod, fill=TRUE, fill.alpha=0.1)

pairs(school.mod, fill=TRUE, fill.alpha=0.1)

library(candisc)

# canonical correlation analysis
school.cc <- cancor(cbind(reading, mathematics, selfesteem) ~ 
                      education + occupation + visit + counseling + teacher, data=schooldata)
school.cc

redundancy(school.cc)

# coef
school.cc$coef$X |> round(3)

school.cc$coef$Y |> round(3)


# plot canonical scores
plot(school.cc, pch=16, id.n = 3)
text(-5, 1, paste("Can R =", round(school.cc$cancor[1], 3)), pos = 4)

plot(school.cc, which = 2, pch=16, id.n = 3)
text(-3, 3, paste("Can R =", round(school.cc$cancor[2], 3)), pos = 4)


heplot(school.cc, xpd=TRUE, scale=0.3)
