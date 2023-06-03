# folder <- "C:/Dropbox/Documents/6140/R"
# folder <- "C:/Users/friendly/Dropbox/Documents/6140/R"

data(mathscore, package="heplots")

library(car)
library(heplots)

math.mod <- lm(cbind(BM, WP) ~ group, data=mathscore)
Anova(math.mod)

summary(Anova(math.mod))

print(summary(Anova(math.mod)), SSP=FALSE)

png(filename="mathscore-covellipses.png", height=480, width=480)
op <- par(mar=c(4,4,1,1)+0.5)
cols <- c("darkgreen", "blue", "red")
covEllipses(mathscore[,2:3], mathscore$group, cex=2,
	xlab="Basic math", ylab="Word problems",
	fill = c(FALSE, FALSE, TRUE),
	col = cols,
#	main = "Methods of teaching algebra", 
	cex.lab=1.5
	)
par(op)
dev.off()



pch <- ifelse(mathscore$group==1, 15, 16)
col <- ifelse(mathscore$group==1, "darkgreen", "blue")
points(mathscore[,2:3], pch=pch, col=col, cex=1.25)

#scatterplot(WP ~ BM | group, data=mathscore, ellipse=TRUE, levels=0.68, smooth=FALSE, pch=c(15,16))

car::scatterplot(WP ~ BM | group, data=mathscore, 
                 xlab="Basic math", ylab="Word problems",
                 ellipse=list(levels=0.68), smooth=FALSE, 
                 xlim = c(130, 210),
                 pch=c(15,16), col=cols,
                 legend=list(coords = "topright"))

# ANCOVA model

math.ancova <- lm(WP ~ BM + group, data=mathscore)
Anova(math.ancova)

coef(math.ancova)

# HE plot

op <- par(mar=c(4,5,1,1)+.2)
heplot(math.mod, fill=TRUE, cex=2, cex.lab=1.8,
	xlab="Basic math", ylab="Word problems")
par(op)


## Multivariate tests: H & E matrices
math.aov <- Anova(math.mod)
H <- math.aov$SSP
E <- math.aov$SSPE


resids <- residuals(math.mod)
crossprod(resids)

fit <- fitted(math.mod)
ybar <- colMeans(mathscore[,2:3])
n <- nrow(mathscore)
crossprod(fit) - n * outer(ybar, ybar)


# E matrix

covEllipses(mathscore[,2:3], mathscore$group, 
            pooled=TRUE, cex=2,
            xlab="Basic math", ylab="Word problems",
          	xlim=c(120,220),
            fill = c(F, F, T),
            asp=1,
            cex.lab=1.5)


# Discriminant analysis

mod.lda <- MASS::lda(group ~ ., mathscore)

mod.lda
names(mod.lda)

library(candisc)
mod.can <- candisc(math.mod)
mod.can

mod.can$structure
mod.can$scores

png(filename="mathscore-can.png", height=480, width=480)
op <- par(mar=c(4,4,1,1)+0.5)
plot(mod.can, var.lwd=3, points.1d = TRUE, pch=c(15,16), col=cols)
par(op)
dev.off()

# t-test of canonical scores.
 t.test(Can1 ~ group, data=mod.can$scores)

# overlay
covEllipses(mathscore[,2:3], mathscore$group, pooled=FALSE, cex=2,
	xlab="Basic math", ylab="Word problems",
#	xlim=c(120,220),
	asp=1,
	main = "Methods of teaching algebra", 
  cex.lab=1.5)

pch <- ifelse(mathscore$group==1, 15, 16)
col <- ifelse(mathscore$group==1, "red", "blue")
points(mathscore[,2:3], pch=pch, col=col, cex=1.25)

heplot(math.mod, fill=TRUE, cex=2, cex.lab=1.8, 
	col=c("red", "black"), fill.alpha=0.2, lwd=c(1,3),
	xlab="Basic math", ylab="Word problems", add=TRUE, error.ellipse=TRUE)

means <-  aggregate(cbind(BM, WP)~group, mean, data=mathscore)[,-1]

# find projection of point A on line between L1 and L2
project_on <- function(A, L1, L2) {
	A <- as.numeric(A)
	L1 <- as.numeric(L1)
	L2 <- as.numeric(L2)
	dot <- function(x,y) sum( x * y)	
	t <- dot(L2-L1, A-L1) / dot(L2-L1, L2-L1)
	C <- L1 + t*(L2-L1)
	C
}

# why are these not orthogonal to the line???
for(i in 1:nrow(mathscore)) {
	gp <- mathscore$group[i]
	pt <- project_on( mathscore[i, 2:3], means[1,], means[2,]) 
#	print(pt)
	segments(mathscore[i, "BM"], mathscore[i, "WP"], pt[1], pt[2])
}


### try Hotelling package

if (!require("Hotelling")) install.packages("Hotelling")
library(Hotelling)
#hotelling.stat(mathscore[1:6,-1], mathscore[7:12,-1])

t2 <- hotelling.test(. ~ group, data=mathscore)
t2

# compare multivariate test with univariate tests

Anova(lm(BM ~ group, data=mathscore))
Anova(lm(WP ~ group, data=mathscore))

boxplot(BM ~ group, data=mathscore)


