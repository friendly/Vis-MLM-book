library(car)
library(heplots)
library(candisc)
library(mvinfluence)

data(Pottery, package = "carData")

#scatterplotMatrix(~ Al + Fe + Mg + Ca + Na | Site, data=Pottery)

pottery.mlm <- lm(cbind(Al, Fe, Mg, Ca, Na) ~ Site, data = Pottery)

heplot(pottery.mlm,
       fill = TRUE, fill.alpha = 0.1)

cqplot(pottery.mlm, id.n = 5)

influencePlot(pottery.mlm, id.n =4)
influencePlot(pottery.mlm, id.n =4, type = "LR")


pottery.rlm <- robmlm(cbind(Al, Fe, Mg, Ca, Na) ~ Site, data = Pottery)

plot(pottery.rlm, segments = TRUE)

plot(pottery.rlm, col=Pottery$Site, segments=TRUE)
xloc <- c(7.5, 15.5, 19.5, 24)
text(xloc, rep(c(1.0, 1.05), length=5), 
     levels(Pottery$Site), pos =3, xpd = TRUE)


# heplots to see effect of robmlm vs. mlm
heplot(pottery.mlm, cex=1.3, lty=1)
heplot(pottery.rlm, 
       add=TRUE, error.ellipse=TRUE, 
       lwd=c(2,2), lty=c(2,2), 
       term.labels=FALSE, err.label="")
