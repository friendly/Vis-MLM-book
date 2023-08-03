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


#' plots of unstandardized coefficients

mod0 <- lm(prestige ~ education + income + women,
           data=Prestige)

mod1 <- lm(prestige ~ education + women + income + type,
           data=Prestige)

mod2 <- lm(prestige ~ education + women + income * type,
                   data=Prestige)

modelplot(list("mod0" = mod0, "mod1" = mod1, "mod2" = mod2), 
          coef_omit="Intercept", size=1.3) +
  labs(title="Raw coefficients") +
  geom_vline(xintercept = 0, size=1.5) +
  scale_y_discrete(limits=rev) +
  theme_bw(base_size = 16) +
  theme(legend.position = c(0.9, 0.2))


#' Scale the variables to get standardized coefficients
Prestige_std <- Prestige %>%
  as_tibble() %>%
  mutate(across(where(is.numeric), scale))

mod0_std <- lm(prestige ~ education + income + women,
              data=Prestige_std)

mod1_std <- lm(prestige ~ education + women + income + type,
               data=Prestige_std)

mod2_std <- lm(prestige ~ education + women + income * type,
               data=Prestige_std)

models <- list("mod0" = mod0_std, "mod1" = mod1_std, "mod2" = mod2_std)
modelplot(models, 
          coef_omit="Intercept", size=1.3) +
  labs(title="Standardized coefficients") +
  geom_vline(xintercept = 0, size=1.5) +
  scale_y_discrete(limits=rev) +
  theme_bw(base_size = 16) +
  theme(legend.position = c(0.9, 0.2))

# Use GGally::ggcoef_compare

library(GGally)
library(broom.helpers)

ggcoef_compare(models) + 
  xlab("Standardized Beta") 



