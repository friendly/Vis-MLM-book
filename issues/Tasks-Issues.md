# Tasks and Issues for Revisions of Book

## Getting Started (original notes)

Scan the contents of this project to understand the organization of the files for producing
both an HTML and PDF version of the book. See `CLAUDE.md` at the project root for a quick-start
summary useful for resuming work in a new session. [DONE]

Note that:

* A file of LaTeX commands is included at the start of each chapter, via `{{< include latex/latex-commands.qmd >}}`. In addition
  to definitions for LaTeX math, it includes some shorthands to make indexing easier: `\ix{}`, `ixp{}` for packages, `ixd{}` 
  for datasets. Also includes a list of packages to be cited, even if they are not cited directly in the text.

* `R/common.R` is sourced at the beginning of each chapter. It contains:
  + `knitr` options used for figures, chunk outputs, etc.
  + functions used inline as `r pkg("ggplot2") to print the name of a package in a distinctive font, with an optional citation,
    and also to create entries in the index. Similarly: `r dataset("prestige")` or `r dataset("carData::prestige")` prints
    and indexes the names of datasets used.

---

## File Organization

Files that are tasks or issues have been moved to `issues/` from `working-text/` and `test/`.
Reviewer comment files are prefixed `reviewer-`.
Files whose issues are fully resolved should be moved to `issues/solved/`.

### Issues files here

Some of these are old/stale/solved; review these & move to solved/ those no longer active.

| File | Contents |
|------|----------|
| `fixmes.md` | Small glitches: pkg() spacing, hrefs as PDF footnotes, colorize() |
| `general-issues.md` | Broad open issues: PDF build, HTML features, pkg formatting, figure consistency |
| `content-todos.md` | Content to add: 3D plots, discrim boundaries, effect plots, robust PCA |
| `quarto-pdf-help.md` | PDF build / LaTeX / Quarto problems writeup (also a draft job post) |
| `exercises-format.md` | Template/prompt for generating chapter exercises |
| `content-dominance-analysis.txt` | Potential addition: dominance weight visualization |
| `reviewer-MichaelT-comments.Rmd` | Chapter-by-chapter reviewer comments (Michael T.) |
| `reviewer-MichaelT-discrim.Rmd` | Reviewer comments on discriminant analysis appendix |
| `reviewer-MichaelT-submit.Rmd` | Additional reviewer line-edit comments (Michael T.) |

---

## Prioritized Work Items

### Priority 1: PDF Build

* **PDF build reliability**: Quarto's PDF build often fails with LaTeX errors; current workaround
  is to compile the generated `.tex` via TeXStudio. Goal: make `Build -> Render Book` work reliably.

  - **Status**: Now, using Quarto v. 1.7.29 or later, `Build -> PDF runs to completion. It produces
  `index.{aux,ilg,ind,toc, ...}`. There were an `index.{tex,pdf}` there, but these were deleted.
  Instead, the TeX file generated is named `Visualizing-Multivariate-Data-and-Models-in-R.tex`.
  Quarto opens a PDF file in the browser, as `http://localhost:6090/web/viewer.html`
  If I click on Download, I get: `file:///C:/Users/friendly/Downloads/Visualizing-Multivariate-Data-and-Models-in-R.pdf`
  
  - Upgraded Quarto to v. 1.9.36. In `quarto.yml`, now have `book: output-file: "Vis-MLM"`. This completes, and opens
  `http://localhost:7466/web/viewer.html` in the browser. Click on Download gives `file:///C:/Users/friendly/Downloads/Vis-MLM.pdf`.
  The Quarto-compiled TeX file is named `Vis-MLM.tex in the project root. All other artifacts of Xelatex are named `index.{aux,toc,idx,...}
  But this run, with `Build -> PDF` also deletes all the `docs/` files for the HTML version.
  
  - Tried `Build -> All formats`. This finally (26 min!) opens the HTML version in the browser; looks OK. `index.*` and `Vis-MLM.tex`
  are in the root directory, but surprisingly, no PDF. Found the PDF file in `docs/Vis-MLM.pdf`, along with all the HTML files.
  
  See `quarto-pdf-help.md` and `general-issues.md`. Key sub-issues:
  - MikTeX vs TinyTeX conflict on Windows (both installed; Quarto prefers TinyTeX) [FIXED: Now using TinyTeX]
  - See Quarto discussion: https://github.com/quarto-dev/quarto-cli/discussions/11087
  - Reference model: https://github.com/bgreenwell/quarto-crc (Quarto-CRC starter)

