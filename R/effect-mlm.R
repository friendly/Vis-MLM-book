#' ---
#' title: Effect plots for MLMs
#' ---

#' Effect.mlm creates the data structures for  effect plots of each response variable
#' in an MLM. Where/how to illustrate this?
#' 
#' Problems: Hard to control graphic attributes, e.g., make CI lines thicker

library(effects)

data(Rohwer, package = "heplots")

Rohwer.mod <- lm(cbind(SAT, PPVT, Raven) ~ SES + n + s + ns + na + ss, 
                 data=Rohwer)

Rohwer.eff <- allEffects(Rohwer.mod)

plot(Rohwer.eff)

op <- par(lwd=3)
plot(predictorEffect("SES", Rohwer.mod), 
     confint = list(lwd = 2),
     rows=1)
par(op)

#' ## Two-way MANOVA
#' 
data(MockJury, package = "heplots")

jury.mod0 <- lm(cbind(Serious, Years) ~ Attr + Crime, data=MockJury)

jury.eff <- allEffects(jury.mod0)
plot(jury.eff)

jury.mod <- lm(cbind(Serious, Years) ~ Attr * Crime, data=MockJury)

jury.eff <- allEffects(jury.mod,
                       confint = list(level = 0.68))
plot(jury.eff)

