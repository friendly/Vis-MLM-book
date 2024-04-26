# 3D versions of added variable plot, with movies

library(car)
library(p3d)
library(spida)

#####################################
# basic models and AV calculations
#####################################

fit.stress <- lm(Heart ~ Stress, data=coffee)
fit.coffee <- lm(Heart ~ Coffee, data=coffee)
fit.both   <- lm(Heart ~ Coffee + Stress, data=coffee)

mod.mat <- model.matrix(fit.both)
# added variables for Stress
res <- lsfit(mod.mat[, -3], cbind(mod.mat[,3], coffee$Heart), 
        intercept = FALSE)$residuals
colnames(res) <- c("Stress", "Heart")
res[,1] <- res[,1] + mean(coffee$Stress)
res[,2] <- res[,2] + mean(coffee$Heart)
res1 <- as.data.frame(res)

res <- lsfit(mod.mat[, -2], cbind(mod.mat[,2], coffee$Heart), 
        intercept = FALSE)$residuals
colnames(res) <- c("Coffee", "Heart")
res[,1] <- res[,1] + mean(coffee$Coffee)
res[,2] <- res[,2] + mean(coffee$Heart)
res2 <- as.data.frame(res)

#####################################
# 3D plot showing all regression planes and data ellipses
#####################################


# y ~ x + z
Init3d(cex=1.2)
Plot3d( Heart ~ Coffee + Stress, coffee,
#	col="blue", 
	surface=TRUE, fit="linear", surface.col="lightblue", 
	grid.lines=10, sphere.size=0.6)
box3d(color="gray")


data.Ell3d(col="lightblue")
Lines3d( y = 'min', xz = with( coffee, dell( Coffee, Stress)), lwd=2, color="black")
Lines3d( z = 'min', xy = with( coffee, dell( Coffee, Heart)), lwd=2, color="blue")
Lines3d( x = 'min', yz = with( coffee, dell( Heart, Stress)), lwd=2, color="blue")

Lines3d( x = 'min', yz = with( res1, dell( Heart, Stress)), lwd=2, color="red")
Lines3d( z = 'min', xy = with( res2, dell( Coffee, Heart)), lwd=2, color="red")

#Lines3d( y = 'mid', xz = with( coffee, dell( Coffee, Stress)), lwd=2)
#Lines3d( z = 'mid', xy = with( coffee, dell( Coffee, Heart)), lwd=2)
#Lines3d( x = 'mid', yz = with( coffee, dell( Heart, Stress)), lwd=2)

Fit3d(fit.stress, col="pink")
Fit3d(fit.coffee, col="green")

########################################
# prepare for animated 3D views
########################################

# make this view reproducible
#  -- manually zoom, stretch, rotate, then capture the current rgl viewpoint
# p3d <- par3d(no.readonly=TRUE)
#p3d <- structure(list(FOV = 15, ignoreExtent = TRUE, mouseMode = structure(c("polar", 
#"fov", "zoom"), .Names = c("left", "right", "middle")), skipRedraw = FALSE, 
#    userMatrix = structure(c(0.733563780784607, -0.245501860976219, 
#    0.633729457855225, 0, 0, 0.932475328445435, 0.361233681440353, 
#    0, -0.679620623588562, -0.264987945556641, 0.6840301156044, 
#    0, 0, 0, 0, 1), .Dim = c(4L, 4L)), scale = c(1.17389690876007, 
#    0.98577243089676, 0.840330600738525), zoom = 1, windowRect = c(692L, 
#    130L, 1449L, 902L), family = "sans", font = 1L, cex = 1.2, 
#    useFreeType = FALSE), .Names = c("FOV", "ignoreExtent", "mouseMode", 
#"skipRedraw", "userMatrix", "scale", "zoom", "windowRect", "family", 
#"font", "cex", "useFreeType"))

# smaller version for smaller file size
p3d <- structure(list(FOV = 15, ignoreExtent = TRUE, mouseMode = structure(c("polar", 
"fov", "zoom"), .Names = c("left", "right", "middle")), skipRedraw = FALSE, 
    userMatrix = structure(c(0.733563780784607, -0.245501860976219, 
    0.633729457855225, 0, 0, 0.932475328445435, 0.361233681440353, 
    0, -0.679620623588562, -0.264987945556641, 0.6840301156044, 
    0, 0, 0, 0, 1), .Dim = c(4L, 4L)), scale = c(1.17389690876007, 
    0.98577243089676, 0.840330600738525), zoom = 1, windowRect = c(770L, 
    129L, 1441L, 809L), family = "sans", font = 1L, cex = 1.2, 
    useFreeType = FALSE), .Names = c("FOV", "ignoreExtent", "mouseMode", 
"skipRedraw", "userMatrix", "scale", "zoom", "windowRect", "family", 
"font", "cex", "useFreeType"))


