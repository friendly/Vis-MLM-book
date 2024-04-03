# How to format & index R packages in Quarto: HTML / LaTeX

In a book using `.Rnw` / LaTeX, I had the definitions below to format package names and also
automatically index them when they appeared. I used `\textsf{}` for a sans-serif font
distinct from typewriter `\texttt{}`, but that's just a detail.

`\pkg{foo} -> \textsf{foo}` and also `\index{\textsf{foo}}`, `\index{package!\textsf{foo}}`


```tex
% R packages:  use \textsf{} & \index under both package name and packages!
\newcommand{\pkg}[1]{\textsf{#1}\ixp{#1}}
\newcommand{\ixp}[1]{%
   \index{#1@\textsf{#1} package}%
   \index{package!#1@\textsf{#1}}%
	}

% Usage:
The \pkg{ggplot2} package is a mighty fine package, but I also like \pkg{car} for base-R plots of statistical models.
```

Is there someway I can duplicate something like this in Quarto, and have it do something sensible
when output is to HTML?


One possibility, just for the formatting of package names is to use inline expressions and something in CSS for
a `class="pkg"`. I haven't really tested this, but think it should work for HTML output.
Is there also some way I could emit the appropriate `\index{}` commands when the output format is LaTeX/PDF ?

```r
# formatting for package names in HTML

pkg <- function(x) {
  cl <- match.call()
  x <- as.character(cl$x)
  paste0('<span class="pkg">', x, '</span>')
}

pkg_chr <- function(x) {
  paste0('<span class="pkg">', x, '</span>')
}

# Usage
The `r pkg(ggplot2)` package is a mighty fine package, but I also like `r pkg_chr("car")`  for base-R plots of statistical models.
```