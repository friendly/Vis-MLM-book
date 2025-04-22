# iris data as repeated measures / transformation                                  ar combinations of them
# treating {Sepal, Petal} and {Length, Width} as factors.

library(dplyr)
library(tidyr)
library(car)
library(heplots)

data(iris)

contrasts(iris$Species) <- matrix(c(1,-1/2,-1/2,  0, 1, -1), nrow=3, ncol=2)
contrasts(iris$Species)

iris.mod <- lm(cbind(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width) ~
                 Species, data=iris)

# part = Sepal - Petal
# dim  = Length - Width
idata <- expand.grid(part = c("Sepal", "Petal"),
                     dim = c("Length", "Width")) |>
  arrange(part) |> print()


iris.aov1 <- Anova(iris.mod, idata = idata, idesign = ~part) |>
  print()

iris.aov2 <- Anova(iris.mod, idata = idata, idesign = ~dim) |>
  print()


Anova(iris.mod, idata = idata, idesign = ~part + dim)

# only 1 dimension for each term
heplot(iris.mod, idata=idata, idesign = ~part + dim, iterm="part",
       col=c("red", "blue", "green3"),
       #  hypotheses=c("trt1", "trt2"),
       main="Iris data, Within-measures effects")

# transform iris measures to comparisons
M <- matrix(
  c(1, 1,  1,  1,
    1, 1, -1, -1,
    1, -1, 1, -1,
    1, -1, -1, 1),
  nrow = 4, ncol = 4
)
rownames(M) <- names(iris)[1:4]
colnames(M) <- c("(Avg)", "part", "dim", "part:dim")
M

irisC <- as.matrix(iris[, 1:4]) %*% (M/4) |>
  as.data.frame() |>
  bind_cols(Species = iris$Species)

head(irisC)

# same as iris.mod
irisC.mod <- lm(cbind(`(Avg)`, part, dim,`part:dim`) ~
                 Species, data=irisC)

Anova(irisC.mod)

heplot(irisC.mod)

pairs(irisC.mod,
      fill = c(TRUE, FALSE))