# a nice view, with the y axis vertical, and at the back
M1 <- structure(c(0.733563780784607, -0.245501860976219, 0.633729457855225, 
0, 0, 0.932475328445435, 0.361233681440353, 0, -0.679620623588562, 
-0.264987945556641, 0.6840301156044, 0, 0, 0, 0, 1), .Dim = c(4L, 
4L))
par3d(p3d)
par3d(userMatrix = M1)
snapshot3d("coffee-av3D-1.png")

# rotate around y axis for 2 minutes
play3d(spin3d(axis=c(0,1,0), rpm=5), duration=2*60/5)

# make a movie, spinning around the Y axis
movie3d(spin3d(axis=c(0,1,0), rpm=5), duration=2*60/5, movie="coffee-av3D-1", clean=FALSE, fps=8)

#############################################
# other interesting views: M2:M5
#############################################

#  view with all 3 planes on edge
# M2 <-par3d("userMatrix")
structure(c(0.667350113391876, -0.423687189817429, 0.612480998039246, 
0, 0, 0.822404623031616, 0.568903028964996, 0, -0.744744122028351, 
-0.379657506942749, 0.548831820487976, 0, 0, 0, 0, 1), .Dim = c(4L, 
4L))
par3d(userMatrix = M2)
snapshot3d("coffee-av3D-2.png")

# view with fit.both on edge
# M3 <-par3d("userMatrix")
M3 <- structure(c(0.990002751350403, 0.116017632186413, -0.0802152454853058, 
0, 0, 0.568708300590515, 0.822539269924164, 0, 0.141048133373260, 
-0.814316153526306, 0.563022792339325, 0, 0, 0, 0, 1), .Dim = c(4L, 
4L))
par3d(userMatrix = M3)
snapshot3d("coffee-av3D-3.png")

# view with fit.coffee on edge
# M4 <-par3d("userMatrix")
M4 <- structure(c(-0.947379469871521, -0.092685081064701, 0.306401044130325, 
0, 0, 0.957166254520416, 0.289538919925690, 0, -0.320112675428391, 
0.27430322766304, -0.906799674034119, 0, 0, 0, 0, 1), .Dim = c(4L, 
4L))
par3d(userMatrix = M4)
snapshot3d("coffee-av3D-4.png")


# view with fit.stress on edge
# M5 <-par3d("userMatrix")
M5 <- structure(c(0.191606238484383, 0.191091522574425, -0.962689518928528, 
0, 0, 0.98086303472519, 0.194698929786682, 0, 0.98147189617157, 
-0.0373055301606655, 0.18793947994709, 0, 0, 0, 0, 1), .Dim = c(4L, 
4L))
par3d(userMatrix = M5)
snapshot3d("coffee-av3D-5.png")

############################################
# another movie, rotating among views
############################################


# define an order to show the views
views <- list(M1, M3, M4, M5, M2)
times <- 5 * (seq_along(views)-1)

# add pauses; use linear interpolation in time
interp3d.fun <- par3dinterp( times=sort(c(times, times+2)),
        	userMatrix=rep(views, each=2),  method="linear")
play3d( interp3d.fun, duration=2*60/5)

movie3d( interp3d.fun, duration=2*60/5, movie="coffee-av3D-2", clean=FALSE, fps=8)
#movie3d(par3dinterp( userMatrix=list(M1, M3, M3, M4, M4, M5, M5, M2, M2)), duration=2*60/5, movie="coffee-av3D-2", clean=FALSE, fps=8)



# try adding labels for planes [this doesn't work]
#lab.both <- with(coffee, data.frame(Coffee=max(Coffee), Stress=max((Stress))) )
#y.both <- predict(fit.both, lab.both)
#text3d( list(x=max.both$Coffee, z=max.both$Stress, y=y.both), text="Heart~Coffee+Stress", color="black" )


