#library(car) # for the example data
# data(Duncan) # example data
# m1 = lm(prestige ~ income + education + type, data=Duncan)
# library(arm) # for coefplot()
# coefplot(m1, vertical=FALSE, mar=c(5.5,2.5,2,2))
# coefplot(m1, mar=c(5.5,2.5,2,2))


library("car") 
data(Prestige, package = "carData")
Prestige$type <- factor(Prestige$type, levels=c("bc", "wc", "prof")) # reorder levels
head(Prestige)

# prex_rtf()


# ggplotColours <- function(n = 6, h = c(0, 360) + 15){
#   if ((diff(h) %% 360) < 1) h[2] <- h[2] - 360/n
#   hcl(h = (seq(h[1], h[2], length = n)), c = 100, l = 65)
# }

# car: fancy scatterplots


scatterplot(prestige ~ income, data=Prestige,
  pch = 16, cex.lab = 1.25,
  regLine = list(col = "red", lwd=3),
  smooth = list(smoother=loessLine, 
                lty.smooth = 1, lwd.smooth=3,
                col.smooth = "darkgreen", col.var = "darkgreen"),
  ellipse = list(levels = 0.68),
  id = list(n=4, method = "mahal", col="black", cex=1.2))

# what would log(income) look like
scatterplot(prestige ~ income, data=Prestige, 
  log = "x",
  pch = 16,  cex.lab = 1.25,
  regLine = list(col = "red", lwd=3),
  smooth = list(smoother=loessLine,
                lty.smooth = 1, lwd.smooth=3,
                col.smooth = "darkgreen", col.var = "darkgreen"),
  ellipse = list(levels = 0.68), 
  id = list(n=4, method = "mahal", col="black", cex=1.2))

# slopes for linear and log income
coef(lm(prestige ~ income, data=Prestige))
1000 * coef(lm(prestige ~ income, data=Prestige))[2]

coef(lm(prestige ~ log(income), data=Prestige))[2]
exp(coef(lm(prestige ~ log(income), data=Prestige))[2])
exp(10*coef(lm(prestige ~ log(income), data=Prestige))[2])


# stratify by type
scatterplot(prestige ~ income | type, data=Prestige,
  col = c("blue", "red", "darkgreen"),
  pch = 15:17,
  grid = FALSE,
  legend = list(coords="bottomright"),
  regLine = list(lwd=3),
  smooth=list(smoother=loessLine, 
              var=FALSE, lwd.smooth=2, lty.smooth=1))

# education
scatterplot(prestige ~ education, data=Prestige,
  pch = 16, cex.lab = 1.25,
  regLine = list(col = "red", lwd=3),
  smooth = list(smoother=loessLine, 
                lty.smooth = 1, lwd.smooth=3,
                col.smooth = "darkgreen", col.var = "darkgreen"),
  ellipse = list(levels = 0.68),
  id = list(n=4, method = "mahal", col="black", cex=1.2))

# identify by residuals
m <- lm(prestige ~ education, data=Prestige)
scatterplot(prestige ~ education, data=Prestige,
            pch = 16, cex.lab = 1.25,
            boxplots = FALSE,
            regLine = list(col = "red", lwd=3),
            smooth = list(smoother=loessLine,
                          lty.smooth = 1, col.smooth = "black", lwd.smooth=3,
                          col.var = "darkgreen"),
            ellipse = list(levels = 0.68),
            id = list(method = which(abs(rstandard(m))>2), col="black", cex=1.2))

# scatterplot matrices

pairs(~ prestige + education + income + women,
      data=Prestige)

scatterplotMatrix(~ prestige + education + income + women ,
                  data=Prestige,
                  regLine = list(method=lm, lty=1, lwd=2, col="black"),
                  smooth=list(smoother=loessLine, spread=FALSE,
                              lty.smooth=1, lwd.smooth=3, col.smooth="red"),
                  ellipse=list(levels=0.68, fill.alpha=0.1))

library(GGally)
ggpairs(Prestige, columns = c(4, 1:3))
my_plot <- function(data, mapping, ...){
  p <- ggplot(data = data, mapping = mapping) + 
    geom_point() + 
    geom_smooth(method=loess, fill="red", color="red", ...) +
    geom_smooth(method=lm, fill="blue", color="blue", ...)
  p
}
ggpairs(Prestige, columns = c(4, 1:3),
        lower = list(continuous = my_plot),
        upper = list(continuous = my_plot)
)


# simple model
data(Prestige, package="carData")
library(modelsummary)
library(dplyr)
mod0 <- lm(prestige ~ education + income + women,
           data=Prestige)
