library(MASS)
library(klaR)
library(dplyr)
data(iris)
partimat(Species ~ ., data = iris, method = "lda")

pch <- (15:17)[iris$Species]
partimat(Species ~ ., data = iris, method = "lda",
         plot.matrix = TRUE, print.err=0,
         gs = pch,
         image.colors = scales::alpha(rainbow(3), 0.2), 
         plot.control = list(cex=1.2),
         main = ""
         )


data(dogfood, package="heplots")

dogfood.lda <- MASS::lda(formula ~ start + amount, data=dogfood)
plot(dogfood.lda, cex = 1.2)
abline(h=0, v=0, col="gray")
coefs <- dogfood.lda$scaling
abline(a = 0, b = coefs[2,1] / coefs[1,1])
abline(a = 0, b = coefs[2,2] / coefs[1,2])

means <- dogfood |>
  group_by(formula) |>
  summarise(start = mean(start), amount = mean(amount)) |> print()

col <- c("red", "blue", "darkgreen", "brown") 
 
partimat(formula ~ amount + start, data=dogfood, method = "lda",
         print.err = 0,
         pch.mean = "+", cex.mean = 2,
         image.colors = col |> scales::alpha(alpha = 0.1),
         plot.control = list(cex.lab = 1.5, xpd=TRUE,
                             xlim = c(0,5),
                             ylim = c(70, 100)),
         main = "")

with(means,
  text(start, amount, label=formula, cex = 1.5))

car::dataEllipse(amount ~ start | formula, data = dogfood,
                 levels = 0.40, group.label = "",
                 center.pch = "",
                 add = TRUE, col = col)
