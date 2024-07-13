#' ---
#' title: Effect plots for Prestige data
#' ---

library("car")
library(effects)  # effect plots
library(dplyr)
library(lattice)
library(marginaleffects)

data(Prestige, package="carData")

#Prestige$type <- ordered(Prestige$type, levels=c("bc", "wc", "prof")) # make ordered factor
Prestige$type <- factor(Prestige$type, levels=c("bc", "wc", "prof")) #  just reorder levels


prestige.mod1 <- lm(prestige ~ education + income + women, data=Prestige)

prestige.mod2 <- lm(prestige ~ education + women +
                    log10(income)*type, data=Prestige)
Anova(prestige.mod2)

# try quadratic in women
prestige.mod3 <- lm(prestige ~ education + poly(women,2) +
                      log10(income)*type, data=Prestige)

#Anova(prestige.mod3)

lmtest::coeftest(prestige.mod3)

# mechanics of effects

X <- expand.grid(
  education = seq(8, 16, 2),
  income = mean(Prestige$income),
  women = mean(Prestige$women)) |> print(digits = 3)

pred <- predict(prestige.mod1, newdata=X, se.fit = TRUE)
cbind(X, fit = pred$fit, se = pred$se.fit) |> print(digits=3)

# simpler with marginal effects
datagrid(education = seq(8, 16, 2),
        income = mean(Prestige$income),
        women = mean(Prestige$women))


predictions(prestige.mod1, newdata = X)

predictorEffect("education", prestige.mod1, 
                 focal.levels = seq(8, 16, 2)) |>
  as.data.frame()

Effect("education", prestige.mod2, 
                xlevels = list(education = seq(8, 16, 2,),
                               type = "wc")) |>
  as.data.frame()


# simplest plot
plot(allEffects(prestige.mod2))



#' Effect of `education` averaged over others
mod2.eff1 <- predictorEffect("education", prestige.mod2)
#as.data.frame(mod2.eff1)

plot(mod2.eff1)

#' Effect of `education`, but showing partial residuals. In some cases, this will help spot influential cases
#' in the partial relation of a predictor to the response.

lattice::trellis.par.get() |> names()

trellis.par.set(par.xlab.text=list(cex=1.5),
                par.ylab.text=list(cex=1.5))

predictorEffects(prestige.mod2, ~ education,
                 residuals = TRUE) |>
  plot(partial.residuals = list(pch = 16, col="blue"),
       id=list(n=4, col="black"))


#plot(predictorEffect("women", prestige.mod2))

predictorEffects(prestige.mod2, ~ women,
                 residuals = TRUE) |>
  plot(partial.residuals = list(pch = 16, col="blue"),
       id=list(n=4, col="black"))


#' Effect of `income` (by `type`) averaged over others


predictorEffects(prestige.mod2, ~ income,
                      confidence.level = 0.68) |>
  plot(lines=list(multiline=TRUE, lwd=3),
     confint=list(style="bands"),
     key.args = list(x=.7, y=.35))


predictorEffects(prestige.mod2, ~ type,
                      confidence.level = 0.68,
                      xlevels = 3) |>
  plot(lines=list(multiline=TRUE),
       confint=list(style="bars"), 
       symbols = list(cex = 1.5, pch = 16),
       key.args = list(space = "top", columns = 3))


##################################################
# try quadratic in women
prestige.mod3 <- lm(prestige ~ education + poly(women,2) +
                      log10(income)*type, data=Prestige)
Anova(prestige.mod3)


predictorEffects(prestige.mod3, ~ education,
                 residuals = TRUE,
                 confidence.level = 0.68) |>
  plot(partial.residuals = list(pch = 16, col="blue"),
       id=list(n=4, col="black")) 


predictorEffects(prestige.mod3, ~ income,
                 confidence.level = 0.68) |>
  plot(lines=list(multiline=TRUE, lwd=3),
       confint=list(style="bands"),
       key.args = list(x=.7, y=.35)) 

predictorEffects(prestige.mod3, ~women,
                 residuals = TRUE) |>
  plot(partial.residuals = list(pch = 16, col="blue", cex=0.8),
       id=list(n=4, col="black"))

predictorEffects(prestige.mod3, ~ type,
                 confidence.level = 0.68,
                 xlevels = 3) |>
  plot(lines=list(multiline=TRUE),
       confint=list(style="bars"), 
       symbols = list(cex = 1.5, pch = 16),
       key.args = list(space = "top", columns = 3))

# plot them together
predictorEffects(prestige.mod3, ~ education + women,
                 residuals = TRUE,
                 confidence.level = 0.68) |>
  plot(partial.residuals = list(pch = 16, col="blue"),
       id=list(n=4, col="black")) 




# try marginaleffects

library(marginaleffects)

plot_predictions(prestige.mod2, condition = "education", points = .4)

#pred <- predictions(prestige.mod3)
plot_predictions(prestige.mod3, condition = "education", points = .4)
plot_predictions(prestige.mod3, condition = "income", points = .4)
plot_predictions(prestige.mod3, condition = "women")

# something wrong with points here
plot_predictions(prestige.mod3, condition = c("income", "type"), points = .4)




