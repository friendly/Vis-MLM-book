library(car)
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

# Joint plot
ggplot(data = means, aes(x = anxiety, y = depression, 
                         color = grade)) +
  geom_point(size = 3) +
  geom_errorbarh(aes(xmin = anxiety - anx_se, 
                     xmax = anxiety + anx_se)) +
  geom_errorbar(aes(ymin = depression - dep_se, 
                    ymax = depression + dep_se)) +
  geom_line(aes(group = 1), linewidth = 1.5) +
  geom_label(aes(label = grade), 
             nudge_x = -0.015, nudge_y = 0.02) +
  scale_color_discrete(guide = "none") +
  theme_bw(base_size = 15)

# covEllipses
op <- par(mar = c(5,4,1,1)+0.1)
covEllipses(AddHealth[, 3:2], group = AddHealth$grade,
            pooled = FALSE, level = 0.1,
            center.cex = 2.5, cex = 1.5, cex.lab = 1.5,
            fill = TRUE, fill.alpha = 0.05)
par(op)



AH.mlm <- lm(cbind(anxiety, depression) ~ grade, data = AddHealth)
# overall test of `grade`
Anova(AH.mlm)

## show separate multivariate tests
summary(Anova(AH.mlm)) |> print(SSP = FALSE)

## linear effect
linearHypothesis(AH.mlm, "grade.L") |> print(SSP = FALSE)

## quadratic effect
linearHypothesis(AH.mlm, "grade.Q") |> print(SSP = FALSE)

rownames(coef(AH.mlm))
## joint test of all higher terms
linearHypothesis(AH.mlm, rownames(coef(AH.mlm))[3:5]) |> print(SSP = FALSE)


