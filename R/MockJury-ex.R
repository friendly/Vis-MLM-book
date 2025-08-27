#' ---
#' title: Mock Jury data
#' ---

library(car)
library(heplots)
library(ggpubr)
library(patchwork)

data(MockJury, package = "heplots")
str(MockJury)

table(MockJury$Attr)
table(MockJury$Attr, MockJury$Crime)

jury.mod <- lm( cbind(Serious, Years) ~ Attr * Crime, data=MockJury)
Anova(jury.mod, test = "Roy")

Anova(jury.mod) |> 
  summary() |> print(SSP = FALSE)

p1 <- ggline(MockJury, 
  x = "Attr", y = "Years",
  color = "Crime", shape = "Crime",
  add = c("mean_se"),
  position = "dodge",
  point.size = 5, 
  linewidth = 1.5,
  ggtheme = theme_pubr(base_size = 16)
  ) +
  xlab("Physical attractiveness of photo") +
  ylab("Recommended years of sentence") +
  theme(legend.position = "inside",
        legend.position.inside = c(.2, .8))
p1

p2 <- ggline(MockJury, 
  x = "Attr", y = "Serious",
  color = "Crime", shape = "Crime",
  add = c("mean_se"),
  position = "dodge",
  point.size = 5, 
  linewidth = 1.5,
  ggtheme = theme_pubr(base_size = 16) 
  ) +
  xlab("Physical attractiveness of photo") +
  ylab("Recommended years of sentence") +
  theme(legend.position = "inside",
        legend.position.inside = c(.2, .2))
p2

p1 + p2

