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

# Ensure CMYK for PDF (issue #32)
grDevices::pdf.options(colormodel = "cmyk")

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
# can also be used to color a color name, as in `r colorize("red")`
#

#' Render text in color for Markdown / Quarto documents using LaTeX or CSS styles
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
#' @return A character string with color-encoded text
#' @export
#'
#' @examples
#' # In inline text, use 
#' #     `r colorize("Gentoo", "orange")` and  `r colorize("Adelie", "purple")` are Penguins.
#' #     The `r colorize("red")` points and the `r colorize("blue")` points are nice
#' 
colorize <- function(text, color) {
  if (missing(color)) color <- text
  if (knitr::is_latex_output()) {
    sprintf("\\textcolor{%s}{%s}", color, text)
  } else if (knitr::is_html_output()) {
    sprintf("<span style='color: %s;'>%s</span>", color, text)
  } else text
}

# Define some color names for use in figure captions.
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
#
#   Assumes the bibtex key will be of the form: R-package
# * Produces appropriate markup for HTML and PDF
# * Allows package names to be printed in color and in different font styles (bold, ital, ...)
#
#
# See: Demonstration of how to use other fonts in an Rmarkdown document 
#      https://gist.github.com/richarddmorey/27e74bcbf28190d150d266ae141f5117

# attributes for displaying the package name
pkgname_font = "bold"    # or: plain, ital, boldital
pkgname_color ="brown"   # uses colorize()
pkgname_face = "mono"    # not implemented

pkg <- function(package, cite=FALSE) {
  if (knitr::is_latex_output()) {
      pkgname <- dplyr::case_when(
      pkgname_font == "ital"      ~ paste0("\\texttt{\\textit{", package, "}}"),
      pkgname_font == "bold"      ~ paste0("\\texttt{\\textbf{", package, "}}"),
      pkgname_font == "boldital"  ~ paste0("\\texttt{\\textit{\\textbf{", package, "}}}"),
      .default = package
    )
  }
  # HTML output
  else {
    pkgname <- dplyr::case_when(
      pkgname_font == "ital"      ~ paste0("_", package, "_"),
      pkgname_font == "bold"      ~ paste0("**", package, "**"),
      pkgname_font == "boldital"  ~ paste0("***", package, "***"),
      .default = paste0("\\texttt{", package, "}}")
    )
  }

  ref <- pkgname
  if (!is.null(pkgname_color)) ref <- colorize(pkgname, pkgname_color)
  if (cite) ref <- paste0(ref, " [@R-", package, "]")
  if (knitr::is_latex_output()) {
    ref <- paste0(ref, "\n\\index{", package, " package}",
                        "\n\\index{packages!", package, "}\n")
  }
  ref
}

# Same, but say "`pkgname` package cite"
package <- function(package, cite=FALSE) {
  if (knitr::is_latex_output()) {
    pkgname <- dplyr::case_when(
      pkgname_font == "ital"      ~ paste0("\\texttt{\\textit{", package, "}}"),
      pkgname_font == "bold"      ~ paste0("\\texttt{\\textbf{", package, "}}"),
      pkgname_font == "boldital"  ~ paste0("\\texttt{\\textit{\\textbf{", package, "}}}"),
      .default = paste0("\\texttt{", package, "}}")
    )
  }
  # HTML output
  else {
    pkgname <- dplyr::case_when(
      pkgname_font == "ital"      ~ paste0("_", package, "_"),
      pkgname_font == "bold"      ~ paste0("**", package, "**"),
      pkgname_font == "boldital"  ~ paste0("***", package, "***"),
      .default = package
    )
  }
  
  ref <- pkgname
  if (!is.null(pkgname_color)) ref <- paste(colorize(pkgname, pkgname_color), "package")
  if (cite) ref <- paste0(ref, " package [@R-", package, "]")
  if (knitr::is_latex_output()) {
    ref <- paste0(ref, "\n\\index{", package, " package}",
                  "\n\\index{packages!", package, "}\n")
  }
  ref
}

## Datasets -- format the dataset name and produce index entries
# Use inline as:
#   `r dataset("prestige")`
#   `r dataset("prestige", "carData")`
# or perhaps
#   `r dataset("carData::prestige")`
#
# regular expression to find / replace [assume pkg::func() has final ()]
#   find: `(\w)+::(\w+)`
#   repl: `r dataset("\2")`

# dsetname_color <- "black"
# dsetname_font <- "plain"

dataset <- function(name, package=NULL) {
  # handle pkg::name
  dname <- name
  if (stringr::str_detect(name, "::")) {
    wds <- name |> stringr::str_split("::", 2) |> unlist()
    dname <- wds[2]
    dpkg  <- wds[1]
  }
  
  if (knitr::is_latex_output()) {
    dsetname <- paste0("\\texttt{", name, "}")
    # dsetname <- dplyr::case_when(
    #   dsetname_font == "ital"      ~ paste0("\\texttt{\\textit{", name, "}}"),
    #   dsetname_font == "bold"      ~ paste0("\\texttt{\\textbf{", name, "}}"),
    #   dsetname_font == "boldital"  ~ paste0("\\texttt{\\textit{\\textbf{", name, "}}}"),
    #   .default = name
    # )
  }
  # HTML output
  else {
    dsetname <- paste0("`", name, "`")
    # dsetname <- dplyr::case_when(
    #   dsetname_font == "ital"      ~ paste0("_", name, "_"),
    #   dsetname_font == "bold"      ~ paste0("**", name, "**"),
    #   dsetname_font == "boldital"  ~ paste0("***", name, "***"),
    #   .default = name
    # )
  }
  
  ref <- dsetname
#  if (!is.null(dsetname_color)) ref <- colorize(dsetname, pkgname_color)
  
  if (knitr::is_latex_output()) {
    ref <- paste0(ref, "\n\\index{", dname, " data}",
                  "\n\\index{datasets!", dname, "}")
    # ref <- paste0(ref, "\n\\index{", dname, " data@\\texttt{", dname, "}}",
    #               "\n\\index{datasets!", dname, "@\\texttt{", dname, "}}")
  }
  ref
  
}

# -------------------------
# packages to be cited here. Code at the end automatically updates `packages.bib`
# .tocite lists packages not used in actual code via `library()` or `require()`,
# but are cited in the text.
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
  "adegraphics",
  "olsrr",
  "HLMdiag",
  "ggdist")

# write list of packages used at end of every chapter
# NB: use results: "none" to hide the output
.pkg_file <- here::here("bib", "pkgs.txt")
base_pkgs <- c("stats", "graphics", "grDevices", "utils", "datasets",  "methods", "base")
write_pkgs <- function(file="", quiet = FALSE) {
  pkgs <- .packages() |> sort() |> unique()
  pkgs <- setdiff(pkgs, base_pkgs)
  np <- length(pkgs)
  if (!quiet) cat(np, " packages used here:\n", paste(pkgs, collapse = ", ")  )
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
