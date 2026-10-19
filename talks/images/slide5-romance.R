set.seed(1884)
out <- 'C:/R/Projects/Vis-MLM-book/talks/images'
n <- 10000
x <- runif(n,-1.2,1.2); y <- runif(n,-1.15,1.35)
k <- (x*x+y*y-1)^3-x*x*y^3 <= 0
x <- x[k]; y <- y[k]; z <- rnorm(length(x),sd=.62)
i <- sample(seq_along(x),1100); x <- x[i]; y <- y[i]; z <- z[i]
ink <- '#233F4C'; muted <- '#6A7880'
draw <- function(preview=TRUE) {
par(mar=rep(0,4),family='sans',xaxs='i',yaxs='i')
plot.new(); plot.window(c(0,16),c(0,9),asp=1)
rect(0,0,16,9,col='white',border=NA)
if(preview) {
text(.85,8.08,'Why a romance in many dimensions?',adj=0,cex=2.35,font=2,col=ink)
text(.88,7.35,'How can we understand important scientific phenomena?',adj=0,cex=1.18,col=muted)
}
pts <- function(a,b,cx,col) points(cx+a*1.45,4.1+b*1.45,pch=16,cex=.38,col=adjustcolor(col,.48))
pts(z,y,3,'#367E89')
u <- .50*x+.866*z; v <- -.30*x+.86*y+.17*z
pts(u,v,8,ink)
pts(x,y,13,'#BB545C')
text(c(3,8,13),1.72,c('A view','Spaceland','A revealing view'),cex=1.18,col=ink,font=c(1,2,1))
text(c(3,8,13),1.25,c('depth and height','the same points in three dimensions','width and height'),cex=.88,col=muted)
if(preview) text(.88,.48,'Our data live in Spaceland, sometimes high-D, but we plot in Planeland',adj=0,cex=1.02,col=ink)
}
png(file.path(out,'slide5-romance-preview.png'),width=2400,height=1350,res=150)
draw(); dev.off()
png(file.path(out,'slide5-romance-background.png'),width=2400,height=1350,res=150)
draw(FALSE); dev.off()
svg(file.path(out,'slide5-romance-background.svg'),width=16,height=9)
draw(FALSE); dev.off()
