# Code simplifications
# 

Since this book was written, there have been a number of enhancements to `dplyr` and `ggplot2`. E.g., 

* `dplyr` 1.2.0 adds verbs `filter_out()`, `recode_values()`, `replace_values()`, and `replace_when()`
* Check what added in ggplot2
* I have a function: `util/geom_means.R`, not used in the book, but designed to make it easier to plot points at the (x,y) means, even grouped.

It is way to late to contemplate a thorough revision, but perhaps there are a couple of tricks that
could make the book better?

As well, many plots that use base R `plot()` could be made nicer or code simpler by using `tinyplot()`.
But I wonder about the advisability of doing this sporadically -- might confuse the reader.

As  first step towards thinking about this, it would be good to identify cases in the plotting/analysis code
that would be candidates for simplification.