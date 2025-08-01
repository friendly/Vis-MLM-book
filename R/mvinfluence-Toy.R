# toy example for multivariate influence
# from: Barrett (2003)

library(tibble)
library(ggplot2)
library(car)
library(mvinfluence)
library(patchwork)

Toy <- tibble(
   case = 1:9,
   x =  c(1,    1,    2,    2,    3,    3,    4,    4,    10),
   y1 = c(0.10, 1.90, 1.00, 2.95, 2.10, 4.00, 2.95, 4.95, 10.00),
   y2 = c(0.10, 1.80, 1.00, 2.93, 2.00, 4.10, 3.05, 4.93, 10.00)
)

scatterplotMatrix(~y1 + y2 + x, data=Toy, cex=2,
                  col = "blue", pch = 16, 
                  id = list(n=1, cex=2), 
                  regLine = list(lwd = 2, col="red"),
                  smooth = FALSE)

#rgl::setupKnitr(autoprint = TRUE)
car::scatter3d(y1 ~ y2 + x, data=Toy,
               ellipsoid = TRUE,
               radius = c(rep(1,8), 2),
               grid.col = "pink", grid.lines = 10, fill = FALSE,
               id = list(n=1), offset=2
)
# needs: rgl::rglwidget()

# Table 1, p.670
Toy.lm1 <- lm(y1 ~ x, data=Toy)
Toy.lm2 <- lm(y2 ~ x, data=Toy)
Toy.mlm <- lm(cbind(y1, y2) ~ x, data=Toy)

coef(Toy.lm1)
coef(Toy.lm2)
coef(Toy.mlm)

# or, using broom::tidy
broom::tidy(Toy.lm1)
broom::tidy(Toy.lm2)
broom::tidy(Toy.mlm)

broom::glance(Toy.lm1)
broom::glance(Toy.lm2)
# But there is no glance method for an mlm
# broom::glance(Toy.mlm)



# Cook's distance
df <- Toy
df$D1  <- cooks.distance(Toy.lm1)
df$D2  <- cooks.distance(Toy.lm2)
df$D12 <- cooks.distance(Toy.mlm)

df

ip1 <- car::influencePlot(Toy.lm1, id=list(cex=1.5), cex.lab=1.5)
ip2 <- car::influencePlot(Toy.lm2, id=list(cex=1.5), cex.lab=1.5)

influencePlot(Toy.mlm, type = "stres",
              id.n=2, id.cex = 1.3,
              cex.lab = 1.5)

influencePlot(Toy.mlm, type="LR",
              id.n=2, id.cex = 1.3,
              cex.lab = 1.5)

stats::hatvalues(Toy.mlm)
mvinfluence::hatvalues.mlm(Toy.mlm)

(inf1 <- influence.measures(Toy.lm1))
(inf2 <- influence.measures(Toy.lm2))


# Figure 1: DFBETAs
# use dfbetas instead
db1 <- as.data.frame(dfbetas(Toy.lm1))
gg1 <- ggplot(data = db1, aes(x=`(Intercept)`, y=x, label=rownames(db1))) +
  geom_point(size=1.5) +
  geom_label(size=6, fill="pink") +
  xlab(expression(paste("Deletion Intercept  ", b[0]))) +
  ylab(expression(paste("Deletion Slope  ", b[1]))) +
  ggtitle("dfbetas for y1") +
  theme_bw(base_size = 16)


db2 <- as.data.frame(dfbetas(Toy.lm2))
gg2 <- ggplot(data = db2, aes(x=`(Intercept)`, y=x, label=rownames(db2))) +
  geom_point(size=1.5) +
  geom_label(size=6, fill="pink") +
  xlab(expression(paste("Deletion Intercept  ", b[0]))) +
  ylab(expression(paste("Deletion Slope  ", b[1]))) +
  ggtitle("dfbetas for y2") +
  theme_bw(base_size = 16)

gg1 + gg2

# dfbetas for the mlm
db12 <- dfbetas(Toy.mlm)
db12.1 <- as.data.frame(db12[,"y1",])
ggplot(data = db12.1, aes(x=`(Intercept)`, y=x, label=rownames(db1))) +
  geom_point(size=1.5) +
  geom_label(size=6, fill="pink") +
  xlab(expression(paste("Deletion Intercept  ", b[0]))) +
  ylab(expression(paste("Deletion Slope  ", b[1]))) +
  ggtitle("dfbetas for y1") +
  theme_bw(base_size = 16)


db12 <- dfbetas(Toy.mlm)
db12 <- as.data.frame.array(db12)
colnames(db12) <- c("y1.b0", "y1.b1", "y2.b0", "y2.b1")
#scatterplotMatrix(db12)

ggplot(data = db12, aes(x=y1.b0, y=y2.b1, label=rownames(db12))) +
  geom_point(size=1.5) +
  geom_label(size=6, fill="pink") 
  

# other stats:: measures
rstandard(Toy.mlm)
rstudent(Toy.mlm)
dffits(Toy.mlm)
covratio(Toy.mlm)

# John: ill-conditioning

with(Toy, cor(y1, y2))

(corr <- cov2cor(vcov(Toy.mlm)))

car::confidenceEllipse(Toy.mlm, which=c(1,2), levels = 0.68,
                       xlab = row.names(corr)[1], 
                       ylab = row.names(corr)[2],
                       fill = TRUE, fill.alpha = 0.2)

car::confidenceEllipse(Toy.mlm, which=c(1,3), levels = 0.68,
                       xlab = row.names(corr)[1], 
                       ylab = row.names(corr)[3],
                       fill = TRUE, fill.alpha = 0.2,
                       cex.lab = 1.5)

car::confidenceEllipse(Toy.mlm, which=c(2,4), levels = 0.68,
                       xlab = row.names(corr)[2], 
                       ylab=row.names(corr)[4],
                       fill = TRUE, fill.alpha = 0.2,
                       cex.lab = 1.5)

heplots::coefplot(Toy.mlm)
# FIXME
# Error in coefplot.mlm(Toy.mlm) : There are only 0 response variables.

# try JF's new version
source(here("extra", "confidenceEllipses.R"))

data(Duncan, package="carData")
m <- lm(prestige ~ income + education + type, data=Duncan)
confidenceEllipses(m)
confidenceEllipses(m, fill=TRUE)

confidenceEllipses(Toy.mlm, fill=TRUE)



#car::dfbetasPlots(Toy.lm1)

# gives an error
#influence.measures(Toy.mlm)

mlm.influence(Toy.mlm)



