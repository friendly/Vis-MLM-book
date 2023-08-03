library(car)
library(heplots)
#library(DescTools)
library(dplyr)
library(ggplot2)


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

summary(Anova(math.mod))

print(summary(Anova(math.mod)), SSP=FALSE)


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
heplot(math.mod, 
       fill=TRUE, lwd = 3,
       asp = 1,
       cex=2, cex.lab=1.8,
       xlab="Basic math", ylab="Word problems")
par(op)

library(candisc)
math.can <- candisc(math.mod)
math.can

plot(math.can, var.lwd=3)

# t-test of canonical scores.
t.test(Can1 ~ group, data=math.can$scores)
t.test(Can1 ~ group, data=math.can$scores)$statistic

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
# project_on <- function(A, L1, L2) {
# 	A <- as.numeric(A)
# 	L1 <- as.numeric(L1)
# 	L2 <- as.numeric(L2)
# 	dot <- function(x,y) sum( x * y)	
# 	t <- dot(L2-L1, A-L1) / dot(L2-L1, L2-L1)
# 	C <- L1 + t*(L2-L1)
# 	C
# }
# viz. geometry::dot
dot <- function(x, y) sum(x*y)
project_on <- function(a, p1, p2) {
  a <- as.numeric(a)
  p1 <- as.numeric(p1)
  p2 <- as.numeric(p2)
  dot <- function(x,y) sum( x * y)	
  d <- dot(p2-p1, a-p1) / dot(p2-p1, p2-p1)
  C <- p1 + t*(p2-p1)
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

# discriminant analysis

(math.lda <- MASS::lda(group ~ ., data=mathscore))

math.lda$scaling

as.matrix(mathscore[, 2:3]) %*% math.lda$scaling

scores <- cbind(group = mathscore$group,
                as.matrix(mathscore[, 2:3]) %*% math.lda$scaling)
scores <- cbind(group = mathscore$group,
                as.matrix(mathscore[, 2:3]) %*% math.lda$scaling) |>
  as.data.frame()

scores |>
  group_by(group) |>
  slice(1:3)


t.test(LD1 ~ group, data=scores)$statistic


# boxplots of scores

scores <- mathscore |>
  bind_cols(LD1 = scores[, "LD1"]) 

scores |>
  tidyr::gather(key = "measure", value ="Score", BM:LD1) |>
  mutate(measure = factor(measure, levels = c("BM", "WP", "LD1"))) |>
  ggplot(aes(x = group, y = Score, color = group, fill = group)) +
    geom_violin(alpha = 0.2) +
    geom_jitter(width = .2, size = 2) +
    facet_grid( ~ measure, 
#                levels = c("BM", "WP", "LD1"),
                scales = "free", labeller = label_both) +
    scale_fill_manual(values = c("darkgreen", "blue")) +
    scale_color_manual(values = c("darkgreen", "blue")) +
    theme_bw(base_size = 14)
  


  