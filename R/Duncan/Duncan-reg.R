#' ---
#' title: Duncan data, regression diagnostics
#' ---
#' 

library(car)
library(dplyr)
library(performance)
library(parameters)

data(Duncan, package = "carData")
car::some(Duncan)

duncan.mod <- lm(prestige ~ income + education, data=Duncan)
Anova(duncan.mod)

parameters::model_parameters(duncan.mod)

hyp <- linearHypothesis(duncan.mod, "income = education") |> print()

# confidence interval
diff <- attr(hyp, "value")
se <- sqrt(attr(hyp, "vcov"))
c(diff - 1.96 * se, diff + 1.96 * se)

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
qqPlot(duncan.mod, id = list(n=3), simulate = TRUE)

# avPlots

avPlots(duncan.mod,
        ellipse = list(levels = 0.68, fill = TRUE, fill.alpha = 0.1),
        id = list(method = "mahal", n=3),
        pch = 16, cex = 0.9,
        cex.lab = 1.5)

# > Duncan[c(6, 9, 16, 27),]
# type income education prestige
# minister    prof     21        84       87
# reporter      wc     67        87       52
# conductor     wc     76        34       38
# RR.engineer   bc     81        28       67


avPlots(duncan.mod2,
        ellipse = list(levels = 0.68, fill = TRUE, fill.alpha = 0.1),
        id = list(method = "mahal", n=3),
        pch = 16, cex = 0.9,
        cex.lab = 1.5)



#' ## show the leverage of the unusual points

# delete minister, conductor
duncan.mod2 <- update(duncan.mod, 
                      subset = - whichNames(c("minister", "conductor"), Duncan))

par(mar = c(4, 5, 4, 1)+.1,
    mfrow = c(1,2))
res <- avPlot(duncan.mod, "income",
              ellipse = list(levels = 0.68),
              id = list(method = "mahal", n=3),
              pch = 16,
              cex.lab = 1.5) |>
  as.data.frame()
fit <- lm(prestige ~ income, data = res)
info <- cbind(res, fitted = fitted(fit), 
             resids = residuals(fit),
             hat = hatvalues(fit),
             cookd = cooks.distance(fit))

# noteworthy points in this plot
big <- which(info$cookd > .20)
with(info, {
  arrows(income[big], fitted[big], income[big], prestige[big], 
         angle = 12, length = .18, lwd = 2, col = "darkgreen")
  })

# line w/o the unusual points
bs <- coef(duncan.mod2)["income"]
abline(a=0, b=bs, col = "red", lwd=2)


# same for education
res <- avPlot(duncan.mod, "education",
              ellipse = list(levels = 0.68),
              id = list(method = "mahal", n=3),
              pch = 16,
              cex.lab = 1.5) |>
  as.data.frame()
fit <- lm(prestige ~ education, data = res)
info <- cbind(res, fitted = fitted(fit), 
             resids = residuals(fit),
             hat = hatvalues(fit),
             cookd = cooks.distance(fit))

big <- which(info$cookd > .2)
with(info, {
  arrows(education[big], fitted[big], education[big], prestige[big], 
         angle = 12, length = .18, lwd = 2, col = "darkgreen")
})

# line w/o the unusual points
bs <- coef(duncan.mod2)["education"]
abline(a=0, b=bs, col = "red", lwd=2)

par(op)



# influence plot
inf <- influencePlot(duncan.mod, id = list(n=3),
                     cex.lab = 1.5)

# which are influential?
merge(Duncan, inf, by="row.names", all.x = FALSE) |> print(digits=3)

#' Coefficient plots
#' 


#------------------------------------------
# use performance check_model()
# see: 

model_parameters(duncan.mod)

check_model(duncan.mod, check=c("linearity", "qq", "homogeneity", "outliers"))

check_model(duncan.mod1)



# return a list of single plots that can be plotted individually
diagnostic_plots <- plot(check_model(duncan.mod, panel = FALSE))

names(diagnostic_plots)
plot(diagnostic_plots[["OUTLIERS"]])
plot(diagnostic_plots[["NCV"]], dot_size = 3)

