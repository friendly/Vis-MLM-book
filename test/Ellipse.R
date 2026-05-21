# Ellipses (orignally by J. Fox and G. Monette)

# added grid lines, 25 May 2010 by S. Weisberg
# arguments more consistent with other functions; ... passes args to plot, 5 Sept 2010 by J. Fox
# confidenceEllipse.lm and .glm can add to current plot, applying patch from Rafael Laboissiere, 17 Oct 2010 by J. Fox
# added fill and fill.alpha arguments for translucent fills (suggested by Michael Friendly), 14 Nov 2010 by J. Fox
# modified 2 May 2011 by Michael Friendly
#   - allow pivot=TRUE (with warning)
#   - barf on non-symmetric shape
#   - return coordinates of ellipse invisibly
# dataEllipse() and confidenceEllipse() invisibly return coordinates,  3 May 2011 by J. Fox
# Modified 5 May 2011 by Michael Friendly
#   - dataEllipse now honors add=FALSE, plot.points=FALSE
# Modified 16 May 2011 by Michaell Friendly
#   - corrected bug introduced in dataEllipse via allowing pivot=TRUE 
# Modified 7 Aug 2011 by J. Fox: added draw argument
# Modified 28 Nov 2011  by J. Fox (suggested by Michael Friendly):
#   - corrected bug in xlab, ylab in confidenceEllipse()
#   - added dfn argument to .lm and .glm methods for confidenceEllipse()
# Modified 14&16 Dec 2011 by J. Fox (suggested by Michael Friendly) to add weights argument to dataEllipse().
# Modified 2 Feb 2012 by J. Fox: Improved handling of center.pch argument to ellipse() (suggestion of Rob Kushler).
# 16 July 2012 added showLabels to dataEllipse
# 2014-02-16: prevent dataEllipse() from opening a graphics device when draw=FALSE (fixing bug reported by Rafael Laboissiere).
# 2015-09-04: throw error if there are too few colors for groups (fixing bug reported by Ottorino Pantani). J. Fox
# 2016-02-16: replace cov.trob() call with MASS::cov.trob(). J. Fox
# 2017-11-30: substitute carPalette() for palette(). J. Fox
# 2022-09-22: add grid argument. J. Fox
# 2023-08-28: trans.color -> grDevices::adjustcolor. Michael Friendly
# 2023-08-28: replace label.ellipse with heplots::label.ellipse, add label.pos argument Michael Friendly
# 2023-08-31: make dataEllipse generic; add formula method. MF
# 2023-09-03: fix formula method using Formula::as.Formula. JF
# 2023-09-03: test formula method & label.pos. MF
# 2023-09-16: tweak code, add label.xpd arg. JF
# 2026-05-21: fix duplicate-cex bug in label.ellipse call. M. Friendly
#   - added cex as explicit formal arg to label.ellipse() (was passed only via ...)
#   - pass cex explicitly to text() in label.ellipse body
#   - at call site, filter cex from ... before do.call(label.ellipse, ...) to prevent
#     "formal argument 'cex' matched by multiple actual arguments" error in text.default()

ellipse <- function(center, shape, radius, log="", center.pch=19, center.cex=1.5, segments=51, draw=TRUE, add=draw, 
		xlab="", ylab="", col=carPalette()[2], lwd=2, fill=FALSE, fill.alpha=0.3,
		grid=TRUE, ...) {
	logged <- function(axis=c("x", "y")){
		axis <- match.arg(axis)
		0 != length(grep(axis, log))
	}
	if (! (is.vector(center) && 2==length(center))) stop("center must be a vector of length 2")
	if (! (is.matrix(shape) && all(2==dim(shape)))) stop("shape must be a 2 by 2 matrix")
	if (max(abs(shape - t(shape)))/max(abs(shape)) > 1e-10) stop("shape must be a symmetric matrix")
	angles <- (0:segments)*2*pi/segments 
	unit.circle <- cbind(cos(angles), sin(angles)) 
#	ellipse <- t(center + radius*t(unit.circle %*% chol(shape,pivot=TRUE))) 
	Q <- chol(shape, pivot=TRUE)
	order <- order(attr(Q, "pivot"))
	ellipse <- t( center + radius*t( unit.circle %*% Q[,order]))
	colnames(ellipse) <- c("x", "y")
	if (logged("x")) ellipse[, "x"] <- exp(ellipse[, "x"])
	if (logged("y")) ellipse[, "y"] <- exp(ellipse[, "y"])
#	fill.col <- trans.colors(col, fill.alpha)
	fill.col <- grDevices::adjustcolor(col, alpha = fill.alpha)
	if (draw) {
		if (add) {
			lines(ellipse, col=col, lwd=lwd, ...) 
			if (fill) polygon(ellipse, col=fill.col, border=NA)
		}
		else {
			plot(ellipse, type="n", xlab = xlab, ylab = ylab, ...) 
			if(grid){
				grid(lty=1, equilogs=FALSE)
				box()}
			lines(ellipse, col=col, lwd=lwd, ... )
			if (fill) polygon(ellipse, col=fill.col, border=NA)
		} 	
		if ((center.pch != FALSE) && (!is.null(center.pch))) points(center[1], center[2], pch=center.pch, cex=center.cex, col=col)
	}
	invisible(ellipse)
}

