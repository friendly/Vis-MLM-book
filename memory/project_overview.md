---
name: Project Overview
description: Vis-MLM-book — Quarto book project structure, build config, chapter list, hosting
type: project
---

**Title:** "Visualizing Multivariate Data and Models in R: A Romance in Many Dimensions"
**Author:** Michael Friendly
**Publisher:** Chapman & Hall / CRC Press
**Repo:** https://github.com/friendly/vis-MLM-book
**HTML site:** https://friendly.github.io/Vis-MLM-book/ (served from `docs/`)

## Structure
- Root `.qmd` files: index.qmd, 00-Author.qmd, 01–15 chapters, 21-discrim.qmd (appendix), 91-colophon.qmd, 95-references.qmd
- Parts: Orienting Ideas (ch01-03), Exploratory Methods (ch04-05), Univariate LM (ch06-09), Multivariate LM (ch10-15), End Matter
- `R/` — 130+ R scripts; `bib/` — bibliography; `child/` — child docs; `latex/` — preamble/before/after-body.tex
- `docs/` — HTML output; `pdf/` — PDF copies; `figs/` — figure output by chapter
- `working-text/` — notes, FIXMEs, TODOs (43 files); `test/` — experimental code (39 files); `issues/` — issue tracking

## Build
- HTML: `output-dir: docs`, xelatex, `documentclass: krantz`, TinyTeX preferred
- PDF: `keep-tex: true`, `output-file: Vis-MLM`, extensions: line-highlight, parse-latex (HTML only)
- Both MikTeX and TinyTeX installed on Windows; PDF build is unreliable from Quarto directly; often compiled via TeXStudio from generated .tex
- `build.sh` at project root: use `./build.sh --html`, `--pdf`, `--all`, `--full` etc. HTML renders twice (two-pass needed for index.html cross-ref resolution). PDF render uses no profile.
- parse-latex filter: must stay in `format: html: filters:` only — running it globally causes `\providecommand` macro expansion in PDF, breaking footnotes.
- Freeze cache: `{{< include >}}` changes (e.g. latex/latex-commands.qmd) do NOT auto-invalidate freeze cache. Use `./build.sh --clean-cache` after editing included files.
- xref cache: `.quarto/xref/` can accumulate stale entries if chapters are renamed/renumbered. Delete all files there and rebuild if cross-refs misbehave.

## Why:
User is preparing camera-ready PDF for CRC Press while maintaining an HTML web version. The two formats require different handling (links as footnotes in PDF, animated GIFs only in HTML, conditional blocks).
