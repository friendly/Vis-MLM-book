## Common options and functions for the book
## seeded with content from same in adv-r
## deleted bits that seem irrelevant
## commented out bits that look like they may become relevant

knitr::opts_chunk$set(
  comment = "#>",
  collapse = TRUE,
  dpi = 300,
  width = 68
  # fig.retina = 0.8, # figures are either vectors or 300 dpi diagrams
  # out.width = "70%",
  # fig.align = 'center',
  # fig.width = 6,
  # fig.asp = 0.618,  # 1 / phi
  # fig.show = "hold"
  # cache = TRUE
)
knitr::opts_knit$set(
  aliases=c(h='fig.height', 
            w='fig.width',
            cap='fig.cap', 
            scap='fig.scap'),
            eval.after = c('fig.cap','fig.scap'))


options(
  digits = 3,
  width = 68
  # str = strOptions(strict.width = "cut"),
  # crayon.enabled = FALSE
)

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

# packages to be cited here. Code at the end automatically updates packages.bib
# These should be packages not used in actual code.
.to.cite <- c(
  "rgl",
  "animation",
  "nnet", 
  "car", 
  "broom", 
  "ggplot2", 
  "equatiomatic", 
  "geomtextpath")
