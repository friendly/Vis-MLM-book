# Partial variables plot

# To understand the partial correlations, make scatterplots of the residuals from the
# models where each x_i, x_j are predicted by all others. 

# see also: pairs version
# https://stackoverflow.com/questions/35591033/plot-scatterplot-matrix-with-partial-correlation-coefficients-in-r

pvPlot <- function(X, vars = 1:2,
                   col = "black", 
                   pch = 16, 
                   cex = par("cex"),
                   axes = TRUE,
                   ...) {
  nv <- ncol(X)
  nr <- nrow(X)
  v1 <- vars[1]
  v2 <- vars[2]
  all <- if(is.numeric(vars)) seq_along(nv) else names(X)
  others <- setdiff(all, vars)
  res <- X[, vars]
  res[, 1] <- lsfit(X[, others], X[, v1])$residuals
  res[, 2] <- lsfit(X[, others], X[, v2])$residuals
  plot(res, 
       col = col, pch = pch, cex = cex, ...)
  if (axes)
    abline(h = 0, v = 0, col = "gray")
  invisible(res)
}

if(FALSE) {
  data(crime, package = "ggbiplot")
  res <- crime |>
    tibble::column_to_rownames("st") |>
    dplyr::select(where(is.numeric)) |>
    pvPlot(vars = c("burglary", "larceny"))
  
  head(res)
  car::scatterplot(larceny ~ burglary, data = res, 
                   xlab = "burglary residual",
                   ylab = "larceny residual",
                   pch = 16, col = "black",
                   smooth = FALSE, boxplots = FALSE,
                   grid = FALSE,
                   id = list(n=5))
  abline(h = 0, v = 0, col = "gray")
  text(-600, 1300, 
       label = paste("partial r =", 
                     round(cor(res[,1], res[,2]), 3)),
       pos = 4)
  
}