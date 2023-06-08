#' ---
#' title: Penguins data: tidy models
#' ---

library(here)
library(dplyr)
library(purrr)
library(broom)
library(effects)
library(ggplot2)

load(here("data", "peng.RData"))

ggplot(data=peng, aes(x=body_mass, y=bill_length, color=species, fill=species)) +
  geom_point() +
  geom_smooth(method = "lm", size=1.5) +
  stat_ellipse(size=1.5) +
  theme_bw(base_size=16) +
  theme(legend.position = c(.8, .2))


#' ## fit model for bill_length
peng.mod0 <- lm(bill_length ~ body_mass + sex + species + island, data=peng)
summary(peng.mod0)

#' ## visualize model effects
#' plot the predicted effects for the model terms
plot(allEffects(peng.mod0))

#' ## A more compact & tidy summary
glance(peng.mod0)

#' tidy() gives the model term statistics
tidy(peng.mod0)

#' ## augment() gives observation-level statistics
augment(peng.mod0) %>% slice(1:5)

#' ## fit multiple models
models <- peng |>
  nest_by(sex, island) |>
  mutate(model = list(lm(bill_length ~ body_mass, data = data)))

models |> summarise(rsq = summary(model)$r.squared)

#' get selected statistics for all models
models |> 
  summarise(broom::glance(model), .groups = "keep") |> 
  select(sex, island, r.squared, sigma, statistic, p.value, nobs)

models |> 
  summarise(broom::augment(model), .groups = "keep") |> 
  mutate(
    sex = stringr::str_to_upper(sex),
    SexIsland = forcats::fct_cross(sex, island)) |>
  ggplot(aes(x=body_mass, y=bill_length, color=SexIsland, fill=SexIsland)) +
    geom_point(alpha=0.4) +
    geom_smooth(method = "lm", size = 2, alpha=0.3) +
    theme_bw(base_size = 16) +
    theme(legend.position = c(.85, .3))

#' Do the same for species, sex  
models <- peng |>
  nest_by(species, sex) |>
  mutate(model = list(lm(bill_length ~ body_mass, data = data)))

models |> summarise(rsq = summary(model)$r.squared)

#' get selected statistics for all models
models |> 
  summarise(broom::glance(model), .groups = "keep") |> 
  select(species, sex, r.squared, sigma, statistic, p.value, nobs)

# plot using augment
models |> 
  summarise(broom::augment(model), .groups = "keep") |> 
  mutate(
    sex = stringr::str_to_upper(sex),
    SpeciesSex = forcats::fct_cross(species, sex)) |>
  ggplot(aes(x=body_mass, y=bill_length, color=SpeciesSex, fill=SpeciesSex)) +
  geom_point(alpha=0.4) +
  geom_smooth(method = "lm", size = 2, alpha=0.3) +
  theme_bw(base_size = 16) +
  theme(legend.position = c(.85, .3))

models |> 
  summarise(broom::augment(model), .groups = "keep") |> 
  mutate(
    sex = stringr::str_to_upper(sex),
    SpeciesSex = forcats::fct_cross(species, sex)) |>
  ggplot(aes(x=body_mass, y=.std.resid, color=SpeciesSex, fill=SpeciesSex)) +
  geom_point(alpha=0.4) +
  geom_smooth(method = "loess", size = 2, level=0.68, alpha=0.2) +
  theme_bw(base_size = 16) +
  theme(legend.position = c(.85, .3))





#' ## plot the predicted effects for the model terms
plot(allEffects(peng.mod0))

