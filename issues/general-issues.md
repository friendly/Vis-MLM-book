# General issues

I'm starting this list of "general issues" for the book to note things to bear in mind while reading through the ms.
A number of things refer to the necessity to produce both a printed PDF and an online HTML version.

* **Workflow**: Making your comments in a separate `.Rmd` is useful, but it's sometimes hard for me to tell what specifically
  in the text `.qmd` file some comment refers to. In the past, Udi made some comments inline in the `.qmd` files,
  of the form `<!--- Udi: ... --.>`, which was helpful. I think, for the most part, he did these via a PR if
  he was also doing any direct editing, but sometimes directly, via a commit to `master`.
  
* Overview of structure: As perhaps another pass through the ms., try to read for coherence, structure, and placement of ideas/methods across chapters. 
  I've been writing from my [book outline](TaylorFrancis/book-outline.docx), with adjustments, but finding that
  I wished I had done things differently. In Ch 10, MLM Review, I'm wishing that I did not defer the introduction
  of HE plots until Ch 11, MLM-viz, for example.
  
* Break chapters into parts. Suggest logical division points; modify `_quarto.yml`. See `working-text/Parts.txt`.

* Handling links : In many cases I've used `[]()` markdown for hyperlinks, but these would better be footnotes in the PDF version.

## Appendices: Perhaps the book needs:

  - Brief review of matrix algebra, or could this just be a reference to something else, e.g., Fox (2021), 
  _A mathematical primer for social statistics_, Chapter 1.
  
  - Table of notation for matrices, vectors, expectation ($\mathcal{E}()), ...
  

  

## PDF version: Unable to compile

  - I'm using Windows 10, where MikTeX was always my LaTeX system. I was able to install LaTeX packages into a `localtexmf` directory and be prompted by MikTeX to install/update packages. 
  Quarto doesn't seem to support MikTeX for this purpose, but prefers `tinytex` based on the TexLive distribution. I don't know how to set this up.
  
  - Started discussion of this on [Quarto-dev Discussions](https://github.com/quarto-dev/quarto-cli/discussions/11087), where I describe
  the problem, and how I solved (sort of) on my home desktop. 
  
  - More generally, the PDF version needs to use the CRC house style, `\documentclass{krantz}`, and this needs to be set up in `_quarto.yml` together with various LaTeX style files.  Currently I have:

```
  pdf:
    documentclass: krantz
    classoption: [10pt, krantz2]
    include-in-header: latex/preamble.tex
    include-before-body: latex/before-body.tex
    include-after-body: latex/after-body.tex
    keep-tex: true
    latex-tinytex: false
    geometry:
      - top=20mm
      - left=25mm
    code-block-bg: 'E8FFFF'  #'#f1f1f1'
```

Currently, I have both MikTeX and TexLive installed:

```
C:\Users\friendly\AppData\Local\Programs\MiKTeX\miktex\bin\x64\
C:\Users\friendly\AppData\Roaming\TinyTeX\bin\windows;
```


  - A good model for this might be Rohan Alexander's [Tellling Stories with Data](https://tellingstorieswithdata.com/)
  whose [source code is on GitHub](https://github.com/RohanAlexander/telling_stories/).

  
  - May need to try to hire someone as a consultant on this issue. How to find someone? Post on LinkdIn? X?, BlueSky?
  Posted a note on https://github.com/quarto-dev/quarto-cli/discussions/11087 
  
  - Need a `Makefile` to create the HTML and PDF versions. 
  
  
  
  - Indexing: I've just started to add `\index{}` entries to the text. At some point, need to go thru and add these throughout. 
    - How to create an Author index? Previously, this was done automatically from the citations to references.
  

## HTML version

  - Some features, like animated GIFs can only appear in the online version. Other things might only appear in the PDF version.
  Need to use [conditional blocks](https://quarto.org/docs/authoring/conditional.html). A good model for doing this
  is Di Cook's [Interactively exploring high-dimensional data and models in R](https://dicook.github.io/mulgar_book/),
  with [source on Github](https://github.com/dicook/mulgar_book).


```
::: {.content-visible when-format="html"}
 ...
:::
```

  - For the online version, I've been using the options `code-fold: show`, and `code-summary`, but not consistently. 
  Should look these over and decide which code chunks should be suppressed for readability, i.e., when the flow is 
  better if the code is not shown initially.

* **color in figure captions**: See [How to use colored text in Quarto figure captions](test/caption-colors.qmd)
  I've been using `colorize()` defined in `R/common.R`, which is loaded in every chapter file.
  **NB**: `colorize()` provides a way to generate different text depending on HTML vs. PDF

* **Exercises**: I intend to have exercises for each chapter, but haven't really started on this. 
  Make **some notes** if any ideas come to you.

## References to packages

  - Generally I refer to the first use of a package in the text with the package name in bold and
  citation: `**lattice** package [@R-lattice]`. But I should probably be using a mono typewriter font, e.g., `lattice`,
  or maybe a bold typewriter font? Or maybe also colored. But I don't know how to define CSS or latex styles for these.
  
  In pure LaTeX, `.Rnw` files I defined a `\pkg{}` macro used consistently through out my DDAR book. This (a) printed the
  package name in mono font; (b) cited the package (c) added index entries for `pkgname`, `packages | pkgname`:

```
\def\pkg#1{\textsf{#1}\ixp{#1}\citex{#1}\xspace}
\def\citex#1{\expandafter\ifx\csname cit:#1\endcsname\relax
      \expandafter\gdef\csname cit:#1\endcsname{}%
      ~\citep{#1}%
   \else
      \nocite{#1}%
   \fi
}
```
  
  - How to do this in Quarto? currently, in `R/common.R`, I have:

```
pkg <- function(package, cite=FALSE, color=NULL) {
  pkgname <- if(is.null(color)) package else colorize(package, color)
  ref <- paste0("**", package, "**")
  if (cite) ref <- paste0(ref, " [@R-", package, "]")
  ref
}
```

  This needs to do things differfently for PDF output.

  Note that there is a system in place defined in `R/common.R` using `write_pkgs(file = .pkg_file)` to automatically
  generate BibTeX entries in `bib/packages.bib` from those included via `library()` in the text.
  
## Consistency
  - Figure sizes: Should be made more consistent. I've generally sized them to sort of "look right" in the HTML version, but
  it would be better to adopt some general rules
  
  - Coding style: Should adopt a general style for variable & function names, e.g., `crime` data -> `crime.pca`;
  
