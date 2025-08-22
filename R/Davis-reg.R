#' ---
#' title: Davis data
#' ---
#'


library(ggplot2) 
library(tidyverse)
library(broom)
library(car)
ggplot2:: theme_set(theme_bw(base_size = 16))

data(Davis, package="carData")

# remove missings
Davis <- Davis |>
  drop_na() 
  

#' ## correlations
Davis |>
  group_by(sex) |>
  select(sex, weight, repwt) |>
  summarise(r = cor(weight, repwt))

#' ## Fit models by sex

davis.modF <- lm(repwt ~ weight, data = Davis, subset = sex=="F")
davis.modM <- lm(repwt ~ weight, data = Davis, subset = sex=="M")

mods <- list(
  modF = lm(repwt ~ weight, data = Davis, subset = sex=="F"),
  modM = lm(repwt ~ weight, data = Davis, subset = sex=="M")
)

sapply(mods, coef) |> t()

Davis |>
  nest(data = -sex) |>
  mutate(model = map(data, ~ lm(repwt ~ weight, data = .)),
         tidied = map(model, tidy)) |>
  unnest(tidied) |>
  filter(term == "weight") |>
  select(sex, term, estimate, std.error)

  
#' ## show the regression lines both ways
p1 <- Davis |>
  ggplot(aes(x = weight, y = repwt, 
             color = sex, shape=sex)) +
  geom_point(size = ifelse(Davis$weight==166, 6, 2)) +
    geom_smooth(method = "lm", formula = y~x, se = FALSE) +
    labs(x = "Measured weight (kg)", 
         y = "Reported weight (kg)") +
    theme_bw(base_size = 14) +
    theme(legend.position = "inside", 
          legend.position.inside = c(.8, .8))

p2 <- Davis |>
  ggplot(aes(y = weight, x = repwt, 
             color = sex, shape=sex)) +
    geom_point(size = 2) +
    labs(y = "Measured weight (kg)", 
         x = "Reported weight (kg)") +
    geom_smooth(method = "lm", formula = y~x, se = FALSE) +
    theme(legend.position = "inside", 
          legend.position.inside = c(.8, .8))

# highlight the discrepant point  
library(ggforce)
# doesn't work
p1 + geom_mark_circle(data=Davis, filter = Davis$weight == 166)

p3 <- Davis |>
  ggplot(aes(x = weight, y = repwt, color = sex, shape=sex)) +
  geom_point(size = ifelse(Davis$weight==166, 6, 2)) +
  labs(y = "Measured weight (kg)", x = "Reported weight (kg)") +
  geom_smooth(method = "lm", formula = y~x, se = FALSE) +
  theme_bw(base_size = 14) +
  theme(legend.position = c(.8, .8))



# influence plot

influencePlot(davis.modF)

davis.mod <- lm(repwt ~ weight * sex, data=Davis)  

influencePlot(davis.mod)

Davis[c(12, 115),]

op <- par(mfrow = c(2,2), mar = c(5, 5, 3, 1) + .1)
plot(davis.mod, 
     cex.lab = 1.2, cex = 1.1, 
     id.n = 2, cex.id = 1.2, lwd = 2)
par(op)

library(performance)
check_model(davis.mod, 
            check=c("linearity", "qq", 
                    "homogeneity", "outliers"))

