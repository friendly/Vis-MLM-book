# matplot of iris

iS <- iris$Species == "setosa"
iV <- iris$Species == "versicolor"
iG <- iris$Species == "virginica"

# iris colors
colors <-c("blue", "darkgreen", "brown4")

#op <- par(bg = "bisque")
matplot(c(1, 8), c(0, 4.5), type =  "n", xlab = "Length", ylab = "Width",
        main = "Petal and Sepal Dimensions in Iris Flowers")
matpoints(iris[iS,c(1,3)], iris[iS,c(2,4)], pch = "sS", col = colors[1])
matpoints(iris[iV,c(1,3)], iris[iV,c(2,4)], pch = "vV", col = colors[2])
matpoints(iris[iG,c(1,3)], iris[iV,c(2,4)], pch = "gG", col = colors[3])

legend(1, 4, c("    Setosa petals", "    Setosa sepals",
               "Versicolor petals", "Versicolor sepals",
               "  Virginica petals", "  Virginica sepals"),
       pch = "sSvVgG", col = rep(colors, each=2))
#
#par(op)