dataEllipse <- function(x, ...){
  UseMethod("dataEllipse")
}

dataEllipse.default <- function(x, y, groups,
    group.labels=group.levels, ellipse.label, 
    weights, log="", levels=c(0.5, 0.95), center.pch=19, 
    center.cex=1.5, draw=TRUE,
    plot.points=draw, add=!plot.points, 
    segments=51, robust=FALSE, 
    xlab=deparse(substitute(x)), 
    ylab=deparse(substitute(y)), 
    col=if (missing(groups)) carPalette()[1:2] else carPalette()[1:length(group.levels)],
    pch=if (missing(groups)) 1 else seq(group.levels),
    lwd=2, fill=FALSE, fill.alpha=0.3, grid=TRUE, id=FALSE,
    label.pos=NULL, label.cex = 1.25, label.xpd=FALSE,
    ...) {
 
#   copied from heplots::label.ellipse
    label.ellipse <- function(ellipse, label, col="black",
                            label.pos=NULL, xpd=FALSE, cex=NULL,  # MF: added cex
                            tweak=0.5*c(strwidth("M"), strheight("M")), ...){
    
    ellipse <- as.matrix(ellipse)
    if (ncol(ellipse) < 2) stop("ellipse must be a 2-column matrix")
    
    if (is.null(label.pos)) {
      r = cor(ellipse, use="complete.obs")[1,2]
      label.pos <- if (r>0) 3 else 1
    }
    else if(length(label.pos) > 1) {
      warning("label.pos = ", paste(label.pos, collapse=", "), " has length ", length(label.pos), " only 1st used." )
      label.pos <- label.pos[1]    # only use 1st if > 1
    }
    
    #		index <- if (1:4 %% 2) ... 
    
    posn <- c("center", "bottom", "left", "top", "right")
    poss <- c("C",      "S",      "W",    "N",   "E")
    if (is.character(label.pos)) {
      if (label.pos %in% posn) label.pos <- pmatch(label.pos, posn, nomatch=3) - 1
      if (label.pos %in% poss) label.pos <- pmatch(label.pos, poss, nomatch=3) - 1
    }
    pos <- label.pos
    
    if (label.pos==1) {   # bottom
      index <- which.min(ellipse[,2])
      x <- ellipse[index, 1]
      y <- ellipse[index, 2] + tweak[2]
    }
    else if (label.pos==2) {   # left
      index <- which.min(ellipse[,1])
      x <- ellipse[index, 1] + tweak[1]
      y <- ellipse[index, 2]
    }
    else if (label.pos==3) {   # top
      index <- which.max(ellipse[,2])
      x <- ellipse[index, 1] 
      y <- ellipse[index, 2] - tweak[2]
    }
    else if (label.pos==4) {   # right
      index <- which.max(ellipse[,1])
      x <- ellipse[index, 1] - tweak[1]
      y <- ellipse[index, 2]
    }
    else if (label.pos==0) {   # center
      x <- mean(ellipse[, 1])
      y <- mean(ellipse[, 2]) - tweak[2]
      pos <-3
    }
    else  {  # use as index into ellipse coords
      if (0 < label.pos & label.pos < 1) 
        label.pos <- floor(label.pos * nrow(ellipse))
      index <- max(1, min(label.pos, nrow(ellipse)))
      x <- ellipse[index, 1]
      y <- ellipse[index, 2]
      pos <- 4 - floor(4*(index-1)/nrow(ellipse))
    }
    
    text(x, y, label, pos=pos, xpd=xpd, col=col, cex=cex, ...)  # MF: cex now explicit
  }
  
  
    default.col <- if (missing(groups)) carPalette()[1] else carPalette()[1:length(groups)]
    id <- applyDefaults(id, defaults=list(method="mahal", n=2, cex=1, col=default.col, location="lr"), type="id")
    if (isFALSE(id)){
        id.n <- 0
        id.method <- "none"
        labels <- id.cex <- id.col <- id.location <- NULL
    }
    else{
        labels <- id$labels
        if (is.null(labels)) labels <- seq(along=y)
        id.method <- id$method
        id.n <- if ("identify" %in% id.method) Inf else id$n
        id.cex <- id$cex
        id.col <- id$col
        id.location <- id$location
    }
    if(missing(y)){
        if (is.matrix(x) && ncol(x) == 2) {
            if (missing(xlab)) xlab <- colnames(x)[1]
            if (missing(ylab)) ylab <- colnames(x)[2]
            y <- x[,2]
            x <- x[,1]
        }
        else stop("x and y must be vectors, or x must be a 2 column matrix")
    }
    else if(!(is.vector(x) && is.vector(y) && length(x) == length(y)))
        stop("x and y must be vectors of the same length")
    if (missing(weights)) weights <- rep(1, length(x))
    if (length(weights) != length(x)) stop("weights must be of the same length as x and y")
    if (!missing(groups)){
        xlab
        ylab
        if (!is.factor(groups)) stop ("groups must be a factor")
        groups <- droplevels(groups)
        if (!(length(groups) == length(x))) stop ("groups, x, and y must all be of the same length")
        if(missing(labels)) labels <- seq(length(x))
        valid <- complete.cases(x, y, groups)
        x <- x[valid]
        y <- y[valid]
        weights <- weights[valid]
        groups <- groups[valid]
        labels <- labels[valid]
        group.levels <- levels(groups)
        col <- col[!is.na(col)]
        if (length(col) < length(group.levels)) stop("too few colors for number of groups")
        result <- vector(length(group.levels), mode="list")
        names(result) <- group.levels
        if(draw) {
            if (!add) {
                plot(x, y, type="n", xlab=xlab, ylab=ylab,  ...) 
                if(grid){
                    grid(lty=1, equilogs=FALSE)
                    box()
                }
            }
        }

        id.lev <- list(method=id.method, n=id.n, cex=id.cex, col=NULL, labels=NULL, location=id.location)
        if(!is.null(label.pos)) label.pos <- rep(label.pos, length.out = length(group.levels))
        for (lev in 1:length(group.levels)){
            level <- group.levels[lev]
            sel <- groups == level
            id.lev$labels <- labels[sel]
            id.lev$col <- rep(id.col[lev], 2)
            lpos <- if(!is.null(label.pos) & length(label.pos)==1) label.pos else label.pos[lev]                                                      # MF
            #cat("Level: ", level, " label.pos: ", lpos, "\n")
            result[[lev]] <- dataEllipse(x[sel], y[sel],
                label.pos = lpos, label.cex = label.cex, label.xpd = label.xpd,                               # MF
                weights=weights[sel], log=log, levels=levels, center.pch=center.pch,
                center.cex=center.cex, draw=draw, plot.points=plot.points, add=TRUE, segments=segments,
                robust=robust, col=rep(col[lev], 2), pch=pch[lev], lwd=lwd, fill=fill, fill.alpha=fill.alpha,
                id=id.lev,
                # labels=labels[sel], id.method=id.method, id.n=id.n, id.cex=id.cex, 
                # id.col=col[lev], id.location=id.location,
                ellipse.label=group.labels[lev], ...)
        }
        return(invisible(result))
    }
    if (length(col) == 1) col <- rep(col, 2)
    if(draw) {
        if (!add) {
            plot(x, y, type="n", xlab=xlab, ylab=ylab,  ...) 
            if(grid){
                grid(lty=1, equilogs=FALSE)
                box()}
        }
        if (plot.points)  points(x, y, col=col[1], pch=pch[1], ...)
    }
    dfn <- 2
    dfd <- length(x) - 1
    if (robust) {
        use <- weights > 0
        v <- MASS::cov.trob(cbind(x[use], y[use]), wt=weights[use])
        shape <- v$cov
        center <- v$center
    }
    else {
        v <- cov.wt(cbind(x, y), wt=weights)
        shape <- v$cov
        center <- v$center
    }
    result <- vector("list", length=length(levels))
    names(result) <- levels
    for (i in seq(along=levels)) {
        level <- levels[i]
        radius <- sqrt(dfn * qf(level, dfn, dfd ))
        result[[i]] <- ellipse(center, shape, radius, log=log,
            center.pch=center.pch, center.cex=center.cex, segments=segments, 
            col=col[2], lwd=lwd, fill=fill, fill.alpha=fill.alpha, draw=draw, ...)

        if (!missing(ellipse.label)) {
            lab <- if (length(ellipse.label) < i) ellipse.label[1] else ellipse.label[i]
            dots <- list(...)
            dots[["cex"]] <- NULL  # MF: remove cex from ... before call; it is passed explicitly below
            do.call(label.ellipse, c(list(result[[i]], lab, col[2]),
                                     list(label.pos=label.pos, cex=label.cex, xpd=label.xpd),
                                     dots))
        }
    }
    if (missing(labels)) labels <- seq(length(x))
    if (draw) showLabels(x, y, labels=labels,
        method=id.method, n=id.n, cex=id.cex,
        col=id.col, location = id.location)
    invisible(if (length(levels) == 1) result[[1]] else result)
}

