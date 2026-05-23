#' ---
#' Partial variables plot
#' ---

# To understand the partial correlations, make scatterplots of the residuals from the
# models where each x_i, x_j are predicted by all others. 

# see also: stuff relevant to a pairs version
# https://stackoverflow.com/questions/35591033/plot-scatterplot-matrix-with-partial-correlation-coefficients-in-r
# TODO: Just as there is an avPlots() function to do avPlot() for all Xs, perhaps develop a pvPlots() function to do all pairs.

# Usage note: in Vis-MLM, need to use my patched version of `dataEllipse`
# Source patched car::dataEllipse until fix is accepted upstream (see test/Ellipse.R)
source(here::here("test/Ellipse.R"))
applyDefaults <- car:::applyDefaults  # make internal visible to sourced dataEllipse.default
carPalette <- car:::carPalette
showLabels <- car:::showLabels

# ✔️DONE: make show.partial take a list(loc = c(x,y), cex = )
# ✔️DONE: make id take a list of options
# ✔️DONE: use dataEllipse() instead of scatterplot()
# 
# ✔️DONE: ellipse.args$col now controls ellipse color independently of point col (2026-05-21)
# ✔️DONE: specify/document what `ellipse.args` work (e.g., `fill`, `fill.alpha`)
# ✔️DONE: ellipse = FALSE now works via levels = numeric(0) (2026-05-21)
# ✔️DONE: cex bug fixed -- root cause was in car::dataEllipse.default: when cex was in ...
#          it was passed to label.ellipse() both via ... and as explicit cex=label.cex,
#          causing "formal argument 'cex' matched by multiple actual arguments" in text.default().
#          Fix: added cex as explicit formal to label.ellipse(); see test/Ellipse.R for PR.
# ✔️DONE: regline now accepts FALSE or list(col, lwd) — same pattern as show.partial (2026-05-21)
# ✔️DONE: others argument added — defaults to all non-vars columns (2026-05-23)
# TODO: test use of plots for factors; implies a different dataset -- use `mtcars`, with `cyl` or `am` as factors?
# TODO: Extend this to a `pvPlots()` function that would produce a scatterplot matrix form of the collection of pvPlot() for all pairs of variables.
#       How this is done in car::avPlots(), C:\Dropbox\R\packages\car\R\avPlots.R, might be useful here.

