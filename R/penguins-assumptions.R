---
  #' title: penguins data -- checking multivariate assumptions
---

library(here)
library(dplyr)
library(ggplot2)
library(car)
#library(effects)
library(heplots)
library(rstatix)
library(ggpubr)

load(here("data", "peng.RData"))

peng.mlm <- lm(cbind(bill_length, bill_depth, flipper_length, body_mass) ~ 
                 sex + species, data=peng)
Anova(peng.mlm)

#' ## univariate homogeneity of variance: levine tests

#' `heplots::leveneTests()` performs the univariate Levene test for each response
#' variable
#' 
options(digits=4)
heplots::leveneTests(peng[,3:6], group=peng$species)

#' `rstatix::levene_test()` does the same, but need some `tidyr` magic to do it for
#' each variable
peng |>
  tidyr::gather(key = "Measure", value = "Size", bill_length:body_mass) |>
  group_by(Measure) |>
  rstatix::levene_test(Size ~ species)


#' ## Homogenerity of covariances (Box's M test)
#' 
res <- heplots::boxM(peng[,3:6], group = peng$species)
res

plot(res)

#' ## Visual check: plot covariance ellipses
#' Use `variables=1:4` to get all pairwise plots
#' 
heplots::covEllipses(peng[,3:6], group = peng$species, 
                     variables=1:4,
                     fill=TRUE, fill.alpha=0.1,
                     pooled=FALSE,
                     col = c("red", "blue", "darkgreen"),
                     var.cex = 2.5)

#' More sensitive comparison: center the responses at the grand means
#' 
heplots::covEllipses(peng[,3:6], group = peng$species, 
                     variables=1:4,
                     center=TRUE,
                     fill=TRUE, fill.alpha=0.1,
                     pooled=FALSE,
                     col = c("red", "blue", "darkgreen"),
                     var.cex = 2.5)




#' ## Check for multivariate outliers

peng |>
  group_by(species) |>
  rstatix::mahalanobis_distance(bill_length:body_mass) |>
  select(-year) |>
  tibble::rownames_to_column() |>
  mutate(across(bill_length:body_mass, .fns= scale)) |>
  filter(is.outlier == TRUE) |>
#  filter(mahal.dist > 12) |>
  as.data.frame() 

op <- par(mar = c(4, 4, 2, 1) + .1)
heplots::cqplot(peng.mlm, id.n = 3, conf=0.999,
                main="Chi-Square QQ plot of residuals from peng.mlm")
par(op)

#' One plot for each species
op <- par(mfrow = c(1,3))
heplots::cqplot(subset(peng[,3:6], peng$species == "Adelie"), 
                id.n = 3,
                main = "CQ plot for Adelie")
heplots::cqplot(subset(peng[,3:6], peng$species == "Chinstrap"), 
                id.n = 3,
                main = "CQ plot for Chinstrap")
heplots::cqplot(subset(peng[,3:6], peng$species == "Gentoo"), 
                id.n = 3,
                main = "CQ plot for Gentoo")
par(op)

#' Actually, multivariate normality applies only for the residuals in the model
#' But this is the same as plotting the MLM

resids <- residuals(peng.mlm)
heplots::cqplot(resids, id.n=3)


#' ## Check univariate normality (Shapiro-Wilks test)

peng |>
  group_by(species) |>
  shapiro_test(bill_length : body_mass) |>
  arrange(variable) |>
  filter(p < 0.10)

#' ## Check multivariate normality 
#' 
peng |>
  select(bill_length : body_mass) |>
  rstatix::mshapiro_test()


library(MVN)

op <- par(mfrow=c(2,2))
res <- mvn(data = peng[,c(1,3:6)], subset="species",
          mvnTest = "mardia",
          multivariatePlot = "qq",
          showOutliers = TRUE)
par(op)

res <- MVN::mvn(data = peng[,c(3:6)], mvnTest="mardia")
res$multivariateNormality

### Univariate Normality Result
res$univariateNormality



