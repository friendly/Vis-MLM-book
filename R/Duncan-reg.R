#' ---
#' title: Duncan data, regression diagnostics
#' ---
#' 

library(car)

data(Duncan, package = "carData")
car::some(Duncan)

duncan.mod <- lm(prestige ~ income + education, data=Duncan)
Anova(duncan.mod)

parameters::model_parameters(duncan.mod)

linearHypothesis(duncan.mod, "income = education")


duncan.mod1 <- lm(prestige ~ income + education + type, data=Duncan)
Anova(duncan.mod1)

#glimpse(duncan.mod, duncan.mod1)

anova(duncan.mod, duncan.mod1)

# regression quartet

op <- par(mfrow = c(2,2), 
          mar = c(4,4,3,1)+.1)
plot(duncan.mod, lwd=2, pch=16)
par(op)

op <- par(mfrow = c(2,2), 
          mar = c(4,4,3,1)+.1)
plot(duncan.mod1, lwd=2, pch=16)
par(op)


# car versions
residualPlots(duncan.mod, layout = c(1,3), 
              id=list(n=3), 
              lwd=2)

spreadLevelPlot(duncan.mod, 
                id = list(n=2, location = "lr"),
                lwd=3
                )

qqPlot(duncan.mod, id = list(n=3))

# influence plot
inf <- influencePlot(duncan.mod, id = list(n=3))

# which are influential?
#cbind(Duncan[row.names(Duncan) %in% rownames(inf),], inf)

merge(Duncan, inf, by="row.names", all.x = FALSE)

#' Coefficient plots
#' 

#' ## Confidence ellipse

confidenceEllipse(duncan.mod, col = "blue",
                  levels = 0.95,
                  fill = TRUE, fill.alpha = 0.2,
                  xlim = c(0,1),
                  ylim = c(0,1), asp = 1)
confidenceEllipse(duncan.mod, col = "darkgreen",
                  levels = 0.68,
                  fill = TRUE, fill.alpha = 0.2,
                  add = TRUE
                  )

abline(h=0, v=0, lwd = 2)
coefs <- lmtest::coeftest(duncan.mod)
b <- coefs[2:3, 1]
se <- coefs[2:3, 2]
segments(b[1] - (1:2)*se[1], c(0.025, 0), 
         b[1] + (1:2)*se[1], c(0.025, 0), lwd=c(8, 5), col = c("darkgreen", "blue"))
segments(c(0.025, 0), b[2] - (1:2)*se[2],
         c(0.025, 0), b[2] + (1:2)*se[2], lwd=c(8, 5), col = c("darkgreen", "blue"))

# add line for equal slopes
abline(a=0, b = 1)
text(0.2, 0.2, expression(beta[1] == beta[2]), srt=45, pos=3)

#------------------------------------------
# use performance check_model()
# see: 
library(performance)
library(parameters)

model_parameters(duncan.mod)

check_model(duncan.mod, check=c("linearity", "qq", "homogeneity", "outliers"))

check_model(duncan.mod1)

# return a list of single plots that can be plotted individually
diagnostic_plots <- plot(check_model(duncan.mod, panel = FALSE))