dataEllipse.formula <- function (formula, data, subset, weights, 
                                 xlab, ylab, id=FALSE, ...) {
  
  id <- if (is.logical(id)){
    if (isTRUE(id)) list() else FALSE
  } else {
    as.list(id)
  }
  
  if (missing(data)) data <- environment(formula)
  mf <- match.call(expand.dots = FALSE)
  m <- match(c("formula", "data", "subset", "weights"), 
             names(mf), 
             0L)
  mf <- mf[c(1L, m)]
  mf$drop.unused.levels <- TRUE
  mf$na.action <- na.pass
  formula <- Formula::as.Formula(formula)
  
  if (length(formula)[1L] != 1L) {
    stop("LHS of formula should have one element")
  }
  if (!(length(formula)[2L] %in% 1L:2L)){
    stop("RHS of formula should have 1 or 2 elements")
  }
  
  mf$formula <- formula
  mf[[1L]] <- as.name("model.frame")
  
  subs <- as.expression(mf$subset)
  
  mf <- eval(mf, parent.frame())
  
  subs <- eval(subs, envir=data)
  if (is.null(subs)) subs <- TRUE
  
  variables <- all.vars(formula)
  if (length(variables) > 3L) stop("too many variables ( > 3)")
  
  mt <- terms(formula, data = data)
  mtX <- terms(formula, data = data, rhs = 1L)
  X <- model.matrix(mtX, mf)
  X[, 1L] <- model.response(mf, "numeric")
  X <- as.data.frame(X)
  
  if (length(formula)[2L] == 2L){
    X <- cbind(X, 
               if (is.data.frame(data)){
                 data[subs, variables[3L]]
               } else {
                 eval(parse(text=variables[3L]), envir=data)[subs]
               }
    )
  }
  if (ncol(X) > 3L) stop("incorrect formula")
  colnames(X) <- variables
  
  weights <- model.weights(mf)
  if (is.null(weights)) weights <- rep(1, nrow(X))
  X <- na.omit(cbind(weights, X))
  weights <- X[, 1L]
  X <- X[, -1L]
  
  if (!isFALSE(id) && is.null(id$labels)) id$labels <- row.names(X)
  if (is.factor(X[, 2L]) && !is.list(id))  id <- list(labels=row.names(X))
  
  names <- colnames(X)
  if (missing(xlab)) xlab <- names[2L]
  if (missing(ylab)) ylab <- names[1L]
  
  if (ncol(X) == 2L) {
    dataEllipse(X[, 2L], X[, 1L], xlab=xlab, ylab=ylab,
                id=id, weights=weights, ...)
  } else {
    dataEllipse(X[, 2L], X[, 1L], groups=X[, 3L], xlab=xlab, ylab=ylab,
                id=id, weights=weights, ...)
  }
  
}
    
