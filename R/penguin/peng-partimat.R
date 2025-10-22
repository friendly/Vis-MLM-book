#' ---
#' title: Test partimat with Penguin data
#' ---


library(MASS)
library(klaR)

data(peng, package="heplots")
#source("R/penguin/penguin-colors.R")

# use penguin colors
#col <- peng.colors("medium")
col <- c(Adelie = "#F89D38", Chinstrap = "#9A78B8", Gentoo = "#73C05B")


peng.lda <- lda(species ~  bill_length + bill_depth + flipper_length + body_mass, data = peng)


peng.partimat <- peng |>
  dplyr::select(species, bill_length:body_mass) |>
  partimat(species ~ ., data = _, 
         method = "lda",
         plot.matrix = TRUE,
#         plot.control = list(cex = 1.2),
#         cex.pts = 0.7,     ## this doesn't work in my revised partimat
         image.colors = scales::alpha(col, alpha = 0.4)
  )