* **Author index**: `authorindex` Perl script fails. Tracked in `build-problems/authorindex.md`. If this cannot be made
  to run, I wonder if it would be possible to re-write what this does in R.

* **Cover page**: `images/cover/cover-peng.jpg` cannot be included via Quarto front matter;
  currently added manually in Adobe Acrobat post-compile.

* **Part-pages**: I would like to have something more than just a page that says: "Part I Orienting Ideas". E.g.,: A brief overview
  of the content, or a gallery-like selection of images or a tikz diagram of the contents, such as I used in my DDAR book.
  Tried something simple in `I-OrientingIdeas.qmd` but this didn't work that well.

* **Indexing functions**: A goal is to have every function mentioned in the text use an inline expression like `r func("glm()")`,
  where `func()`, defined in `R/common.R` creates index entries. This doesn't work for functions with underscores in their names,
  like `stat_ellipse()`. 

* **Rendering**: I use the `Build -> Render Book` button to render in either PDF or HTML. It creates a background job via the command, e.g.,
  `quarto preview --render pdf --no-watch-inputs --no-browse`, and takes ~ 10 min to render. 

### Priority 2: HTML/PDF Conditional Content

* Links (`[]()` markdown) should render as footnotes in PDF — need conditional handling throughout.
  See `general-issues.md` and `test/figs-html-pdf.md` for the pattern to use.

* Animated GIFs should appear only in HTML (use `.content-visible when-format="html"` divs).

* `code-fold` / `code-summary` usage is inconsistent across chapters — audit needed. Also, perhaps there is too much code
  printed in the PDF version. 

### Priority 3: Formatting & Conventions

* **Package references**: `pkg()` in `R/common.R` needs to emit `\index{}` entries for PDF and
  format differently (monofont, colored) for HTML vs. PDF. See `issues/general-issues.md`
  and `test/pkg-names.md`.

* **Figure sizes**: Inconsistent across chapters; need general rules. In the most recent PDF, `pdf/index-review.pdf`
  I manually adjusted many figures to make them fit the pages better.

* **Color in figure captions**: `colorize()` in `R/common.R` — usage should be reviewed
  for consistency. See `fixmes.md`.

### Priority 4: Content Additions & Revisions

See `content-todos.md` for full list. Highlights:
* 3D plots (rgl): data + PCA axes, regression surface, HE plot 3D
* Discriminant analysis: classification boundary plots in data space and discriminant space [DONE: `21-discrim.qmd`, but intended to be online only]
* Effect plots for MLM chapters
* Robust PCA section (Ch 13/14) [DONE: `14-infl-robust.qmd#sec-robust-estimation`]
* Dominance analysis visualization (see `content-dominance-analysis.txt`)

### Priority 5: Reviewer Comments

* Work through `reviewer-MichaelT-comments.Rmd` — chapter-by-chapter items, some marked DONE.
* Work through `reviewer-MichaelT-discrim.Rmd` — comments on discriminant analysis appendix.
* Work through `reviewer-MichaelT-submit.Rmd` — line edits and broken refs.
* Review PDFs in `reviews/` (Reviewer 1.pdf, Reviewer 2.pdf).

### Priority 6: Exercises

* Plan: exercises at end of each chapter; format not yet settled for Quarto.
  See `exercises-format.md` (prompt template) and `test/numbered-exercises.md` (LaTeX → Quarto question).

### Priority 7: Infrastructure / End-of-project

* Separate GitHub repo for web (HTML) version — copy only relevant files.
  Currently HTML and source are in the same repo; `docs/` is served to GitHub Pages.

* `Makefile` for building HTML and PDF versions (draft in `working-text/Makefile`).

* Index: `\index{}` entries have been started; need systematic pass through all chapters.

* What I learned from this: There are lots of notes on the issues I struggled with to write this book using Quarto. 

---

