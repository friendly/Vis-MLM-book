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

uniStats(jury.mod)

legend_inside <- function(pos) {
  theme(legend.position = "inside",
        legend.position.inside = pos)
}

p1 <- ggline(MockJury, 
  x = "Attr", y = "Years",
  color = "Crime", shape = "Crime", linetype = "Crime",
  add = c("mean_se"), position = position_dodge(width = .1),
  point.size = 5, linewidth = 1.5,
  palette = c("blue", "darkorange2"),
  ggtheme = theme_pubr(base_size = 16)
  ) +
  xlab("Physical attractiveness of photo") +
  ylab("Recommended years of sentence") +
  legend_inside(c(.25, .9))

p2 <- ggline(MockJury, 
  x = "Attr", y = "Serious",
  color = "Crime", shape = "Crime", linetype = "Crime",
  add = c("mean_se"), position = position_dodge(width = .1),
  point.size = 5,  linewidth = 1.5,
  palette = c("blue", "darkorange2"),
  ggtheme = theme_pubr(base_size = 16) 
  ) +
  xlab("Physical attractiveness of photo") +
  ylab("Seriousness of crime") +
  legend_inside(c(.75, .9))

p1 + p2

