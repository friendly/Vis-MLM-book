# `pvPlot()` migration to `heplots`

`pvPlot()` (partial variables plot, used in @sec-pvPlot / Ch. 4 network diagrams
section) has been ported into the `heplots` package (`C:\R\Projects\heplots\R\pvPlot.R`,
documented, exported, with roxygen examples). The book should stop carrying its own
copy and depend on `heplots::pvPlot()` instead.

**Status:** `heplots` 1.8.3 is now installed in R-4.6.1 and `pvPlot` is confirmed
exported (`exists("pvPlot", where = asNamespace("heplots"))` → `TRUE`, checked
2026-08-11). The steps below are unblocked.

## API check

Compared `R/pvPlot.R` (book copy) against `heplots`'s `R/pvPlot.R` line by line: the
function signature and defaults are **identical** (`X, vars, others, labels, id,
ellipse, ellipse.args, draw, col, pch, cex, axes, regline, show.partial, ...`), so
none of the existing call sites in the book need argument changes — this is a
source-location change only, not an API migration.

One behavioral fix landed in the `heplots` copy but not the book's: `labels` is now
actually wired into `id$labels` (previously computed but silently dropped). Doesn't
affect the book's call sites since none of them pass `labels`.

## Required changes

### 1. `04-multivariate_plots.qmd` (the live copy — §"Visualizing partial correlations", `#sec-pvPlot`, ~line 3541–3606)

- `library(heplots)` is already loaded chapter-wide (`load-pkgs` chunk, line 73), so
  no new `library()` call is needed.
- Line 3572: delete `source("R/pvPlot.R")` from the `fig-crime-pvPlots-code` chunk.
- Line 3563: `<!-- **TODO**: Put `pvPlot` into `heplots` package or `car`. Leave as is for now -->`
  — this TODO is now done; remove the comment (or replace with a note that it now lives
  in `heplots`).
- Line 3557: `` My function `pvPlot()` calculates... `` — reads fine as-is, but consider
  rewording to `` `r func("heplots::pvPlot()")` `` for consistency with how other
  `heplots` functions are referenced elsewhere in the book (e.g. `heplots::Mahalanobis()`,
  `heplots::cqplot()` in this same chapter).

### 2. `child/04-network.qmd` (lines 231–296) — stale orphaned duplicate

This child doc contains an **exact duplicate** of the same "Visualizing partial
correlations" section (including the same `source("R/pvPlot.R")` call), but it is
**not referenced by any `{{< include >}}`** anywhere in the project (checked all
`*.qmd` and `*.yml`) — grep for `04-network` outside this file itself returns nothing.
It looks like the section was copied inline into `04-multivariate_plots.qmd` at some
point and the child file was never removed, the same situation `issues/TODOs.md`
already recorded for `child/10-discrim.qmd` ("deleted — superseded by `21-discrim.qmd`;
remove from any remaining references").

Recommend the same treatment: delete `child/04-network.qmd`, or at minimum apply the
same `source("R/pvPlot.R")` → `heplots::pvPlot()` fix to it if it's being kept around
for reference.

### 3. `30-Rcode.qmd` (Rcode appendix, line 112)

Utilities list includes:
```
- [pvPlot.R](https://github.com/friendly/vis-MLM-book/blob/master/R/pvPlot.R) &mdash; Partial variables plots to visualize partial correlation
```
Remove this line once `R/pvPlot.R` is removed from the book repo (see §5) — the
function is documented in `heplots`'s own reference index instead.

### 4. `07-linear_models-plots.qmd` (line 746) — no change needed

`the partial variables plot (@sec-pvPlot)` — just a cross-reference to the section
anchor; unaffected as long as `{#sec-pvPlot}` stays on the section heading in
`04-multivariate_plots.qmd`.

### 5. Book-repo file cleanup (once §1 is rendered and verified)

- `R/pvPlot.R` — delete. Superseded by `C:\R\Projects\heplots\R\pvPlot.R`.
- `test/pvPlot-test.R` — delete or archive. It's an exploratory test script
  (`source("R/pvPlot.R")`) whose content has already migrated to
  `C:\R\Projects\heplots\dev\pvPlot-test.R`, so it's now a duplicate rather than a
  reference to update.
- `R/crime/crime-pvPlots.R` — update `source(here::here("R", "pvPlot.R"))` (line 3) to
  `library(heplots)` if this script is still used to regenerate
  `images/crime-pvPlot-1-2.png`. Not urgent: no functional change since the API is
  identical, and the current PNG in `images/` doesn't need to be regenerated on this
  account alone.

### 6. `issues/TODOs.md` (line 164)

```
| 265 | hidden | Move `pvPlot()` function into `heplots` or `car` package |
```
This TODO (under `### child/04-network.qmd`) is now done — mark resolved, and drop or
update the `child/04-network.qmd` subsection per §2 above.

### 7. Not affected / no action

- `issues/solved/task-june-submit.md` line 140 — `` `pvPlot()` / `dataEllipse` PR to **car** ``
  is about a separate, still-open item (a `car::dataEllipse()` internal cex-collision
  bug). Per the usage note now at the top of `heplots`'s `R/pvPlot.R`, that bug is only
  reachable via `dataEllipse`'s `ellipse.label` argument, which `pvPlot()` never passes
  — so it doesn't block anything here, but the upstream `car` PR is still worth pursuing
  separately (tracked at https://github.com/bprice2652/car_repo/issues/1, unresolved as
  of 2026-08-10).
- `issues/missing-func-scan.md`, `issues/abstract-notes.md`, `issues/CMYK-checklist.md`,
  `issues/cmyk-image-audit-results.csv` — only mention `pvPlot` descriptively (scan
  output, blog-topic notes, image-audit rows); nothing to change.

## Suggested order of operations

1. ~~Install `heplots` ≥ 1.8.3 into R-4.6.1; verify `heplots::pvPlot` is exported.~~ **Done 2026-08-11.**
2. Edit `04-multivariate_plots.qmd` (§1) and re-render Ch. 4 to confirm
   `@fig-crime-pvPlots-code` still runs cleanly with `source()` removed.
3. Resolve `child/04-network.qmd` (§2) — delete or fix, matching the `child/10-discrim.qmd`
   precedent.
4. Remove the `pvPlot.R` line from `30-Rcode.qmd` (§3).
5. Delete `R/pvPlot.R` and `test/pvPlot-test.R`; update `R/crime/crime-pvPlots.R` (§5).
6. Mark the TODO resolved in `issues/TODOs.md` (§6).
