# Blog post seed: "Why Quarto Is Not LaTeX, However Hard It Tries"

**Working title:** *Why Quarto Is Not LaTeX, However Hard It Tries*

**Status:** Seed / notes. A formal task to write this up will be created later.
**Related file:** `working-text/quarto-pains.qmd` — an earlier draft on similar themes.

---

## Prelude

When I started writing this book, [*Visualizing Multivariate Data and Linear Models with R*](https://friendly.github.io/Vis-MLM-book/)
I chose Quarto over bookdown and other modern solutions to publishing complex documents with R code, output, figures
automatically included. I made this choice because Quarto promised to be able to produce both a print-quality PDF and an online HTML version from the same source.

Some publishers, such as CRC Press, allow authors to do this, with the online version being free. A trade-off is that the publisher wants me
to submit, before printing, essentially camera-ready copy they can ship off to a 3rd world printer. That means: All pages are correctly laid out,
with regard to figure size & placement, no widow-lines breaking pages, 

For comparison, my
previous book ([*Discrete Data Analysis with R*](https://www.taylorfrancis.com/books/mono/10.1201/b19022/discrete-data-analysis-michael-friendly-david-meyer)) was written in `.Rnw` format — This was essentially text written in LaTeX (`\chapter{}, \begin{itemize}, \emph{}, $math$, ...`)
with embedded R code chunks (Sweave/knitr).

In that workflow, I had **complete control** over the entire process of turning LaTeX source into the PDF was exactly what I wanted. I could easily define shorthands
for LaTeX math in one file (`commands.tex`), used as `\input{commands}`
With Quarto, I was trading that control for
convenience — write once in Markdown, get both formats.

The trade-off turned out to be less favourable than advertised. This post documents the places where
Quarto's abstraction layer over LaTeX broke things that were trivial in `.Rnw`, and the
workarounds I found (or didn't).

CRC press provides a bare-bones Quarto framework for a book: 
Over time, I carefully reviewed a number of online versions of R-related books using Quarto. I learned the most from:

  - Rohan Alexander: [*Telling Stories With Data*](). GitHub source: 
  - Cook & Laa: [*Interactive and dynamic graphics for high-dimensional data using R*](https://dicook.github.io/mulgar_book/). GitHub source: https://github.com/dicook/mulgar_book



**Ref**: Kieran Healy's post on re-writing his data visualization book in Quarto: [Using Quarto to Write a Book](https://kieranhealy.org/blog/archives/2026/03/09/using-quarto-to-write-a-book/) / anything from Frank Harrell?

---

## The fundamental tension

In `.Rnw`, the pipeline was transparent and controllable:

```
.Rnw  →  knitr  →  .tex  →  LaTeX  →  BibTeX  →  LaTeX  →  PDF
```

Every step was explicit. You could run them individually, inspect intermediate files, and
insert extra steps (like `authorindex`) at precisely the right point. The `.tex` file was
*yours* — it contained exactly the `\cite{}`, `\index{}`, and `\usepackage{}` calls you wrote.

In Quarto, the pipeline is:

```
.qmd  →  knitr  →  .md  →  pandoc (citeproc + LaTeX writer)  →  .tex  →  LaTeX  →  PDF
```

Pandoc acts as an opaque intermediary. It reads your Markdown, resolves citations itself
(via citeproc), and generates `.tex` that doesn't necessarily look like LaTeX you would have
written. External tools that plug into the traditional LaTeX pipeline often break, because the
`.tex` file and `.aux` file don't have the structure those tools expect.

What this also means for an author is that you have much, much more to try to understand for writing a
book if you want to take advantages of some of the lovely features Quarto offers:

* Extensions:
* Multiple language support: 
* Conditional compilation: The possibility to produce multiple output formats (HTML, PDF, eBook,) from a single source
* 

---

## Problem 1: You can't keep your project on Dropbox

In `.Rnw`, the DDAR project lived in a `C:/Dropbox/` folder with no issues, and was sync'd with other authors via GitHub.
I use multiple machines (Home / Office) to work on my writing projects, and Dropbox was a simple way to sync this work
across machines. Edit something on my laptop, and it is there on my other machines.
Other Cloud services may work similarly.

Quarto writes many temporary
files during compilation (`.aux`, `.log`, `.quarto/`, figure caches) and is very sensitive to files
being locked or modified by external processes. Dropbox's continuous sync interferes: Quarto
hits file-locking errors (`The process cannot access the file because it is being used by
another process`) and compilation fails or produces corrupted output. This sometimes caused problems
with `git`. 

**Workaround:** I moved the project to a local directory outside Dropbox. Back up / share only with `git` instead.
Dropbox now does a more convenient way to handle the files it syncs: You can create a file
`~/Dropbox/rules-dropboxignore` that tells it to stay your of your way in various folders,
similar in spirit to your standard `.gitignore`.

---
## Problem 2: The `authorindex` disaster

**In `.Rnw`:** I used `\aicite{key}` throughout the source (or `\usepackage{authorindex}` with
natbib, which patches `\cite` globally). BibTeX ran as a normal build step, writing `\bibdata`
and `\bibcite` entries to the `.aux` file. The `authorindex` Perl script could find everything
it needed and produced a `.ain` file for `\printauthorindex`. Straightforward.

**In Quarto:** Five separate things broke simultaneously:

1. **No `\cite{}` in the generated `.tex`** — pandoc citeproc resolves all citations before
   LaTeX runs, replacing `[@key]` with `\citeproc{ref-key}{Formatted Author, Year}`. The
   `authorindex` package intercepts `\cite`; since there are no `\cite` calls, it writes zero
   `\citationpage` entries.

2. **No BibTeX step** — citeproc reads the `.bib` files itself and emits a
   `\begin{thebibliography}` block directly into the `.tex`. LaTeX never calls BibTeX, so
   `\bibdata{...}` is never written to the `.aux` file. The Perl script dies immediately:
   *"You must specify at least one BibTeX database."*

3. **Citation keys renamed** — pandoc prefixes every key with `ref-`, so `Friendly2013`
   becomes `ref-Friendly2013` throughout the `.tex` and `.aux`. The `.bib` files still use
   `Friendly2013`. BibTeX lookups fail silently.

4. **`authorindex.sty` doesn't auto-patch `\cite`** — despite being designed for LaTeX+BibTeX
   workflows, the package does *not* globally redefine `\cite`. It provides `\aicite` as an
   opt-in alternative. In `.Rnw` you controlled the source and could use `\aicite`. In Quarto
   you can't — the `.tex` is generated by pandoc.

5. **Windows CRLF line endings** — LaTeX on Windows writes `.aux` files with `\r\n` line
   endings. The Perl script was written for Unix; its regexes use `$` to anchor end-of-line,
   but `\r` sits before `\n` and causes every pattern match to silently fail. Nothing matches.
   No errors, no output, no index.

6. **`@Preamble` directives in `.bib` files are silently ignored** — in `.Rnw`, a
   `@Preamble{ " \providecommand{\de}[1]{d'#1} " }` in `references.bib` worked because
   BibTeX emitted it into the `.bbl` file, which LaTeX read. With citeproc, the `.bib` file
   is read by pandoc (not BibTeX), and `@Preamble` content is never passed to LaTeX. Author
   names using such commands (e.g. `{\de{O}}cagne`) cause "Undefined control sequence" errors
   when the author index is typeset. **Workaround:** define the command in `preamble.tex`
   instead: `\providecommand{\de}[1]{d'#1}`.

**Workaround summary:** Patch `\@citex` in `preamble.tex` via `\AtBeginDocument` to also call
`\@aicitey`; write `\bibdata` manually to the `.aux` file; fix CRLF in the Perl script;
strip `ref-` prefix from keys; move `@Preamble` command definitions into `preamble.tex`.
See `issues/task-authorindex.md` for details.

---


## Problem 3: Indexing R function names with underscores

In LaTeX, `_` is a special character (subscript in math mode). In `.Rnw`, a macro like:

```latex
\newcommand{\ixfunc}[1]{\index{#1@\texttt{#1()}}}
```

could be called as `\ixfunc{plot\_hemat}` with a simple escaped underscore. You saw exactly
what you were writing.

In Quarto, index entries are written as raw LaTeX `\index{}` calls embedded in Markdown. The
Markdown processor and pandoc each have opinions about underscores (Markdown italics, LaTeX
subscripts). Getting `\index{plot_hemat@\texttt{plot\_hemat()}}` into the `.aux` file
correctly requires careful escaping at multiple levels, and the rules differ between code
spans, text, and inline LaTeX.

**Status:** Partially solved via `\ixfunc{}` macros in `preamble.tex`, but edge cases remain.

---

## Problem 4: Links become dead text in print

In Markdown, `[some text](https://example.com)` is natural to write and renders as a
hyperlink in HTML. In a printed book, hyperlinks need to become footnotes — the URL must
appear in print or the reader has no way to follow the reference.

In `.Rnw`, you could redefine `\href` for the print version:
```latex
\renewcommand{\href}[2]{#2\footnote{\url{#1}}}
```

In Quarto, every Markdown link becomes `\href{url}{text}` in the PDF. Adding the footnote
redefinition to `preamble.tex` works, but it applies globally — including to internal
cross-references that shouldn't become footnotes. Conditional blocks (`::: {.content-visible
when-format="pdf"}`) can help, but require rewriting every link in the source.

**Status:** Open. Needs a systematic pass through all chapters.

---

## Problem 5: Formatting R package names

In `.Rnw`, a single macro handled everything:

```latex
\def\pkg#1{\textsf{#1}\ixp{#1}\citex{#1}\xspace}
```

One call to `\pkg{ggplot2}` would (a) typeset the name in sans-serif font, (b) add index
entries under both `ggplot2` and `packages|ggplot2`, and (c) cite the package on first use.
No duplication, no inconsistency, works the same everywhere in the document.

In Quarto, you need an R function that generates different output for HTML and PDF:

```r
pkg <- function(package, cite = FALSE, color = NULL) { ... }
```

Getting this to also emit `\index{}` entries in the PDF output without breaking in HTML is
non-trivial (inline R in Quarto doesn't easily write to the `.aux` file). The cite-on-first-use
logic is harder too, since each chapter is compiled independently. The current `pkg()` in
`R/common.R` handles formatting and optional citation but does not yet handle indexing.

**Status:** Open. See `issues/package-formatting.md`.

---

## Problem 6: Build workflow fragility

In `.Rnw`, "compile" meant run knitr, run LaTeX, run BibTeX, run LaTeX again. Each step was
explicit; if one failed, you knew which one and why.

In Quarto, `Build -> Render Book` is one button that does everything. When it fails, the
error may come from R, from pandoc, from LaTeX, or from Quarto itself, and the messages are
sometimes swallowed or misattributed. In practice:

- Building only HTML (`Render Book` in HTML mode) **wipes out `docs/`** even if you're only
  changing a PDF-specific file, because Quarto re-renders all output.
- Building PDF and HTML separately produces **inconsistent intermediate files** (aux, tex)
  that can confuse external tools.
- **Workaround:** Always use `Build -> All Formats` to keep HTML and PDF in sync.

Also, Quarto's naming is inconsistent and counterintuitive:

- The `output-file: Vis-MLM` setting in `_quarto.yml` sounds like it controls the PDF
  filename. It doesn't — it names the *LaTeX intermediate* (`Vis-MLM.tex`). The final PDF
  is named after the book's entry-point file (`index.qmd`) and lands in the project root
  as `index.pdf`, regardless of `output-file`.
- The `.aux` file is therefore `index.aux`, not `Vis-MLM.aux` — which breaks external
  tools (like `authorindex`) that expect the aux file to match the output filename.

In plain LaTeX, `\jobname` is always the name you gave your file, and every output
(`jobname.pdf`, `jobname.aux`, `jobname.idx`, ...) follows from it consistently. In Quarto,
the job name, the tex filename, and the PDF filename can all be different things.

---

## Problem 7: No Makefile / incremental build

**In `.Rnw` (DDAR book):** The build was controlled by a `Makefile` (`C:\Dropbox\Documents\VCDR\Makefile`)
and a thin `Make.R` wrapper (`C:\Dropbox\Documents\VCDR\Make.R`) that called:

```r
knitr::knit2pdf(input = 'book.Rnw', quiet = TRUE)
```

The Makefile could specify dependencies and rebuild only what had changed — a specific chapter,
the bibliography, the index. You could run `make chapter3` and only that chapter would be
re-knitted and re-typeset. The PDF viewer could stay open during the build because pdflatex
overwrites the file in place; the viewer reloads automatically on the next page turn.

**In Quarto:** There is no Makefile equivalent. `Build -> All Formats` is one monolithic
operation. Quarto has caching (`cache: true` in chunk options) but it operates at the R
chunk level, not the chapter level. A change to `_quarto.yml` or `preamble.tex` can
invalidate the entire cache and force a full rebuild of all 15 chapters.

Additionally, Quarto deletes and recreates `index.pdf` on every build rather than overwriting
it in place. This means the PDF **must be closed** in Acrobat (or any viewer) before building,
or Quarto fails with:

```
ERROR: The process cannot access the file because it is being used by another process.
(os error 32): remove 'C:\R\Projects\Vis-MLM-book\index.pdf'
```

In `.Rnw`, the PDF viewer could stay open indefinitely.

**Status:** Open. A `Makefile` is planned but not yet written; see `working-text/Makefile`
for a draft.

---

## Problem 8: Quarto doesn't like competition

On Windows, Quarto holds locks on intermediate files during compilation. If RStudio, TeXStudio,
or any other process has a file open (e.g., the PDF viewer has `Vis-MLM.pdf` open), Quarto
fails with:

```
ERROR: The process cannot access the file because it is being used by another process.
(os error 32): remove 'C:\R\Projects\Vis-MLM-book\index.tex'
```

In `.Rnw`, you could have the PDF open in a viewer while re-compiling; the viewer would reload
automatically on the next page refresh. In Quarto, you must close the PDF before every build.

---

## Things Quarto does better

In fairness:

- **HTML output is excellent** — equations (MathJax), code folding, callout blocks, tabsets,
  cross-references, and a polished default theme all work well with minimal configuration.
- **Single source for two formats** is genuinely valuable — most of the book source works for
  both HTML and PDF without conditional blocks.
- **Cross-references** (`@fig-name`, `@sec-label`, `@eq-name`) are cleaner than LaTeX's
  `\ref` + manual numbering.
- **`code-fold`** and **`code-summary`** allow showing/hiding code in HTML in ways that
  would require JavaScript hacks in `.Rnw`.
- **Publishing to GitHub Pages** from `docs/` is straightforward.

---

## Summary table

| Feature | `.Rnw` / LaTeX | Quarto / pandoc |
|---------|---------------|-----------------|
| Author index | Works natively via BibTeX pipeline | Requires patching 4 separate things |
| Package name macros | One `\pkg{}` macro does everything | Needs R function + conditional output |
| Index entries | Direct `\index{}` in source | Fragile via raw LaTeX in Markdown |
| Footnote links in print | One `\renewcommand{\href}` | Requires per-link conditional blocks |
| Build control | Explicit multi-step Makefile | One button; hard to customize |
| Dropbox-friendly | Yes | No |
| PDF viewer during build | Can stay open (overwrites in place) | Must be closed (deletes and recreates) |
| Windows compatibility | Good | CRLF issues with external tools |
| HTML output | Minimal (via `htlatex` etc.) | Excellent, first-class |
| Online publishing | Manual | Built-in GitHub Pages workflow |

---

## Possible title variants

- *Why Quarto Is Not LaTeX, However Hard It Tries*
- *The Hidden Costs of "Write Once, Render Twice": A Quarto Book Diary*
- *From `.Rnw` to Quarto: What I Gained, What I Lost*
- *Quarto Growing Pains: A Technical Post-Mortem*
