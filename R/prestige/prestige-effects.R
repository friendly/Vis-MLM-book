#' ---
#' title: Effect plots for Prestige data
#' ---

library("car")
library("effects")  # effect plots
library(dplyr)
data(Prestige, package="carData")

#Prestige$type <- ordered(Prestige$type, levels=c("bc", "wc", "prof")) # make ordered factor
Prestige$type <- factor(Prestige$type, levels=c("bc", "wc", "prof")) #  just reorder levels

prestige.mod2 <- lm(prestige ~ education + women +
                    log(income)*type, data=Prestige)
summary(prestige.mod2)


plot(allEffects(prestige.mod2))

#' Effect of `education` averaged over others
mod2.eff1 <- predictorEffect("education", prestige.mod2)
plot(mod2.eff1)

#' Effect of `education`, but showing partial residuals. In some cases, this will help spot influential cases
#' in the partial relation of a predictor to the response.

predictorEffects(prestige.mod2, ~ education,
                 residuals = TRUE) |>
  plot(partial.residuals = list(pch = 16, col="blue"),
       id=list(n=4, col="black"),
       axes = list(x = list(cex=1)))



#plot(predictorEffect("women", prestige.mod2))

predictorEffects(prestige.mod2, ~ women,
                 residuals = TRUE) |>
  plot(partial.residuals = list(pch = 16, col="blue"),
       id=list(n=4, col="black"))


#' Effect of `income` (by `type`) averaged over others

plot(predictorEffect("income", prestige.mod2, 
                     confidence.level = 0.68),
     lines=list(multiline=TRUE, lwd=3),
     confint=list(style="bands"),
     key.args = list(x=.7, y=.35))

plot(predictorEffects(prestige.mod2, ~ income,
                     confidence.level = 0.68),
     lines=list(multiline=TRUE, lwd=3),
     confint=list(style="bands"),
     key.args = list(x=.7, y=.35))



plot(predictorEffects(prestige.mod2, ~ type,
                      confidence.level = 0.68), 
     lines=list(multiline=TRUE),
     axes=list(grid=TRUE),
     confint=list(style="bars"))

# try quadratic in women
prestige.mod3 <- lm(prestige ~ education + poly(women,2) +
                      log(income)*type, data=Prestige)
Anova(prestige.mod3)

plot(predictorEffects(prestige.mod3, ~women,
                      residuals = TRUE))


# try marginaleffects

library(marginaleffects)

pred <- predictions(prestige.mod3)
plot_predictions(prestige.mod3, condition = "education", points = .4)
plot_predictions(prestige.mod3, condition = "income", points = .4)
plot_predictions(prestige.mod3, condition = "women")

# something wrong with points here
plot_predictions(prestige.mod3, condition = c("income", "type"), points = .4)




