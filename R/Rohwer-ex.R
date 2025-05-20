library(heplots)
library(broom)
library(car)

data(Rohwer, package = "heplots")
set.seed(42)
Rohwer |> dplyr::sample_n(6)

# MANCOVA, assuming equal slopes
Rohwer.mod1 <- lm(cbind(SAT, PPVT, Raven) ~ SES + n + s + ns + na + ss, 
                 data=Rohwer)
Anova(Rohwer.mod1)

glance(Rohwer.mod1)

coefplot(Rohwer.mod1, parm = 2:6,
         fill = TRUE,
         level = 0.68,
         cex.lab = 1.5)

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

