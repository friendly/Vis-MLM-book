---
  #' title: penguins data -- checking multivariate assumptions
---

library(here)
library(dplyr)
library(tidyr)
library(ggplot2)
library(car)
#library(effects)
library(heplots)
library(rstatix)
library(ggpubr)

#load(here("data", "peng.RData"))
data(peng, package = "heplots")
source("R/penguin/penguin-colors.R")
col <- peng.colors("dark")

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
cqplot(peng.mlm, id.n = 3, conf=0.95,
       main="Chi-Square QQ plot of residuals from peng.mlm")
par(op)

# color the points by species
op <- par(mar = c(5,4, 3, 1)+.1)
ids <- cqplot(peng.mlm, id.n = 3 , conf=0.95,
       col = col[peng$species], 
       cex = 1.3, id.cex = 1.4,
       main="Chi-Square QQ plot of residuals from peng.mlm")

# detrend
cqplot(peng.mlm, id.n = 3 , conf=0.95, detrend = TRUE,
       col = col[peng$species], 
       cex = 1.3, id.cex = 1.4,
       main="Chi-Square QQ plot of residuals from peng.mlm",
       ylim = c(-6, 20))
par(op)


# which points are outliers?
#out <- c(10, 179, 283)
out <- rownames(ids)
outliers <- peng[out,] |>
#  tibble::rownames_to_column() |>
  mutate(across(bill_length:body_mass,  ~ scale(.)[,1])) |>     # scale w/in group?
  bind_cols(id = rownames(ids)) |>
  bind_cols(ids) |>
  rename(BL = bill_length, BD = bill_depth, FL = flipper_length, BM = body_mass) |>
  relocate(id:quantile)

outliers

# show outliers in plots
peng.dsq <- peng |>
  tibble::rownames_to_column(var = "id") |>
  mutate(DSQ = Mahalanobis(residuals(peng.mlm)),
         pvalue = pchisq(DSQ, df=4, lower.tail = FALSE)) 

peng.dsq |>
  ggplot(aes(x = bill_length, y = bill_depth,
           color = species, shape = species, fill=species)) +
  geom_point(size=1.7) +
  geom_smooth(method = "lm", formula = y ~ x,
              se=FALSE, linewidth=1.2) +
  stat_ellipse(geom = "polygon", level = 0.95, alpha = 0.2) +
  geom_label(aes(label = id),
             fill = "white",
            nudge_y = 0.3,
            data = subset(peng.dsq, pvalue < 0.005)) +
  theme_penguins +
  theme(legend.position = "inside",
        legend.position.inside=c(0.85, 0.15))

peng.dsq |>
  ggplot(aes(x = bill_length, y = flipper_length,
             color = species, shape = species, fill=species)) +
  geom_point(size=1.7) +
  geom_smooth(method = "lm", formula = y ~ x,
              se=FALSE, linewidth=1.2) +
  stat_ellipse(geom = "polygon", level = 0.95, alpha = 0.2) +
  geom_label(aes(label = id), 
             fill = scales::alpha("white", 0.2),
             nudge_y = 1.5,
             data = subset(peng.dsq, pvalue < 0.005)) +
  theme_penguins +
  theme(legend.position = "inside",
        legend.position.inside=c(0.05, 0.85))




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
ids <- heplots::cqplot(resids, id.n=3)

# Try qqtest
library(qqtest)
qqtest(resids, dist = "chi-squared", df = 4)



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



