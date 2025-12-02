# from: https://stackoverflow.com/questions/25450719/plotting-text-in-r-at-absolute-position

#' Add Text to a Plot at Normalized Device Coordinates
#' 
#' @description
#' `text_usr()` draws the strings given in the vector labels at the coordinates given by `x` and `y`, 
#' but using normalized device coordinates (0, 1) to position text at absolute locations in a plot.
#' This is useful when you know where in a plot you want to add some text annotation, but don't want to figure
#' out what the data coordinates are.
#' 
#' @details
#' `y` may be missing since \code{\link[grDevices]{xy.coords}} is used for construction of the coordinates.
#' 
#' The function also works with `par(xlog) == TRUE` and `par(ylog) == TRUE` when either of these is set
#' for log scales.
#' 
#' @param x,y  numeric vectors of coordinates in (0, 1) where the text `labels` should be written. If the length of 
#'        `x` and `y` differs, the shorter one is recycled. Alternatively, a single argument `x` can be provided.
#' @param labels a character vector or \code{\link[base]{expression}} specifying the text to be written
#' @param ...    other arguments passed to \code{\link[graphics]{text}}, such as `pos`, `cex`, `col`, ...
#' @keywords utilities
#' @source From <https://stackoverflow.com/questions/25450719/plotting-text-in-r-at-absolute-position>
#' @importFrom graphics text
#' 
#' @export
#' @examples
#' library(heplots)
#' x = c(0.5, rep(c(0.05, 0.95), 2))
#' y = c(0.5, rep(c(0.05, 0.95), each=2))
#' plot(x, y, pch = 16,
#'      xlim = c(0,1),
#'      ylim = c(0,1))
#' text_usr(0.05, 0.95, "topleft",    pos = 4)
#' text_usr(0.95, 0.95, "topright",   pos = 2)
#' text_usr(0.05, 0.05, "bottomleft", pos = 4)
#' text_usr(0.95, 0.05, "bottomright",pos = 2)
#'
 
text_usr <- function(x, y, labels, ...) {
  xlim <- par("usr")[1:2]
  ylim <- par("usr")[3:4]
  
  xpos <- xlim[1] + x * (xlim[2] - xlim[1])
  ypos <- ylim[1] + y * (ylim[2] - ylim[1])
  
  if(par("xlog")) xpos <- 10^xpos
  if(par("ylog")) ypos <- 10^ypos
  
  text(xpos, ypos, labels, ...)
}

