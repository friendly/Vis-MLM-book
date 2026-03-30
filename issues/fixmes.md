# FIXMEs
# 
Some small glitches to be fixed:
  
* `pkg(, cite=TRUE)` sometimes inserts extra space or line break --> maybe use `\ixp{}` directly ?

* In PDF, `hrefs` should be footnotes, because the link isn't visible in print

* using `colorize()` for text can be replaced by `colorize_bg()` in most cases or maybe all, except that
  black text on a dark background isn't readable.
  