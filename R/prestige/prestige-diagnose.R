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
mod0 <- lm(prestige ~ education + income + women + type,
           data=Prestige)

#' ## The standard diagnostic plot (the _regression quartet_)
#' Simply plot the model object

#+ plot_model, fig.height=8
op <- par(mfrow = c(2,2), mar=c(4,4,3,1)+.1)
plot(mod0)
par(op)

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

  

#' The default plot gives an array of six nicely done diagnostic plots
#+ check_model, fig.height=8, fig.width=8
check_model(mod0)

# can specify `check="all"`, or a subset of these:
check <- c("vif", "qq", "normality", "linearity", "ncv", "homogeneity", "outliers")

check_model(mod0, check=c("normality", "linearity", "ncv", "homogeneity", "outliers"))

#' detrended QQ plots are often better
#' 
check_model(mod0, check="qq", detrend=TRUE)

#' ## Model reports
if(!require(report)) install.packages("report")
library(report)
report(mod0)


#' ## `model_dashboard()`
#' `easystats::model_dashboard()` gives a comprehensive report, constructed with the `report` package
#' Not run here because it generates a separate HTML file.

# model_dashboard(mod0, 
#                 output_file = "prestige-dashboard.html",
#                 output_dir = "examples")

