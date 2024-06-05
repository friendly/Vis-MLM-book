---
#'  title: prestige data, coefficient plots
---
  
data(Prestige, package="carData")
# make an ordered factor? NO - this gives linear/quad
#Prestige$type <- factor(Prestige$type, levels=c("bc", "wc", "prof")) # reorder levels
#head(Prestige)

library(dplyr)
library(ggplot2)
library(here)
library(modelsummary)
library(GGally)
library(broom.helpers)

data(Prestige, package = "carData")

#' plots of unstandardized coefficients

mod1 <- lm(prestige ~ education + income + women,
           data=Prestige)

# display coefficients
lmtest::coeftest(mod1)

# or use model summary
modelsummary(list("Model1" = mod1),
  coef_omit = "Intercept",
  stars = TRUE,
  shape = term ~ statistic,
  estimate = "{estimate} [{conf.low}, {conf.high}]",
  statistic = c("std.error", "p.value"),
  fmt = fmt_statistic("estimate" = 3, "conf.low" = 4, "conf.high" = 4),
   gof_omit = ".")

models <- list("Model1" = mod1, "Model2" = mod2, "Model3" = mod3)
modelsummary(models,
     coef_omit = "Intercept",
     fmt = 2,
     stars = TRUE,
     shape = term ~ statistic,
     statistic = c("std.error", "p.value"),
     gof_map = c("rmse", "r.squared")
     )


# plot the coefficients

theme_set(theme_minimal(base_size = 14))

modelplot(mod1, coef_omit="Intercept", 
          color="red", size=1, linewidth=2) +
  labs(title="Raw coefficients for mod1")

# fit other models
mod2 <- lm(prestige ~ education + women + income + type,
           data=Prestige)

mod3 <- lm(prestige ~ education + women + income * type,
                   data=Prestige)

models <- list("Model1" = mod1, "Model2" = mod2, "Model3" = mod3)
modelplot(models, 
          coef_omit="Intercept", 
          size=1.3, linewidth=2) +
  ggtitle("Raw coefficients") +
  geom_vline(xintercept = 0, linewidth=1.5) +
  scale_y_discrete(limits=rev) +
  theme(legend.position = "inside",
        legend.position.inside = c(0.85, 0.2))


#' Scale the variables to get standardized coefficients
Prestige_std <- Prestige %>%
  as_tibble() %>%
  mutate(across(where(is.numeric), scale))

mod1_std <- lm(prestige ~ education + income + women,
              data=Prestige_std)

mod2_std <- lm(prestige ~ education + women + income + type,
               data=Prestige_std)

mod3_std <- lm(prestige ~ education + women + income * type,
               data=Prestige_std)

models <- list("Model1" = mod1_std, "Model2" = mod2_std, "Model3" = mod3_std)
modelplot(models, 
          coef_omit="Intercept", size=1.3) +
  ggtitle("Standardized coefficients") +
  geom_vline(xintercept = 0, linewidth=1.5) +
  scale_y_discrete(limits=rev) +
  theme_bw(base_size = 16) +
  theme(legend.position = "inside",
        legend.position.inside = c(0.85, 0.2))

#' or use modelsummary with `standardize = "refit"`

modelplot(list("mod1" = mod1, "mod2" = mod2, "mod3" = mod3),
          standardize = "refit",
          coef_omit="Intercept", size=1.3) +
  ggtitle("Standardized coefficients") +
  geom_vline(xintercept = 0, linewidth=1.5) +
  scale_y_discrete(limits=rev) +
  theme(legend.position = "inside",
        legend.position.inside = c(0.85, 0.2))


library(ggstats)
ggcoef_model(mod2) +
  labs(x = "Standarized Coefficient")

models <- list(
  "Base model"      = mod1_std,
  "Add type"        = mod2_std,
  "Add interaction" = mod3_std)

ggcoef_compare(models) +
  labs(x = "Standarized Coefficient")


# Use GGally::ggcoef_compare
# This is based on ggstats::ggcoef_compare()

library(GGally)
library(broom.helpers)

ggcoef_compare(models) + 
  xlab("Standardized Beta") 


#' ## More meaningful units
#' A better substantative comparison of the coefficients could use understandable scales for the
#' predictors, e.g., months of education, $50,000 income or 10% of women's participation.
#' 
#' Note that the effect of this is just to multiply the coefficients and their standard errors by a factor. 
#' The statistical conclusions of significance are unchanged.

Prestige_scaled <- Prestige |>
  mutate(education = 12 * education,
         income = income / 100,
         women = women / 10)

mod1_scaled <- lm(prestige ~ education + income + women,
                  data=Prestige_scaled)
mod2_scaled <- lm(prestige ~ education + income + women + type,
                  data=Prestige_scaled)

arm::display(mod1_scaled, detail = TRUE)
arm::display(mod2_scaled, detail = TRUE)

ggcoef_model(mod1_scaled,
  signif_stars = FALSE,
  variable_labels = c(education = "education\n(months)",
                      income = "income\n(/$100K)",
                      women = "women\n(/10%)")
             ) +
  xlab("Coefficients for prestige with scaled predictors")

models <- list(
  "Base model"      = mod1_scaled,
  "Add type"        = mod2_scaled
#  "Add interaction" = mod3_scaled
  )

ggcoef_compare(models,
   variable_labels = c(education = "education\n(months)",
                       income = "income\n(/$100K)",
                       women = "women\n(/10%)")
) +
  xlab("Coefficients for prestige with scaled predictors")
