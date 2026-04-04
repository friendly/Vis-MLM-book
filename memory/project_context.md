---
name: Project context
description: Book revision status — resolved issues, open priorities, key file locations
type: project
---

Book: "Visualizing Multivariate Data and Models in R" (15 chapters + appendix), Quarto project targeting both HTML (GitHub Pages via docs/) and PDF (CRC krantz class via TinyTeX/XeLaTeX).

**Resolved (DONE/FIXED):**
- PDF build now works end-to-end with Quarto v1.9.36 + TinyTeX; output named `Vis-MLM.pdf` via `_quarto.yml` `output-file: "Vis-MLM"`. TeX file is `Vis-MLM.tex`.
- MikTeX vs TinyTeX conflict resolved — now using TinyTeX exclusively.
- Discriminant analysis appendix (`21-discrim.qmd`) completed (online-only).
- Robust PCA section done (`14-infl-robust.qmd#sec-robust-estimation`).
- CLAUDE.md created as quick-start reference.

**Open priorities (as of 2026-04-03):**
1. **PDF build sub-issues**: Author index (authorindex Perl script fails), cover page (added manually in Acrobat), part-pages content, indexing functions with underscores
2. **Conditional content**: hrefs as footnotes in PDF, GIFs only in HTML, code-fold audit
3. **Formatting**: pkg() needs \index{} for PDF + different HTML/PDF styling; figure sizes inconsistent; colorize() review
4. **Content**: 3D plots (rgl), effect plots for MLM chapters, dominance analysis viz
5. **Reviewer comments**: Work through reviewer-MichaelT-*.Rmd files and reviews/*.pdf
6. **Exercises**: Format not settled; see exercises-format.md and test/numbered-exercises.md
7. **Infrastructure**: Separate GitHub repo for HTML, Makefile, systematic index pass

**Why:** Book is in revision phase heading toward CRC Press submission.
**How to apply:** Suggestions should account for both HTML and PDF output requirements; prefer Quarto-native solutions; flag Windows/TinyTeX constraints.
