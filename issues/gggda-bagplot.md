# Check bagplot example against gggda outlier-control update

`gggda` has added outlier control for bagplots:

> New `outlier_points` and `outlier_labels` parameters toggle these elements
> of bagplots. Additional text aesthetics are introduced for the latter.

## Where this matters in Vis-MLM

- `04-multivariate_plots.qmd`, @sec-bagplots (~line 1315–1369): the Penguin
  bagplot figure (`fig-peng-bagplot`), built via `geom_bagplot()` /
  `stat_bagplot()` from `r pkg("gggda", cite=TRUE)`.
- `R/geom-bagplot.R`: the fig-code source for that chunk. It currently
  computes outlier labels **manually** — finds the two most extreme points
  per species by Mahalanobis distance (`out <- ... Mahalanobis(...) |>
  ... |> head(n = 2)`) and adds them with a separate `geom_text(data = out,
  aes(label = ID), ...)` layer (lines 44–58).
- `R/geom-bagplot-test.R`, `working-text/bagplot-notes.txt`: related
  exploration, including a linked upstream gggda issue
  (github.com/corybrunson/gggda/issues/13) about getting outlier row IDs.

## To do

1. Check current `gggda` version/changelog for the exact signature of the
   new `outlier_points` / `outlier_labels` params and the new text
   aesthetics for labels.
2. See whether `outlier_labels` (built-in) can replace the manual
   Mahalanobis-distance + `geom_text()` workaround in
   `R/geom-bagplot.R` — would simplify the fig-code and may also resolve
   the open question in `working-text/bagplot-notes.txt` / upstream issue
   #13 about identifying outlier row IDs.
3. If simplified, re-render `fig-peng-bagplot` and update
   `04-multivariate_plots.qmd` fig-code comment / caption if the outlier
   labeling approach changes.
4. Update `bib/Rpackages-4.5.1.bib` gggda version/citation if bumping the
   package version.
