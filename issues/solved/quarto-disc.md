# Quarto Discussion Post: Complex error in PDF build--- parse-latex filter, pandoc, Quarto

(parse-latex filter expands macros during PDF build via pandoc macro table)
**Forum:** https://github.com/quarto-dev/quarto-cli/discussions  
**Category:** Q&A / Potential Enhancement  
**Date:** 2026-04-14

---

For nearly two weeks I've been struggling to re-build the HTML & PDF versions of my book, [_Visualizing Multivariare Data and Models in R_](https://github.com/friendly/Vis-MLM-book/). I get the same, persistent error every time. Each build takes ~18 min, so this is extremely frustrating.

With the help of Claude, I think I tracked this down to two problems, one related to the  [`tarleb/parse-latex`](https://github.com/tarleb/parse-latex) extension and the other to the Quarto freeze/cache mechanism, described below. I'll also post this as an issue for `tarleb/parse-latex`, but the  behavior I saw leads me to ask for help here.

I've documented the attempts at solving this problem at [Two Weeks in Quarto / Pandoc / LaTeX Hell](https://github.com/friendly/Vis-MLM-book/blob/master/issues/quarto-hell.Rmd)

## Problem

The [`tarleb/parse-latex`](https://github.com/tarleb/parse-latex) extension, when listed under `format: html: filters:` in `_quarto.yml`, still expands user-defined LaTeX macros during the **PDF** pandoc pass. This is seems to be because the filter calls `pandoc.read(raw.text,'latex')` on raw LaTeX blocks, which populates pandoc's internal macro table. Subsequent `pandoc.read()` calls on raw inline content then expand those macros — using whatever multi-line `\providecommand` or `\newcommand` definition was registered — and the expanded text contains `%` characters from the definition body, causing Xelatex to fail!

When a Markdown footnote reference (`.[^fn]`) follows the expanded inline in the source, the last `%` comments out the `.\footnote{` opener, producing:

```
! Extra }, or forgotten \endgroup
```

A compounding factor: Quarto's freeze cache does not track changes to `{{< include >}}`'d files, so stale macro definitions can persist in cached chapter output even after the included file is corrected.

---

## Setup

- **Project:** Quarto book, HTML + PDF (XeLaTeX / `documentclass: krantz`)
- **Quarto version:** 1.8.25 / 1.9.x (error reproduced on both)
- **Extension:** `tarleb/parse-latex` 
- **`_quarto.yml`:**

My `_quarto.yml` includes:

```yaml
format:
  html:
    filters:
      - quarto
      - line-highlight
      - parse-latex
```

The book uses `{{< include latex/latex-commands.qmd >}}` at the top of every chapter. `latex-commands.qmd` defines fallback versions of custom indexing macros for HTML rendering contexts:

```latex
\providecommand{\ixd}[1]{%
  \index{#1@\texttt{#1} data}%
  \index{datasets!#1@\texttt{#1}}%
}
\providecommand{\ixp}[1]{%
   \index{#1@\texttt{#1} package}%
   \index{packages!#1@\texttt{#1}}%
}
\providecommand{\ixfunc}[2]{%
  \index{#1@\texttt{#2}}%
}
```

These same macros are also defined (authoritatively) in `latex/preamble.tex` via
`include-in-header`, which is loaded before the document body for PDF output.
`\providecommand` is used in `latex-commands.qmd` so that the preamble definitions
take precedence for PDF.

Inline R functions (`dataset()`, `pkg()`, `func()` in `R/common.R`) emit these macros
as raw LaTeX inlines:

```r
# e.g., dataset("Prestige") returns (for PDF output):
"\texttt{Prestige}\ixd{Prestige}"
```

The `.qmd` source then has a Markdown footnote immediately after:

```markdown
recorded in `r dataset("Prestige")`.[^prestige-src]

[^prestige-src]: The dataset was collected by...[@Blishen-etal-1987].
```

---

## The Error

Every PDF build failed at the same location:

```
! Extra }, or forgotten \endgroup.
l.4193 ...citeproc{ref-Blishen-etal-1987}{1987}).}
```

The generated `index.tex` (Quarto's internal tex file, compiled by xelatex) contained:

```latex
\texttt{Prestige}%
  \index{Prestige@\texttt{Prestige} data}%
  \index{datasets!Prestige@\texttt{Prestige}}%.\footnote{The dataset was
  collected by...(\citeproc{ref-Blishen-etal-1987}{1987}).}
```

The `%` at the end of the last `\index{}` line comments out `.\footnote{`. LaTeX
never opens the footnote, encounters orphaned text, and when it hits the closing `}`
of the footnote, reports `Extra }`.

---

## Investigation: Two Weeks of Failed Fixes

### Fix 1 — Remove `\n` from inline R output

The R functions originally emitted:

```r
ref <- paste0(ref, "\n\\index{...}\n\\index{...}\n")
```

The explicit `\n` caused pandoc to add `%` at each line break. We switched to a
custom LaTeX macro call:

```r
ref <- paste0(ref, "\\ixd{", dname, "}")   # single-line, no \n
```

**Result:** Error persisted.

### Fix 2 — Delete all freeze caches

Suspected the `.quarto/_freeze/*/execute-results/tex.json` files were stale and serving old multi-line output. Deleted all 15+ `tex.json` files.

**Result:** Error persisted. Caches were regenerated with new `\ixd{}` format —
but the expansion was still happening downstream.

### Fix 3 — Move parse-latex to `format: html: filters:` only

parse-latex was originally in the global `filters:` list. Moved it to `format: html: filters:` to prevent it running during the PDF pandoc pass.

**Result:** Error persisted.

### Fix 4 — Change parse-latex.lua FORMAT guard

The filter's built-in guard was:
```lua
if FORMAT:match 'latex' then
  return {}
end
```

Hypothesis: Quarto's PDF pandoc pass uses a FORMAT value that doesn't contain `"latex"` (e.g. `"pdf"` or a Quarto-internal format). Changed to:

```lua
if not FORMAT:match 'html' then
  return {}
end
```

**Result:** Error persisted. Most `\ixd{}` calls in `index.tex` were still expanded
(785 `\index{}` occurrences vs. only 4 unexpanded `\ixd{}`).

### Fix 5 — Make preamble.tex macro definitions single-line

Hypothesis: parse-latex expands `\ixd{}` using its definition from `preamble.tex`, and the multi-line definition body (with `%` at line ends) causes the problem. Changed to single-line:

```latex
\newcommand{\ixd}[1]{\index{#1@\texttt{#1} data}\index{datasets!#1@\texttt{#1}}}
```

**Result:** Error persisted. The content of `index.tex` was **identical** — unchanged by the preamble fix. This ruled out preamble.tex as the source of the definition being used.

---

## Root Cause

Inspecting the freeze cache (`tex.json`) revealed that it contained not just the knitr R output, but the **full resolved chapter content** including the `{{< include latex/latex-commands.qmd >}}` content. Crucially, `tex.json` stored the **old multi-line** `\providecommand{\ixd}` definition:

```json
"\\providecommand{\\ixd}[1]{%\n  \\index{#1@\\texttt{#1} data}%\n  \\index{datasets!#1@\\texttt{#1}}%\n}"
```

The mechanism:

1. Quarto reads `tex.json` from the freeze cache (which embeds the `latex-commands.qmd`
   content with multi-line `\providecommand{\ixd}`)
2. During the pandoc pass, parse-latex's `RawBlock` handler calls
   `pandoc.read(raw.text, 'latex')` on the raw LaTeX block containing `\providecommand{\ixd}`
3. This **registers `\ixd` in pandoc's internal macro table** with the multi-line body
4. Later, parse-latex's `RawInline` handler processes `\ixd{Prestige}` and calls
   `pandoc.read("\ixd{Prestige}", 'latex')`
5. Pandoc now knows `\ixd`'s definition and **expands it** — producing the multi-line
   body with `%` literally included
6. When written back to the LaTeX output, the `%` from the definition body comments
   out the `.\footnote{` that follows on the same line in the source

This happens even though parse-latex is in `format: html: filters:` only. The FORMAT
guard changes had no effect because — regardless of format — `pandoc.read()` calls
within a Lua filter share pandoc's global macro table.

Changing `preamble.tex` had no effect because parse-latex never reads `preamble.tex`
via `pandoc.read()` — it only processes raw LaTeX blocks that appear in the document
body, which come from the freeze cache, not from `include-in-header`.

### Compounding factor: freeze cache doesn't track `{{< include >}}` dependencies

After fixing `latex-commands.qmd` to use single-line definitions, the `tex.json` freeze caches still contained the old multi-line definitions — because Quarto's freeze invalidation only tracks changes to the main `.qmd` file, not to `{{< include >}}`'d files. The fix required:

1. Updating `latex-commands.qmd` to single-line definitions
2. **Manually deleting all `tex.json` freeze caches** to force regeneration

---

## The Fix

### `latex/latex-commands.qmd` — single-line `\providecommand` bodies

```latex
\providecommand{\ixd}[1]{\index{#1@\texttt{#1} data}\index{datasets!#1@\texttt{#1}}}
\providecommand{\ixp}[1]{\index{#1@\texttt{#1} package}\index{packages!#1@\texttt{#1}}}
\providecommand{\ixfunc}[2]{\index{#1@\texttt{#2}}}
```

When parse-latex expands these via `pandoc.read()`, the expansion body contains no
`%` characters. The `.\footnote{` that follows in the source is no longer commented out.

### Delete all `tex.json` freeze caches

```bash
find .quarto/_freeze -name "tex.json" -delete
```

Required because Quarto does not invalidate freeze caches when included files change.

---

## Questions / Requests

1. **Is parse-latex's `pandoc.read()` behavior — registering macro definitions in
   pandoc's global macro table and then expanding them in subsequent calls — expected
   or a side effect?** The filter is designed for HTML output only, but its
   `pandoc.read()` calls have PDF-build side effects because the macro table is global
   within a pandoc process.

2. **Should `format: html: filters:` actually prevent a filter from running during the
   PDF pandoc pass?** Our experience suggests it does not — the filter appears to run
   regardless of format placement. The FORMAT guard (`if not FORMAT:match 'html' then
   return {} end`) also did not prevent the macro expansion side effects.

3. **Should the freeze cache track `{{< include >}}` file dependencies?** Currently,
   changing an included file requires manual cache deletion. This is a significant
   problem when included files define LaTeX macros that are then embedded in cached
   chapter output.

---

## Environment

```
Quarto: 1.8.25 (also reproduced on 1.9.x)
Platform: Windows 11
R: 4.5.2
pandoc: (Quarto-bundled)
Extension: tarleb/parse-latex (from _extensions/)
```

