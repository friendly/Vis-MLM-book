# TODO: add stuff for other discriminant methods: 
#  library(mda) -> mda() -> predict.mda()
#  
#' Predicted values for discriminant analysis
#' 
#' \code{predict_discrim} calculates predicted class membership values for a linear or quadratic discriminant analysis,
#' returning a `data.frame` suitable for graphing or other analysis.
#' 
#' @details
#' The `predict()` methods provided for [MASS::lda()] and [MASS::qda()] are a mess, because they return their results as
#' a list, with components `class`, `posterior` and `x`. 
#' 
#' 
#' @param object   An object of class `"lda"` or `"qda"`  such as results from [MASS::lda()] or [MASS::qda()] 
#' @param newdata  A data frame of cases to be classified or, if `object` has a formula, a data frame with columns of the same names as the variables used. A vector will be interpreted as a row vector. If `newdata` is missing, an attempt will be made to retrieve the data used to fit the `lda` object.
#' @param prior The prior probabilities of the classes. By default, taken to be the proportions in what was set in the call to [MASS::lda()] or [MASS::qda()] 
#' @param dimen The dimension of the space to be used. If this is less than min(p, ng-1), only the first `dimen` discriminant components are used 
#' @param scores A logical. If `TRUE`, the discriminant scores of the cases in `newdata` are appended as additional columns in the the result, with names `LD1`, `LD2`, ...
#' @param ...      arguments based from or to other methods, not yet used here
#' @md
#' @returns        A data.frame, containing the the predicted class of the observations, values of the `newdata` variables and the maximum value of the posterior probabilities of the classes. `rownames()` in the result are inherited from those in `newdata`.
#' @export
#' @examples
#' # none yet.
predict_discrim <- function(object, 
                            newdata, 
                            prior = object$prior,
                            dimen,
                            scores = FALSE,
                            ...) {
  cls <- class(object)
  if (!cls %in% c("lda", "qda")) {
    stop(paste('object must be of class "lda" or "qda", not', cls))
  }
  if (missing(newdata)) {
    newdata <- insight::get_modelmatrix(object) |>
      as.data.frame() |>
      dplyr::select(-"(Intercept)") 
  }
  nv <- ncol(newdata)
  pred <- predict(object, newdata, prior=prior, type = "prob")
  class <- pred$class
  probs <- pred$posterior
  maxp <- apply(probs, 1, max)

  # get response variable name to substitute for `class`
  response <- insight::find_response(object)
  
  # if it is already in newdata, remove it
  if (response %in% colnames(newdata)) 
    newdata <- newdata[, !(names(newdata) %in% response)]
  
  
  ret <- cbind(class, newdata, maxp)
  colnames(ret)[1] <- response
  
  if (scores) {
    scores <- pred$x
    ret <- cbind(ret, scores)
  }
  
  ret
}
