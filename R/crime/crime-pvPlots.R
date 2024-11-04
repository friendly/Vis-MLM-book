# Scatterplots for the two largest partial correlations in the crime data

source(here::here("R", "pvPlot.R"))

data(crime, package = "ggbiplot")
crime.num <- crime |>
  tibble::column_to_rownames("st") |>
  dplyr::select(where(is.numeric))

# combine side by side
op <- par(mar = c(5, 5, 1, 0)+.5,
          mfrow = c(1, 2))
pvPlot(crime.num, vars = c("burglary", "larceny"), 
       id = list(n=5), cex.lab = 1.5)
pvPlot(crime.num, vars = c("robbery", "auto"), 
       id = list(n=5), cex.lab = 1.5)
par(op)
  

#  try using dataEllipse directly

res <- pvPlot(crime.num, vars = c("burglary", "larceny"), draw = FALSE)
dataEllipse(larceny ~ burglary, data = res,
            levels = 0.68, fill = TRUE, fill.alpha = 0.05, robust=FALSE,
            grid = FALSE,
            pch = 16,
            id = list(n=5))
abline(h = 0, v = 0, col = "gray")
abline(lm(larceny ~ burglary, data = res), lwd=2)

# now, using dataEllipse
pvPlot(crime.num, vars = c("burglary", "larceny"), 
       id = list(n=5),
       cex.lab = 1.5)

  

  
# earlier attempts, saving to separate  
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
  
  
