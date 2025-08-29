#' ---
#' title: Mock Jury data
#' ---

library(car)
library(heplots)
library(candisc)
library(ggpubr)
library(patchwork)

data(MockJury, package = "heplots")
names(MockJury)

table(MockJury$Attr)
table(MockJury$Attr, MockJury$Crime)

# consider contrasts?
levels(MockJury$Attr)
C <- matrix(c(1, -0.5, -0.5,
              0,  1,    -1), nrow=3)

jury.mod <- lm( cbind(Serious, Years) ~ Attr * Crime, data=MockJury)
Anova(jury.mod, test = "Roy")

Anova(jury.mod) |> 
  summary() |> print(SSP = FALSE)

uniStats(jury.mod)

legend_inside <- function(position) {          # simplify legend placement
  theme(legend.position = "inside",
        legend.position.inside = position)
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

# Manipulation check

jury.mod1 <- lm( cbind(phyattr, exciting, sociable, happy, independent) ~ Attr * Crime, 
                  data=MockJury)
Anova(jury.mod1)
uniStats(jury.mod1)

op <- par(mar = c(4, 4, 1, 1)+0.5, mfrow = c(1, 2))
heplot(jury.mod1, 
       terms = "Attr", factor.means = "Attr",
       fill = TRUE, fill.alpha = 0.2,
       cex.lab = 1.6, asp = 1)

heplot(jury.mod1,
       variables = c(1,5),
       terms = "Attr", factor.means = "Attr",
       fill = TRUE, fill.alpha = 0.2,
       cex.lab = 1.6, asp = 1)
par(op)


pairs(jury.mod1, 
      terms = "Attr", factor.means = "Attr",
      fill = TRUE, fill.alpha = 0.1)

jury.can1 <- candisc(jury.mod1, term = "Attr") |>
  print()

op <- par(mar = c(4, 4, 1, 1)+0.5)
plot(jury.can1, rev.axes = c(TRUE, TRUE),
     lwd = 3,
     var.lwd = 2,
     var.cex = 1.4,
     var.col = "black",
     pch = 15:17,
     cex = 1.2,
     cex.lab = 1.5)
par(op)

jury.mod2 <- lm(cbind(exciting, calm, independent, sincere, warm, phyattr, sociable, 
                      kind, intelligent, strong, sophisticated, happy, ownPA) ~ Attr * Crime,
                data = MockJury)
uniStats(jury.mod2)

jury.can2 <- candisc(jury.mod2, term = "Attr")
  
plot(jury.can2, rev.axes = c(FALSE, TRUE),
     lwd = 3,
     var.lwd = 2,
     var.col = "black",
     pch = 15:17)