confidenceEllipse <- function (model, ...) {
	UseMethod("confidenceEllipse")
}

confidenceEllipse.lm <- function(model, which.coef, vcov.=vcov, L, levels=0.95, Scheffe=FALSE, dfn,
		center.pch=19, center.cex=1.5, segments=51, xlab, ylab, 
		col=carPalette()[2], lwd=2, fill=FALSE, fill.alpha=0.3, draw=TRUE, add=!draw, grid=TRUE, ...){
	if (missing(dfn)) dfn <- if (Scheffe) sum(df.terms(model)) else 2
	dfd <- df.residual(model)
	vcov. <- getVcov(vcov., model)
	if (missing(L)){
		which.coef <- if(length(coefficients(model)) == 2) c(1, 2)
				else{
					if (missing(which.coef)){
						if (has.intercept(model)) c(2,3) else c(1, 2)
					} else which.coef
				}
		coef <- coefficients(model)[which.coef]
		if (missing(xlab)) xlab <- paste(names(coef)[1], "coefficient")
		if (missing(ylab)) ylab <-  paste(names(coef)[2], "coefficient")
		shape <- vcov.[which.coef, which.coef]
	}
	else {
		res <- makeLinearCombinations(L, coef(model), vcov.)
		coef <- res$coef
		xlab <- res$xlab
		ylab <- res$ylab
		shape <- res$shape
	}
	levels <- rev(sort(levels))
	result <- vector("list", length=length(levels))
	names(result) <- levels
	for (i in seq(along=levels)){
		level <- levels[i]
		radius <- sqrt(dfn*qf(level, dfn, dfd))
		add.plot <- !level==max(levels) | add
		result[[i]] <- ellipse(coef, shape, radius, add=add.plot, xlab=xlab, ylab=ylab,
				center.pch=center.pch, center.cex=center.cex, segments=segments, 
				col=col, lwd=lwd, fill=fill, fill.alpha=fill.alpha, draw=draw, grid=grid, ...)
	}
	invisible(if (length(levels) == 1) result[[1]] else result)
}


