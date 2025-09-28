if (!require(genridge)) {install.packages("genridge"); library(genridge)}
library(splines)

# use a wider range of lambda for these figures
lambda <- c(0, 0.001, 0.0025, 0.005, 0.01, 0.02, 0.04, 0.08)
lambdaf <- c("0", ".001", ".0025", ".005", ".01", ".02", ".04", ".08")

# Ridge regression: Longley data
lridge <- ridge(Employed ~ GNP + Unemployed + Armed.Forces + Population + Year + GNP.deflator, 
		data=longley, lambda=lambda)

clr <- c("black", rainbow(length(lambda)-1, start=.6, end=.1))
(pdat <- precision(lridge))

##############################
# Figure 6(a)
op <- par(mar=c(4, 4, 1, 1) + 0.2)
with(pdat, {
	plot(norm.beta, det, type="b", 
	cex.lab=1.25, pch=16, cex=1.5, col=clr, lwd=2,
  xlab='shrinkage: ||b|| / max(||b||)',
	ylab='variance: log |Var(b)|')
	text(norm.beta, det, lambdaf, cex=1.35, pos=c(rep(2,length(lambda)-1),4))
	text(min(norm.beta), max(det), "log |Variance| vs. Shrinkage", cex=1.5, pos=4)
	})
mod <- lm(cbind(det, norm.beta) ~ bs(lambda, df=5), data=pdat)
x <- data.frame(lambda=c(lridge$kHKB, lridge$kLW))
fit <- predict(mod, x)
points(fit[,2:1], pch=15, col=gray(.20), cex=1.5)
text(fit[,2:1], c("HKB", "LW"), pos=4, cex=1.25, col=gray(.20))
par(op)

#dev.copy2eps(file="fig/precision-var1.eps")
#dev.copy2pdf(file="fig/precision-var1.pdf")

# Figure 6(b)
op <- par(mar=c(4, 4, 1, 1) + 0.2)
with(pdat, {
	plot(norm.beta, trace, type="b",
	cex.lab=1.25, pch=16, cex=1.5, col=clr, lwd=2,
  xlab='shrinkage: ||b|| / max(||b||)',
	ylab='variance: trace [Var(b)]')
	text(norm.beta, trace, lambdaf, cex=1.25, pos=c(2, rep(4,length(lambda)-1)))
	text(min(norm.beta), max(trace), "tr(Variance) vs. Shrinkage", cex=1.5, pos=4)
	})
mod <- lm(cbind(trace, norm.beta) ~ bs(lambda, df=5), data=pdat)
x <- data.frame(lambda=c(lridge$kHKB, lridge$kLW))
fit <- predict(mod, x)
points(fit[,2:1], pch=15, col=gray(.20), cex=1.5)
text(fit[,2:1], c("HKB", "LW"), pos=3, cex=1.25, col=gray(.20))
par(op)

#dev.copy2eps(file="fig/precision-var2.eps")
#dev.copy2pdf(file="fig/precision-var2.pdf")
#
# Figure 8.4
op <- par(mar=c(4, 4, 1, 1) + 0.2)
library(splines)
with(pdat, {
	plot(norm.beta, det, type="b", 
	     cex.lab=1.25, pch=16, 
	     cex=1.5, col=clr, lwd=2,
       xlab='shrinkage: ||b|| / max(||b||)',
       ylab='variance: log |Var(b)|')
	text(norm.beta, det, 
	     labels = lambdaf, 
	     cex = 1.25, 
	     pos = c(rep(2,length(lambda)-1),4))
	text(min(norm.beta), max(det), 
	     labels = "log |Variance| vs. Shrinkage", 
	     cex=1.5, pos=4)
	})
# find locations for optimal shrinkage criteria
mod <- lm(cbind(det, norm.beta) ~ bs(lambda, df=5), 
          data=pdat)
x <- data.frame(lambda=c(lridge$kHKB, 
                         lridge$kLW))
fit <- predict(mod, x)
points(fit[,2:1], pch=15, 
       col=gray(.82), cex=1.6)
text(fit[,2:1], c("HKB", "LW"), 
     pos=3, cex=1.5, col=gray(.20))


# Use plot method for precision objects

pridge <- precision(lridge) |> print()
plot(pridge)

criteria <- lridge$criteria
names(criteria) <- sub("k", "", names(criteria))
plot(pridge, criteria = criteria, 
     cex.lab = 1.5,
     xlab ='shrinkage: ||b|| / max(||b||)',
     ylab='variance: log |Var(b)|'
     )
with(pdat, {
  	text(min(norm.beta), max(det), 
	     labels = "log |Variance| vs. Shrinkage", 
	     cex=1.5, pos=4)
  })

# use df for labels
plot(pridge, criteria = criteria, 
     labels="df", label.prefix="df:",
     cex.lab = 1.5,
     xlab ='shrinkage: ||b|| / max(||b||)',
     ylab='variance: log |Var(b)|'
     )
with(pdat, {
  	text(min(norm.beta), max(det), 
	     labels = "log |Variance| vs. Shrinkage", 
	     cex=1.5, pos=4)
  })
