---
name: Duplicate Index Entries Fix
description: Duplicate index entries — source fix (2026-04-07) is NOT sufficient; every PDF build still needs the fix-index normalization pass
type: project
---

**Verified 2026-07-11 (full clean rebuild):** the 2026-04-07 source-level fix did NOT
fully eliminate the problem. After `./build.sh --all --authorindex`, `index.idx` still
contained 10 terms in both `\texttt  {X}` (two-space) and `\texttt{X}` forms (GGally,
datasets, heplots, lda(), ggpcp, etc.), i.e. duplicate entries in the printed index.
**The fix-index pass is still required after every PDF build** — either
`./build.sh --pdf --fix-index` / run its steps manually (sed-normalize index.idx →
`makeindex -s latex/book.ist index.idx` → one `xelatex -no-shell-escape` pass → copy
index.pdf to docs/ and pdf/). Note `--full` does NOT include `--fix-index`. Also note:
the xelatex pass rewrites index.idx with the two-space artifacts again — that is
harmless; verify the fix in `index.ind`, not `index.idx`.

Duplicate index entries for packages (e.g., `car package` appearing twice) and datasets
(e.g., `dogfood dataset`) were caused by inconsistent `\texttt` spacing in `index.idx`.

**Root cause:** TeX's `\write` mechanism appends a space after control words ending in a
letter, so `\ixp{car}` → `\texttt  {car}` (two spaces) in `.idx`. Meanwhile `dataset()`
was writing literal `\index{name@\texttt{name} data}` into the `.tex` source (via Pandoc),
producing `\texttt{name}` (no space). Makeindex treats these as different display texts →
separate entries instead of merging.

**Fix implemented (2026-04-07) — needs recompile to verify:**

1. `latex/preamble.tex` — `\ixd` macro updated to `@\texttt{#1}` format matching `\ixp`:
   ```latex
   \newcommand{\ixd}[1]{%
     \index{#1@\texttt{#1} data}%
     \index{datasets!#1@\texttt{#1}}%
   }
   ```

2. `R/common.R` — `dataset()` now emits `\ixd{name}` + `\ixp{pkg}` instead of
   direct `\index{...@\texttt{...}...}` strings. All entries now go through the macro
   path → consistent spacing → makeindex merges correctly.

3. `12-mlm-viz.qmd` — replaced `\ix{dogfood data}` + `\ix{datasets!dogfood}` with
   `\ixd{dogfood}` to match `r dataset("dogfood")` in ch. 11.

**Additional problems found after first recompile (2026-04-07):**

1. **"data sets" vs "datasets"**: Two separate index headings because Vis-MLM.tex was
   partially stale — chapters rendered before the `dataset()` fix had direct
   `\index{data sets!name}` calls; chapters rendered after had `\ixd{name}` through
   the new preamble.tex `\ixd` macro (which routes to `datasets!`).
   Also, `latex/latex-commands.qmd` had old `\ixd` definition with `data sets!` (space).
   **Fix applied**: Updated `latex-commands.qmd` `\ixd` to match preamble.tex.
   Full Quarto re-render needed to regenerate all chapters with new `dataset()`.

2. **"car package" / "carData package" / "datasets package" twice**: Two .idx display
   strings: `\texttt  {car}` (two spaces, from `\ixp{car}` macro calls) vs
   `\texttt{car}` (no space, from old direct `\index{car@\texttt{car} package}` in
   stale chapters). Full Quarto re-render will replace all stale direct calls with
   `\ixp{}` → consistent format → entries merge.

**Status (2026-04-07):** `latex-commands.qmd` fixed. Needs full Quarto re-render to
flush stale chapters from Vis-MLM.tex, then recompile .tex → .pdf.

**Why:** preamble.tex uses `\newcommand` (always defines); latex-commands.qmd uses
`\providecommand` (no-op if already defined). preamble.tex wins for PDF. Both must
agree so standalone/HTML use is also correct.
