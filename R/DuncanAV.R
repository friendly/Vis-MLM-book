data(Duncan, package="carData")
duncmod <- lm(prestige ~ income + education, data=Duncan)
mod.mat <- model.matrix(duncmod)

alpha=seq(0, 1, .1)

myCols = colorRamp(c("red", "blue"))(alpha)
# can we make the color of the lines & data ellipses change?

# function to do an animation for one variable
dunc.anim <- function(variable, other, alpha=seq(0, 1, .1)) {
  var <- which(variable==colnames(mod.mat))
  duncdev <- scale(Duncan[,c(variable, "prestige")], scale=FALSE)
  duncav <- lsfit(mod.mat[, -var], cbind(mod.mat[, var], Duncan$prestige), 
                  intercept = FALSE)$residuals
  colnames(duncav) <- c(variable, "prestige")
  
  lims <- apply(rbind(duncdev, duncav),2,range)
  
  cols = colorRamp(c("red", "blue"))(length(alpha))
  for (i in seq_along(alpha)) {
    alp = alpha[i]
    main <- if(alp==0) paste("Marginal plot:", variable)
    else paste(round(100*alp), "% Added-variable plot:", variable)
    heplots::interpPlot(duncdev, duncav, alp, xlim=lims[,1], ylim=lims[,2], pch=16,
               main = main,
               xlab = paste(variable, "| ", alp, other),
               ylab = paste("prestige | ", alp, other),
               abline = TRUE,
               col.lines = cols[i],
               ellipse=TRUE, 
               ellipse.args=(list(levels=0.68, fill=TRUE, fill.alpha=alp/2)), 
               id.n=3, id.cex=1.2, cex.lab=1.25)
    Sys.sleep(2)
  }
}

# show these in the R console
dunc.anim("income", "education")


## from ?interplot

dunc.anim <- function(variable, other, alpha=seq(0, 1, .1)) {
  var <- which(variable==colnames(mod.mat))
  duncdev <- scale(Duncan[,c(variable, "prestige")], scale=FALSE)
  duncav <- lsfit(mod.mat[, -var], cbind(mod.mat[, var], Duncan$prestige), 
                  intercept = FALSE)$residuals
  colnames(duncav) <- c(variable, "prestige")
  
  lims <- apply(rbind(duncdev, duncav),2,range)
  
  for (alp in alpha) {
    main <- if(alp==0) paste("Marginal plot:", variable)
    else paste(round(100*alp), "% Added-variable plot:", variable)
    heplots::interpPlot(duncdev, duncav, alp, xlim=lims[,1], ylim=lims[,2], pch=16,
               main = main,
               xlab = paste(variable, "| ", alp, other),
               ylab = paste("prestige | ", alp, other),
               ellipse=TRUE, ellipse.args=(list(levels=0.68, fill=TRUE, fill.alpha=alp/2)), 
               abline=TRUE, id.n=3, id.cex=1.2, cex.lab=1.25)
    Sys.sleep(2)
  }
}

dunc.anim("income", "education")


  