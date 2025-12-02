#' from: https://stackoverflow.com/questions/25450719/plotting-text-in-r-at-absolute-position

#' Add text to a plot at normalized device coordinates
#' 
#' @description
#' `text.usr()` draws the strings given in the vector labels at the coordinates given by \code{x} and \code{y}, 
#' but using normalized device coordinates (0, 1) to position text at absolute locations in a plot.
#' \code{y} may be missing since \code{\link[grDevices]{xy.coords(x, y)}} is used for construction of the coordinates.
#' 
#' @param x,y  numeric vectors of coordinates where the text \code{labels} should be written. If the length of 
#'        \code{x} and \code{y} differs, the shorter one is recycled.
#' @param labels a character vector or \code{\link[base]{expression}} specifying the text to be written
#' @param ...    other arguments passed to \code{\link[grDevices]{text}}, such as `pos`, `cex`, `col`, ...
#' @source From \url{https://stackoverflow.com/questions/25450719/plotting-text-in-r-at-absolute-position}
#' @export 
#' @examples
#' # example code
#' x = c(0.5, rep(c(0.05, 0.95), 2))
#' y = c(0.5, rep(c(0.05, 0.95), each=2))
#' plot(x, y, pch = 16,
#'      xlim = c(0,1),
#'      ylim = c(0,1))
#' text.usr(0.05, 0.95, "topleft",    pos = 4)
#' text.usr(0.95, 0.95, "topright",   pos = 2)
#' text.usr(0.05, 0.05, "bottomleft", pos = 4)
#' text.usr(0.95, 0.05, "bottomright",pos = 2)
#'
 
text.usr <- function(x, y, labels, ...) {
  xlim <- par("usr")[1:2]
  ylim <- par("usr")[3:4]
  
  xpos <- xlim[1] + x*(xlim[2] - xlim[1])
  ypos <- ylim[1] + y*(ylim[2] - ylim[1])
  
  if(par("xlog")) xpos <- 10^xpos
  if(par("ylog")) ypos <- 10^ypos
  
  text(xpos, ypos, labels, ...)
}

if (FALSE) {
  x = c(0.5, rep(c(0.05, 0.95), 2))
  y = c(0.5, rep(c(0.05, 0.95), each=2))
  plot(x, y, pch = 16,
       xlim = c(0,1),
       ylim = c(0,1))
  text.usr(0.05, 0.95, "topleft",    pos = 4)
  text.usr(0.95, 0.95, "topright",   pos = 2)
  text.usr(0.05, 0.05, "bottomleft", pos = 4)
  text.usr(0.95, 0.05, "bottomright",pos = 2)

}