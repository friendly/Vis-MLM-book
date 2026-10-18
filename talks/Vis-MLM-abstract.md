# Visualizing Multivariate Data and Models in R: A Romance in Many Dimensions

**Michael Friendly**, York University

Methodology & Statistics Group, Utrecht, 6 November 2026

## Abstract

For a linear model with a single response, we have a rich and familiar toolkit of plots for understanding the data, the fitted model and its problems. With several responses, the model is just as easy to fit, but the results usually arrive as tables of multivariate tests, with little to show what they mean. This talk, based on my forthcoming book (CRC Press), argues that multivariate models deserve graphs as good as those we have for a single response. It shows how far a few simple ideas can take us toward that goal.

The subtitle is a nod to Abbott's *Flatland*: our data live in many dimensions, but we can only plot them in two, so multivariate visualization is largely the art of choosing good views. Rather than following the book chapter by chapter, the talk follows two visual ideas that run through it.

The first is the ellipse. As a data ellipse, it summarizes means, spread and correlation, and with the points removed it shows everything a linear model sees. Ellipses also give a geometric account of problems that are hard to see in formulas: outliers hiding in the smallest dimensions, the effects of measurement error in predictors, collinearity, and ridge regression. Finally, the hypothesis (**H**) and error (**E**) ellipses of the HE plot framework show the size and nature of effects in MANOVA and multivariate regression, and provide visual tests for significance.

The second is the multivariate juicer: dimension-reduction methods that squeeze many variables a few views that matter for a given goal. Principal components and biplots do this for data; canonical discriminant analysis does the same for a multivariate model. The talk ends with ways to check such models: plots for outliers, influence and robust estimation.

All of these methods are implemented in R, largely in the **heplots**, **candisc**, **mvinfluence**, **genridge** and **VisCollin** packages. The examples, with animations and complete code, are in the online version of the book at <https://friendly.github.io/Vis-MLM-book>.
