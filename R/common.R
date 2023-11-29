## Common options and functions for the book
## seeded with content from same in adv-r
## deleted bits that seem irrelevant
## commented out bits that look like they may become relevant


# --------------
# general options
# --------------

# set a seed for all chapters
set.seed(47)

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
  fig.path = "figs/"
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

# --------------
# ggplot options
# --------------

ggplot2::theme_set(ggplot2::theme_bw(base_size = 16))


# ------------
# Extra stuff
# ------------

# colorize text: use inline as `r colorize(text, color)` to print `text` in a given `color`
# can also be used to color a color name, as in r colorize("red")`
colorize <- function(text, color) {
  if (missing(color)) color <- text
  if (knitr::is_latex_output()) {
    sprintf("\\textcolor{%s}{%s}", color, text)
  } else if (knitr::is_html_output()) {
    sprintf("<span style='color: %s;'>%s</span>", color, text)
  } else x
}



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

# packages to be cited here. Code at the end automatically updates packages.bib
# These should be packages not used in actual code via `library()` or
# `require()`. Packages only referenced via `data()` need to be listed here.
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
  "FactoMineR")

# write list of packages used at end of every chapter
.pkg_file <- here::here("bib", "pkgs.txt")
write_pkgs <- function(file="") {
  pkgs <- .packages() |> sort() |> unique()
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
