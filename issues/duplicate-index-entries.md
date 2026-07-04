# Duplicate Index Entries: mixed index-entry mechanisms

## Symptom

Many package names appear **twice** in the printed index — once for front-matter pages
(Roman numerals) and once for body pages (Arabic numerals):

```
car package, xviii, xx–xxii
car package, 48, 59, 197, 198, …
```

## Root cause

Two different mechanisms write package index entries to `index.idx`, producing slightly
different display text — so makeindex treats them as **separate** entries:

| Source | `.idx` display text | Origin |
|--------|---------------------|--------|
| `r pkg("car")` → `\ixp{car}` (current) | `\texttt  {car}` (two spaces) | front matter, recent chapters |
| Direct `\index{car@\texttt{car} package}` | `\texttt{car}` (no spaces) | body chapters (knitr cache from old `pkg()`) |

The two-space artifact arises because `\ixp{}` is expanded by `\newcommand` before
`\protected@write` serializes it to the `.idx` file. When ALL entries go through the same
path (`\ixp{}`), they all get the same display text and makeindex merges them correctly.
The problem is the **mix**: old knitr-cached output from body chapters uses the previous
`pkg()` format (direct `\index{}`), while freshly-rendered code uses `\ixp{}`.

### Why front matter vs. body?

- **Front matter chapters** run fresh (no cache, or re-cached recently) → current `pkg()`
  → `\ixp{car}` → `\texttt  {car}` (two spaces in `.idx`)
- **Body chapters** use knitr cache generated when `pkg()` emitted direct `\index{}` calls
  → `\texttt{car}` (no spaces in `.idx`)

makeindex uses the display text as part of the sort/merge key, so these become two items
with the same sort key but different display text → two index lines.

## Correct approach

The canonical method is **always** use `r pkg("animation")`, `r dataset("Prestige")` etc.
in `.qmd` source files — never insert raw `\ixp{}` or `\index{}` directly in chapter text.
This ensures all package index entries go through the same `pkg()` → `\ixp{}` path and
produce identical display text.

## Fixes applied (2026-07-01)

1. **`01-Prelude.qmd` line 260**: replaced `\ixp{animation}` (raw LaTeX) with
   `` `r pkg("animation")` `` (correct R inline call).

2. **Knitr cache** (still needed): the body chapters' cache must be cleared so they
   re-render via current `pkg()` and emit `\ixp{}` consistently. Until then, cached
   chapters still write old-format `\index{}` entries. Clear with:
   ```r
   # from project root in R:
   unlink(list.dirs(".", recursive = FALSE, full.names = TRUE) |>
            Filter(f = \(d) grepl("_cache$", d)), recursive = TRUE)
   ```
   or manually delete `*_cache/` / `*_files/` directories before the next full build.

## Other direct `\index{}` calls in body chapters

Some body chapter `.qmd` files may also contain raw `\index{...}` calls written by hand
(not from knitr cache). A systematic grep can find them:

```bash
grep -rn '\\index{' --include="*.qmd" .
```

These should either be converted to R inline calls or to the appropriate LaTeX macro
(`\ix{}`, `\ixmain{}`, `\ixon{}`/`\ixoff{}` for ranges) depending on intent.
