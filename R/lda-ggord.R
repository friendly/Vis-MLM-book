#' ---
#' title: LDA plot with ggord

library(MASS)
library(devtools)
install_github("fawda123/ggord")

library(ggord)
data(iris)
ord <- lda(Species ~ ., iris, prior = rep(1, 3)/3)

# expan vector lengths
ggord(ord, iris$Species,
      ylims = c(-5, 7),
      veclsz = 1.2,
      vec_ext = 1.5)


# view in data space
install.packages("klaR")
library(klaR)
partimat(Species ~ ., data = iris, 
         method = "lda",
         plot.matrix = TRUE,
         image.colors = hcl.colors(3, alpha = 0.5))
