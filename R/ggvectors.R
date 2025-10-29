#' Draw labeled vectors in a ggplot scene
#'
#' @param x,y      coordinates of vector ends
#' @param label    text labels for vector ends
#' @param scale    scale factor for vectors
#' @param origin   origin of vectors 
#' @param arrow_style style for the vector arrows 
#' @param color    colors for vectors
#' @param linewidth linewidth for vectors
#' @param adjust   adjustment offset for labels 
#' @param size     text size for labels
#'
#' @return
#' @export
#'
#' @examples
ggvectors <- function(x, y, label,
                     scale = 1,
                     origin = c(0, 0),
                     arrow_style,
                     color = "black",
                     linewidth = 1.4,
                     lineheight = 1,
                     adjust = 1.25,
                     size = 3
){
  
  if(missing(arrow_style)) arrow_style <- arrow(length = unit(1/2, 'picas'), 
                                                   type="closed", 
                                                   angle=15) 
  # Variables for text label placement
  df <- data.frame(x = x, y = y, label = label)
  df$angle <- with(df, (180/pi) * atan(y / x))
  df$hjust <- with(df, (1 - adjust * sign(x)) / 2)
  
  geom_segment(data = df,
               aes(x = origin[1], y = origin[2], 
                   xend = x, yend = y),
               arrow = arrow_style, 
               color = color,
               linewidth = linewidth)
  if(!missing(label)) {
  geom_text(data = df, 
              aes(label = label, x = x, y = y, 
                  angle = angle, hjust = hjust), 
              color = color, size = size)
  }
  
}
