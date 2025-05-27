library(heplots)
library(broom)
library(car)
library(dplyr)
library(purrr)

data(Rohwer, package = "heplots")
# Make SES == 'Lo' the reference category
Rohwer$SES <- relevel(Rohwer$SES, ref = "Lo")

set.seed(42)
Rohwer |> dplyr::sample_n(6)

# MANCOVA, assuming equal slopes
Rohwer.mod1 <- lm(cbind(SAT, PPVT, Raven) ~ SES + n + s + ns + na + ss, 
                 data=Rohwer)
Anova(Rohwer.mod1)

heplots::uniStats(Rohwer.mod1)
#glance(Rohwer.mod1) |> select(response, r.squared)

op <- par(mar = c(4,4,1,1)+.1, mfrow = c(1,2))
coefplot(Rohwer.mod1, parm = 2:6,
         fill = TRUE,
         level = 0.68,
         cex.lab = 1.5)
coefplot(Rohwer.mod1, parm = 2:6, variables = c(1,3),
         fill = TRUE,
         level = 0.68,
         cex.lab = 1.5)
par(op)

# Compare observed mean diff with adjusted
means <- Rohwer |>
  group_by(SES) |>
  summarise_all(mean) |>
  print()

means[2, 3:5] - means[1, 3:5]  

# adjusted means
coef(Rohwer.mod1)[2,]

library(lmtest)
ct <- coeftest(Rohwer.mod1) 
broom::tidy(ct)

confint(ct, parm = c(2,9,12))
confint(ct, parm = rownames(ct) %>% grep("SES", .))



#coefplot(mod1, lwd=2, fill=TRUE, parm=(1:5),
#' 	main="Bivariate 68% coefficient plot for SAT and PPVT", level=0.68)


# test the joint effects of the PA tasks
covariates  <- c("n", "s", "ns", "na", "ss")
# or: covariates <- rownames(coef(Rohwer.mod1))[-(1:2)]

linearHypothesis(Rohwer.mod1, covariates, title = "All PA tasks") |>
  print(SSP = FALSE)

# Testing homogeneity of regression
Rohwer.mod2 <- lm(cbind(SAT, PPVT, Raven) ~ SES * (n + s + ns + na + ss),
                  data=Rohwer)
Anova(Rohwer.mod2)

# test interaction terms jointly
coefs <- rownames(coef(Rohwer.mod2)) 
interactions <- coefs[grep(":", coefs)]

print(linearHypothesis(rohwer.mod2, interactions), SSP=FALSE)

colors <- c("red", "blue", rep("black",5), "#969696")
(coefs <- rownames(coef(Rohwer.mod2)))
heplot(Rohwer.mod2, col=c(colors, "darkgreen"), 
       terms=c("SES", "n", "s", "ns", "na", "ss"), 
       hypotheses=list("Regr" = c("n", "s", "ns", "na", "ss"),
                       "Slopes" = coefs[grep(":", coefs)]),
       fill = TRUE, fill.alpha = 0.2)

# separate models

Rohwer.sesLo <- lm(cbind(SAT, PPVT, Raven) ~ n + s + ns + na + ss, 
                   data=Rohwer, subset = SES=="Lo")
Rohwer.sesHi <- lm(cbind(SAT, PPVT, Raven) ~ n + s + ns + na + ss, 
                   data=Rohwer, subset = SES=="Hi")

Anova(Rohwer.sesHi)
Anova(Rohwer.sesLo)

glance(Rohwer.sesHi)
glance(Rohwer.sesLo)


# use nested data?
Rohwer |>
  nest_by(SES) |>
  mutate(model = map(data, function(df) lm(cbind(SAT, PPVT, Raven) ~ n + s + ns + na + ss), data=df))

# HE plots -- separate groups


# sesLo first
heplot(Rohwer.sesLo, 
       xlim = c(0,100),                # adjust axis limits
       ylim = c(40,110), 
       col=c("red", "black"), 
       fill = TRUE, fill.alpha = 0.1,
       lwd=2, cex=1.2, cex.lab = 1.5)
heplot(Rohwer.sesHi, 
       add=TRUE, 
       col=c("brown", "black"), 
       grand.mean=TRUE, 
       error.ellipse=TRUE,              # not shown by default when add=TRUE
       fill = TRUE, fill.alpha = 0.1,
       lwd=2, cex=1.2)


# MANCOVA model

op <- par(mar = c(4,4,4,1) + .1, mfrow = c(1,2))
colors <- c("red", "blue", rep("black",5), "#969696")
heplot(Rohwer.mod1, 
       col=colors, variables=c(1,2),
       hypotheses=list("Regr" = covariates),
       fill = TRUE, fill.alpha = 0.1,
       cex=1.5, cex.lab = 1.5,
       lwd=c(2, rep(3,5), 4),
       main="Rohwer MANCOVA model")

heplot(Rohwer.mod1, 
       col=colors,  variables=c(1,3),
       hypotheses=list("Regr" = covariates),
       fill = TRUE, fill.alpha = 0.1,
       cex=1.5, cex.lab = 1.5,
       lwd=c(2, rep(3,5), 4),
       main="Rohwer MANCOVA model")
par(op)

pairs(Rohwer.mod1, 
       col=colors,
       hypotheses=list("Regr" = covariates),
       fill = TRUE, fill.alpha = 0.1,
       cex=1.5, cex.lab = 1.5, var.cex = 3,
       lwd=c(2, rep(3,5), 4))


# All interactions model

op <- par(mar = c(4,4,4,1) + .1, mfrow = c(1,2))
colors <- c("red", "blue", rep("black",5), "#969696")
heplot(Rohwer.mod2, 
       col=colors, variables=c(1,2),
       hypotheses=list("Regr" = covariates),
       fill = TRUE, fill.alpha = 0.1,
       cex=1.5, cex.lab = 1.5,
       lwd=c(2, rep(3,5), 4),
       main="Heterogeneous regressions model")

heplot(Rohwer.mod2, 
       col=colors,  variables=c(1,3),
       hypotheses=list("Regr" = covariates),
       fill = TRUE, fill.alpha = 0.1,
       cex=1.5, cex.lab = 1.5,
       lwd=c(2, rep(3,5), 4),
       main="Heterogeneous regressions model")
par(op)

pairs(Rohwer.mod2, 
      col=colors,
      hypotheses=list("Regr" = covariates),
      fill = TRUE, fill.alpha = 0.1,
      cex=1.5, cex.lab = 1.5,
      lwd=c(2, rep(3,5), 4))

library(equatiomatic)

extract_eq(Rohwer.mod2)

extract_eq(Rohwer.sesLo)
extract_eq(Rohwer.sesHi)


