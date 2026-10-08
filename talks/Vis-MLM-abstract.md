# Visualizing Multivariate Data and Models in R: A Romance in Many Dimensions

**Michael Friendly**, York University

Methodology & Statistics Group, Utrecht, 5 November 2026

## Abstract

For a linear model with a single response, we have a rich and familiar toolkit of plots for understanding the data, the fitted model and its problems. With several responses, the model is just as easy to fit, but the results usually arrive as tables of multivariate tests, with little to show what they mean. This talk, based on my forthcoming book of the same title (CRC Press), argues that multivariate models deserve graphs as good as those we have for a single response, and shows how far a few simple ideas can take us toward that goal.

The subtitle is a nod to Abbott's *Flatland*: our data live in many dimensions, but we can only plot them in two, so multivariate visualization is largely the art of choosing good views. The talk follows the path of the book, from plots of data, to plots of models with one response, to plots of models with many. One device ties these together: the ellipse, first as a data ellipse summarizing means, spread and correlation, then as a confidence ellipse for coefficients, and finally as the hypothesis (**H**) and error (**E**) ellipses of the HE plot framework, which show the size and nature of effects in MANOVA and multivariate regression. Along the way, I illustrate dimension reduction methods (PCA, biplots, canonical discriminant analysis) as ways to find the low-dimensional views that matter, a graphical account of collinearity and ridge regression, and diagnostic plots for outliers, influence and robust estimation in multivariate models.

All of these methods are implemented in R, largely in the **heplots**, **candisc**, **mvinfluence** and **genridge** packages. The examples, with animations and complete code, are in the online version of the book at <https://friendly.github.io/Vis-MLM-book>.
