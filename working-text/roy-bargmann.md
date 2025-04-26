## Stepdown analysis of multivariate models in R

Roy - Bargmann stepdown tests are commonly recommended for multivariate linear models fit with `lm()` as:

```
lm(cbind(y1, y2, y3, ...) ~ x1 + x2 + x3 + ...)
```

But I can't find any implementation in R for class `"mlm"` objects.  The idea is relatively straight-forward. Simple fit a
collection of models, with the Y variables in a defined order, where in each model after the first, a response on the
left-hand-side becomes a predictor on the right-hand-side.

```
lm(cbind(y1, y2, y3) ~ x1 + x2 + x3 + ...)
lm(cbind(    y2, y3) ~ x1 + x2 + x3 + y1 + ...)
lm(cbind(        y3) ~ x1 + x2 + x3 + y1, y2 + ...)
```

Sets of models like these can be fit `manuall` as above, but I'll looking for some way to generate this collection
in a function and return these in a list. 

I wonder if `update()` can help here or else some other way to manipulate the model formula.
