library(MASS)
#library(ggord)
library(ggplot2)

data(peng, package="heplots")
source("R/penguin/penguin-colors.R")

peng.lda <- lda(species ~  bill_length + bill_depth + flipper_length + body_mass, data = peng)
peng.lda


# peng_new <- tibble(
#   id = c("Abe", "Betsy", "Chloe"),
#   species = rep(NA, 3),
#   island = rep("Z", 3),
#   bill_length = c(35, 52, 52),
#   bill_depth= c(18, 20, 15),
#   flipper_length = c(220, 190, 210),
#   body_mass = c(5000, 3900, 4000),
#   sex = c("m", "f", "f")
# )

# use rownames
peng_new <- data.frame(
  species = rep(NA, 3),
  island = rep("Z", 3),
  bill_length = c(35, 52, 52),
  bill_depth= c(18, 20, 15),
  flipper_length = c(220, 190, 210),
  body_mass = c(5000, 3900, 4000),
  sex = c("m", "f", "f")
)

rownames(peng_new) <- c("Abe", "Betsy", "Chloe")
peng_new



predict(peng.lda, newdata = new_peng)

pred_lda <- function(object, newdata, ...) {
  if (missing(newdata)) {
    newdata <- insight::get_modelmatrix(object) |>
      as.data.frame() |>
      dplyr::select(-"(Intercept)") 
  }
  nv <- ncol(newdata)
  pred <- predict(object, newdata, type = "prob")
  class <- pred$class
  probs <- pred$posterior
  maxp <- apply(probs, 1, max)

    # get response variable name
  response <- insight::find_response(object)
  
  ret <- cbind(newdata, class, maxp)
  colnames(ret)[nv+1] <- response
  ret
}


pred_lda(peng.lda, newdata = peng_new[, -1])

#tidy_pred(pend.lda, "species")
