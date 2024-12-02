## Common options and functions for the book
## seeded with content from same in adv-r
## deleted bits that seem irrelevant
## commented out bits that look like they may become relevant


# --------------
# general options
# --------------

# set a seed for all chapters
set.seed(47) # The one TRUE seed

options(
  digits = 3,
  width = 68
  # str = strOptions(strict.width = "cut"),
  # crayon.enabled = FALSE
)

# --------------
# knitr related
# --------------

knitr::opts_chunk$set(
  comment = "#>",
  collapse = TRUE,
  dpi = 300,
  width = 68,
  message = FALSE,
  warning = FALSE,
  error = FALSE,
  fig.align = 'center',
  fig.path = "figs/",
  fig.width = 7,
  fig.height = 5
  # fig.retina = 0.8, # figures are either vectors or 300 dpi diagrams
  # out.width = "70%",
  # fig.width = 6,
  # fig.asp = 0.618,  # 1 / phi
  # fig.show = "hold"
  # cache = TRUE
  # screenshot.force =TRUE
)

knitr::opts_knit$set(
  aliases=c(h='fig.height', 
            w='fig.width',
            cap='fig.cap', 
            scap='fig.scap'),
            eval.after = c('fig.cap','fig.scap'))

# provide a new chunk option, `out.lines` to limit the number of lines produced.
# from: https://blog.djnavarro.net/posts/2023-12-30_knitr-hooks/
custom_hook_output <- function(x, options) {
  n <- options$out.lines
  if(!is.null(n)) {
    x <- xfun::split_lines(x)
    if (length(x) > n) x <- c(head(x, n), "....\n")
    x <- paste(x, collapse = "\n")
  }
  default_hook_output(x, options)
}


# wrap chunk output hook
# from: https://github.com/yihui/knitr-examples/blob/master/077-wrap-output.Rmd
library(knitr)
hook_output = knit_hooks$get('output')
knit_hooks$set(output = function(x, options) {
  # this hook is used only when the linewidth option is not NULL
  if (!is.null(n <- options$linewidth)) {
    x = xfun::split_lines(x)
    # any lines wider than n should be wrapped
    if (any(nchar(x) > n)) x = strwrap(x, width = n)
    x = paste(x, collapse = '\n')
  }
  hook_output(x, options)
})


# --------------
# ggplot options
# --------------

ggplot2::theme_set(ggplot2::theme_bw(base_size = 16))

# shorthands

legend_inside <- function(position) {
  theme(legend.position = "inside",
        legend.position.inside = position)
}



# ------------
# Extra stuff
# ------------

# Inline expressions of the form `r Rexpr(expr)` to give "expr = value", e.g., 
# `r Rexpr(cor(x, y))` giving "cor(x, y) = 0.53" (but rounded)

Rexpr = function(expr, digits = 3) {
  value <- eval(parse(text=expr)) |> round(digits)
  paste(expr, " = ", value)
}

#' colorize text: 
# use inline as `r colorize(text, color)` to print `text` in a given `color`
# can also be used to color a color name, as in r colorize("red")`
#

#' Render text in color using LaTeX or CSS styles
#' 
#' This function uses `\textcolor{}{}` from the `xcolor` package for LaTeX output
#' or a CSS `<span>` for HTML output.
#' 
#' Note that a color not defined in the `xcolor` package will trigger a latex error.
#' e.g., `darkgreen` is not defined but can use:
#'    \definecolor{darkgreen}{RGB}{1,50,32}
#'
#' @param text  Text to display, a character string
#' @param color Color to use, a valid color designation
#'
#' @return A character string
#' @export
#'
#' @examples
#' See the `r color`
colorize <- function(text, color) {
  if (missing(color)) color <- text
  if (knitr::is_latex_output()) {
    sprintf("\\textcolor{%s}{%s}", color, text)
  } else if (knitr::is_html_output()) {
    sprintf("<span style='color: %s;'>%s</span>", color, text)
  } else text
}

# define some color names for use in figure captions.
# use as: 
#    #| fig-cap: !expr glue::glue("Some points are ", {red}, " some are ", {blue}, "some are ", {green})

red <- colorize('red')
pink <- colorize("pink")
blue <- colorize('blue')
green <- colorize("green")
lightgreen <- colorize("lightgreen")
darkgreen <- colorize("darkgreen")


