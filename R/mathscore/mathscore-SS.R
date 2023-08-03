data(mathscore, package="heplots")

library(car)
library(heplots)
library(dplyr)

setwd("C:/Users/friendly/Dropbox/Documents/SCS/VisMLM-course/fig/mathscore")

math.mod <- lm(cbind(BM, WP) ~ group, data=mathscore)
Anova(math.mod)

pch <- ifelse(mathscore$group==1, 15, 16)
col <- ifelse(mathscore$group==1, "darkgreen", "blue")
cols <- c("darkgreen", "blue")

#points(mathscore[,2:3], pch=pch, col=col, cex=1.25)

grandmean <- colMeans(mathscore[,2:3])
grandmean <- c(group=0, grandmean)

gpmeans <- mathscore %>% group_by(group) %>% summarize(BM=mean(BM), WP=mean(WP))

gpmeansx <- mathscore %>% group_by(group) %>% mutate(BM=mean(BM), WP=mean(WP)) %>% ungroup()

# Show total SSP

png(filename="mathscore-SST.png", height=480, width=480)

op <- par(mar=c(4,4,1,1)+0.5)
scatterplot(WP ~ BM | group, data=mathscore, 
         xlab="Basic math", ylab="Word problems",
         ellipse=FALSE, smooth=FALSE,
         regLine = FALSE,
         grid = FALSE,
         xlim = c(130, 210),
         pch=c(15,16), col=cols,
         cex.lab = 1.5, cex = 1.5,
         legend=list(coords = "topright"))
points(grandmean[2], grandmean[3], pch = "+", cex=3)
points(gpmeans[,2:3], pch = "+", col=c("darkgreen", "blue"), cex=3)

arrows(grandmean[2], grandmean[3], mathscore[,2], mathscore[,3], 
		col=col, length=.2, angle=10, lwd=2) 
dataEllipse(mathscore[,2], mathscore[,3], 
		plot.points=FALSE, add=TRUE, fill=TRUE, col="grey",
		levels = 0.68, fill.alpha=0.2)
text(130, 145, "Total", cex=3.5, pos=4)
par(op)

dev.off()


# Show SSE

png(filename="mathscore-SSE.png", height=480, width=480)

op <- par(mar=c(4,4,1,1)+0.5)
scatterplot(WP ~ BM | group, data=mathscore, 
         xlab="Basic math", ylab="Word problems",
         ellipse=list(levels=0.68, fill.alpha=0.2), 
         smooth=FALSE, 
         regLine = FALSE,
         grid = FALSE,
         xlim = c(130, 210),
         pch=c(15,16), col=cols,
         cex.lab = 1.5, cex = 1.5,
         legend=FALSE)

#points(gpmeans[,2:3], pch = "+", col=c("darkgreen", "blue"), cex=3)
gpmx <- as.data.frame(gpmeansx)
arrows(gpmx[,2], gpmx[,3], mathscore[,2], mathscore[,3],
		col=col, length=.2, angle=10, lwd=2) 
text(130, 145, "Within", cex=3.5, pos=4)

par(op)
dev.off()

# Show SSH

png(filename="mathscore-SSH.png", height=480, width=480)
op <- par(mar=c(4,4,1,1)+0.5)
scatterplot(WP ~ BM | group, data=mathscore, 
         xlab="Basic math", ylab="Word problems",
         ellipse=FALSE, 
         smooth=FALSE, 
         regLine = FALSE,
         grid = FALSE,
         xlim = c(130, 210),
         pch=c(15,16), col=cols,
         cex.lab = 1.5, cex = 1.5,
         legend=FALSE)
points(grandmean[2], grandmean[3], pch = "+", cex=3)
points(gpmeans[,2:3], pch = "+", col=c("darkgreen", "blue"), cex=6)

dataEllipse(jitter(gpmx[,2], amount=0.75), jitter(gpmx[,3], amount=0.75), 
		plot.points=FALSE, add=TRUE, fill=TRUE, col="skyblue",
		levels = 0.68, fill.alpha=0.2)

gpm <- as.data.frame(gpmeans)
arrows(grandmean[2], grandmean[3], gpm[,2], gpm[,3],
		col=c("darkgreen", "blue"), length=.2, angle=10, lwd=8)

text(130, 145, "Between", cex=3.5, pos=4)
par(op)
dev.off()

# Show HE plot with same scale3s

png(filename="mathscore-HE-scaled.png", height=480, width=480)
op <- par(mar=c(4,4,1,1)+0.5)

heplot(math.mod,
			fill = TRUE, fill.alpha=.2,
      xlim = c(130, 210),
      ylim = c(60, 140),
      lwd=3,
      lty=1,
      center.cex=3,
      cex.lab = 1.5, cex = 2,
      xlab ="Basic Math", ylab = "Word Problems"
      )
text(130, 132, "HE\nplot", cex=2.5, pos=4)
par(op)
dev.off()
