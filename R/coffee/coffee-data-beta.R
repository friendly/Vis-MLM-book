load(here::here("data", "coffee.RData"))

library(car)
library(dplyr)

scatterplotMatrix(~ Heart + Coffee + Stress, data=coffee,
                  smooth = FALSE,
                  pch = 16, col = "brown",
                  ellipse = list(levels = 0.68, fill.alpha = 0.1))

plot(Heart ~ Coffee, data=coffee)
text(coffee$Coffee, coffee$Heart, label = coffee$Group, cex = 0.5)

## Coffee-stress data space
png("images/coffee-data-beta0.png", width = 560, height = 560, res = 120)
op <- par(mar=c(4,4,1,1)+0.1)
dataEllipse(Stress ~ Coffee, data = coffee,
            pch = 16,
            levels = 0.68,
            center.cex = 2, cex.lab = 1.5,
            fill = TRUE, fill.alpha = 0.1)
abline(lm(Stress ~ Coffee, data = coffee), lwd = 2)
text(21, 180, "Data space", cex = 2, pos = 4)
par(op)
dev.off()

# try the same, but with 40, 68 % ellipses

png("images/coffee-data-beta1.png", width = 560, height = 560, res = 120)
op <- par(mar=c(4,4,1,1)+0.1)
dataEllipse(Stress ~ Coffee, data = coffee,
            pch = 16,
            levels = 0.68,
            ellipse.label = 0.68,
            center.cex = 2, cex.lab = 1.5,
            fill = FALSE,
            xlim = c(0, 160),
            ylim = c(0, 200))
dataEllipse(Stress ~ Coffee, data = coffee,
            levels = 0.40,
            ellipse.label = 0.40,
            fill = TRUE, fill.alpha = 0.1,
            col = "red", add = TRUE, plot.points = FALSE)

stats <- coffee |> 
  tidyr::pivot_longer(Coffee:Stress, names_to = "variable") |>
  select(-Group, -Heart) |>
  group_by(variable) |>
  summarise(mean = mean(value), sd = sd(value), 
            lower = mean - sd,
            upper = mean + sd
            ) 
CI <- stats[, c("lower", "upper")]
lines( y = c(10,10), x = CI[1,] , lwd = 6, col = 'red')
lines( x = c( 0, 0), y = CI[2,] , lwd = 6, col = 'red')
points(y = 10, x = stats[1, "mean"], col = 'black', pch = 16, cex=1.8)
points(x =  0, y = stats[2, "mean"], col = 'black', pch = 16, cex=1.8)

abline(lm(Stress ~ Coffee, data = coffee), lwd = 2)
text(0, 180, "Data space", cex = 2, pos = 4)
par(op)
dev.off()



coffee.mod <- lm(Heart ~ Coffee + Stress, data=coffee)
Anova(coffee.mod)
broom::tidy(coffee.mod)

#confidenceEllipses(coffee.mod)

png("images/coffee-data-beta2.png", width = 560, height = 560, res = 120)
op <- par(mar=c(4,5,1,1)+0.1)
confidenceEllipse(coffee.mod, 
    grid = FALSE,
    xlim = c(-2, 1), ylim = c(-0.5, 2.5),
    xlab = expression(paste("Coffee coefficient,  ", beta["Coffee"])),
    ylab = expression(paste("Stress coefficient,  ", beta["Stress"])),
    cex.lab = 1.5)
confidenceEllipse(coffee.mod, add=TRUE, draw = TRUE,
    col = "red", fill = TRUE, fill.alpha = 0.1,
    dfn = 1)
abline(h = 0, v = 0, lwd = 2)

# confidence intervals
beta <- coef( coffee.mod )[-1]
CI <- confint(coffee.mod)
lines( y = c(0,0), x = CI["Coffee",] , lwd = 6, col = 'red')
lines( x = c(0,0), y = CI["Stress",] , lwd = 6, col = 'red')
points( diag( beta ), col = 'black', pch = 16, cex=1.8)

abline(v = CI["Coffee",], col = "red", lty = 2)
abline(h = CI["Stress",], col = "red", lty = 2)

text(-2.1, 2.35, "Beta space", cex=2, pos = 4)
arrows(beta[1], beta[2], beta[1], 0, angle=8, len=0.2)
arrows(beta[1], beta[2], 0, beta[2], angle=8, len=0.2)

text( -1.5, 1.85, "df = 2", col = 'blue', adj = 0, cex=1.2)
text( 0.2, .85, "df = 1", col = 'red', adj = 0, cex=1.2)

heplots::mark.H0(col = "darkgreen", pch = "+", lty = 0, pos = 4, cex = 3)
par(op)
dev.off()

# see conditional relation in avPlots
avPlots(coffee.mod,
        ellipse = list(levels = 0.68, fill=TRUE, fill.alpha = 0.1),
        cex.lab = 1.5,
        pch = 19,
        main = "Added-variable plots for coffee.mod")




