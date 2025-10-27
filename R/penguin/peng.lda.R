if(!require(ggord)) {
  options(repos = c(
      fawda123 = 'https://fawda123.r-universe.dev',
      CRAN = 'https://cloud.r-project.org'))
  
  # Install ggord
  install.packages('ggord')
}

library(MASS)
library(ggord)
library(ggplot2)

data(peng, package="heplots")
source("R/penguin/penguin-colors.R")

# use penguin colors
col <- peng.colors("medium")
pch <- 15:17
theme_set(theme_bw(base_size = 14))



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
data_pred <- data.frame(Species=pred$class,
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

data_pred <- tidy_pred(peng.lda, "Species") 

LDA.lda <- lda(Species ~ LD1 + LD2, data=data_pred)

make_grid <- function(x, y, names, mul = 0.05, ngrid = 100) {
  xlim <- expand_range(min(x), max(x), mul = mul)
  ylim <- expand_range(min(y), max(y), mul = mul)
  xval <- seq(from = xlim[1], to = xlim[2], length.out = ngrid)
  yval <- seq(from = ylim[1], to = ylim[2], length.out = ngrid)
  df <- expand.grid(xval, yval)
  if (!missing(names)) {
    if (length(names) < 2) stop("`names` must be a charactger vector of length 2")
    colnames(df) <- names[1:2]
  }
  df
}



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
  dplyr::select(species, bill_length:body_mass) |>
  lda(species ~ ., data= _)

# expan vector lengths
ggord(peng.lda, peng$species,
      cols = col,
      ylims = c(-6, 7),
      veclsz = 1.2,
      ext = 1.1,
      vec_ext = 3.5)



# view in data space
#if(!require(klaR)) install.packages("klaR")
library(klaR)
# added cex.pts arg
#source("C:/Dropbox/R/functions/partimat.R")
peng.partimat <- peng |>
  dplyr::select(species, bill_length:body_mass) |>
  partimat(species ~ ., data = _, 
         method = "lda",
#         plot.matrix = TRUE,
#         plot.control = list(cex = 1.2),
#         cex.pts = 0.7,
         image.colors = scales::alpha(col, alpha = 0.4),
         main = "Penguin Partition Plot"
  )

peng.partimat <- peng |>
  dplyr::select(species, bill_length:body_mass) |>
  partimat(species ~ ., data = _, 
         method = "qda",
#         plot.matrix = TRUE,
#         plot.control = list(cex = 1.2),
#         cex.pts = 0.7,
         image.colors = scales::alpha(col, alpha = 0.4)
  )


peng.partimat <- peng |>
  dplyr::select(species, bill_length:body_mass) |>
  partimat(species ~ ., data = _, 
           method = "qda",
           plot.matrix = TRUE,
           plot.control = list(cex = 1.2),
           image.colors = scales::alpha(col, alpha = 0.4)
           )