summary(mod0)


modelplot(mod0, coef_omit="Intercept", color="blue", size=1) +
  labs(title="Raw coefficients for mod0")

# plot model coefficients, but using standardized variables
Prestige_std <- Prestige %>%
  as_tibble() %>%
  mutate(across(where(is.numeric), scale))

mod0_std <- lm(prestige ~ education + women + income,
               data=Prestige_std)

modelplot(mod0_std, coef_omit="Intercept", color="blue", size=1) +
  labs(title="Standardized coefficients for mod0")

mod1_std<- lm(prestige ~ education + women + income*type, 
              data=Prestige_std)

modelplot(list("mod0" = mod0_std, "mod1" = mod1_std), 
          coef_omit="Intercept", size=1.3) +
  labs(title="Standardized coefficients") +
  geom_vline(xintercept = 0, size=1.5) +
  scale_y_discrete(limits=rev) +
  theme_bw(base_size = 16) +
  theme(legend.position = c(0.9, 0.2))



# basic all main effects model
mod0 <- lm(prestige ~ education + income + women + type,
           data=Prestige)

summary(mod0)

# log2 coefficient
mod_log <- lm(prestige ~ log2(income), data=Prestige)
summary(mod_log)
options(digits=3)
coef(mod_log)


# mod1 <- lm(prestige ~ education + poly(women, 2) +
#                      log(income)*type, data=Prestige)
# use only linear in women
mod1 <- lm(prestige ~ education + women +
             log(income)*type, data=Prestige)

# coefficients


summary(mod1)


arm::coefplot(mod0, col.pts="red", cex.pts=1.5)
arm::coefplot(mod1, add=TRUE, col.pts="blue", cex.pts=1.5)



anova(mod0, mod1)

# effect plots
             
library("effects")
mod1.e1 <- predictorEffect("education", mod1)
plot(mod1.e1)

# mod1.e1 <- predictorEffect("education", mod1, partial.residuals=TRUE)
# plot(mod1.e1, residuals.pch=16, id=list(n=4, col="black"))

mod1.e1a <- predictorEffect("education", mod1, residuals=TRUE)
plot(mod1.e1a, 
     residuals.pch=16, id=list(n=4, col="black"))

#brief(mod1.e1$model.matrix)

# e1a.mod1 <- predictorEffect("education", mod1, focal.levels=5)
# e1a.mod1
# #summary(e1a.mod1)
# as.data.frame(e1a.mod1)

# mod1.e2 <- predictorEffect("women", mod1)
# plot(mod1.e2, ylim=c(30, 70))

mod1.e2 <- predictorEffect("women", mod1, residuals=TRUE)
plot(mod1.e2, ylim=c(40, 65), lwd=4,
     residuals.pch=16)



## -----------------------------------------------------------------------------
e2.mod1 <- predictorEffect("income", mod1, focal.levels=5)
as.data.frame(e2.mod1)

plot(predictorEffect("income", mod1),
     lines=list(multiline=TRUE, lwd=3),
     key.args = list(x=.7, y=.35),
    )

## ----fig13,include=TRUE,fig.width=5,fig.height=5,fig.show='hide'--------------
plot(predictorEffect("type", mod1), lines=list(multiline=TRUE))

## ----fig14,include=TRUE,fig.width=7,fig.height=8,fig.show='hide'--------------
eall.mod1 <- predictorEffects(mod1)
plot(eall.mod1)

plot(allEffects(mod1))

## ----eval=FALSE---------------------------------------------------------------
#  plot(eall.mod1)
#  plot(predictorEffects(lm1))
#  plot(predictorEffects(lm1, ~ income + education + women + type))

# Diagnostic plots

setwd("C:/Users/friendly/Dropbox/Documents/SCS/VisMLM-course/fig")
png(file="prestige-plot4.png", height=550, width=680, units = "px")
op <- par(mfrow=c(2,2))
plot(mod1, lwd=2, cex.lab=1.4)
par(op)
dev.off()

# better plots from car

qqPlot(~ income, data=Prestige, subset = type == "prof")
qqPlot(income ~ type, data=Prestige, layout=c(1, 3))

qqPlot(mod1, pch=16)


png(file="prestige-influence.png", height=550, width=680, units = "px")
car::influencePlot(mod1, id=list(n=2, cex=1.4), cex.lab=1.4)
dev.off()


boxCox(mod1)

boxTidwell(prestige ~ income + education, 
           other.x = ~ type + poly(women, 2), data=Prestige)



