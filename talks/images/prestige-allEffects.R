# Effect displays for the Prestige model (book Fig 7.17, fig-prestige-allEffects),
# re-drawn for the talk: the three plots in one row, with the income*type interaction
# as one multi-line panel rather than three small ones.
#
# Code adapted from 07-linear_models-plots.qmd (chunks prestige, prestige-mod3, fig-prestige-allEffects).
# Run from the project root:  Rscript talks/images/prestige-allEffects.R

library(effects)

data(Prestige, package="carData")
# Reorder levels of type
Prestige$type <- factor(Prestige$type,
                        levels=c("bc", "wc", "prof"))

prestige.mod3 <- lm(prestige ~ education + poly(women,2) +
                       log10(income)*type, data=Prestige)

png("talks/images/prestige-allEffects.png", width = 10, height = 3.9, units = "in", res = 300)
allEffects(prestige.mod3) |>
  plot(rows = 1, cols = 3,
       lines = list(multiline=TRUE, lwd=3),
       confint = list(style="bands"),
       axes = list(
          x=list(income=list(ticks=list(at=c(5000, 15000, 25000))))),
       key.args = list(x=.97, y=.1, corner=c(1,0)))
dev.off()
