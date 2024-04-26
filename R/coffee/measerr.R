#' Demonstrate Effect of Measurement Error in Regression
#' 
#' This function takes a variables x and y and demonstrates the effect of adding random normal errors
#' to one or both of the coordinates. For each level of \code{err}, it adds \code{rnorm(0, err * SD)}
#' to the corresponding x and/or y and displays the data points, a data ellipse and the fitted
#' regression line overlaid on the corresponding plot of the un-perturbed data.
#'
#' My thought was to make this general, to be used either in an interactive demonstration or an animated
#' graphic using the \pkg{animate} package. There is something wrong with my logic, because it doesn't
#' work for an interactive demo.
#'
#' @param x     predictor variable, a vector
#' @param y     response variable, a vector
#' @param err   a vector of error factors, as a multiple of the sd() of x and/or y
#' @param add.to character, the coordinate to add the errors to. One of "x", "y" or "both"
#' @param cols  vector of colors to be used to draw sequential plots 
#' @param lev   coverage level of the data ellipse
#' @param pch   plotting symbol
#' @param cex   size of plot symbol
#' @param xlim  x limits, a vector of length 2
#' @param ylim  y limits, a vector of length 2
#' @param xlab  label for x axis
#' @param ylab  label for y axis
#' @param start_loop  function to run at the start of each loop. Use \code{dev.hold()} for 
#'              use with the \pkg{animate} package
#' @param end_loop    function to run at the end of each loop. The default is \code{Sys.sleep(3)}
#'              Use \code{ani.pause()} 
#'              for use with the animate package, or \code{readkey()} for interactive demo.
#'
#' @return A data frame containing the intercepts, slopes and standard errors of the regressions
#' @export
#'
#' @examples

measerr <- function(x, y,
                   err,
                   add.to = c("x", "y", "both"),
                   cols,
                   lev=0.68,
                   pch = 16,
                   cex = 1.2,
                   xlim, ylim,
                   xlab, ylab,
                   start_loop = NULL,
                   end_loop = Sys.sleep(3)
                         ) {
  if(missing(xlim)) {
    rx <- range(x)
    xlim <-c(rx[1] - .2 * diff(rx), 
             rx[2] + .2 * diff(rx))
  }
  if(missing(ylim)) {
    ry <- range(y)
    ylim <-c(ry[1] - .2 * diff(ry), 
             ry[2] + .2 * diff(ry))
  }
  if(missing(xlab)) xlab <- deparse(substitute(x))
  if(missing(ylab)) ylab <- deparse(substitute(y))
  
  for(i in 1:length(err)) {
    start_loop
#    print(paste("i =", i, "error = ", err[i]))
    # plot the original data with fitted regression line
    E1 <- dataEllipse(x, y, 
                      col = "black",
                      lev = lev,
                      grid=FALSE, 
                      xlim = xlim, ylim = ylim,
                      xlab = xlab, ylab = ylab,
                      fill = TRUE, fill.alpha = 0.2, 
                      cex.lab = 1.4, 
                      pch = pch, cex = cex
                      )
    abline(fit <- lm(y ~ x), col="black", lwd=3)
    if (i==1) res <- data.frame(error = 0, 
                                intercept = coef(fit)[1], 
                                slope = coef(fit)[2], 
                                sigma = summary(fit)$sigma)
    
    # create a new version of x, or y with added error, N(0 err[i] * sd(x))
    add.to = match.arg(add.to)
    xx <- x; yy <- y
    if(add.to %in% c("x", "both")) xx <- add_error(x, err[i])
    if(add.to %in% c("y", "both")) yy <- add_error(x, err[i])

    # plot the perturbed data with fitted regression line
    E2 <- dataEllipse(xx, yy, 
                      col = cols[i],
                      lev = lev,
                      grid=FALSE, 
                      add = TRUE,
                      fill = TRUE, fill.alpha = 0.2,
                      pch = pch, cex = cex
                      )
    abline(fit <- lm(yy ~ xx), col=cols[i], lwd=3)
    res <- rbind( res, c(err[i], coef(fit), summary(fit)$sigma) )
    segments(x0=xx, y0=yy,
             x1=xx, y1=yy, lty=2, col=cols[i])
    text(x = xlim[2] - .01*diff(xlim), 
         y = min(y) + .01 * diff(range(y)), 
         label = paste("Error factor:", err[i], 
                       "\nSlope:", round(coef(fit)[2], 2)), 
         pos=2, cex=1.2)
#    Sys.sleep(1)
    end_loop
  }
  row.names(res) <- 1:nrow(res)
  invisible(res)
}

# Add a N(0, SD) error, but keep the mean unchanged
add_error <- function(x, factor) {
  n <- length(x)
  mean <- mean(x)
  SD <- sd(x)
  x <- x + round(rnorm(n, sd=factor*SD))
  x <- mean + as.vector(scale(x, center=TRUE, scale=FALSE))
  x
}

# function to prompt before continuing
readkey <- function()
{
  cat ("Press [enter] to continue")
  line <- readline()
}