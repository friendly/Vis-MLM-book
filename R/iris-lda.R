# LDA partition plots
# from: https://rpubs.com/Nolan/298913

library(MASS)
library(klaR)

iris.lda <- lda(Species ~ ., iris)
plot(iris.lda, col = as.integer(iris$Species))

partimat(Species ~ Sepal.Length + Sepal.Width + Petal.Length + Petal.Width, 
         data=iris, method="lda")