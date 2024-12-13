# LDA partition plots
# from: https://rpubs.com/Nolan/298913

library(MASS)
library(klaR)
library(car)

iris.lda <- lda(Species ~ ., iris)
str(iris.lda)

plot(iris.lda, col = as.integer(iris$Species))

dataEllipse(LD2 ~ LD1, data=iris.lda, groups = iris$Species, levels = 0.68 )

partimat(Species ~ Sepal.Length + Sepal.Width + Petal.Length + Petal.Width, 
         data=iris, method="lda")