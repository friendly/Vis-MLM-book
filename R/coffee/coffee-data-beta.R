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
            center.cex = 2, cex.lab = 1.5,
            fill = TRUE, fill.alpha = 0.1)
abline(lm(Stress ~ Coffee, data = coffee), lwd = 2)
text(21, 180, "Data space", cex = 2, pos = 4)

coffee.mod <- lm(Heart ~ Coffee + Stress, data=coffee)
Anova(coffee.mod)
broom::tidy(coffee.mod)

#confidenceEllipses(coffee.mod)

confidenceEllipse(coffee.mod, Scheffe = TRUE,
                  grid = FALSE,
                  xlim = c(-2, 1), ylim = c(-0.5, 2.5))
confidenceEllipse(coffee.mod, add=TRUE, draw = TRUE,
                  Scheffe = TRUE)
abline(h = 0, v = 0)

beta <- coef( coffee.mod )[-1]
lines( y = c(0,0), x = confint(coffee.mod)["Coffee",] , lwd = 6, col = 'red')
lines( x = c(0,0), y = confint(coffee.mod)["Stress",] , lwd = 6, col = 'red')
points( diag( beta ), col = 'black', pch = 16, cex=1.8)

text(-2, 2.25, "Beta space", cex=1.5, pos = 4)