if (knitr::is_latex_output()) {
  # options(crayon.enabled = FALSE)
  # options(cli.unicode = TRUE)
}

if (knitr::is_html_output()) {'
$\\renewcommand*{\\vec}[1]{\\ensuremath{\\mathbf{#1}}}$
$\\newcommand*{\\mat}[1]{\\ensuremath{\\mathbf{#1}}}$
$\\newcommand{\\trans}{\\ensuremath{^\\mathsf{T}}}$
$\\newcommand*{\\diag}[1]{\\ensuremath{\\mathrm{diag}\\, #1}}$
'
}

# -------------
# packages
# -------------

# References to package inline in text
#   Use as: `r pkg("lattice")` or `r pkg("lattice", cite=TRUE)`
#   Assumes the bibtex key will be of the form: R-package
# TODO: add styles (color, font); do it differently for PDF output
#   Want to be able to use bold (**...**), italic (_ ... _) or bold-italic (*** ... ***)

# See: Demonstration of how to use other fonts in an Rmarkdown document 
#      https://gist.github.com/richarddmorey/27e74bcbf28190d150d266ae141f5117

# attributes for displaying the package name
pkgname_font = "bold" # or: plain, ital, boldital
pkgname_face = "mono"
pkgname_color ="brown"

pkg <- function(package, cite=FALSE) {
  pkgname <- dplyr::case_when(
    pkgname_font == "ital"      ~ paste0("_", package, "_"),
    pkgname_font == "bold"      ~ paste0("**", package, "**"),
    pkgname_font == "boldital"  ~ paste0("***", package, "***"),
    .default = package
  )
  ref <- pkgname
  if (!is.null(pkgname_color)) ref <- colorize(pkgname, pkgname_color)
  if (cite) ref <- paste0(ref, " [@R-", package, "]")
  if (knitr::is_latex_output()) {
    ref <- paste0(ref, "\\index{`", package, "`}")
  }
  ref
}

# Same, but say `pkgname` package cite
package <- function(package, cite=FALSE) {
  pkgname <- dplyr::case_when(
    pkgname_font == "ital"      ~ paste0("_", package, "_"),
    pkgname_font == "bold"      ~ paste0("**", package, "**"),
    pkgname_font == "boldital"  ~ paste0("***", package, "***"),
    .default = package
  )
  ref <- pkgname
  if (!is.null(pkgname_color)) ref <- colorize(pkgname, pkgname_color)
  if (cite) ref <- paste0(ref, " package [@R-", package, "]")
  if (knitr::is_latex_output()) {
    ref <- paste0(ref, "\\index{`", package, "`}")
  }
  ref
}



# packages to be cited here. Code at the end automatically updates `packages.bib`
# These should be packages not used in actual code via `library()` or `require()`. 
# Packages only referenced via `data()` need to be listed here.
.to.cite <- c(
  "rgl",
  "animation",
  "nnet", 
  "car", 
  "broom", 
  "ggplot2", 
  "equatiomatic", 
  "geomtextpath",
  "lattice",
  "datasauRus",
  "vcd",
  "vcdExtra", 
  "palmerpenguins",
  "FactoMineR",
  "factoextra",
  "seriation",
  "tourr",
  "liminal",
  "langevitour",
  "vegan",
  "glmnet",
  "penalized",
  "adegraphics")

# write list of packages used at end of every chapter
.pkg_file <- here::here("bib", "pkgs.txt")
base_pkgs <- c("stats", "graphics", "grDevices", "utils", "datasets",  "methods", "base")
write_pkgs <- function(file="") {
  pkgs <- .packages() |> sort() |> unique()
  pkgs <- setdiff(pkgs, base_pkgs)
  np <- length(pkgs)
  cat(np, " packages used here:\n", paste(pkgs, collapse = ", ")  )
  if(np > 0) cat(pkgs, file = .pkg_file, append=TRUE, sep = "\n")
}

read_pkgs <- function() {
  pkgs <- read.csv(.pkg_file, header = FALSE)
  pkgs <- pkgs[, 1] |> as.vector() |> sort() |> unique()
  np <- length(pkgs)
#  message(np, " unique packages read from ", .pkg_file)
  pkgs
}

clean_pkgs <- function() {
  if (file.exists(.pkg_file)) {
    #Delete file if it exists
    file.remove(.pkg_file)
  }
}
