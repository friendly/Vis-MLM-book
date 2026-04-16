# Blog post seed: "Quarto Is Not LaTeX, However Hard It Tries"

**Working title:** *Why Quarto Is Not LaTeX, However Hard It Tries*

**Status:** Seed / notes. A formal task to write this up will be created later.
**Related file:** `working-text/quarto-pains.qmd` — an earlier draft on similar themes.

### Possible subtitles

- *From `.Rnw` to Quarto: What I Gained, What I Lost* [use this!]
- *The Making of Vis-MLM* (or, use that as a section, describing `Makefile` vs `build.sh`)
- *The Hidden Costs of "Write Once, Render Twice": A Quarto Book Diary*
- *Quarto Growing Pains: A Technical Post-Mortem*

---

## Prelude

When I started writing this book, [*Visualizing Multivariate Data and Linear Models with R*](https://friendly.github.io/Vis-MLM-book/)
I chose Quarto over bookdown and other modern solutions to publishing complex documents with R code, output, figures
automatically included. I made this choice because Quarto promised to be able to produce both a print-quality PDF and an online HTML version from the same source.

Some publishers, such as CRC Press, allow authors to do this, with the online version being free. A trade-off is that the publisher wants me
to submit, before printing, essentially camera-ready copy they can ship off to an inexpensive printer. That means: All pages are correctly laid out, with regard to figure size & placement, no widow-lines breaking pages, proper, comprehensive indexes (Subject, Author), ...

For comparison, my
previous book ([*Discrete Data Analysis with R*](https://www.taylorfrancis.com/books/mono/10.1201/b19022/discrete-data-analysis-michael-friendly-david-meyer)) was written in `.Rnw` format. This was essentially text written in LaTeX  (using `\chapter{}, \begin/end{itemize}, \emph{}, $math$, ...`)
with embedded R code chunks (in Sweave/knitr syntax).

In that workflow, I had **complete control** over the entire process of turning LaTeX source into the PDF was exactly what I wanted. I could:

* easily define shorthands for LaTeX math in a single file (`commands.tex`), used as `\input{commands}` and therefore available globally in the entire book. 
* For writing & editing, it was easy to setup _conditional rendering_ (using `\includeonly{ch05,ch06}`) so that only those chapters were compiled to the PDF, but all page numbers, cross-references to figures or sections, ... reflected the entire book.
* More importantly, I could control the page design and layout even though my book design skills are limited. For example, I wanted to have a visual table of contents for each chapter, which I did using `tikz` fairly easily.

![](images/DDAR-Ch2-header.png)

I also designed similar visual Part pages using `tikz` for the chapters within each part, and I developed a coherent scheme of different accent colors for the chapters within each part, so that section headings and running titles used a unique accent color throughout that
part. Among other books I've written, it's the one I'm most proud of.

![](images/DDAR-title-page.png)


With Quarto, as I later realized, I was trading that control for
convenience -- I could write once in Markdown, and get both formats (HTML, PDF) from a single source. That is something I didn't have before.
The trade-off turned out to be less favorable than advertised, at least when trying to achieve the goals of beautiful and consistent
online and print versions.

This post documents the places where Quarto's abstraction layer over LaTeX broke things that were trivial in `.Rnw`, but much more difficult
in Quarto. I was able to solve many of these, often with great assistance from Team Quarto in the [Quarto Dev Discussion](https://github.com/orgs/quarto-dev/discussions/) forum. (Thanks, guys!)
For authors facing a similar writing task, I thought it would be useful to describe these problems and my solutions so far.



## Starting point

CRC press provides a [bare-bones Quarto framework](https://github.com/bgreenwell/quarto-crc) for a book using their house `krantz` style.
When I say "bare-bones", it's just that: It generates a table of contents, contains a few chapters, and shows some simple R code with output. Importantly, it includes the [`_quarto.yml`](https://github.com/bgreenwell/quarto-crc/blob/main/_quarto.yml) that sets this up
as a Quarto Project in RStudio, which can be rendered via the `Build -> {formats}` button. 

But, this didn't allow for, or suggest how do do anything fancier than a very dry `krantz`-style book. There was nothing here about using the potential of Quarto to provide for parallel (but perhaps slightly different) online and print versions. 

Over time, I carefully reviewed a number of online versions of R-related books using Quarto. I learned the most from:

  - Rohan Alexander: [*Telling Stories With Data*](https://tellingstorieswithdata.com/). GitHub source: https://github.com/RohanAlexander/tswd
  - Cook & Laa: [*Interactive and dynamic graphics for high-dimensional data using R*](https://dicook.github.io/mulgar_book/). GitHub source: https://github.com/dicook/mulgar_book

These provided ideas for using Quarto features (like `.content-visible when-format="html"` divs)
and knitr chunk options (like `echo=knitr::is_html_output()` and `eval=knitr::is_html_output()`) that would allow for different
content in online and printed versions.

Recently, I've enjoyed reading Kieran Healy's post on re-writing his data visualization book in Quarto: [Using Quarto to Write a Book](https://kieranhealy.org/blog/archives/2026/03/09/using-quarto-to-write-a-book/). He discusses the features of
Quarto in the publishing process in relation to what he as an author wants.
As well, I've been impressed with what Frank Harrell has done in turning his lovely [_Regression Modeling Strategies_](https://www.academia.edu/43291466/Regression_Modeling_Strategies_With_Applications_to_Linear_Models_Logistic_and_Ordinal_Regression_and_Survival_Analysis) book
into a [web-based spinoff]() ...


---

## The fundamental tension

In `.Rnw`, the pipeline was **totally transparent**, involving only LaTeX and R. All stages were controllable in a simple, coherent pipeline:

```
.Rnw  →  knitr  →  .tex  →  LaTeX  →  BibTeX  →  LaTeX  →  PDF
```

Every step was explicit. You could run them individually, inspect intermediate files, and
insert extra steps (like `authorindex`) at precisely the right point. The final `book.tex` file was
*yours* -- it contained exactly the `\cite{}`, `\index{}`, and `\usepackage{}` calls you wrote.

Most importantly, I had only two languages to work with--- R for the code, analyses, outputs and graphs,
`(`knitr` for including that stuff),
and LaTeX for compiling the knitted `.tex` file to a PDF book I felt proud of.

If need be, I could open the generated `.tex` file in [TeXStudio](https://www.texstudio.org/), a remarkable IDE for anything LaTeX
and see exactly where there
were problems; I could re-run different build steps, and so forth. Not only was this conceptually simple,
but the LaTeX-based process allowed me to:

* Set something in the main `book.Rnw` so that only selected chapters were compiled, to save time when testing: `includeonly = c("ch01", "ch02", "ch03", "ch04")` 
* Have other sources in the same folder to build something of an Instructor's Manual, with solutions to problems in the chapters.

In Quarto, the pipeline is:

```
.qmd  →  knitr  →  .md  →  pandoc (citeproc + LaTeX writer)  →  .tex  →  LaTeX  →  PDF
```

The first thing to recognize is that nearly everything is controlled by your `_quarto.yml` file. You set the `project:` type,
`book:` parameters (title, author, ...), then list your `chapters:`, include `bibliography:` information and so forth.
That works great for simple projects. But, when you have trouble, it is hard to tell where to look for a solution.

Pandoc acts as an opaque intermediary. It reads your Markdown, resolves citations itself
(via pandoc's `citeproc`), and generates `.tex` that doesn't necessarily look like LaTeX you would have
written. External tools that plug into the traditional LaTeX pipeline often break, because the
`.tex` file and `.aux` file don't have the structure those tools expect.

What this also means for an author is that you have much, much more to try to understand for writing a
book if you want to take advantages of some of the lovely features Quarto offers:

* **Extensions**: In a way reminiscent of LaTeX packages, the Quarto community has developed a wide range of Quarto extensions ...
* **Multiple language** support: Quarto beautifully support the use of different computer languages. You can have code chunks using R, or Python; `mermaid` allows simple diagrams, syntax highlighting is largely built-in, and so forth.
* **Conditional** compilation: The possibility to have different content processed for different output formats (HTML, PDF, ...) all from a single source. For example, in Vis-MLM I'm able to include animated graphics in the HTML version, and replace these with static images in the PDF version.
* **Tabsets**: For HTML output, you can easily design outputs to allow a reader to see alternative views of something (R code vs. Python, views of data for different strata, ...). But this is a feature that has no natural equivalent in a printed book.

But you can quickly get into trouble if you want to take advantage of features (like easy index generation, fancy page design, ...) that
are simple in LaTeX but frought in Quarto. As I write this, a [new Quarto 2.0](https://quarto.org/docs/blog/posts/2026-04-06-whats-next-quarto-2/) is in the works. They say: "Quarto 1 is built by integrating a number of tools that work very well in isolation, but aren’t designed to be performant when used together." But the issues run deeper.
---

## Whitespace shouldn't matter

When you are writing, the focus should be on your _ideas_, expressed in words, using markup to express those in style and with formatting.
What you see and do in an editor window should reflect the WYSEIWYG principle that "What You See Is What You Get". Markdown and Quarto
violate this in several ways. In RStudio, there is a Visual Editor ...

* **Hard line breaks**: ending a line with two or more spaces followed by a return creates the equivalent to an HTML `<br>` tag within the same paragraph, breaking the text to a new line at that point. 

* **Blank lines matter**: When you write text, followed immediately by a code chunk or equation, or itemized lists the results are often not as you expected, unless you insert blank likes


## The `<div>` vs `:::` design flaw

Before considering content of what you want to write and how you do it, I have to comment on one aspect of the Quarto implementation of nearly everything
that is not straight-up text or code, and allows things like conditional compilation. The HTML `<div> ... </div>`  (short for "division")  construct
is a generic container used to group other HTML elements together to provide 
a flexible tool for web structure and styling. For example:

* It is used to divide a web page into distinct sections, such as a navigation bar, sidebar, or footer.
* By assigning a class or id to a <div>, developers can apply specific CSS styles (like background colors, borders, or alignment) to a whole group of elements at once.
* It serves as a "hook" for Javascript scripts to target and manipulate content dynamically, such as showing or hiding a specific section of a page.

A key feature is that `<div> ... </div>` can be nested inside one another to create complex, hierarchical structures whose properties
are naturally inherited from their parents. If you are writing with HTML directly or using an R package (??) to write HTML in your work,
an important feature is to be able to **see** the visual hierarchy in the text, usually done by indenting.


## Problem: You can't keep your project on Dropbox

In `.Rnw`, the DDAR project lived in a `C:/Dropbox/` folder with no issues, and this was sync'd with other authors and contributors via GitHub.
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
## Problem: The `authorindex` disaster

**In `.Rnw`:** I used [`\usepackage{authorindex}`]() to create an Author Index in the book.
BibTeX ran as a normal build step, writing `\bibdata`
and `\bibcite` entries to the `.aux` file. The `authorindex` Perl script was designed to
read the `.aux` file, find the citations and the pages cited and write these to an
`.ain` file, using a special `\aicite{} macro for formatting.
Then, the line `\printauthorindex` automatically generated the author index, in the same way that
`\printindex` did for the Subject Index.
This was completely straightforward and allowed formatting of the index entries to be customized.

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


## Problem: Indexing R function names with underscores

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
automatically on the next page refresh. In Quarto, you must close the PDF (and every other related output file) before every build.

---

## Problem 9: The Mysterious Cache

### The underscore-in-index fix that broke footnotes (April 2026)

**In `.Rnw`:** `\index{}` entries are written directly in the `.tex` source by the author.
If a dataset name like `Prestige` is referenced inline, the author writes something like
`\texttt{Prestige}\index{Prestige@\texttt{Prestige} data}` and the structure is exactly what
the author typed — no intermediary, no caching.

**In Quarto:** Inline R expressions (`` `r dataset("Prestige")` ``) are executed by knitr and
their output is spliced into the Markdown, which pandoc then converts to LaTeX. The executed
output is also cached in `.quarto/_freeze/<chapter>/execute-results/tex.json` so Quarto can
skip re-executing unchanged chunks on subsequent builds.

This cache is a hidden layer between the R source and the LaTeX output. When the R function
changes but the surrounding `.qmd` source does not, Quarto sees no reason to invalidate the
cache — and the old output silently persists.

#### How the error arose

Earlier (Problem 3), the `func()` and `dataset()` helpers in `R/common.R` were updated to fix
underscore-in-index entries. The old version emitted multiple lines from a single inline R call:

```latex
\texttt{Prestige}
\index{Prestige@\texttt{Prestige} data}%
\index{datasets!Prestige@\texttt{Prestige}}%
```

Note the trailing `%` on each `\index` line — a TeX comment character. In LaTeX, `%` discards
everything to the right of it on the same line, including any following whitespace or newline.
This was intentional in the original code to suppress unwanted blank lines between the
`\index{}` calls. The fix changed the function to emit a single-line macro call instead:

```latex
\texttt{Prestige}\ixd{Prestige}
```

where `\ixd{}` is defined in `preamble.tex` with the `%` safely inside the macro body (where
it is consumed during tokenization and never appears in the expansion).

The problem: the freeze cache for `04-multivariate_plots` still held the **old output** with
trailing `%`. Chapter 4 contains the only occurrence of this pattern:

```qmd
The `r dataset("Prestige")` dataset[^fn-blishen] ...
```

In the cached LaTeX, this became:

```latex
\texttt{Prestige}
\index{Prestige@\texttt{Prestige} data}%
\index{datasets!Prestige@\texttt{Prestige}}%.\footnote{...}
```

The `%` on the last `\index{}` line commented out `.\footnote{The dataset was ...` — the
footnote brace was never opened. When LaTeX later encountered the closing `}` for the footnote,
it had nothing to close, producing:

```
! Extra }, or forgotten \endgroup.
l.4219 ...citeproc{ref-Blishen-etal-1987}{1987}).}
```

Because the error occurred before the bibliography section was typeset, the `.aux` file was
truncated — `\bibcite` entries were not written — and the **next build also failed** for the
same reason. Classic deadlock: the first failure corrupts the state that the second build needs.

The error message pointed at `\citeproc{ref-Blishen-etal-1987}{1987}` (the last token before
the orphaned `}`), which led to a long but incorrect investigation of the citeproc machinery,
the author-index `\@citex` patch, and `.aux` file integrity. The real culprit — the stale
freeze cache — was invisible to that investigation.

#### Why the upgrade to Quarto 1.9.36 surfaced the bug

The broken cache had presumably existed since the `dataset()`/`func()` fix was applied. Earlier
Quarto builds (before the upgrade) had not triggered the error, possibly because the cache was
freshly generated or re-executed at that time. After upgrading to 1.9.36, a full rebuild
re-used all existing freeze caches, including the stale `tex.json` for chapter 4.

#### Fix

Delete the stale freeze cache file:

```bash
rm .quarto/_freeze/04-multivariate_plots/execute-results/tex.json
```

On the next build, Quarto re-executes chapter 4's R code, generating fresh output with
`\ixd{Prestige}` (no trailing `%`), and the footnote opens normally.

**Status:** Fixed. The `\ixd{}` macro in `preamble.tex` is the permanent solution; the cache
deletion was a one-time cleanup. The Quarto freeze cache should be treated as a build artifact
that can become stale whenever R helper functions change — analogous to a `.o` file that is not
recompiled because the header it depends on has no Make rule connecting them.

**Lesson:** When a LaTeX error appears immediately after an R helper function is changed, check
the freeze cache before investigating the LaTeX machinery. Look in
`.quarto/_freeze/<chapter>/execute-results/tex.json` for the cached output and compare it
against what the current R function would produce.

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
| Freeze cache staleness | No cache; re-knit is explicit | Cache can persist stale output; silent until LaTeX fails |
| Windows compatibility | Good | CRLF issues with external tools |
| HTML output | Minimal (via `htlatex` etc.) | Excellent, first-class |
| Online publishing | Manual | Built-in GitHub Pages workflow |

---

