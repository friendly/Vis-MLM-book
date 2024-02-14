My env: Quarto 1.3.450 / R version 4.3.2

For a book project using Quarto I'm trying to place figures side-by-side from R code.
This always worked perfectly with `knitr/rmarkdown` using `fig.show="hold", out.width="49%"`
The Quarto documentation https://quarto.org/docs/authoring/figures.html shows
examples using `:::` divs and `![Surus](surus.png){#fig-surus}`, but not for code blocks.
What am I doing wrong?

```{r fig.show="hold", out.width="49%"}
#| label: fig-proj-vectors
#| code-fold: true
#| fig-cap: "Data variables viewed as vectors in the space of their projections. The angles of the **x** vectors with respect to the **y** coordinate axes show their relative contributions to each. The lengths of the **x** vectors show the relative degree to which they are library(matlib)

vals <- c(0, 10)
X <- expand.grid(x1 = vals, x2=vals, x3=vals) |> as.matrix()
# project on just x1, x2 plane
P1 <- rbind(diag(2), c(0,0))
Y1 <- X %*% P1
# oblique projection
P2 <- matrix(c(0.71, 0.71, 0, -0.42, .42, 0.84), ncol=2)
Y2 <- X %*% P2

op <- par(mar=c(4, 5, 1, 1)+.1)
xlim <- ylim <- c(-1.1, 1.1)
axes.x <- c(-1, 1, NA, 0, 0)
axes.y <- c(0, 0, NA, -1, 1)
labs <- c(expression(x[1]), expression(x[2]), expression(x[3]))
plot(xlim, ylim, type = "n", asp=1,
     xlab = expression(y[1]), ylab = expression(y[2]),
     cex.lab = 1.8)
circle(0, 0, 1, col = adjustcolor("skyblue", alpha = 0.2))
lines(axes.x, axes.y, col = "grey")
vectors(P1, labels = labs, cex.lab = 1.8, lwd = 3, pos.lab = c(4, 2, 1))

plot(xlim, ylim, type = "n", asp=1,
     xlab = expression(y[1]), ylab = expression(y[2]),
     cex.lab = 1.8)
circle(0, 0, 1, col = adjustcolor("skyblue", alpha = 0.2))
lines(axes.x, axes.y, col = "grey")
vectors(P2, labels = labs, cex.lab = 1.8, lwd = 3)
par(op)
```

I also tried using `include_graphics()` with the figures generated from the previous code block:

```{r}
#| label: fig-proj-vectors
#| fig-show: hold
#| out-width: "49%"
#| echo: false
#| fig-cap: "Data variables viewed as vectors in the space of their projections. The angles of the **x** vectors with respect to the **y** coordinate axes show their relative contributions to each. The lengths of the **x** vectors show the relative degree to which they are represented in the space of **y**s. Left: **P1** projection; right: **P2** projection."
knitr::include_graphics(c("figs/ch03/fig-proj-vectors-1.png",
                          "figs/ch03/fig-proj-vectors-2.png"))
```
