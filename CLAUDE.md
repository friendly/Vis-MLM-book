# CLAUDE.md — Vis-MLM-book Project

Quick-start reference for resuming work on this Quarto book project.

## Project

**Title:** Visualizing Multivariate Data and Models in R: A Romance in Many Dimensions
**Author:** Michael Friendly
**Publisher:** CRC Press / Chapman & Hall
**Repo:** https://github.com/friendly/vis-MLM-book
**HTML site:** https://friendly.github.io/Vis-MLM-book/ (served from `docs/`)

## Book structure

15 chapters in 4 parts + appendix, all `.qmd` files at the project root:

| Part | Chapters |
|------|----------|
| Orienting Ideas | 01-Prelude, 02-intro, 03-getting_started |
| Exploratory Methods | 04-multivariate_plots, 05-pca-biplot |
| Univariate Linear Models | 06-linear_models, 07-linear_models-plots, 08-lin-mod-topics, 09-collinearity-ridge |
| Multivariate Linear Models | 10-hotelling, 11-mlm-review, 12-mlm-viz, 13-eqcov, 14-infl-robust, 15-case-studies |
| End Matter | 91-colophon, 95-references |
| Appendix | 21-discrim |

Front matter: `index.qmd`, `00-Author.qmd`

## Key directories

| Directory | Contents |
|-----------|----------|
| `R/` | 130+ R scripts for chapter examples, organized by dataset/topic |
| `bib/` | Bibliography files (references.bib, pkgs.bib, R-refs.bib, packages.bib, Rpackages-4.5.1.bib) |
| `child/` | Child `.qmd` docs included into chapters |
| `latex/` | LaTeX config: preamble.tex, before-body.tex, after-body.tex |
| `figs/` | Figure output, organized by chapter (ch01–ch15, discrim, etc.) |
| `images/` | Static images (cover, logos, diagrams) |
| `docs/` | HTML output (deployed to GitHub Pages) |
| `pdf/` | PDF copies (manually maintained) |
| `issues/` | Issue tracking and task files — **start here** |
| `working-text/` | Background notes, drafts, RA instructions |
| `test/` | Experimental code and test renders |
| `reviews/` | Reviewer PDFs (Reviewer 1.pdf, Reviewer 2.pdf) |

## Build

**HTML + PDF together:** Use `Build -> All Formats` (not `Render Book`). Building only HTML
wipes out `docs/` and can leave inconsistent filenames between formats; building all formats
together avoids this.

**Output locations:**
- PDF → `./index.pdf` (project root). Named after the entry point `index.qmd`, not after
  `output-file: Vis-MLM` in `_quarto.yml` (that setting names the `.tex` intermediate only).
- HTML → `docs/` (served to GitHub Pages)
- TeX intermediate → `./Vis-MLM.tex` (kept because `keep-tex: true`)
- Older PDF copies are manually archived to `pdf/`

**PDF:** Uses xelatex + `documentclass: krantz` (CRC house style).
- Quarto PDF build is **unreliable** — often fails with LaTeX errors.
- Workaround: `keep-tex: true` is set; compile `Vis-MLM.tex` manually in TeXStudio.
- Both MikTeX and TinyTeX are installed on this Windows machine; Quarto prefers TinyTeX.
- **Close `index.pdf` in Acrobat before every build** — Quarto cannot overwrite the file
  while it is open and will fail with "process cannot access the file" (os error 32).
- See `issues/quarto-pdf-help.md` and https://github.com/quarto-dev/quarto-cli/discussions/11087

**R setup:** `R/common.R` is sourced at the start of each chapter. It defines:
- `pkg()` — format R package names (bold + optional citation)
- `colorize()` / `colorize_bg()` — colored text for HTML and PDF
- `write_pkgs()` — auto-generate `bib/packages.bib` from `library()` calls

## Current priorities

See `issues/Tasks-Issues.md` for the full prioritized list. Top items:

1. **PDF build reliability** — make `Render Book` work end-to-end
2. **Author index** — `authorindex` Perl script fails
3. **Cover page** — can't include via Quarto; currently added manually in Acrobat
4. **Conditional content** — links as footnotes in PDF; GIFs only in HTML
5. **pkg() formatting** — needs `\index{}` for PDF, different style for HTML vs PDF
6. **Reviewer comments** — see `issues/reviewer-MichaelT-*.Rmd` and `reviews/*.pdf`
7. **Content additions** — see `issues/content-todos.md`

## Claude Memory

Session context and persistent notes live in `memory/` at the project root (git-tracked).
**Always read `memory/MEMORY.md` at the start of each session** to load prior context.

## Conventions

- `\index{}` entries are being added incrementally; systematic pass still needed.
- Figure paths: `figs/chNN/` set via `knitr opts_chunk$set(fig.path = "figs/")` in each chapter.
- Conditional format blocks: `::: {.content-visible when-format="html"}` / `when-format="pdf"`
- Package references: first use → bold + citation e.g. `**ggplot2** [@R-ggplot2]`
- Citation style: APA (`bib/apa.csl`)
