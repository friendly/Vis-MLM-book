library(car)
library(heplots)
library(DescTools)
library(dplyr)

mathscore <- read.table(here::here("data", "mathscore.dat"), header=TRUE)
mathscore$group <- factor(mathscore$group)
str(mathscore)

save(mathscore, file = here::here("data", "mathscore.RData"))

#' t-test
t.test(mathscore[, "BM"], mu = 150)

mathscore |> 
  filter(group == 1) |>
  select(BM) |>
  t.test(mu = 150)

mathscore |> 
  filter(group == 1) |>
  select(BM, WP) |>
  HotellingsT2Test(mu = c(150, 150))



mod <- lm(cbind(BM, WP) ~ group, data=mathscore)
Anova(mod)

summary(Anova(mod))

print(summary(Anova(mod)), SSP=FALSE)

covEllipses(mathscore[,2:3], mathscore$group, pooled=FALSE, cex=2,
	xlab="Basic math", ylab="Word problems",
	main = "Methods of teaching algebra", cex.lab=1.5)

pch <- ifelse(mathscore$group==1, 15, 16)
col <- ifelse(mathscore$group==1, "red", "blue")
points(mathscore[,2:3], pch=pch, col=col, cex=1.25)

#scatterplot(WP ~ BM | group, data=mathscore, ellipse=TRUE, levels=0.68, smooth=FALSE, pch=c(15,16))

car::scatterplot(WP ~ BM | group, data=mathscore, 
	ellipse=list(levels=0.68), smooth=FALSE, pch=c(15,16), 
	legend=list(coords = "topright"))


op <- par(mar=c(4,5,1,1)+.2)
heplot(mod, fill=TRUE, cex=2, cex.lab=1.8,
	xlab="Basic math", ylab="Word problems")
par(op)

library(candisc)
mod.can <- candisc(mod)
mod.can

plot(mod.can, var.lwd=3)

# t-test of canonical scores.
 t.test(Can1 ~ group, data=mod.can$scores)

# overlay
covEllipses(mathscore[,2:3], mathscore$group, pooled=FALSE, cex=2,
	xlab="Basic math", ylab="Word problems",
#	xlim=c(120,220),
	asp=1,
	main = "Methods of teaching algebra", cex.lab=1.5)

pch <- ifelse(mathscore$group==1, 15, 16)
col <- ifelse(mathscore$group==1, "red", "blue")
points(mathscore[,2:3], pch=pch, col=col, cex=1.25)

heplot(mod, fill=TRUE, cex=2, cex.lab=1.8, 
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
