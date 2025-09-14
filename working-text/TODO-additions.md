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

* Plots in data space showing the discriminant classifications boundaries

  - Generate a grid of values for two focal variables.
  - Get predicted class
  - Plot using geom_tile

* Plots in discriminant space showing disc boundaries

  - Can this be added to candisc::plot.candisc

## Effect plots

* Could go in Ch10, e.g., 
  - Parenting data or AddHealth [1 way]
  - MockJury [2-way]
  - use effects::Effect.mlm
