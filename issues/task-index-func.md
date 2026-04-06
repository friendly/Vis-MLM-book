# Task: Indexing R Function Names (especially with underscores)

## Problem summary

Function names containing underscores (e.g. `stat_ellipse()`, `geom_smooth()`,
`facet_wrap()`) could not be indexed correctly because:

1. **Display in text**: `paste0("\\texttt{", name, "}")` left `_` unescaped → LaTeX
   subscript error when typesetting.

2. **Index entry display**: `\ixfunc` generated `\index{name@\texttt{name()}}` with raw
   `_` in the display part. The sort-key write is sanitized by LaTeX's `\index`, but the
   display text survives into the `.ind` file where LaTeX re-typesets it — and `_` is
   catcode 8 (subscript) again, causing "Missing $" errors.

---

## Fix implemented (2026-04-06)

### Convention

**Always pass function names WITH `()` to `func()`:**

```r
`r func("stat_ellipse()")`   # correct
`r func("MASS::lda()")`      # correct — index entry shows lda() only
```

### `R/common.R` — `func()`

Two changes:

1. **Display**: use `escape(name)` so `_` → `\_` in `\texttt{}`:
   ```r
   funcname <- paste0("\\texttt{", escape(name), "}")
   ```

2. **Index**: pass sort key (raw `_`) and display (escaped `\_`) as two separate args:
   ```r
   ref <- paste0(ref, "\n\\ixfunc{", fname, "}{", escape(fname), "}\n")
   ```
   where `fname` is the function-name-only part (strips `pkg::` prefix if present).

### `latex/preamble.tex` — `\ixfunc`

Changed from one-arg (which added `()` itself) to two-arg (caller supplies `()`):

```latex
% \ixfunc{sort-key}{display-name}  — caller includes () in both args
% e.g. \ixfunc{stat_ellipse()}{stat\_ellipse()}
\newcommand{\ixfunc}[2]{%
  \index{#1@\texttt{#2}}%
}
```

**Why two args?** Sort key uses raw `_` (fine for makeindex; never typeset). Display uses
`\_` explicitly so it survives into the `.ind` file and typesets correctly. A single arg
cannot serve both purposes.

### `pkg::func()` pattern

`func("MASS::lda()")` → `fname = "lda()"` (package prefix stripped). In text renders as
`\texttt{MASS::lda()}` (full name); in index appears as `lda()` only (no package prefix).

---

## Remaining work: systematic pass through chapters

The fix is in place but many function references in the `.qmd` files still use bare
backticks instead of `r func()`. These need to be updated chapter by chapter.

### Priority cases found (scan of *.qmd files, 2026-04-06)

**`03-getting_started.qmd`** — DONE (user fixed directly):
- `stat_ellipse()` converted; old bare-backtick and `\ix{}` commented out.

**`04-multivariate_plots.qmd`** — DONE (2026-04-06):
Converted: `geom_smooth()`, `facet_wrap()`, `theme_penguins()` (×2), `legend_inside()`,
`stat_bagplot()`, `geom_density_2d()` (×2), `MASS::kde2d()`, `geom_hdr()` (×2),
`geom_text()`, `scales::hue_pal()`, `ggpairs()`, `ggally_cor()`, `ggally_points()`,
`ggally_densityDiag()`, `ggally_barDiag()`, `my_panel()`, `pcp_select()`, `pcp_scale()`,
`pcp_arrange()`.

Left as bare backtick: `facet_grid(row ~ col)` (shows argument syntax, not just name);
`ggally_NAME()` (placeholder pattern, not a real function).

**`05-pca-biplot.qmd`**:
```
line 763:  `coord_fixed()`
line 834:  `geom_segment()`
line 1022: `fviz_pca()`
line 1023: `fviz_ca()`, `fviz_mca()`, `fviz_famd()`, `fviz_cluster()`
line 1127: `factoextra::get_pca_var()`
line 1146: `factoextra::fviz_contrib()`
line 1279: `fviz_pca_var()`
line 1280: `fviz_pca_biplot()`
line 1993: `tidyr::pivot_wider()`
line 2096: `geom_raster()`
line 2098: `facet_wrap()`
```

**`06-linear_models.qmd`**:
```
line 261: `geom_smooth()`
```

**`07-linear_models-plots.qmd`**:
```
line 143: `parameters::model_parameters()`
line 290: `performance::check_model()`
line 505: `scale_y_discrete()`
line 592: `ggcoef_model()`, `ggcoef_compare()`
line 635: `ggcoef_model()`
```

**`09-collinearity-ridge.qmd`**:
```
line 483: `performance::check_collinearity()`
line 690: `geom_text_repel()`
```

**`10-hotelling.qmd`**, **`11-mlm-review.qmd`**, **`15-case-studies.qmd`**, **`21-discrim.qmd`**:
miscellaneous cases — search each file for bare backtick `_` function names.

### Replacement pattern

Global find-replace in each file:
- Find: `` `func_name()` `` (bare backtick with underscore)
- Replace: `` `r func("func_name()")` ``

For `pkg::func()` forms:
- Find: `` `pkg::func_name()` ``
- Replace: `` `r func("pkg::func_name()")` ``

Not every bare-backtick function reference needs indexing — use judgement for functions
mentioned once in passing vs. functions that are key to a section.

### Note on `not_these` cases

Some backtick references are NOT function calls and should stay as bare backticks:
- `binwidth`, `probs` — argument names, not functions
- `NAME` in `ggally_NAME()` — a placeholder, not a real function
- `labels`, `theme_penguins()` used as shorthand in prose — may be OK as bare backtick

---

## Related files

- `R/common.R` — `func()`, `escape()`, `tt()` definitions
- `latex/preamble.tex` — `\ixfunc` macro definition
- `latex/latex-commands.qmd` — HTML-only macro stubs (no `\ixfunc` needed there;
  `func()` only emits `\ixfunc` for LaTeX output)
- `03-getting_started.qmd` lines 130–134 — first test case