confidenceEllipse.default <- function(model, which.coef, vcov.=vcov, L, levels=0.95, Scheffe=FALSE, dfn,
		center.pch=19, center.cex=1.5, segments=51, xlab, ylab,
		col=carPalette()[2], lwd=2, fill=FALSE, fill.alpha=0.3, draw=TRUE, add=!draw, grid=TRUE, ...){
  vcov. <- getVcov(vcov., model)  
#if (is.function(vcov.)) vcov. <- vcov.(model)
	if (missing(L)){
		which.coef <- if(length(coefficients(model)) == 2) c(1, 2)
				else{
					if (missing(which.coef)){
						if (has.intercept(model)) c(2, 3) else c(1, 2)
					} else which.coef
				}
		coef <- coefficients(model)[which.coef]
		shape <- vcov.[which.coef, which.coef]
		xlab <- if (missing(xlab)) paste(names(coef)[1], "coefficient")
		ylab <- if (missing(ylab)) paste(names(coef)[2], "coefficient")
	}
	else {
		res <- makeLinearCombinations(L, coef(model), vcov.)
		coef <- res$coef
		xlab <- res$xlab
		ylab <- res$ylab
		shape <- res$shape
	}
	df <- if (!missing(dfn)) dfn
			else if (Scheffe) sum(df.terms(model)) else 2
	levels <- rev(sort(levels))
	result <- vector("list", length=length(levels))
	names(result) <- levels
	for (i in seq(along=levels)){
		level <- levels[i]
		radius <- sqrt(qchisq(level, df))
		add.plot <- !level==max(levels) | add
		result[[i]] <- ellipse(coef, shape, radius, add=add.plot, xlab=xlab, ylab=ylab,
				center.pch=center.pch, center.cex=center.cex, segments=segments,
				col=col, lwd=lwd, fill=fill, fill.alpha=fill.alpha, draw=draw, grid=grid, ...)
	}
	invisible(if (length(levels) == 1) result[[1]] else result)
}

