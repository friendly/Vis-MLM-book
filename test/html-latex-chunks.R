```{r, echo=FALSE, fig.asp=1}
if (knitr::is_html_output()) {
  if (!file.exists("img/pca.gif")) {

	# create animation
    library(animation)
    saveGIF({
    # code to draw the animation
    }, interval = 0.1, ani.width = 600, ani.height = 600, ani.res = 90,
    loop = TRUE, movie.name = "pca.gif")
    system(paste("mv pca.gif", file.path("img", "pca.gif")))
  }
  knitr::include_graphics("img/pca.gif")
}
```

```{r pca-demo, echo=FALSE}
if (!knitr::is_html_output()) {
  library(ggExtra)
  library(gridExtra)
  # create two plots to be shown in PDF
  thetas <- c(0,-45)*2*pi/360
  ps <- vector("list", 2)
  for (i in 1:2) {
    A <- matrix(c(cos(thetas[i]), -sin(thetas[i]), 
                  sin(thetas[i]), cos(thetas[i])), 2, 2)
    z <- x %*% A
    sds <- apply(z, 2, sd)
    lim <- c(-4, 4)
    p <- data.frame(x1 = z[,1], x2 = z[,2]) |>  
      ggplot(aes(x1, x2)) + geom_point() +
      xlim(lim) + ylim(lim) + 
      xlab(paste("Dimension 1 SD =",format(round(sds[1],2)))) +
      ylab(paste("Dimension 2 SD =",format(round(sds[2],2))))
    ps[[i]] <- ggMarginal(p, bw = 0.375, fill = "grey")
  }
  grid.arrange(ps[[1]], ps[[2]], ncol = 2)
}
```
