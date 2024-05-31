#' ---
#' title: "Linear models example: Occupational Prestige data"
#' author: "Michael Friendly"
#' date: "`r format(Sys.Date())`"
#' output:
#'   html_document:
#'     theme: readable
#'     code_download: true
#' ---

#+ echo=FALSE
knitr::opts_chunk$set(warning=FALSE, message=FALSE, R.options=list(digits=4))

#' ## Load packages & Prestige data
#' 
#' The `car` and `effects` packages are the main workhorses here.

library("car")
library("effects")  # effect plots
library("arm")      # coefplots
data(Prestige, package="carData")

#' ## Reorder levels of `type` factor
#' 
#' Here it is useful to recognize that "bc" < "wc" < "prof". Do so by making `Prestige$type` an ordered factor.
#' Note that the occupation names are the `row.names` in the data.frame, not a separate variable.

Prestige$type <- ordered(Prestige$type, levels=c("bc", "wc", "prof")) # reorder levels
some(Prestige, 6)



#' ## scatterplotMatrix
#' 
#' Let's get a visual overview of the data in a scatterplot matrix. I use options to specify a
#' linear regression line (`regLine=`), a loess smoothed curve (`smooth=`) and 
#' a 68% (~ $\bar{y} \pm 1 sd$) data ellipse (`ellipse=`) in each panel.

#+ fig.width=7, fig.height=7
scatterplotMatrix(~ prestige + education + income + women ,
                  data=Prestige,
                  regLine = list(method=lm, lty=1, lwd=2, col="black"),
                  smooth=list(smoother=loessLine, spread=FALSE,
                              lty.smooth=1, lwd.smooth=3, col.smooth="red"),
                  ellipse=list(levels=0.68, fill.alpha=0.1))


#' ## Fancy scatterplots

#' `car::scatterplot` has many options to add informative annotations, label unusual points, etc.
#' This plot shows clearly that income is positively skewed and the relation with `prestige` is non-linear.
#' The `id =` argument allows to identify unusual observations with their labels

scatterplot(prestige ~ income, data=Prestige,
            pch = 16,
            regLine = list(col = "red", lwd=3),
            smooth = list(smoother=loessLine,
                          lty.smooth = 1, col.smooth = "black", lwd.smooth=3,
                          col.var = "darkgreen"),
            ellipse = list(levels = 0.68),
            id = list(n=4, col="black", cex=1.2))

#' ### What would log(income) look like?
#' 
#' Rather than actually transforming `income`, the argument `log = "x"` says to 
#' plot `income` on a log scale
scatterplot(prestige ~ income, data=Prestige, 
            log = "x",
            pch = 16,
            regLine = list(col = "red", lwd=3),
            smooth = list(smoother=loessLine,
                          lty.smooth = 1, col.smooth = "black", lwd.smooth=3,
                          col.var = "darkgreen"),
            ellipse = list(levels = 0.68), 
            id = list(n=4, col="black", cex=1.2))


#' ### Stratify by type
#' 
#' The formula notation `~ income | type` says to do plot annotations conditional on occupation type.
#' Oh, now that has a very different interpretation!
scatterplot(prestige ~ income | type, data=Prestige,
            col = c("blue", "red", "darkgreen"),
            pch = 15:17,
            legend = list(coords="bottomright"),
            smooth=list(smoother=loessLine, 
                        var=FALSE, span=1, lwd=4))



#' ## Fit the basic all-main-effects model
data(Prestige)
mod0 <- lm(prestige ~ education + income + women + type,
           data=Prestige)
summary(mod0)


#' ## Add more complex terms
#' 
#' Here we model income as `log(income)``
#' and allow an interaction
#' with occupation `type`.
mod1 <- lm(prestige ~ education + women +
                     log(income)*type, data=Prestige)
summary(mod1)

#' ## Plot coefficients
#' 
#' Plots of coefficients with CI often more informative that tables of coefficients. 
#' These intervals are shown for $\pm 1, \pm 2$ standard errors.
#' 
#' However,
#' this plots the _raw coefficients_, which are on different scales, so the small coefficients
#' for `income` do not appear to be significant.  It would be better if there was an option
#' to plot standardized ($\beta$) coefficients.
arm::coefplot(mod0, col.pts="red", cex.pts=1.5)
arm::coefplot(mod1, add=TRUE, col.pts="blue", cex.pts=1.5)

#' ## Compare model fits
#' 
#' This `anova` call tests whether `mod1` is a significant improvement over the baseline `mod0`
anova(mod0, mod1)

#' ## Effect plots
             
#' Effect of `education` averaged over others
mod1.e1 <- predictorEffect("education", mod1)
plot(mod1.e1)

#' Effect of `education`, but showing partial residuals. In some cases, this will help spot influential cases
#' in the partial relation of a predictor to the response.

mod1.e1a <- predictorEffect("education", mod1, residuals=TRUE)
plot(mod1.e1a, 
     residuals.pch=16, id=list(n=4, col="black"))

#' Effect of `women` averaged over others. The blue curve shows the fitted quadratic relation in the model.
#' The red curve shows a non-parametric smoooth.

mod1.e2 <- predictorEffect("women", mod1, residuals=TRUE)
plot(mod1.e2, ylim=c(40, 65), lwd=4,
     residuals.pch=16)


#' Effect of `income` (by `type`) averaged over others

plot(predictorEffect("income", mod1),
     lines=list(multiline=TRUE, lwd=3),
     key.args = list(x=.7, y=.35),
    )


#' ## Diagnostic plots
#' 
#' In base graphics, `plot()` for an `lm` object gives the "regression quartet" of diagnostic plots.

#+ fig.width=7, fig.height=7
op <- par(mfrow=c(2,2))
plot(mod1, lwd=2, cex.lab=1.4)



#' ## better QQ plots from `car::qqPlot`

#' Overall plot of residuals for `mod1`
#' 
qqPlot(mod1, pch=16, simulate = FALSE)

qqPlot(mod1, distribution = "norm", simulate = FALSE)

#' QQ plots for individual variables and/or subsets
#' 
qqPlot(~ income, data=Prestige, subset = type == "prof")
qqPlot(income ~ type, data=Prestige, layout=c(1, 3))


#' ## influence plot
#'
#+ fig.height=6, fig.width=7
car::influencePlot(mod1, id=list(n=2, cex=1.2), cex.lab=1.4)