confidenceEllipse.glm <- function (model, chisq, ...) {
	sumry <- summary(model)
	if (missing(chisq)) chisq <- is.null(sumry$dispersion)
	if (chisq) confidenceEllipse.default(model, ...)
	else confidenceEllipse.lm(model, ...)
}

makeLinearCombinations <- function(L, coef, V){
	nms <- names(coef)
	if (is.character(L)){
		L <- makeHypothesis(nms, L)
		L <- L[, -ncol(L)]
	}
	if (nrow(L) != 2 || ncol(L) != length(coef))
		stop("the hypothesis matrix is the wrong size")
	coef <- as.vector(L %*% coef)
	shape <- L %*% V %*% t(L)
	L.nms <- printHypothesis(L, c(0, 0), nms)
	names(coef) <- sub(" =.*", "", L.nms)
	xlab <- names(coef)[1]
	ylab <- names(coef)[2]
	list(coef=coef, shape=shape, xlab=xlab, ylab=ylab)
}

confidenceEllipses <- function(model, ...) {
  UseMethod("confidenceEllipses")
}

confidenceEllipses.default <- function(model, coefnames,  main, grid=TRUE, ...) {
    if (missing(main))
      main <- paste("Pairwise Confidence Ellipses for",
                    deparse(substitute(model)))
    b <- coef(model)
    p <- length(b)
    if (missing(coefnames))
      coefnames <- paste0(names(b), "\ncoefficient")
    save <-
      par(
        mfrow = c(p, p),
        mar = c(2, 2, 0, 0) + 0.1,
        oma = c(0, 0, 2, 0) + 0.2
      )
    on.exit(par(save))
    ylab <- coefnames[1]
    for (i in 1:p) {
      for (j in 1:p) {
        if (j == 1) {
          yaxis <- TRUE
        } else {
          yaxis <- FALSE
        }
        if (i == p) {
          xaxis <- TRUE
        } else {
          xaxis <- FALSE
        }
        if (i == j) {
          if (i == 1) {
            confidenceEllipse(
              model,
              c(2, 1),
              xaxt = "n",
              yaxt = "n",
              center.pch = "",
              col = "white",
              grid = FALSE
            )
            axis(2)
          } else if (j == p) {
            confidenceEllipse(
              model,
              c(p, 2),
              xaxt = "n",
              yaxt = "n",
              center.pch = "",
              col = "white",
              grid = FALSE
            )
            axis(1)
          }
          else {
            confidenceEllipse(
              model,
              c(1, 2),
              xaxt = "n",
              yaxt = "n",
              center.pch = "",
              col = "white",
              grid = FALSE
            )
          }
          usr <- par("usr")
          text(mean(usr[1:2]), mean(usr[3:4]), coefnames[i])
        }
        else{
          confidenceEllipse(model, c(j, i), # xlab = xlab, ylab = ylab,
                            xaxt = "n", yaxt = "n", grid=grid, ...)
          if (j == 1)
            axis(2)
          if (i == p)
            axis(1)
        }
      }
    }
    title(main = main,
          outer = TRUE,
          line = 1)
    invisible(NULL)
}

confidenceEllipse.mlm <- function(model, xlab, ylab, which.coef=1:2, ...){
  if (missing(xlab) || missing(ylab)){
    coefnames <- rownames(vcov(model))
    if (missing(xlab)) xlab <- coefnames[which.coef[1]]
    if (missing(ylab)) ylab <- coefnames[which.coef[2]]
  }
  NextMethod(xlab=xlab, ylab=ylab)
}

confidenceEllipses.mlm <- function(model, coefnames, main, ...) {
  if (missing(coefnames))  {
    coefnames <- rownames(vcov(model))
    coefnames <- paste0(coefnames, "\ncoefficient")
  }
  if (missing(main))
    main <- paste("Pairwise Confidence Ellipses for",
                           deparse(substitute(model)))
  NextMethod(coefnames = coefnames, main = main)
}
