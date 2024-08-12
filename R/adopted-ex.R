library(ggplot2)
library(dplyr)
library(patchwork)

data(AddHealth, package="heplots")
str(AddHealth)

# Exploratory plots


means <- AddHealth |>
  group_by(grade) |>
  summarise(
    n = n(),
    dep_sd = sd(depression, na.rm = TRUE),
    anx_sd = sd(anxiety, na.rm = TRUE),
    dep_se = dep_sd / sqrt(n),
    anx_se = anx_sd / sqrt(n),
    depression = mean(depression),
    anxiety = mean(anxiety) ) |> 
  relocate(depression, anxiety, .after = grade) |>
  print()

p1 <-ggplot(data = means, aes(x = grade, y = anxiety)) +
  geom_point(size = 4) +
  geom_line(aes(group = 1), linewidth = 1.2) +
  geom_errorbar(aes(ymin = anxiety - anx_se, 
                    ymax = anxiety + anx_se),
                width = .2) +
  theme_bw(base_size = 15)

p2 <-ggplot(data = means, aes(x = grade, y = depression)) +
  geom_point(size = 4) +
  geom_line(aes(group = 1), linewidth = 1.2) +
  geom_errorbar(aes(ymin = depression - dep_se, 
                    ymax = depression + dep_se),
                width = .2) +
  theme_bw(base_size = 15)

p1 + p2


adopted.mod <- lm(cbind(anxiety, depression) ~ grade, data=AddHealth)
Anova(adopted.mod)