#' ---
#' title: "Coefficient plots for linear models"
#' author: "Michael Friendly"
#' date: "`r format(Sys.Date())`"
#' output:
#'   html_document:
#'     theme: readable
#'     code_download: true
#' ---


#+ echo=FALSE
knitr::opts_chunk$set(warning=FALSE, 
                      message=FALSE, 
                      error = FALSE,
                      R.options=list(digits=4))

#' Coefficient plots are often more useful than tables[^1]
#' but plotting _raw coefficients_ can be misleading when the predictors are
#' on different scales.
#' 
#' [^1]: Kastellec, J. P., & Leoni, E. L. (2007). Using Graphs Instead of Tables in Political Science. _Perspectives on Politics_, 5, 755–771.
#' 
#' The packages [`arm`](https://cran.r-project.org/package=arm) and 
#' [`modelsummary`](https://modelsummary.com/), and later,
#' [`ggstats`](https://cran.r-project.org/web/packages/ggstats/vignettes/ggcoef_model.html)
#' are used to illustrate these plots.
#' 
#' In the process, I discover some other problems with naive use of coefficient plots.
#' I compare plotting:
#'
#' * raw coefficients
#' * standardized coefficients
#' * meaningfully scaled coefficients
#' 

#' ### Load packages
library(dplyr)
library(ggplot2)
library(arm)           # coefplot()
library(modelsummary)  # modelplot()
library(ggstats)       # ggcoef_model()


#' ## Occupational prestige data
#' How does occupational prestige depend on education (years), income ($), %women, ...?
#' 
#' I use a classic example from the `carData` package. The observations are averages for occupational
#' categories rather than individuals. The data come from the 1971 Canadian census.
data(Prestige, package="carData")
head(Prestige, 5)

#' ## Fit a simple model
mod0 <- lm(prestige ~ education + income + women,
           data=Prestige)
summary(mod0)

#' ### Displaying coefficients
#' I'm interested in the coefficients in this model, so here is just a reminder that you can extract
#' the numerical values using `coef()`, or display them in a table similar to the "Coefficients"
#' portion above using `broom::tidy()` or `arm::display()`:

coef(mod0)
broom::tidy(mod0)
arm::display(mod0, detail = TRUE)

#' ## Visualize coefficients
#' The plots below show default coefficient plots for this model using `modelsummary::modelplot()`
#' and `arm::coefplot()`. At the end, I show some examples using the `ggstats` package.
#' 
#' They are disappointing and misleading because these show the **raw** coefficients. 
#' It looks like only `education` has a non-zero effect, but the effect of `income` is also
#' highly significant.
#' 
#' These plots are misleading because the predictors
#' are on different scales, so it makes little sense to compare the change in `prestige` for
#' a 1 year increase in `education` with the change for a $1 increase in `income`.
theme_set(theme_minimal(base_size = 14))
modelplot(mod0, 
          coef_omit="Intercept", 
          color="blue", size=1) +
  labs(title="Raw coefficients for mod0")

arm::coefplot(mod0, col.pts="red", cex.pts=1.5)

#' Other graphical features to note here:
#' 
#' * `coefplot()` includes a dashed vertical reference line at `x = 0` by default, but `modelplot()` does not.
#' * The $Y$ axis is ordered in reverse to what appears in tabular output.
#'  
#' ## Fit a more complex model
#' For this example, graphical analysis suggested that the relation between `prestige` and `income` was
#' non-linear, which could be corrected using `log(income)`. As well, other plots suggested an
#' interaction with `type` of occupation.
mod1 <- lm(prestige ~ education + women +
             log(income)*type, data=Prestige)
summary(mod1)

#' ## Compare models
#' `arm::coefplot()` allows you to compare several models in the same plot, using `add=TRUE` for the second and subsequent ones.
#' The intercept is ignored by default.
arm::coefplot(mod0, col.pts="red", cex.pts=1.5)
arm::coefplot(mod1, add=TRUE, col.pts="blue", cex.pts=1.5)

#' But **WAIT**: `income` was entered as `log(income)` in `mod1`. The plot above is silently
#' wrong,  because it doesn't include `log(income)` or the interaction terms.
#' It is was probably stupid to
#' try to compare the coefficients, and this should have raised a warning or error.
#' 
#'
#' All the terms will appear if the most complex model is plotted first.
arm::coefplot(mod1, col.pts="red", cex.pts=1.5)
arm::coefplot(mod0, add=TRUE, col.pts="blue", cex.pts=1.5)


#' ## Standardize the variables, giving $\beta$ coefficients
#' An alternative is to present the standardized coefficients. These are interpreted
#' as the standardized change in prestige for a one standard deviation change in the
#' predictors.
#' 
#' One way to do this is to transform all variables to standardized ($z$) scores.
#' The syntax ultimately uses `scale` to transform all the numeric variables.
#' 

Prestige_std <- Prestige |>
  as_tibble() |>
  mutate(across(where(is.numeric), scale))

#' ### Fit the same models to the standardized variables
#' This accords better with the fitted (standardized) coefficients. `income` and `education`
#' are now both large and significant compared with the effect of `women`.
#' 
#' But a nagging doubt remains:  How can I interpret the numerical **size** of coefficients?
#' The direct answer is that they give the expected change in standard deviations of
#' `prestige` for a one standard deviation
#' change in each of the predictors.

