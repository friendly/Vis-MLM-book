library(MASS)
#library(ggord)
library(ggplot2)
library(patchwork)

data(peng, package="heplots")
source("R/penguin/penguin-colors.R")


peng_new <- data.frame(
  species = rep(NA, 5),
  island = rep("Z", 5),
  bill_length = c(35, 52, 52, 50, 40),
  bill_depth= c(18, 20, 15, 16, 15),
  flipper_length = c(220, 190, 210, 190, 195),
  body_mass = c(5000, 3900, 4000, 3500, 5500),
  sex = c("m", "f", "f", "m", "f"),
  row.names = c("Abe", "Betsy", "Chloe", "Dave", "Emma")
  )
peng_new

peng.lda <- lda(species ~ bill_length + bill_depth + flipper_length + body_mass, 
                data = peng)
peng.lda


peng_pred <- predict(peng.lda, newdata = peng_new) |>
  print(digits = 4)

class <- peng_pred$class 
posterior <- peng_pred$posterior
maxp <- apply(posterior, 1, max)
data.frame(class, round(posterior, 4), maxp)

#zapsmall(peng_pred$posterior)

pred_lda <- function(object, newdata, ...) {
  if (missing(newdata)) {
    newdata <- insight::get_modelmatrix(object) |>
      as.data.frame() |>
      dplyr::select(-"(Intercept)") 
  }
  nv <- ncol(newdata)
  pred <- predict(object, newdata, type = "prob")
  class <- pred$class
  probs <- pred$posterior
  maxp <- apply(probs, 1, max)

    # get response variable name
  response <- insight::find_response(object)
  
  ret <- cbind(newdata, class, maxp)
  colnames(ret)[nv+1] <- response
  ret
}


pred_lda(peng.lda, newdata = peng_new[, -1])

# try predict_discrim
# 
source("R/predict_discrim.R")

pred <- predict_discrim(peng.lda, newdata = peng_new[, 3:6]) |>
  print()

ggplot2::theme_set(ggplot2::theme_bw(base_size = 16))

theme_penguins <- list(
  scale_color_penguins(shade="dark"),
  scale_fill_penguins(shade="dark"))
legend_inside <- function(position) {
  theme(legend.position = "inside",
        legend.position.inside = position)
}

p1 <- ggplot(peng, 
       aes(x = bill_length, y = bill_depth,
           color = species, shape = species, fill=species)) +
  geom_point(size=2) +
  stat_ellipse(geom = "polygon", level = 0.95, alpha = 0.4) +
  geom_label(data = pred, label=row.names(pred), 
             fill="white", size = 5, fontface="bold") +
  theme_penguins +
  legend_inside(c(0.87, 0.15))

p2 <- ggplot(peng, 
       aes(x = flipper_length, y = body_mass,
           color = species, shape = species, fill=species)) +
  geom_point(size=2) +
  stat_ellipse(geom = "polygon", level = 0.95, alpha = 0.4) +
  geom_label(data = pred, label=row.names(pred), 
             fill="white", size = 5, fontface="bold") +
  theme_penguins +
  legend_inside(c(0.87, 0.15))

p1 + p2

# plots in discrim space
# 
# default plot from MASS
# 
op <- par(mar = c(4, 4, 1, 1)+.5)
plot(peng.lda)
par(op)

plot(peng.lda, abbrev = 1)


pred <- predict_discrim(peng.lda, 
                        newdata = peng_new[, 3:6],
                        scores = TRUE)
print(pred[, -(1:4)])

# get variance proportions for axis labels
svd <- peng.lda$svd
var <- 100 * round(svd^2/sum(svd^2), 3)
labs <- glue::glue("Discriminant dimension {1:2} ({var}%)")

panel.pts <- function(x, y, ...) points(x, y, ...)
col <- peng.colors()
plot(peng.lda, 
     panel = panel.pts,
     col = col[peng$species],
     pch = (15:17)[peng$species],
     xlab = labs[1],
     ylab = labs[2],
     ylim = c(-6, 6),
     cex.lab = 1.3
)


# get LD scores for the new observations
with(pred,{
     points(LD1, LD2, pch = 16, col = "black", cex = 2)
     text(LD1, LD2, label=row.names(pred),
          col = col[species], cex = 1.3, font = 2,
          pos = c(3, 1, 1, 1, 3),
          xpd = TRUE)
  })


pred_all <- predict_discrim(peng.lda, scores=TRUE)

# labels, rather than a legend
# WHY IS THIS WRONG?
means <- pred_all |>
#  group_by(species) |>
  summarise(LD1 = mean(LD1),
            LD2 = mean(LD2), .by = species)
text(means, labels = means$species)  

# add data ellipses
dataEllipse(LD2 ~ LD1 | species, data = pred_all,
            levels = 0.68, fill=TRUE, fill.alpha = 0.1,
            group.labels = NULL,
            add = TRUE, plot.points = FALSE,
            col = col)


