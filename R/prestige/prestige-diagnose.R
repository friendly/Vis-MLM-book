#' ---
#' title: "Diagnostic plots for linear models"
#' author: "Michael Friendly"
#' date: "`r format(Sys.Date())`"
#' output:
#'   html_document:
#'     theme: readable
#'     code_download: true
#' ---

#+ echo=FALSE
knitr::opts_chunk$set(warning=FALSE, message=FALSE, R.options=list(digits=4))


#' ## Load data & fit a model for occupational prestige
data(Prestige, package="carData")
#' `type` is really an ordered factor. Make it so.
Prestige$type <- ordered(Prestige$type, levels=c("bc", "wc", "prof")) # reorder levels

#' Main effects model
prestige.mod <- lm(prestige ~ education + income + women + type,
           data=Prestige)

#' ## The standard diagnostic plot (the _regression quartet_)
#' Simply plot the model object

#+ plot_model, fig.height=8
op <- par(mfrow = c(2,2), mar=c(4,4,3,1)+.1)
plot(prestige.mod)
par(op)

# car::residual plots

car::residualPlots(prestige.mod, id = list(n=2), lwd = 2, fitted = FALSE)

#car::residualPlots(prestige.mod, id = list(n=2), fitted = FALSE, type = "rstandard")



#' ## `performance::check_model()` plots
#' Below, I use the `check_model` function from the `performance` package. This is part of the 
#' `easystats` collection of packages.  See: https://easystats.github.io/easystats/ for
#' an overview.
#' 
#' 
#' ### Install and load packages
#+ install, message=TRUE
if(!require(easystats)) install.packages("easystats")
library(easystats)
if(!require(performance)) install.packages("performance")   # also needs "see"
library(performance)
library(ggplot2)

  

#' The default plot gives an array of six nicely done diagnostic plots
#+ check_model, fig.height=8, fig.width=8
res <- check_model(presditge.mod)



# can specify `check="all"`, or a subset of these:
check <- c("vif", "qq", "normality", "linearity", "ncv", "homogeneity", "outliers")

check_model(presditge.mod, check=c("linearity", "qq", "homogeneity", "outliers"))

res <- 
#' detrended QQ plots are often better
#' 
check_model(presditge.mod, check="qq", detrend=TRUE)


# alternative residuals plot
d <- data.frame(
  Fitted = fitted(presditge.mod),
  StdResidual = rstandard(presditge.mod),
  AbsResidual = abs(rstandard(presditge.mod)),
  positive = as.factor(rstandard(presditge.mod) >= 0)
)

ggplot(d, aes(Fitted, StdResidual, color = positive, fill = positive)) +
  geom_point(size = 2) +
  geom_smooth(method = "lm", formula = y ~ x, alpha = 0.2) +
  geom_smooth(method = "loess", se=FALSE, linetype = 2) +
  theme_bw(base_size = 14) +
  theme(legend.position = "inside",
        legend.position.inside = c(.85, .85))

ggplot(d, aes(Fitted, AbsResidual, color = positive, fill = positive)) +
  geom_point() +
  geom_smooth(method = "lm", se = TRUE) +
  theme_bw(base_size = 14) +
  theme(legend.position = "inside",
        legend.position.inside = c(.85, .85))



#' ## Model reports
if(!require(report)) install.packages("report")
library(report)
report(presditge.mod)


#' ## `model_dashboard()`
#' `easystats::model_dashboard()` gives a comprehensive report, constructed with the `report` package
#' Not run here because it generates a separate HTML file.

# model_dashboard(presditge.mod, 
#                 output_file = "prestige-dashboard.html",
#                 output_dir = "examples")


