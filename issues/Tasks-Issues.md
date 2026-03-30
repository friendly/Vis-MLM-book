# Tasks and Issues for Revisions of Book

## File Organization

Files that are tasks or issues have been moved here from `working-text/` and `test/`.
Reviewer comment files are prefixed `reviewer-`.
Files whose issues are fully resolved should be moved to `issues/solved/`.

### Issues files here

| File | Contents |
|------|----------|
| `fixmes.md` | Small glitches: pkg() spacing, hrefs as PDF footnotes, colorize() |
| `general-issues.md` | Broad open issues: PDF build, HTML features, pkg formatting, figure consistency |
| `content-todos.md` | Content to add: 3D plots, discrim boundaries, effect plots, robust PCA |
| `quarto-pdf-help.md` | PDF build / LaTeX / Quarto problems writeup (also a draft job post) |
| `exercises-format.md` | Template/prompt for generating chapter exercises |
| `chapter-structure.txt` | Alternative chapter/part structure sketch |
| `content-dominance-analysis.txt` | Potential addition: dominance weight visualization |
| `reviewer-MichaelT-comments.Rmd` | Chapter-by-chapter reviewer comments (Michael T.) |
| `reviewer-MichaelT-discrim.Rmd` | Reviewer comments on discriminant analysis appendix |
| `reviewer-MichaelT-submit.Rmd` | Additional reviewer line-edit comments (Michael T.) |

---

## Prioritized Work Items

### Priority 1: PDF Build

* **PDF build reliability**: Quarto's PDF build often fails with LaTeX errors; current workaround
  is to compile the generated `.tex` via TeXStudio. Goal: make `Build -> Render Book` work reliably.
  See `quarto-pdf-help.md` and `general-issues.md`. Key sub-issues:
  - MikTeX vs TinyTeX conflict on Windows (both installed; Quarto prefers TinyTeX)
  - See Quarto discussion: https://github.com/quarto-dev/quarto-cli/discussions/11087
  - Reference model: https://github.com/bgreenwell/quarto-crc (Quarto-CRC starter)

* **Author index**: `authorindex` Perl script fails. Previously tracked in `build-problems/authorindex.md`
  (now deleted from tree; recoverable from git history if needed).

* **Cover page**: `images/cover/cover-peng.jpg` cannot be included via Quarto front matter;
  currently added manually in Adobe Acrobat post-compile.

### Priority 2: HTML/PDF Conditional Content

* Links (`[]()` markdown) should render as footnotes in PDF — need conditional handling throughout.
  See `general-issues.md` and `test/figs-html-pdf.md` for the pattern to use.

* Animated GIFs should appear only in HTML (use `.content-visible when-format="html"` divs).

* `code-fold` / `code-summary` usage is inconsistent across chapters — audit needed.

### Priority 3: Formatting & Conventions

* **Package references**: `pkg()` in `R/common.R` needs to emit `\index{}` entries for PDF and
  format differently (monofont, colored) for HTML vs. PDF. See `issues/general-issues.md`
  and `test/pkg-names.md`.

* **Figure sizes**: Inconsistent across chapters; need general rules.

* **Color in figure captions**: `colorize()` in `R/common.R` — usage should be reviewed
  for consistency. See `fixmes.md`.

### Priority 4: Content Additions & Revisions

See `content-todos.md` for full list. Highlights:
* 3D plots (rgl): data + PCA axes, regression surface, HE plot 3D
* Discriminant analysis: classification boundary plots in data space and discriminant space
* Effect plots for MLM chapters
* Robust PCA section (Ch 13/14)
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

---

## Getting Started (original notes)

Scan the contents of this project to understand the organization of the files for producing
both an HTML and PDF version of the book. See `CLAUDE.md` at the project root for a quick-start
summary useful for resuming work in a new session.
