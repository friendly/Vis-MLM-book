#' ---
#' title: Salaries data, model plot
#' ---

library(ggplot2)
library(car)
library(dplyr)
library(modelsummary)
data(Salaries, package="carData")

theme_set(theme_bw(base_size = 14))

salaries.mod1 <- lm(salary ~ yrs.since.phd + rank + discipline + sex,
                    data=Salaries)

summary(salaries.mod1)
arm::display(salaries.mod1, detail=TRUE)
#modelsummary(salaries.mod1)

# unstandardized coefs
modelplot(salaries.mod1,
          coef_omit = "Intercept", 
          size = 1.2, linewidth = 1.2) +
  geom_vline(xintercept = 0, linetype = 2, linewidth=1) +
  scale_y_discrete(limits=rev)

# standardized
modelplot(salaries.mod1,
          standardize = "refit",
          coef_omit = "Intercept", 
          size = 1.2, linewidth = 1.2) +
  geom_vline(xintercept = 0, linetype = 2, linewidth=1) +
  scale_y_discrete(limits=rev)


salaries.mod2 <- lm(salary ~ yrs.since.phd * rank + discipline + sex,
                    data=Salaries)

salaries.mod3 <- lm(salary ~ yrs.since.phd * (rank + discipline) + sex,
                    data=Salaries)

salaries.mod4 <- lm(salary ~ yrs.since.phd * (rank + discipline + sex),
                    data=Salaries)

models <- list(
  "Model1" = salaries.mod1,
  "Model2" = salaries.mod2,
  "Model3" = salaries.mod3,
  "Model4" = salaries.mod4
)


modelsummary(models, 
             fmt = fmt_decimal(digits = 2))

# unstandardized coefficients
modelplot(models, 
          coef_omit = "Intercept",
          size = 1, linewidth = 1) +
  geom_vline(xintercept = 0, linetype = 2, linewidth=1) +
  scale_y_discrete(limits=rev) +
  theme(legend.position = "inside",
        legend.position.inside = c(0.8, 0.2))

# standardized coefficients
modelplot(models, 
          standardize = "refit",
          coef_omit = "Intercept",
          size = 1, linewidth = 1) +
  geom_vline(xintercept = 0, linetype = 2, linewidth=1) +
  scale_y_discrete(limits=rev) +
  theme(legend.position = "inside",
        legend.position.inside = c(0.8, 0.2))




