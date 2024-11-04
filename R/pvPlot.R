# Partial variables plot

# To understand the partial correlations, make scatterplots of the residuals from the
# models where each x_i, x_j are predicted by all others. 

# see also: stuff relevant to a pairs version
# https://stackoverflow.com/questions/35591033/plot-scatterplot-matrix-with-partial-correlation-coefficients-in-r

# DONE: make show.partial take a list(loc = c(x,y), cex = )
# DONE: make id take a list of options
# DONE: use dataEllipse() instead of scatterplot()

# TODO: be able to use ellipse = FALSE
# BUG:  passing either ellipse or cex to dataEllipse() -> error
#       Error in text.default(x, y, label, pos = pos, xpd = xpd, col = col, ...) : 
#       formal argument "cex" matched by multiple actual arguments
#       Trying to pass 

#' Partial variables plot
#' 
#' @description
#' A partial variable plot is a visualization of a partial correlation of two variables in the context
#' of other variables in a dataset. For two variables \eqn{x_i} and \eqn{x_j}, 
#' it is simply an enhanced scatterplot of the \emph{partial residuals},
#' \eqn{e_i = (x_i - \hat{x}_i)} from a regression of \eqn{x_i} on all other variables \eqn{Z}
#' against those \eqn{e_j = (x_j - \hat{x}_j)} for another variable $x_j$.
#' The basic scatterplot of these residuals can be enhanced by also showing the data ellipse
#' of these residuals and point labels to identify unusual data.
#' (These plots are produced by SAS \code{PROC CORR}, with the \code{PARTIAL} and \code{SCATTER}
#' statements.)
#' 
#' Partial variable plots are intimately related to an \emph{added-variable plot},
#' such as produced by \code{\link[car]{avPlots}}. However, that implementation
#' is designed for a linear model, rather than a data.frame.
#' 
#'
#' @param X     a data.frame of numeric variables
#' @param vars  either the character names of two variables in \code{X} or their indices
#' @param labels id labels for the points. If not supplied, rownames of the dataset are used.
#' @param id    controls point identification; if \code{FALSE} (the default), no points are identified; 
#'              can be a list of named arguments to the \code{\link[car]{showLabels} function
#' @param ellipse    logical; whether to draw the data ellipse. Not presently used
#' @param ellipse.args  a list of other arguments for the ellipse
#' @param draw     logical; if \code{TRUE} produce graphical output; if \code{FALSE}, only invisibly return 
#'              coordinates of ellipse(s).
#' @param col   color used for points, ...
#' @param pch   the plotting character
#' @param cex   Character expansion for points and labels. Not presently used
#' @param axes  logical; if \code{TRUE} (the default), grey axes lines are drawn at 0 on both coordinates
#' @param regline logical; if \code{TRUE} (the default), draws the regression line for the partial residuals
#'        of \code{vars[2]} on those for \code{vars[1]}.
#' @param show.partial controls whether the partial correlation value is displayed in the plot. If \code{FALSE}
#'              the value is not shown. Otherwise, can be a list containing the location (\code{loc}) and 
#'              character size (\code{cex}) of the label. 
#' @param ...   other arguments passed to \code{\link[car]{dataEllipse}}
#'
#' @return      This functions is mainly used for their side effect of producing plots. For greater 
#'              flexibility (e.g., adding plot annotations), it returns invisibly the coordinates of the residuals
#'              plotted.
#' @export
#' @author Michael Friendly
#' @importFrom car dataEllipse
#' @examples
#' data(crime, package = "ggbiplot")
#' crime.num <- crime |>
#'   tibble::column_to_rownames("st") |>
#'   dplyr::select(where(is.numeric))
#'   
#' pvPlot(crime.num, vars = c("burglary", "larceny"))
#' pvPlot(crime.num, vars = c("auto", "robbery"))
#' 
#' # bugged:
#' pvPlot(crime.num, vars = c("burglary", "larceny"), ellipse=FALSE)
#' 
pvPlot <- function(
   X, 
   vars = 1:2,
   labels,
   id = FALSE, 
   ellipse=TRUE,
   ellipse.args = list(levels = 0.68, fill = TRUE, fill.alpha = 0.05, robust=FALSE, col="black"),
   draw = TRUE,
   col = "black", 
   pch = 16, 
   cex = par("cex"),
   axes = TRUE,
   regline = TRUE,
   show.partial = list(loc = c(0.025, 0.95), cex = 1.2),
   ...) {

  nv <- ncol(X)
  nr <- nrow(X)
  
  # variables, as names, even if vars is numeric
  all <- names(X)
  vars <- if(is.numeric(vars)) names(X)[vars] else vars
  # TODO: make others an argument, so it's not necessary to partial _all_ others
  others <- setdiff(all, vars)

  # variables for this plot  
  v1 <- vars[1]
  v2 <- vars[2]

  # get the partial residuals fitting each var from all the others
  res <- X[, vars]
  rownames(res) <- rownames(X)
  res[, 1] <- lsfit(X[, others], X[, v1])$residuals
  res[, 2] <- lsfit(X[, others], X[, v2])$residuals

  xlab <- paste(vars[1], "| others")
  ylab <- paste(vars[2], "| others")
  labels <- if (missing(labels)) rownames(X) else labels
  
  applyDefaults <- car:::applyDefaults
  id <- applyDefaults(id, 
                      defaults=list(method="mahal", 
                                    n=5, cex=1, 
                                    col="black", 
                                    location="lr"), type="id")

  if (draw) {

    # handle ellipse args
    levels <- ellipse.args$levels %||% 0.68
    fill <-   ellipse.args$fill %||% TRUE
    fill.alpha <- ellipse.args$alpha %||% 0.05
    robust <- ellipse.args$robust %||% FALSE
  
    dataEllipse(res[, 2] ~ res[, 1], data = res,
                xlab = xlab, ylab = ylab,
                pch = pch, col = col,
 #               cex = cex,
 #               ellipse = ellipse, # ellipse.label = "",
                levels = levels, fill = fill, fill.alpha = fill.alpha, robust=robust,
                grid = FALSE,
                id = id,
                ...)
    
    if (axes) abline(h = 0, v = 0, col = "gray")
    if (regline) abline(lm(res[, 2] ~ res[, 1], data = res), lwd = 2)
  
    if (!isFALSE(show.partial)) {
        loc <- show.partial$loc %||% c(0.025, 0.95)
        cex <- show.partial$cex %||% 1.2
        pos <- show.partial$pos %||% 4

        pcor <- round(cor(res[,1], res[,2]), 3)
        usr <- par("usr")        # save old user/default/system coordinates
        par(usr = c(0, 1, 0, 1)) # new relative user coordinates
        text(loc[1], loc[2], label = paste("partial r =", pcor),  pos = pos, cex = cex)
        par(usr = usr)           # restore original user coordinates
    }
  }
  
  invisible(res)
}

