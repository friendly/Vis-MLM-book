# PCA demo
library(dplyr)
library(ggplot2)
library(car)

set.seed(1237)
n <- 15
Years <- round(runif(n, min=1, max = 15))
Salary <-  10 + 2 * Years + rnorm(n, 0, 8)
dat <- data.frame(Years, Salary)
cor(dat)
cov(dat)


#plot(dat)
dataEllipse(Salary ~ Years, data=dat, 
            levels = 0.68,
            pch = 16,
            cex=1.5)

# > cov(dat)
# Years Salary
# Years   13.3   29.0
# Salary  29.0   70.9

# get names?
install.packages("babynames")
library(babynames)
bn <- babynames::babynames |>
  filter(year > 2000) |>
  mutate(initial = substr(name, 1, 1)) |>
  subset(initial %in% LETTERS[1:n])
str(bn)

# Run PCA
pca <- princomp(dat)
load <- loadings(pca)
#pca <- prcomp(dat)

slope <- load[2, ] / load[1, ]
cmeans <- apply(dat, 2, mean)
intercept <- cmeans[2] - (slope * cmeans[1])
# perpendicular lines
x1 <- (dat[, 2] - intercept[1]) / slope[1]
y1 <- intercept[1] + slope[1] * dat[, 1]
x2 <- (x1 + dat[, 1]) / 2
y2 <- (y1 + dat[, 2]) / 2

plot <- data.frame(dat,x2=x2,y2=y2)

ggplot(plot,
       aes(x=Years, y=Salary)) +
  geom_point(size = 3) +
  stat_ellipse() +
  geom_abline(intercept=intercept[1],slope=slope[1]) 
#  geom_segment(aes(xend=x2,yend=y2), color="red") 
#  coord_fixed()
