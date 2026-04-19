# R code for figures and analyses

## What exists

`<!-- fig.code: R/filename.R -->` HTML comments appear in the `.qmd` chapter files, immediately before (or near) the figures they generate. These are invisible in both HTML and PDF output — they are purely editorial notes at present.

**Coverage (as of 2026-04-17):** ~35 comments across chapters 03, 04, 05, 07, 08, 09, 10, 12, 14, 21 and some child/ files. Many chapters have none yet.

**R file header format** (some files, not all):
```r
#' ---
#' title: Davis data-- Models and plots
#' ---
```

---

## Goals

### Goal 1: Appendix `Rcode.qmd` (online-only)
A generated page listing, per chapter, the R files referenced via `fig.code`, with links to the source on GitHub. Optional: extract the `title:` from the R file header.

### Goal 2: Margin notes in HTML
Replace each `<!-- fig.code: R/foo.R -->` with a visible margin note (HTML only) of the form:
> R code: [foo.R](https://github.com/friendly/vis-MLM-book/blob/master/R/foo.R)

---

## Current problems with the `fig.code` comments [FIXED]

The comments are inconsistently formatted — any automated processing must handle all these variants:

| Pattern | Example |
|---------|---------|
| Plain | `<!-- fig.code: R/Davis-reg.R -->` |
| Backtick-quoted | `<!-- fig.code: \`R/Salaries-scatterplots.R\` -->` |
| Double-quoted (unclosed) | `<!-- fig.code: "R/ellipses-coverage.R -->` |
| Extra whitespace | `<!-- fig.code:  R/outlier-demo.R -->` |
| Two comments for one figure | lines 1224–1225 in `09-collinearity-ridge.qmd` |
| Free-text note, not a filename | `<!-- fig.code: taken from genridge README.Rmd -->` |
| Possible filename typo | `R/acetlyne-colldiag.R` (actual file: `acetylene-colldiag.R`) |

**Before implementing either goal, the comments should be normalized** to a single clean format: `<!-- fig.code: R/path/to/file.R -->` (no quotes, no backticks, single comment per figure).

---

## Recommended approach [DONE]

### Step 1: Normalize the comments (one-time sed/R pass)
Write a small R script (`R/normalize-figcode.R`) that reads each `.qmd`, normalises all `fig.code` comments to the canonical form, and writes back. Flag lines that don't look like valid paths (e.g., the free-text genridge note).

### Step 2: Margin notes via Lua filter (Goal 2)

A Quarto Lua filter (`filters/figcode.lua`) intercepts `<!-- fig.code: R/... -->` RawBlock nodes in the pandoc AST and, for HTML output, replaces them with a `.column-margin` div:

```markdown
::: {.column-margin .figcode}
[Davis-reg.R](https://github.com/friendly/vis-MLM-book/blob/master/R/Davis-reg.R)
:::
```

For PDF output the filter emits nothing (comment is already invisible). This approach:
- Requires no changes to the `.qmd` source files beyond normalizing the comments
- Works automatically for every new `fig.code` comment added
- Lives entirely in the filter; no per-chapter manual work

The filter would be added to `_quarto-online.yml` under `format: html: filters:` (online only, since PDF output should ignore it).

### Step 3: Generate `Rcode.qmd` (Goal 1)

A Quarto pre-render R script (`R/make-rcode-appendix.R`) run via `_quarto.yml` `pre-render:`:
1. Reads each `.qmd` in chapter order (from `_quarto-online.yml`)
2. Extracts all `fig.code` paths (deduplicated per chapter)
3. For each file: tries to read the `#' title:` header; flags missing titles
4. Writes `Rcode.qmd` with one section per chapter

This script runs automatically before each online render, keeping the appendix current.

**NO**: Wrote the script (`R/make-rcode-appendix.R`), but will be doing this infrequently, so no need to pre-render.

---

## Implementation order

1. [x] Normalize `fig.code` comments (Step 1) — prerequisite for reliable parsing
2. [x] Add `title:` headers to R files that lack them (incremental; flag via Step 1 script)
3. [ ] Lua filter for margin notes (Step 2) — high value, small effort
4. [ ] Pre-render script for `Rcode.qmd` (Step 3) — more effort, lower urgency

### Step 4: Find other R files that could be added.

There are probably a bunch more of R examples that could be listed here. I don't want to include absolutely every one,
but it would be useful to: 

* scan the chapter `.qmd` files looking for figures produced by R code that don't already have the `<!-- fig.code: R/filename.R -->` comment.

* try to find the likely source under `R/` that includes this source. Note cases where this cannot be found.

* make an easy way for me to decide to include them in the chapters by adding those `<!-- fig.code: R/filename.R -->` comments

**Status**: I'm working through these, but it is tedious

### Step 5: Add **Utiilities* section

There are a bunch of custom functions I use for various scripts that are not yet in packages. After the sections for all chapters
and Appendices in `Rcode.qmd` add a section that lists these.

* Find instances of `source("R/...")` or `source(here::here())` in any of the R scripts already cited
* Normalize that path to something that can be listed.
* Write a list of the unique R files with links to their GH sources

---

## GitHub base URL for links
`https://github.com/friendly/vis-MLM-book/blob/master/R/`
