# TODO Additions
# 

Some things I'd like to add to the book (or online supplements)

## 3D plots

There are no 3D plots in the book, largely b/c it's hard to make them look nice. But it would be useful to have a few.

* 3D data plot, with PCA axes : ./R/iris/iris-3D-rgl.R
* 3D scatterplot with fitted regression surface
* Vector diagram showing a fitted regression
* One nice heplot3d()

Example source files:

```
$ find ./R |grep "3" |grep "\.R"
./R/coffee/coffee-av3D.R
./R/crime/crime-biplot2d3d.R
./R/diabetes/diabetes-3d.R
./R/Duncan/Duncan-3D.R
./R/iris/iris-3D-rgl.R
./R/iris/iris-3D-spin.R
./R/penguin/peng-3D-rgl.R
./R/penguin/peng-3D-spin.R
./R/penguin/penguins3d.R
./R/pollen-3D.R
```


## Discriminant analysis

* Plots in data space showing the discriminant classifications boundaries. The beginning of this is in `child/10-discrim.qmd`

  - Generate a grid of values for two focal variables.
  - Get predicted class
  - Plot using geom_tile
  - Examples: 

```
$ find ./R | grep "lda"
./R/dogfood/dogfood-lda.R
./R/iris/iris-lda-ggplot.R
./R/iris/iris-lda-margeffs.R
./R/iris/iris-lda.R
./R/lda-ex.R
./R/lda-ggord.R
./R/penguin/peng.lda.R
```

* Plots in discriminant space showing disc boundaries

  - Can this be added to candisc::plot.candisc

## Effect plots

* Could go in Ch10, e.g., 
  - Parenting data or AddHealth [1 way]
  - MockJury [2-way]
  - use effects::Effect.mlm

## Robust methods

* Add section on robust PCA to Ch 13
