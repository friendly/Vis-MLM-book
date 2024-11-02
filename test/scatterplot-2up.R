# car::scatterplot side-by-side, using par()

library(car)
data(Prestige, package = "carData")

op <- par(mfrow = c(1,2))
scatterplot(prestige ~ income, data = Prestige,
            smooth = FALSE, boxplot = FALSE)
scatterplot(prestige ~ education, data = Prestige,
            smooth = FALSE, boxplot = FALSE)
par(op)


op <- par(mfrow = c(1,2),
          mar = c(5,5,1,1)+.1)
dataEllipse(prestige ~ income, data = Prestige)
dataEllipse(prestige ~ education, data = Prestige)
par(op)


