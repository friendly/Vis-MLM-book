
load(here::here("data", "peng.RData"))
source("R/penguin/penguin-colors.R")

# use penguin colors
col <- peng.colors("medium")
pch <- 15:17
theme_set(theme_bw(base_size = 14))


library(MASS)
library(ggord)

peng.lda <- lda(species ~  bill_length + bill_depth + flipper_length + body_mass, data = peng)
peng.lda

# bibplot in discrim space
ggord(peng.lda, peng$species,
      cols = peng.colors("medium"),
      ylims = c(-8, 5),
      xlims = c(-8, 8),
      veclsz = 1.1,
      ext = 1.1,
      vec_ext = 5.5,
      arrow = 0.3,
      size = 2)


pred <- predict(peng.lda)
datPred <- data.frame(Species=pred$class,
                      pred$x,
                      maxProb = apply(pred$posterior, 1, max))

# get a tidy data frame from an LDA/QDA object
tidy_pred <- function(object, group) {
  pred <- predict(object)
  res <- data.frame(group = pred$class,
                    pred$x,
                    pred$posterior,
                    maxProb = apply(pred$posterior, 1, max))
  colnames(res)[1] <- group
  res
}

tidy_pred(peng.lda, "Species") 


peng.qda <- qda(species ~  bill_length + bill_depth + flipper_length + body_mass, data = peng)
peng.qda

ggord(peng.qda, peng$species,
      cols = peng.colors("medium"),
      ylims = c(-8, 5),
      xlims = c(-8, 8),
      veclsz = 1.1,
      ext = 1.1,
      vec_ext = 5.5,
      arrow = 0.3,
      size = 2)


peng.lda <- peng |>
  dplyr::select(species, bill_length:sex) |>
  lda(species ~ ., data= _)

# expan vector lengths
ggord(peng.lda, peng$species,
      cols = col,
      ylims = c(-6, 7),
      veclsz = 1.2,
      ext = 1.1,
      vec_ext = 3.5)

# view in data space
#if(!require(klar)) install.packages("klaR")
library(klaR)
peng.partimat <- peng |>
  dplyr::select(species, bill_length:body_mass) |>
  partimat(species ~ ., data = _, 
         method = "lda",
         plot.matrix = TRUE,
         plot.control = list(cex = 1.2),
         image.colors = col)

peng.partimat <- peng |>
  dplyr::select(species, bill_length:body_mass) |>
  partimat(species ~ ., data = _, 
           method = "qda",
           plot.matrix = TRUE,
           plot.control = list(cex = 1.2),
           image.colors = col)

