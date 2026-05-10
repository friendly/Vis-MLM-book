# Bare `pkg::func()` References — Conversion Tracker

Bare backtick references of the form `` `pkg::func()` `` should be converted to
`` `r func("pkg::func()")` `` so that index entries are generated automatically.

**Completed:** `04-multivariate_plots.qmd` — all prose occurrences converted 2026-05-10.
All other chapter/child files — converted 2026-05-10. See per-file tables below for skipped entries.

**Note on `fig-cap:` lines:** Inline R does not execute inside `#| fig-cap:` chunk options.
These entries are flagged below and should be left as plain backtick code.

---

## `04-multivariate_plots.qmd`

Intentionally skipped (`fig-cap:`):

| Line | Reference |
|------|-----------|
| 1919 | `` `car::scatterplotMatrix()` `` |
| 1943 | `` `car::scatterplotMatrix()` `` |

---

## `04b-higher.qmd`

| Line | Reference | Note |
|------|-----------|------|
| 114 | `` `MASS::parcoord()` ``, `` `GGally::ggparcoord()` ``, `` `PairViz::pcp()` `` | three on one line |

---

## `05-pca-biplot.qmd`

| Line | Reference | Note |
|------|-----------|------|
| 503 | `` `heplots::ellipse.axes()` `` | prose |
| 1991 | `` `imager::load.image()` `` | prose |

---

## `07-linear_models-plots.qmd`

| Line | Reference | Note |
|------|-----------|------|
| 299 | `` `performance::check_model()` `` | **fig-cap:** — skip |

---

## `10-hotelling.qmd`

| Line | Reference | Note |
|------|-----------|------|
| 222 | `` `broom::tidy.mlm()` `` | prose |
| 647 | `` `broom::tidy.mlm()` `` | prose |

---

## `11-mlm-review.qmd`

| Line | Reference | Note |
|------|-----------|------|
| 1091 | `` `stats::summary.aov()` `` | prose |
| 1780 | `` `heplots::coefplot.mlm()` `` | prose |

---

## `14-infl-robust.qmd`

| Line | Reference | Note |
|------|-----------|------|
| 248 | `` `stats::cooks.distance.lm()` `` | prose |
| 249 | `` `mvinfluence::cooks.distance.mlm()` `` | prose |
| 285 | `` `mvinfluence::influencePlot.mlm()` `` | prose |
| 547 | `` `MASS::psi.bisquare()` `` | prose |

---

## `21-discrim.qmd`

| Line | Reference | Note |
|------|-----------|------|
| 286 | `` `MASS::predict.lda()` `` | prose |

---

## `child/04-grand-tour.qmd`

| Line | Reference | Note |
|------|-----------|------|
| 254 | `` `matlib::len()` `` | prose |

---

## `child/04-network.qmd`

| Line | Reference | Note |
|------|-----------|------|
| 258 | `` `car::dataEllipse()` `` | prose |
| 263 | `` `car::scatterplot()` `` | inside `<!-- comment -->` — skip |

---

## `child/10-discrim.qmd`

| Line | Reference | Note |
|------|-----------|------|
| 159 | `` `MASS::predict.lda()` `` | prose |

---

## Excluded from conversion

- `index.qmd` lines 277/322 — explaining the `pkg::func()` notation convention, not actual references
- `blogs/` and `test/` — not book chapter content
- All `#| fig-cap:` lines — inline R does not execute there
- `child/04-network.qmd:263` — inside an HTML comment
