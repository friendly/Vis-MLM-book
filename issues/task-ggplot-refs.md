# Task: ggplot vs. ggplot2 Reference Consistency

Audit of `ggplot` / `ggplot2` usage across all `.qmd` files.
Searched for: bare `` `ggplot` `` (missing the 2), plain `` `ggplot2` `` backticks,
and `**ggplot2**` bold — compared against the correct `r pkg("ggplot2")` form.

---

## Group 1 — `ggplot` instead of `ggplot2` (FIXED)

Four places where the package name was simply wrong.

| File | Line | Was | Fixed to |
|------|------|-----|----------|
| `03-getting_started.qmd` | 325 | `` `ggplot` `` | `` `ggplot2` `` |
| `03-getting_started.qmd` | 512 | `` `ggplot` `` | `` `ggplot2` `` |
| `04-multivariate_plots.qmd` | 870 | `` `ggplot` `` | `` `ggplot2` `` |
| `index.qmd` | 236 | `` `ggplot` `` | `` `ggplot2` `` |

---

## Group 2 — `` `ggplot2` `` in plain backticks (deferred)

Approximately 25 occurrences where prose uses `` `ggplot2` `` rather than
`` `r pkg("ggplot2")` ``. These are likely acceptable as subsequent-mention
shorthand after the first `pkg()` citation in each chapter, but are inconsistent
across chapters. Deferred for a later pass.

| File | Lines |
|------|-------|
| `04-multivariate_plots.qmd` | 364, 464, 1117, 1135, 1196, 1227, 1272, 1328, 1435, 1717, 1878, 2521 |
| `05-pca-biplot.qmd` | 824, 1024, 1032 |
| `07-linear_models-plots.qmd` | 291, 1120, 1384 |
| `08-lin-mod-topics.qmd` | 473 |
| `10-hotelling.qmd` | 493 |
| `11-mlm-review.qmd` | 1006, 1433, 1437, 1894 |
| `15-case-studies.qmd` | 110, 199 |
| `21-discrim.qmd` | 550, 553 |

---

## Group 3 — `**ggplot2**` bold without `pkg()` (FIXED)

Two places using raw bold rather than backtick formatting. Changed to
`` `ggplot2` `` to match the group 2 convention for non-first mentions.

| File | Line | Was | Fixed to |
|------|------|-----|----------|
| `04-multivariate_plots.qmd` | 249 | `**ggplot2**` | `` `ggplot2` `` |
| `summary/Ch08-summary.qmd` | 26 | `**ggplot2**` | `` `ggplot2` `` |

---

## Group 4 — `package()` vs `pkg()` (not an inconsistency)

`package()` and `pkg()` are semantically different: `package("ggplot2")` typesets
the name followed by the word "package" (e.g. "the ggplot2 package"), while
`pkg("ggplot2")` gives the name alone. Both are intentional; no fix needed.
