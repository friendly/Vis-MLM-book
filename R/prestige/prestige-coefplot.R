---
#'  title: prestige data, coefficient plots
---
  
data(Prestige, package="carData")
# make an ordered factor
Prestige$type <- factor(Prestige$type, levels=c("bc", "wc", "prof")) # reorder levels
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
#  output = "markdown",
  stars = TRUE,
  shape = term ~ statistic,
  statistic = c("std.error", "p.value"),
  gof_omit = ".")


# plot the coefficients

theme_set(theme_minimal(base_size = 14))

modelplot(mod1, coef_omit="Intercept", 
          color="red", size=1) +
  labs(title="Raw coefficients for mod1")

# fit other models
mod2 <- lm(prestige ~ education + women + income + type,
           data=Prestige)

mod3 <- lm(prestige ~ education + women + income * type,
                   data=Prestige)

modelplot(list("mod1" = mod1, "mod2" = mod2, "mod3" = mod3), 
          coef_omit="Intercept", size=1.3, linewidth=2) +
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

models <- list("mod1" = mod1_std, "mod2" = mod2_std, "mod3" = mod3_std)
modelplot(models, 
          coef_omit="Intercept", size=1.3) +
  ggtitle("Standardized coefficients") +
  geom_vline(xintercept = 0, size=1.5) +
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
  theme_bw(base_size = 16) +
  theme(legend.position = "inside",
        legend.position.inside = c(0.85, 0.2))

# Use GGally::ggcoef_compare

library(GGally)
library(broom.helpers)

ggcoef_compare(models) + 
  xlab("Standardized Beta") 



