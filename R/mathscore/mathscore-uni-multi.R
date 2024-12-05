library(tidyr)
library(dplyr)
library(broom)
library(broom.helpers)
library(purrr)
library(ggplot2)
library(car)

data(mathscore, package="heplots")

math.mod <- lm(cbind(BM, WP) ~ group, data=mathscore)
Anova(math.mod)

# what does predict give?
fitted(math.mod)
predict(math.mod, se = TRUE) # no std errors

heplots::etasq(math.mod)

# get univariate results

lm(BM ~ group, data = mathscore) |> summary()

tidy(math.mod) |>
  filter(term != "(Intercept)") |>
  select(-term) |>
  rename(Mean_diff = estimate,
         t = statistic)
  


math_long <- mathscore |>
  pivot_longer(cols = BM:WP, names_to = "score")
  
