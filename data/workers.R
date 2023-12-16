# workers data

library(dplyr)
library(heplots)
workers <- read.csv(here::here("data", "workers.csv"))

workers.mod <- lm(Income ~ Experience + Skill + Gender, data=workers)
summary(workers.mod)
coef(workers.mod)

set.seed(42)
# create job satisfaction measure
workers <- workers |> 
  mutate(
    Sat = Income/5 - 
          Experience / 2 + 
          Skill/2 + (Gender=="Female"),
    Sat = Sat + rnorm(n = nrow(workers), mean=0, sd = 1) |> round()) |>
  relocate(Sat, .after = Income)

car::spm(workers[, 2:5])

workers.mlm <- lm(cbind(Income, Sat) ~ Experience + Skill + Gender, data=workers)
summary(workers.mlm)

heplot(workers.mlm)

save(workers, file = here::here("data", "workers.RData"))
