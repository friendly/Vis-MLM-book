## How make figs side-by-side and produce different HTML / PDF versions

From: https://github.com/dicook/mulgar_book/blob/master/3-intro-dimred.qmd


Now let's think about what this looks like with five variables. `r ifelse(knitr::is_html_output(), '@fig-dimension-html', '@fig-dimension-pdf')` shows a grand tour on five variables, with (a) data that is primarily 2D, (b) data that is primarily 3D and (c) fully 5D data.  You can see that both (a) and (b) the spread of points collapse in some projections, with it happening more in (a). In (c) the data is always spread out in the square, although it does seem to concentrate or pile in the centre. This piling is typical when projecting from high dimensions to low dimensions. The sage tour [@sagetour] makes a correction for this. 

```{r echo=knitr::is_html_output()}
#| eval: false
#| code-summary: "Code to make animated gifs"
library(mulgar)
data(plane)
data(box)
render_gif(plane,
           grand_tour(), 
           display_xy(),
           gif_file="gifs/plane.gif",
           frames=500,
           width=200,
           height=200)
render_gif(box,
           grand_tour(), 
           display_xy(),
           gif_file="gifs/box.gif",
           frames=500,
           width=200,
           height=200)
# Simulate full cube
library(geozoo)
cube5d <- data.frame(cube.solid.random(p=5, n=300)$points)
colnames(cube5d) <- paste0("x", 1:5)
cube5d <- data.frame(apply(cube5d, 2, function(x) (x-mean(x))/sd(x)))
render_gif(cube5d,
           grand_tour(), 
           display_xy(),
           gif_file="gifs/cube5d.gif",
           frames=500,
           width=200,
           height=200)
```

::: {.content-visible when-format="html"}

::: {#fig-dimension-html fig-align="center" layout-ncol=3}

![2D plane in 5D](gifs/plane.gif){#fig-plane width=180 fig-alt="Animation of sequences of 2D projections shown as scatterplots. You can see points collapsing into a thick straight line in various projections. A circle with line segments indicates the projection coefficients for each variable for all projections viewed."}

![3D plane in 5D](gifs/box.gif){#fig-box width=180 fig-alt="Animation of sequences of 2D projections shown as scatterplots. You can see points collapsing into a thick straight line in various projections, but not as often as in the animation in (a). A circle with line segments indicates the projection coefficients for each variable for all projections viewed."}

![5D plane in 5D](gifs/cube5d.gif){#fig-cube5 width=180 fig-alt="Animation of sequences of 2D projections shown as scatterplots. You can see points are always spread out fully in the plot space, in all projections. A circle with line segments indicates the projection coefficients for each variable for all projections viewed."}

Different dimensional planes - 2D, 3D, 5D - displayed in a grand tour projecting into 2D. Notice that the 5D in 5D always fills out the box (although it does concentrate some in the middle which is typical when projecting from high to low dimensions). Also you can see that the 2D in 5D, concentrates into a line more than the 3D in 5D. This suggests that it is lower dimensional. 
:::
:::

::: {.content-visible when-format="pdf"}

::: {#fig-dimension-pdf layout-ncol=3}

![2D plane in 5D](images/plane.png){#fig-plane width=160}

![3D plane in 5D](images/box.png){#fig-box width=160}

![5D plane in 5D](images/cube5d.png){#fig-cube5 width=160}

Single frames from different dimensional planes - 2D, 3D, 5D - displayed in a grand tour projecting into 2D. Notice that the 5D in 5D always fills out the box (although it does concentrate some in the middle which is typical when projecting from high to low dimensions). Also you can see that the 2D in 5D, concentrates into a line more than the 3D in 5D. This suggests that it is lower dimensional. (Animations can be viewed [here](https://dicook.github.io/mulgar_book/3-intro-dimred.html).)
:::
:::