#' 
#' @title Partial Variables Plot
#' 
#' @description
#' A partial variable plot is a visualization of a partial correlation of two variables in the context
#' of other variables in a dataset. For two variables \eqn{x_i} and \eqn{x_j}, 
#' it is simply an enhanced scatterplot of the \emph{partial residuals},
#' \eqn{e_i = (x_i - \hat{x}_i)} from a regression of \eqn{x_i} on all other variables \eqn{Z}
#' against those \eqn{e_j = (x_j - \hat{x}_j)} for another variable $x_j$.
#' Consequently, it shows directly the net, \emph{conditional relation} between \eqn{x_i, x_j \vert \text{others}} when
#' all of the others in \eqn{Z} have been controlled/adjusted-for.
#' 
#' As implemented here, the basic scatterplot of these residuals can be enhanced by also showing the data ellipse
#' of these residuals, the linear regression line, which reflects the partial correlation, and point labels to identify unusual data.
#' 
#' @details
#' Partial variable plots are intimately related to an \emph{added-variable plot},
#' such as produced by \code{\link[car]{avPlots}}. However, that implementation
#' is designed for a linear model, rather than a data.frame.
#' 
#' This function uses \code{\link[car]{dataEllipse}} for drawing, so ...
#' 
#' 
#'
#' @param X     a data.frame of numeric variables
#' @param vars  either the character names of two variables in \code{X} or their indices
#' @param others character names or indices of the variables to partial out. If \code{NULL}
#'              (the default), all variables in \code{X} other than \code{vars} are used.
#' @param labels id labels for the points. If not supplied, rownames of the dataset are used.
#' @param id    controls point identification; if \code{FALSE} (the default), no points are identified; 
#'              can be a list of named arguments to the \code{\link[car]{showLabels} function
#' @param ellipse    logical; whether to draw the data ellipse
#' @param ellipse.args  a list of arguments controlling the ellipse: `levels`, `fill`,
#'              `fill.alpha`, `robust`, and `col` (ellipse outline/fill color, independent
#'              of the point `col`). See \code{\link[car]{dataEllipse} for what these mean.
#' @param draw     logical; if \code{TRUE} produce graphical output; if \code{FALSE}, only invisibly return 
#'              coordinates of ellipse(s).
#' @param col   color used for points
#' @param pch   the plotting character for points
#' @param cex   Character expansion for points and labels
#' @param axes  logical; if \code{TRUE} (the default), grey axes lines are drawn at 0 on both coordinates
#' @param regline controls the regression line. \code{FALSE} suppresses it; \code{TRUE} (default)
#'        draws it with default style; a list with named elements \code{col} and/or \code{lwd}
#'        draws it with those attributes, e.g. \code{regline = list(col="red", lwd=3)}.
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
#' # ellipse color independent of point color
#' pvPlot(crime.num, vars = c("auto", "robbery"),
#'        ellipse.args = list(col="red"))
#'
#' # styled regression line
#' pvPlot(crime.num, vars = c("burglary", "larceny"),
#'        regline = list(col = "red", lwd = 3))
#' 
#' # partial out only a subset of the other variables
#' pvPlot(crime.num, vars = c("burglary", "larceny"),
#'        others = c("murder", "rape"))
#'
#' # suppress the ellipse
#' pvPlot(crime.num, vars = c("burglary", "larceny"), ellipse=FALSE)
#' 
#' # label some observations
#' pvPlot(crime.num, vars = c("burglary", "larceny"), 
#'        id = list(n=5),
#'        cex.lab = 1.5)
#' 
pvPlot <- function(
   X,
   vars = 1:2,
   others = NULL,
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

  if (!requireNamespace("car", quietly = TRUE))
    stop("Package 'car' is required by pvPlot().")

  nv <- ncol(X)
  nr <- nrow(X)
  
  # variables, as names, even if vars is numeric
  all <- names(X)
  vars <- if(is.numeric(vars)) names(X)[vars] else vars
  if (is.null(others)) {
    others <- setdiff(all, vars)
  } else {
    others <- if(is.numeric(others)) names(X)[others] else others
    invalid <- setdiff(others, setdiff(all, vars))
    if (length(invalid))
      warning("'others' contains variables not in X or already in vars: ",
              paste(invalid, collapse=", "))
    others <- intersect(others, setdiff(all, vars))
  }

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
  
  id <- car:::applyDefaults(id,
                      defaults=list(method="mahal", 
                                    n=5, cex=1, 
                                    col="black", 
                                    location="lr"), type="id")

  if (draw) {

    # handle ellipse args
    levels    <- ellipse.args$levels     %||% 0.68
    fill      <- ellipse.args$fill       %||% TRUE
    fill.alpha <- ellipse.args$fill.alpha %||% 0.05
    robust    <- ellipse.args$robust     %||% FALSE
    col_ell   <- ellipse.args$col        %||% col   # ellipse color; defaults to point color

    dataEllipse(res[, 2] ~ res[, 1], data = res,
                xlab = xlab, ylab = ylab,
                pch = pch, col = c(col, col_ell),   # col[1]=points, col[2]=ellipse
                cex = cex,
                levels = if (ellipse) levels else numeric(0),
                fill = fill, fill.alpha = fill.alpha, robust=robust,
                grid = FALSE,
                id = id,
                ...)
    
    if (axes) abline(h = 0, v = 0, col = "gray")
    if (!isFALSE(regline)) {
      rl.col <- if (is.list(regline)) regline$col %||% "black" else "black"
      rl.lwd <- if (is.list(regline)) regline$lwd %||% 2       else 2
      abline(lm(res[, 2] ~ res[, 1], data = res), col = rl.col, lwd = rl.lwd)
    }
  
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

