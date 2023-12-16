#' ---
#' title: banknote data
#' ---

data(banknote, package= "mclust")
library(ggbiplot)
library(ggplot2)
library(MASS)
library(heplots)
library(candisc)

banknote.pca <- prcomp(banknote[, -1], scale = TRUE)
banknote.pca

ggbiplot(banknote.pca,
   obs.scale = 1, var.scale = 1,
   groups = banknote$Status,
    ellipse = TRUE, 
    ellipse.level = 0.5, ellipse.alpha = 0.1, ellipse.linewidth = 0,
    varname.size = 4,
    varname.color = "black") +
  labs(fill = "Status", color = "Status") +
  theme_minimal(base_size = 14) +
  theme(legend.direction = 'horizontal', legend.position = 'top')

banknote.lda <- lda(Status ~ Length + Left + Right + Bottom + Top + Diagonal,
                    data = banknote)
banknote.lda

plot(banknote.lda, dimen=1)


scores <- as.matrix(banknote[, -1]) %*% banknote.lda$scaling
boxplot(scores ~ banknote$Status)

fit <- predict(banknote.lda) |> as.data.frame()
boxplot(LD1 ~ class, data=fit)

banknote.mlm <- lm(cbind(Length, Left, Right, Bottom, Top, Diagonal) ~ Status,
                   data=banknote)

pairs(banknote.mlm)

banknote.can <- candisc(banknote.mlm)
banknote.can

plot(banknote.can)
