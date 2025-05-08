#' ---
#' title: LDA plot with ggord

library(MASS)
if(!require(ggord)) devtools::install_github("fawda123/ggord")

library(ggord)
data(iris)
iris.lda <- lda(Species ~ ., iris)

# expand vector lengths
ggord(iris.lda, iris$Species,
      ylims = c(-6, 7),
      xlims = c(-10, 10),
      veclsz = 1.2,
      ext = 1.1,
      vec_ext = 1.5,
      size = 2)

library(ggbiplot)
ggbiplot(iris.lda, #obs.scale = 1, var.scale = 1,
         groups = iris$Species, point.size=2,
         varname.size = 6)

# view in data space
if(!require(klaR)) install.packages("klaR")
library(klaR)
partimat(Species ~ ., data = iris, 
         method = "lda",
         plot.matrix = TRUE,
         lab.cex = 2,
         image.colors = hcl.colors(3, alpha = 0.5))
