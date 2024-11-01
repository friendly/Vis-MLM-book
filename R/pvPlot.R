# Partial variables plot

# To understand the partial correlations, make scatterplots of the residuals from the
# models where each x_i, x_j are predicted by all others. 

# see also: pairs version
# https://stackoverflow.com/questions/35591033/plot-scatterplot-matrix-with-partial-correlation-coefficients-in-r

# TODO: make show.partial take a list(loc = c(x,y), cex = )
# TODO: make id take a list of options

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
  
  applyDefaults <- car:::applyDefaults
  id <- applyDefaults(id, defaults=list(method="mahal", 
                                       n=5, cex=1, 
                                       col="black", 
                                       location="lr"), type="id")
  if (isFALSE(id)){
    id.n <- 0
    id.method <- "mahal"
    labels <- id.cex <- id.col <- id.location <- NULL
  }
  else{
    labels <- id$labels
    id.method <- id$method
    id.n <- if ("identify" %in% id.method) Inf else id$n
    id.cex <- id$cex
  #    id.col <- if (by.groups) id$col else id$col[1]
    id.location <- id$location
  }
  
  car::scatterplot(res[, 1], res[, 2],
    xlab = xlab, ylab = ylab,
    pch = pch, col = col, cex = cex,
    ellipse = ellipse,
    smooth = FALSE, boxplots = FALSE,
    grid = FALSE,
    id = list(n=5, labels = labels),      # make it id = id, using our defaults
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
       ellipse = ellipse.args,
       id = list(n=5),
       cex.lab = 1.5)
par(op)
dev.off()
  
png(filename = "images/crime-pvPlot2.png", height = 500, width = 500)
op <- par(mar = c(5, 5, 1, 1)+.5)
pvPlot(crime.num, vars = c("robbery", "auto"), 
       ellipse = ellipse.args,
       id = list(n=5),
       cex.lab = 1.5)
par(op)
dev.off()
  
# combine them side-by-side

p1 <- image_read("images/crime-pvPlot1.png")
p2 <- image_read("images/crime-pvPlot2.png")
# join them left to right
p12 <- image_append(c(p1, p2), stack = FALSE)
image_write(p12, path="images/crime-pvPlot-1-2.png", format="png")

  
}