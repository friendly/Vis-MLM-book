# Partial variables plot

# To understand the partial correlations, make scatterplots of the residuals from the
# models where each x_i, x_j are predicted by all others. 

# see also: pairs version
# https://stackoverflow.com/questions/35591033/plot-scatterplot-matrix-with-partial-correlation-coefficients-in-r

pvPlot <- function(
   X, 
   vars = 1:2,
   labels,
   id = FALSE, 
   ellipse=FALSE, 
   col = "black", 
   pch = 16, 
   cex = par("cex"),
   axes = TRUE,
   show.partial = TRUE,
   ...) {

  nv <- ncol(X)
  nr <- nrow(X)
  
  # variables, as names, even if vars is numeric
  all <- names(X)
  vars <- if(is.numeric(vars)) names(X)[vars] else vars
  others <- setdiff(all, vars)

  # variables for this plot  
  v1 <- vars[1]
  v2 <- vars[2]

  # get the partial residuals fitting each var from all the others
  res <- X[, vars]
  res[, 1] <- lsfit(X[, others], X[, v1])$residuals
  res[, 2] <- lsfit(X[, others], X[, v2])$residuals
  # plot(res, 
  #      col = col, pch = pch, cex = cex, ...)

  xlab <- paste(vars[1], "residual")
  ylab <- paste(vars[2], "residual")
  labels <- if (missing(labels)) rownames(X) else labels
  car::scatterplot(res[, 1], res[, 2],
    xlab = xlab, ylab = ylab,
    pch = pch, col = col, cex = cex,
    ellipse = ellipse,
    smooth = FALSE, boxplots = FALSE,
    grid = FALSE,
    id = list(n=5, labels = labels),
    ...)

  if (axes)
    abline(h = 0, v = 0, col = "gray")

  if (show.partial) {
    pcor <- round(cor(res[,1], res[,2]), 3)
    usr <- par("usr")        # save old user/default/system coordinates
    par(usr = c(0, 1, 0, 1)) # new relative user coordinates
    text(0.025, 0.95, label = paste("partial r =", pcor),  pos = 4, cex = 1.25)
    par(usr = usr)           # restore original user coordinates
  }
  
  invisible(res)
}

if(FALSE) {

# Scatterplots for the two largest partial correlations in the crime data
  data(crime, package = "ggbiplot")
  crime.num <- crime |>
    tibble::column_to_rownames("st") |>
    dplyr::select(where(is.numeric))

png(filename = "images/crime-pvPlot1.png", height = 500, width = 500)

op <- par(mar = c(5, 5, 1, 1)+.5)
ellipse.args <- list(levels = 0.68, fill.alpha = 0.1, robust = FALSE)
pvPlot(crime.num, vars = c("burglary", "larceny"), 
       ellipse = list(levels = 0.68, fill.alpha = 0.1, robust = FALSE),
       cex.lab = 1.5)
par(op)
dev.off()
  
png(filename = "images/crime-pvPlot2.png", height = 500, width = 500)
op <- par(mar = c(5, 5, 1, 1)+.5)
pvPlot(crime.num, vars = c("robbery", "auto"), 
         ellipse = list(levels = 0.68, fill.alpha = 0.1, robust = FALSE),
         cex.lab = 1.5)
par(op)
dev.off()
  

  
}