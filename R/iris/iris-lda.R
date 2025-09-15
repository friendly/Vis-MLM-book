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
iris.colors <- c("red", "darkgreen", "blue")

# using MASS::plot.lda
panel.pts <- function(x, y, ...) points(x, y, ...)
plot(iris.lda, 
     panel = panel.pts
     col = iris.colors,
     pch = 15:17
)

# using dataEllipse
iris.scores <- data.frame(
  Species = iris$Species,
  predict(iris.lda)$x)

str(iris.scores)

# varnames for labeling vectors
vecs <- iris.lda$scaling
rownames(vecs) <- sub("\\.", "\n", rownames(vecs))
vecs

# reflect LD1
iris.scores[, "LD1"] <- -1 * iris.scores[, "LD1"]

vecs[, "LD1"] <- -1 * vecs[, "LD1"]

# dataEllipse(LD2 ~ LD1 | Species, data=iris.scores, 
#             levels = 0.68, 
#             fill = TRUE, fill.alpha = 0.05,
#             col = iris.colors,
#             pch = 15:17,
#             grid = FALSE,
#             label.pos = "top",
#             label.cex = 1.8)
# 
# candisc::vectors(vecs, 
#                  col = "black", lwd=2, cex = 1.3)

# use asp=1
dataEllipse(LD2 ~ LD1 | Species, data=iris.scores, 
            levels = 0.68, 
            fill = TRUE, fill.alpha = 0.05,
            col = iris.colors,
            pch = 15:17,
            grid = FALSE,
            label.pos = "bottom",
            label.cex = 1.6,
            asp = 1)
abline(h=0, v=0, col = "grey")

#vecscale(vecs)
# 2.74

vectors(vecs, 
        col = "black", lwd = 2, cex = 1.3,
        scale = vecscale(vecs), 
        xpd = TRUE)


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


# partimat methods
partimat(Species ~ Sepal.Length + Sepal.Width + Petal.Length + Petal.Width, 
         data=iris, 
         method="lda",
         image.colors = scales::alpha(iris.colors, alpha=0.2),
         gs = 15:17, 
         plot.control = list(cex.lab = 1.4)
         )

# try in matrix form
partimat(Species ~ Sepal.Length + Sepal.Width + Petal.Length + Petal.Width, 
         data=iris, 
         plot.matrix = TRUE,
         plot.control = list(cex = 1.5), gs = 15:17,
         method="lda",
         image.colors = scales::alpha(iris.colors, alpha=0.2)
         )


partimat(Species ~ Sepal.Length + Sepal.Width + Petal.Length + Petal.Width, 
         data=iris, 
         method="qda",
         image.colors = scales::alpha(iris.colors, alpha=0.3)
         )

