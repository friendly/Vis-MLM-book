# cars data - collinearity diagnostics examples


library(VisCollin)
library(car)         # for vif
library(dplyr)

data(cars, package = "VisCollin")

# correlation matrix of predictors

R <- cars |>
  select(cylinder:year) |>
  tidyr::drop_na() |>
  cor()

100 * R |> round(digits = 2)

library(corrplot)
corrplot.mixed(R, lower = "square", upper = "ellipse", tl.col = "black")


# model
cars.mod <- lm (mpg ~ cylinder + engine + horse + weight + accel + year,
                data=cars)
vif(cars.mod)

cars.mod2 <- lm (mpg ~ cylinder + engine + horse + weight + accel + year + origin,
                data=cars)
vif(cars.mod2)


# SAS: / collin option
#colldiag(cars.mod)

# SAS: / collinnoint option
cd <- colldiag(cars.mod, add.intercept=FALSE, center=TRUE)

# simplified display
print(colldiag(cars.mod, add.intercept=FALSE, center=TRUE), fuzz=.3)

tableplot(cd)

# Biplots
# cars.numeric  <- cars[,sapply(cars,is.numeric)]
# cars.complete <- cars.numeric[complete.cases(cars.numeric),]

cars.X <- cars |>
  select(where(is.numeric)) |>
  select(-mpg) |>
  tidyr::drop_na()
cars.pca <- prcomp(cars.X, scale. = TRUE)
cars.pca

cars.pca.save <- cars.pca

# NB: The relative scaling of the variable vectors and scores differs
#     from the SAS versions.
# standard biplot of predictors

# Make labels for dimensions include % of variance
pct <- 100 *(cars.pca$sdev^2) / sum(cars.pca$sdev^2)
lab <- glue::glue("Dimension {1:6} ({round(pct, 2)}%)")

# reflect and scale dimensions
cars.pca$rotation <- -cars.pca$rotation

op <- par(lwd = 2, xpd = NA )
biplot( cars.pca,
        scale=0.5,
        cex=c(0.6,1),
        col = c("black", "blue"),
        expand = 1.7,
        xlab = lab[6],
        ylab = lab[5]
)
par(op)

#last 2 dimensions for VIF
op <- par(lwd = 2, xpd = NA )
biplot(cars.pca,
       choices=6:5,           # only the last two dimensions
       scale=0.5,             # symmetric biplot scaling
       cex=c(0.6, 1),         # character sizes for points and vectors
       col = c("black", "blue"),
       expand = 1.7,          # expand variable vectors for visibility
       xlab = lab[6],
       ylab = lab[5],
       xlim = c(-0.7, 0.5),
       ylim = c(-0.8, 0.5)
)
par(op)

# try factoextra

library(factoextra)

# scale the variable vectors

cars.pca <- cars.pca.save
cars.pca$rotation <- -2.5 * cars.pca$rotation

ggp <- fviz_pca_biplot(
  cars.pca,
  axes = 6:5,
  geom = "point",
  col.var = "blue",
  labelsize = 5,
  pointsize = 1.5,
  arrowsize = 1.5,
  addEllipses = TRUE,
  ggtheme = ggplot2::theme_bw(base_size = 14),
  title = "Collinearity biplot for cars data")

# add point labels for outlying points
dsq <- heplots::Mahalanobis(cars.pca$x[, 6:5])
scores <- as.data.frame(cars.pca$x[, 6:5])
scores$name <- rownames(scores)

library(ggrepel)
ggp + geom_text_repel(data = scores[dsq > qchisq(0.95, df = 6),],
                aes(x = PC6,
                    y = PC5,
                    label = name),
                vjust = -0.5,
                size = 5)


library(ggbiplot)

cars.pca <- reflect(cars.pca.save, columns = 5:6)
# why no ellipse?
ggbiplot(cars.pca,
         choices = 6:5,
         obs.scale = 1, var.scale = 1,
         point.size = 1,
         var.factor =10,
         varname.size = 4,
         varname.color = "blue",
         ellipse = TRUE,
         ellipse.prob = 0.5, ellipse.alpha = 0.1,
         axis.title = "Dim") +
  theme_bw(base_size = 14)


