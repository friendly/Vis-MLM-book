# car::scatterplot side-by-side, using par()

library(car)
data(Prestige, package = "carData")

op <- par(mfrow = c(1,2))
scatterplot(prestige ~ income, data = Prestige,
            smooth = FALSE, boxplot = FALSE)
scatterplot(prestige ~ education, data = Prestige,
            smooth = FALSE, boxplot = FALSE)
par(op)


