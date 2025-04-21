# LDA partition plots
# from: https://rpubs.com/Nolan/298913

library(MASS)
library(klaR) # partimat
library(car)
library(ggbiplot)
library(heplots)
library(candisc)

iris.lda <- lda(Species ~ ., iris)
iris.lda
names(iris.lda)

str(iris.lda)

col <- scales::hue_pal()(3)
panel.pts <- function(x, y, ...) points(x, y, ...)
plot(iris.lda, 
     panel = panel.pts 
#     col = col #, pch = (15:17)[iris$Species]
)

iris.scores <- data.frame(
  Species = iris$Species,
  predict(iris.lda)$x)

str(iris.scores)

dataEllipse(LD2 ~ LD1 | Species, data=iris.scores, 
            levels = 0.68, 
            fill = TRUE, fill.alpha = 0.05,
            col = col,
            pch = 15:17,
            grid = FALSE,
            label.pos = "top",
            label.cex = 1.8)
candisc::vectors(iris.lda$scaling, col = "black", lwd=2)

# use asp=1
dataEllipse(LD2 ~ LD1 | Species, data=iris.scores, 
            levels = 0.68, 
            fill = TRUE, fill.alpha = 0.05,
            col = col,
            pch = 15:17,
            grid = FALSE,
            label.pos = "top",
            label.cex = 1.8,
            asp = 1)
abline(h=0, v=0, col = "grey")

vecs <- iris.lda$scaling
rownames(vecs) <- sub("\\.", "\n", rownames(vecs))
vecs

vecscale(vecs)

vectors(vecs, col = "black", lwd = 2,
        scale = vecscale(vecs), xpd = TRUE)


# point id
dataEllipse(LD2 ~ LD1 | Species, data=iris.scores, 
            levels = 0.68, 
            fill = TRUE, fill.alpha = 0.05,
            col = col,
            pch = 15:17,
            grid = FALSE,
            label.cex = 1.5,
            id = list(n = 2, col = col))


# MANOVA
iris.mod <- lm(cbind(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width) ~ Species, data = iris)
iris.can <- candisc(iris.mod)
plot(iris.can, ellipse = TRUE, pch = 15:17)


ggbiplot(iris.lda,
#         obs.scale = 1, var.scale = 1, 
          scale = 0.5,
         groups = iris$Species,
         ellipse = TRUE
        )


partimat(Species ~ Sepal.Length + Sepal.Width + Petal.Length + Petal.Width, 
         data=iris, method="lda")