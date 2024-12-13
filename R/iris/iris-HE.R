library(heplots)
library(candisc)
library(car)
#source("R/util/text.usr.R")

data(iris)
contrasts(iris$Species) <- matrix(c(0,-1,1, 2, -1, -1), 3,2)
contrasts(iris$Species)

iris.mod <- lm(cbind(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width) ~
                 Species, data=iris)

Anova(iris.mod)

summary(iris.mod)

summary(iris.mod, univariate = TRUE)

# tests for each response

glance(iris.mod)

op <- par(mar = c(4, 4, 1, 1) + .5)
heplot(iris.mod, size = "effect",
       cex = 1.5, cex.lab = 1.5,
       fill=TRUE, fill.alpha=c(0.3,0.1),
       xlim = c(2,10), ylim = c(1.4,4.6))
text(10, 4.5, expression(paste("Effect size scaling:", bold(H) / df[e])), 
     pos = 2, cex = 1.2)

heplot(iris.mod, size = "evidence",
       cex = 1.5,
       fill=TRUE, fill.alpha=c(0.3,0.1),
       xlim = c(2,10), ylim = c(1.4,4.6))
text(10, 4.5, expression(paste("Significance scaling:", bold(H) / (lambda[alpha] * df[e]))), 
     pos = 2, cex = 1.2)
par(op)

pairs(iris.mod,
      fill=TRUE, fill.alpha=c(0.3,0.1)
)

# show contrasts
hyp <- list("V:V"="Species1","S:VV"="Species2")
heplot(iris.mod, hypotheses=hyp,
       cex = 1.5, cex.lab = 1.5,
       fill=TRUE, fill.alpha=c(0.3,0.1),
       col = c("red", "blue", "darkgreen", "darkgreen"),
       lty=c(0,0,1,1), label.pos=c(3, 1, 2, 1),
       xlim = c(2,10), ylim = c(1.4,4.6))
# compare with effect-size scaling
#heplot(iris.mod, hypotheses=hyp, size="effect", add=TRUE)

# try filled ellipses; include contrasts
heplot(iris.mod, hypotheses=hyp, fill=TRUE, 
       fill.alpha=0.2, col=c("red", "blue"))
heplot(iris.mod, hypotheses=hyp, fill=TRUE, 
       col=c("red", "blue"), lty=c(0,0,1,1))

# vary label position and fill.alpha
heplot(iris.mod, hypotheses=hyp, fill=TRUE, fill.alpha=c(0.3,0.1), col=c("red", "blue"), 
       lty=c(0,0,1,1), label.pos=0:3)
