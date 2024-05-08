load(here::here("data", "coffee.RData"))

library(car)

scatterplotMatrix(~ Heart + Coffee + Stress, data=coffee,
                  smooth = FALSE,
                  pch = 16, col = "brown",
                  ellipse = list(levels = 0.68, fill.alpha = 0.1))

plot(Heart ~ Coffee, data=coffee)
text(coffee$Coffee, coffee$Heart, label = coffee$Group, cex = 0.5)

dataEllipse(Stress ~ Coffee, data = coffee,
            pch = 16,
            levels = 0.68,
            center.cex = 2,
            fill = TRUE, fill.alpha = 0.1)
abline(lm(Stress ~ Coffee, data = coffee), lwd = 2)
text(21, 180, "Data space", cex = 2, pos = 4)

coffee.mod <- lm(Heart ~ Coffee + Stress, data=coffee)

confidenceEllipses(coffee.mod)

confidenceEllipse(coffee.mod, 
                  grid = FALSE,
                  xlim = c(-2, 1), ylim = c(-0.5, 2.5))
confidenceEllipse(coffee.mod, add=TRUE, draw = TRUE,
                  Scheffe = TRUE)
abline(h = 0, v = 0)