mod0_std <- lm(prestige ~ education + income + women,
               data=Prestige_std)

mod1_std <- lm(prestige ~ education + women +
               log(income)*type, 
               data=Prestige_std)

#' ## Plot the standardized coefficients
#' These plots look more like what I was expecting to show the relative magnitudes of the coefficients
#' and CIs so one could see which differ from zero.
#' 
modelplot(mod1_std, 
          coef_omit="Intercept", color="blue", size=1) +
  labs(title="Standardized coefficients for mod0") +
  geom_vline(xintercept = 0, linetype = 2) 
  

#' ## Using `standardize = "refit"`
#' It turns out there is an easier way to get plots of standardized coefficients.
#' `modelsummary()` extracts coefficients from model objects using the `parameters` package, and that package offers several options for standardization: 
#' See [model parameters documentation](https://easystats.github.io/parameters/reference/model_parameters.default.html).
#'  We can pass the `standardize="refit"` (or other) argument directly to `modelsummary()` or `modelplot()`, and that argument will be forwarded to `parameters`. 
#' To compare models, pass them to `modelplot` as a list.
modelplot(list(mod0 = mod0, mod1 = mod1),
          standardize = "refit",
          coef_omit="Intercept", size=1) +
  labs(title="Standardized coefficients for mod0 and mod1") +
  geom_vline(xintercept = 0, linetype = 2) 
  
#' A small annoyance: This gives a warning because `standardize` is handled via `...`
#' and that is pushed to both `parameters` and `ggplot2`.

#' ## More meaningful units
#' A better substantative comparison of the coefficients could use understandable scales for the
#' predictors, e.g., months of education, $50,000 income or 10% of women's participation.
#' 
#' Note that the effect of this is just to multiply the coefficients and their standard errors by a factor. 
#' The statistical conclusions of significance are unchanged.

Prestige_scaled <- Prestige |>
  mutate(education = 12 * education,
         income = income / 50,
         women = women / 10)

mod0_scaled <- lm(prestige ~ education + income + women,
               data=Prestige_scaled)

arm::display(mod0_scaled, detail = TRUE)

arm::coefplot(mod0_scaled, col.pts="red", cex.pts=1.5,
              main = "Coefficients for prestige with scaled predictors",
              varnames=c("intercept", 
                         "education\n(/month)",
                         "income\n(/$50K)",
                         "women\n(/10%)")
               )

#' ## Re-ordering terms
#' There is a mismatch between the tabular displays of coefficients, where terms are listed in their
#' order in the model, and the plots shown above, where terms appear on the vertical axis in the reverse order,
#' because the $Y$ axis starts at 0. With `modelplot()`, we can reorder the terms using `scale_y_discrete()`.
#' 

modelplot(list(mod0 = mod0, mod1 = mod1),
          standardize = "refit",
          coef_omit="Intercept", size=1) +
  labs(title="Standardized coefficients for mod0 and mod1") +
  scale_y_discrete(limits = rev) +
  geom_vline(xintercept = 0, linetype = 2) +
  theme(legend.position = c(0.9, 0.2))

#' ## Factor levels
#' There are several features of the plots shown above that are handled better in other packages.
#' A main one is how terms involving factor variables are handled: 
#' In the `Prestige` data, occupation `type` is a factor, with levels `"bc", "prof", "wc"`
#' meaning blue-collar, professional and white-collar jobs. 
#' 
#' By default, `lm()` treats the first
#' level (`"bc"`) as the baseline category, so the coefficients for `type` are labeled
#' `typeprof` and `typewc`. This is ugly and non-informative for presentation purposes,
#' where it would be better to group the coefficients for the levels under the `type` factor.
#' 
#' To illustrate, I ignore using `log(income)`, and specify some models using `type` and its
#' interactions.
#' 
mod0 <- lm(prestige ~ education + income + women,
          data=Prestige_std)
mod2 <- update(mod0, ~ . + type)
mod3 <- update(mod0, ~ . + type + type * income)

#' The [`ggstats`](https://larmarange.github.io/ggstats/) package provides some nicer versions
#' of coefficient plots that handle factors in a more reasonable way, as levels nested within
#' the factor. By default it shows $p$-values and significance stars in the labels, and 
#' (redundantly) uses different symbols for terms significant at $p \le 0.05$ or not.
library(ggstats)
ggcoef_model(mod2) +
  labs(x = "Standarized Coefficient")

#' I find the $p$-values and significance stars distracting in the plot, but these can be suppressed
#' using options `show_p_values = FALSE` and `signif_stars = FALSE`.
#'
#' ## Comparing models
#' To compare several models, use `ggcoef_compare()`, supplied with a list of models.
#' This does a much nicer job of organizing the terms for main effects and interactions
#' so they may be more readily compared.
models <- list(
  "Base model"      = mod0,
  "Add type"        = mod2,
  "Add interaction" = mod3)

ggcoef_compare(models) +
  labs(x = "Standarized Coefficient")


#' ## Wrapup

#' At first glance, printing and plotting coefficients from statistical models seems like an
#' easy task for which there should be straightforward solutions, with reasonable defaults
#' and the ability to customize displays easily.
#' 
#' `modelplot()` is nice in that you can ask it to plot standardized coefficients, but it doesn't
#' handle factors well. I think that, by default it should reverse the order of coefficients
#' on the vertical axis and plot the vertical reference line at 0.
#' 
