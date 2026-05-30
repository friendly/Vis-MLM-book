# The Roy-Bargmann procedure is typically used as a post hoc or follow-up analysis to a significant MANOVA. It evaluates the specific contribution of each dependent variable (DV) based on an a priori hierarchy of importance:
  

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
