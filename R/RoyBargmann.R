#' ---
#' title: Roy-Bargmann tests
#' ---

# The Roy-Bargmann procedure is typically used as a post hoc or follow-up analysis to a significant MANOVA. It evaluates the specific contribution of each dependent variable (DV) based on an a priori order of importance
# * This idea is similar in spirit to Helmert contrasts for factors.
# * Hey, its the Fritz-Lowell-?? theorem in relation to the responses, rather than predictors.
# * This would make a great research paper!
# 
# Not mentioned so far in the book, except that this is the basis for step-down tests in candisc.
# For possible use in `heplots` as an alternative / addition to Anova, where we would get
# a series of Sequential overall tests for the univariate models: y1 ~ x; y2|y1 ~ x; y3|y1 y2, ...

# This implementation is just a simple guess at the processing step, using car::Anova() to extract the appropriate model
  
# TODO: Would using `reformulate()` rather than all that `paste()` simplify this?
# TODO: The desired end result should include a useful print method to format an Anova table giving the tests

RoyBargmann <- function(data, dvs, ivs, type = "III") {
  # dvs: vector of dependent variable names ordered by importance
  # ivs: string specifying the independent variables/factors
  
  results <- list()
  
  for (i in seq_along(dvs)) {
    target_dv <- dvs[i]
    
    if (i == 1) {
      formula_text <- paste(target_dv, "~", ivs)
    } else {
      covariates <- paste(dvs[1:(i - 1)], collapse = " + ")
      formula_text <- paste(target_dv, "~", covariates, "+", ivs)
    }
    
    model <- lm(as.formula(formula_text), data = data)
    results[[target_dv]] <- car::Anova(model, type = type)
  }
  
  return(results)
}

# Example Usage:
# output <- RoyBargmann(iris, c("Sepal.Length", "Sepal.Width"), "Species")
# output$Sepal.Width
