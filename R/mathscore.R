library(car)
library(heplots)
#library(DescTools)
library(dplyr)


data(mathscore, package = "heplots")

#' t-test
t.test(mathscore[, "BM"], mu = 150)

mathscore |> 
  filter(group == 1) |>
  select(BM) |>
  t.test(mu = 150)

mathscore |> 
  filter(group == 1) |>
  select(BM, WP) |>
  HotellingsT2Test(mu = c(100, 150))

# two-sample test
DescTools::HotellingsT2Test(cbind(BM, WP) ~ group, data=mathscore)

library(Hotelling)
ht <- hotelling.test(cbind(BM, WP) ~ group, data=mathscore)
str(ht)

T2 <- ht$stats$statistic
N <- nrow(mathscore)
p <- 2
(F <- ((N-p)/(p * (N-1))) * T2)




math.mod <- lm(cbind(BM, WP) ~ group, data=mathscore)
car::Anova(mod)

summary(Anova(mod))

print(summary(Anova(mod)), SSP=FALSE)


means <-  aggregate(cbind(BM, WP)~group, mean, data=mathscore)[,-1]


# use formula method for covEllipses

colors <- c("darkgreen", "blue")
covEllipses(cbind(BM, WP) ~ group, data = mathscore,
            pooled=FALSE, 
            col = colors,
            fill = TRUE, 
            fill.alpha = 0.05,
            cex=2, cex.lab=1.5,
            asp = 1,
            xlab="Basic math", ylab="Word problems")
# plot points
pch <- ifelse(mathscore$group==1, 15, 16)
col <- ifelse(mathscore$group==1, colors[1], colors[2])
points(mathscore[,2:3], pch=pch, col=col, cex=1.25)

# show S_p
covEllipses(cbind(BM, WP) ~ group, data = mathscore,
            col = c(colors, "red"),
            fill = c(FALSE, FALSE, TRUE), 
            fill.alpha = 0.3,
            cex=2, cex.lab=1.5,
            asp = 1,
            xlab="Basic math", ylab="Word problems")


# car::scatterplot(WP ~ BM | group, data=mathscore, 
# 	ellipse=list(levels=0.68), 
# 	smooth=FALSE, 
# 	pch=c(15,16), 
# 	asp = 1, 
# 	cex.lab = 1.5,
# 	legend=list(coords = "topright"),
# 	xlab="Basic math", ylab="Word problems"
# )


op <- par(mar=c(4,5,1,1)+.2)
heplot(mod, 
       fill=TRUE, lwd = 3,
       asp = 1,
       cex=2, cex.lab=1.8,
       xlab="Basic math", ylab="Word problems")
par(op)

library(candisc)
mod.can <- candisc(mod)
mod.can

plot(mod.can, var.lwd=3)

# t-test of canonical scores.
 t.test(Can1 ~ group, data=mod.can$scores)

# overlay with HEplot
covEllipses(cbind(BM, WP) ~ group, data = mathscore,
            pooled=FALSE, 
            col = colors,
            cex=2, cex.lab=1.5,
            asp=1, 
            xlab="Basic math", ylab="Word problems"
            )
pch <- ifelse(mathscore$group==1, 15, 16)
col <- ifelse(mathscore$group==1, "red", "blue")
points(mathscore[,2:3], pch=pch, col=col, cex=1.25)

math.mod <- lm(cbind(BM, WP) ~ group, data=mathscore)
heplot(math.mod, 
       fill=TRUE, 
       cex=2, cex.lab=1.8, 
  	   fill.alpha=0.2, lwd=c(1,3),
	     add = TRUE, 
       error.ellipse=TRUE)



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

# find group means
means <- mathscore |>
  group_by(group) |>
  summarize(BM = mean(BM), WP = mean(WP))

# why are these not orthogonal to the line???
for(i in 1:nrow(mathscore)) {
	gp <- mathscore$group[i]
	pt <- project_on( mathscore[i, 2:3], means[1,2:3], means[2,2:3]) 
#	print(pt)
	segments(mathscore[i, "BM"], mathscore[i, "WP"], pt[1], pt[2])
}
