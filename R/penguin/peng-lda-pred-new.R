library(MASS)
#library(ggord)
library(ggplot2)

data(peng, package="heplots")
source("R/penguin/penguin-colors.R")

peng.lda <- lda(species ~  bill_length + bill_depth + flipper_length + body_mass, data = peng)
peng.lda

peng_new <- data.frame(
  species = rep(NA, 4),
  island = rep("Z", 4),
  bill_length = c(35, 52, 52, 50),
  bill_depth= c(18, 20, 15, 16),
  flipper_length = c(220, 190, 210, 190),
  body_mass = c(5000, 3900, 4000, 3800),
  sex = c("m", "f", "f", "m")
)

# use rownames
rownames(peng_new) <- c("Abe", "Betsy", "Chloe", "Dave")
peng_new



peng_pred <- predict(peng.lda, newdata = peng_new)

zapsmall(peng_pred$posterior)

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

# try predict_discrim
# 
source("R/predict_discrim.R")

predict_discrim(peng.lda, newdata = peng_new[, -1])

