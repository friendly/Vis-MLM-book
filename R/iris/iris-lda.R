# LDA partition plots
# from: https://rpubs.com/Nolan/298913

library(MASS)
library(klaR) # partimat
library(car)

iris.lda <- lda(Species ~ ., iris)
iris.lda
names(iris.lda)

str(iris.lda)

plot(iris.lda, col = as.integer(iris$Species), abbrev = 3)

iris.scores <- data.frame(
  Species = iris$Species,
  predict(iris.lda)$x
)
str(iris.scores)

col <- scales::hue_pal()(3)
dataEllipse(LD2 ~ LD1 | Species, data=iris.scores, 
            levels = 0.68, 
            fill = TRUE, fill.alpha = 0.05,
            col = col,
            pch = 15:17,
            grid = FALSE,
            label.pos = "top",
            label.cex = 1.8)

# point id
dataEllipse(LD2 ~ LD1 | Species, data=iris.scores, 
            levels = 0.68, 
            fill = TRUE, fill.alpha = 0.05,
            col = col,
            pch = 15:17,
            grid = FALSE,
            label.cex = 1.5,
            id = list(n = 2, col = col))


partimat(Species ~ Sepal.Length + Sepal.Width + Petal.Length + Petal.Width, 
         data=iris, method="lda")