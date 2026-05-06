# Code-fold audit

One reviewer commented that there was too much code displayed in the book and
length could be shortened by excluding some. 

* For HTML: This can be done by folding the code in the knitr comments:

````
```{r}
#| label: fig-draft-gg1
#| fig-align: center
#| out-width: "80%"
#| code-fold: true
#| code-summary: "Show the code"
#| fig-cap: "Basic scatterplot of 1970 Draft Lottery data plotting rank order of selection against birthdates in the year. Points are colored by month. The horizontal line is at the average rank."
````

* For PDF: This can be done selectively using the `knitr` option `echo=knitr::is_html_output()` (Must be included in the first chunk line.
Doesn't work as a chunk comment)


````
```{r echo=knitr::is_html_output()}
#| label: fig-draft-gg1
#| fig-align: center
#| out-width: "80%"
#| code-fold: true
#| code-summary: "Show the code"
#| fig-cap: "Basic scatterplot of 1970 Draft Lottery data plotting rank order of selection against birthdates in the year. Points are colored by month. The horizontal line is at the average rank."
````

Gavin has been going through the book, noting those chunks whose code could be folded or ommitted from the printed PDF version.
His working file is: https://raw.githubusercontent.com/friendly/Vis-MLM-book/refs/heads/GK-work/reviews/reviewer-GavinK-CodeAudit.Rmd

A first step it to see if the chunks to be modified this way can be found from his working file.

---

## Check info for automation

*Compiled 2026-05-05 from Gavin's audit file (fetched from `GK-work` branch) and
inspection of current `master` branch `.qmd` files.*

### Implementation pattern

Each flagged chunk needs two changes:

1. Change the chunk header from `` ```{r} `` to `` ```{r echo=knitr::is_html_output()} ``
   (suppresses code in PDF; must be on the header line, not a `#|` comment).
2. Add `#| code-fold: true` and `#| code-summary: "Show the code"` as chunk options
   (folds code in HTML; ignored by PDF since echo is already FALSE).

For chunks that already have `#| code-fold: false`, change that to `true`.

### Chunks flagged by Gavin (Chs 1–10; review ends at Ch 11)

| Label | File | Line | Current state | Gavin's reason |
|-------|------|------|---------------|----------------|
| `fig-diabetes1` | `01-Prelude.qmd` | 368 | `code-fold: false` | Only figure in ch1 with code shown; narrative is about the figure |
| `fig-davis-reg1` | `03-getting_started.qmd` | 300 | no code-fold | Narrative describes the figure, not its construction |
| `fig-davis-reg2` | `03-getting_started.qmd` | 328 | no code-fold | Consistency with `fig-Salaries-lm` (already folded in ch4) |
| `fig-Prestige-scatterplot-educ1` | `04-multivariate_plots.qmd` | 937 | no code-fold | Only change from previous figure is the predictor variable |
| `fig-crime-spm` | `04-multivariate_plots.qmd` | 2001 | no code-fold | Main differences from prior `scatterplotMatrix()` calls described in text |
| `ggally-smooth-fns` | `04-multivariate_plots.qmd` | 2360 | no code-fold | Old-style label (`` ```{r ggally-smooth-fns} ``). Lists GGally smooth fns; functions mentioned in-text |
| `fig-crime-biplot3` | `05-pca-biplot.qmd` | 1098 | no code-fold | Only addition over biplot2 is `choices` argument, described in text |
| `fig-modelplot3` | `07-linear_models-plots.qmd` | 559 | no code-fold | Same code as modelplot2 with minor model/title changes |
| `fig-collin-centering` | `09-collinearity-ridge.qmd` | 852 | no code-fold | Narrative describes the figure; reader unlikely to reproduce it |
| `fig-longley-pca-dim56` | `09-collinearity-ridge.qmd` | 1535 | no code-fold | By this point reader knows how to make such a plot; code adds nothing |

**Note on `ggally-smooth-fns`:** Uses old-style knitr syntax `` ```{r ggally-smooth-fns} ``
rather than `#| label:`. Scanning must search both forms. The chunk is a 2-line exploratory
listing (`ls(getNamespace("GGally")) |> str_subset("^ggally_smooth_")`), not a figure.
The adjacent `my-panel` / `my-panel1` chunks were NOT flagged by Gavin.

**Scanning rule:** to find all chunk labels, search for both:
- `#| label: <name>` (YAML-style, current Quarto convention)
- `` ```{r <name>} `` (old knitr inline style, still valid)

### Scope of Gavin's review

Gavin's file ends with `<!-- I have read up to the start of Chapter 11 -->`.
Chapters 11–15 and 21 have not been audited yet.

### Already folded (skip)

From `master`, the following chunks already have `code-fold: true` and need no changes:
`03-getting_started.qmd` lines 413, 457; `04-multivariate_plots.qmd` lines 185, 679, 758,
1141; `05-pca-biplot.qmd` lines 2060, 2264; `07-linear_models-plots.qmd` lines 190, 1432,
1714, 1818; `08-lin-mod-topics.qmd` lines 224, 329; `09-collinearity-ridge.qmd` line 1419;
`11-mlm-review.qmd` lines 291, 1013, 2269; `12-mlm-viz.qmd` line 216; `13-eqcov.qmd`
lines 164, 205, 298, 327; `14-infl-robust.qmd` lines 344, 489; `21-discrim.qmd` line 772;
`child/04-grand-tour.qmd` lines 154, 205, 275; `child/10-discrim.qmd` line 583.

### Status

- [x] Fetch and parse Gavin's audit file
- [x] Identify chunk labels and their current state in `master`
- [ ] Implement changes (11 chunks across 6 files)
- [ ] Verify Gavin has not already implemented these on `GK-work` branch before editing
- [ ] Audit Chs 11–15 and 21 (Gavin has not reviewed these yet)
