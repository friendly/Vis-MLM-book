---
  #' title: Comparing models, Penguins data
---


library(parameters)     # Processing of Model Parameters
library(performance)    # Assessment of Regression Models Performance
library(see)            # Model Visualisation Toolbox for 'easystats' and 'ggplot2'
library(car)            # Companion to Applied Regression (for Anova)



load("data/peng.RData")

#' Here, use `body_mass` as main quantitative predictor, but control for `sex`, `species` and `island`
peng.mod0 <- lm(bill_length ~ body_mass + sex + species + island, data=peng)
Anova(peng.mod0)

#' ### Try an interaction term
peng.mod1 <- lm(bill_length ~ body_mass * sex + species + island, data=peng)
Anova(peng.mod1)

#' ### Test all interactions
#' 
#' This is a simple screening test to check whether any interactions with `body_mass` are important.
peng.mod2 <- lm(bill_length ~ body_mass * (sex + species + island), data=peng)
Anova(peng.mod2)

#' ### Compare models
#' 
#' `Anova()` tests the additional contribution of each model over the previous one.
anova(peng.mod0, peng.mod1, peng.mod2)

model_parameters(peng.mod0)

check_model(peng.mod0)

compare_parameters(peng.mod0, peng.mod1, peng.mod2, style="se_p")

compare_models(peng.mod0, peng.mod1, peng.mod2)

compare_performance(peng.mod0, peng.mod1, peng.mod2)

compare_performance(peng.mod0, peng.mod1, peng.mod2, rank=TRUE)

# plot method
plot(compare_performance(peng.mod0, peng.mod1, peng.mod2, rank=TRUE), size_line=2)


