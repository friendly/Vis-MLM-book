# In-text TODOs

Compiled from all chapter `.qmd` and `child/` files.
**Visible** = appears in rendered output (urgent to fix or remove).
**Hidden** = inside `<!-- -->` comment (not rendered, but still active).

Struck-through items (~~...~~) in the source have been omitted as already done.

---

## Preface (`index.qmd`)

| Line | Status | Note |
|------|--------|------|
| 20 | hidden | Make preface a more general introduction |
| 86 | hidden | Complete the "required background" section |
| 178 | hidden | Add more on general books about graphics |

---


## Ch 04 — Multivariate Plots (`04-multivariate_plots.qmd`)

| Line | Status | Note |
|------|--------|------|
| 1435 | hidden | Panel tabset looks fine in HTML but is awkward in PDF — decide how to handle |
| 1524 | hidden | Decide how to handle the other plots in the PDF version of this section |
| 1553 | hidden | Add material on 3D scatterplots; start is in `child/03-3D-scat.qmd` and `R/penguin/peng-3D-rgl.R` |
| 2025 | hidden | Consider splitting the chapter at the Corrgrams section |
| 2495 | hidden | Revise the History section of Wikipedia's Parallel coordinates article |

---

## Ch 05 — PCA & Biplots (`05-pca-biplot.qmd`)

| Line | Status | Note |
|------|--------|------|
| 46 | hidden | Mention the `gellipsoid` package |
| 132  | hidden  | 3D plots should be introduced earlier, in Ch 3, before @sec-scatmat |
| 815 | hidden | Should the `rownames` callout be `callout-warning` or a footnote? |
| 1006 | ~~done~~ | Explain the biplot scaling parameter α (0, ½, 1) better |
| 1856 | hidden | Make a diagram illustrating vector angle interpretation |
| 1958 | hidden | Web links like this should be footnotes for PDF |
| 1971 | hidden | Show necessary parts of the MonaLisa example including screeplot |

---

## Ch 06 — Linear Models (`06-linear_models.qmd`)

| Line | Status | Note |
|------|--------|------|
| 35 | hidden | The model overview should be a table (not currently working) |
| 487 | hidden | Move contrasts material from Ch 10 (§10.3.1) to here |
| 800 | hidden | Make a figure for the two interaction examples |
| 915 | hidden | Move initial ANCOVA discussion from @sec-ANCOVA-MANCOVA here with generic example |

---

## Ch 07 — Linear Model Plots (`07-linear_models-plots.qmd`)

| Line | Status | Note |
|------|--------|------|
| 310 | hidden | Prestige example already introduced in @exm-prestige — pair down and integrate |
| 1789 | ~~done~~ | Fix up the code displayed here; source is `R/Duncan/Duncan-reg.R` → `R/Duncan/duncan-av-influence.R` |

---

## Ch 08 — Linear Model Topics (`08-lin-mod-topics.qmd`)

| Line | Status | Note |
|------|--------|------|
| 323 | hidden | Consider including this code only in the HTML version (conditional block) |

---

## Ch 09 — Collinearity & Ridge (`09-collinearity-ridge.qmd`)

| Line | Status | Note |
|------|--------|------|
| 373 | ~~visible~~ done | Complete footnote thought about VIF and added-variable plots |
| 1583 | ~~visible~~ done | Consider replacing the "What have we learned?" prose with bullet-point take-aways |
| 405 | hidden | Use `performance::check_collinearity()` and its `plot()` method for the Cars example |
| 1408 | hidden | Redo precision figure using `plot.precision()` method |

---

## Ch 10 — Hotelling (`10-hotelling.qmd`)

No active visible TODOs. One commented item (combining with a summary file) appears struck-through/done.

---

## Ch 11 — MLM Review (`11-mlm-review.qmd`)

| Line | Status | Note |
|------|--------|------|
| 46 | hidden | Offer defense against @Huang2019; cite @Huberty-Morris1989 — or maybe not |
| 72 | hidden | Use `\Epsilon` macro for residuals throughout |
| 115 | ~~visible~~ hidden | Revise notation: be explicit and consistent about inclusion of β₀ and size of **B** |
| 719 | hidden | Contrasts material was copied to @sec-contrasts — delete the duplicate here |
| 760 | hidden | Use ½ for contrast so that L₁ is the mean difference |
| 1381 | hidden | Move initial part of Plastic film 2×2 example (@exm-plastic2) here |
| 1720 | hidden | Using `log2(income)` gives less dramatic HE plots in Ch 11 — consider `income` instead |
| 2115 | ~~visible~~ hidden | Sort out coverage overlap here vs. @sec-influence-robust — done: forward ref added |
| 2194 | ~~visible~~ hidden | Consider moving MANCOVA section to @sec-vis-mlm — deferred/ignored |
| 2373 | hidden | For interpretation, know how many items per PA task — ignored: item counts unavailable |
| 2400 | hidden | Do this with a CI for the effects — deferred: make an exercise |

---

## Ch 12 — MLM Visualization (`12-mlm-viz.qmd`)

| Line | Status | Note |
|------|--------|------|
| 762 | hidden | `var.labels` is not a graphical parameter — fix |
| 1077 | ~~visible~~ hidden | Use `heplots::Hernior` (herniorrhaphy) as an exercise — deferred |
| 1408 | ~~visible~~ hidden | Check signs of structure coefficients from `cancor()`; reflect vectors for `Ycan1` — deferred |
| 1576 | ~~done~~ | Insert chapter summary (section header exists but is empty) |
| 1311 | hidden | Fill in details of canonical correlations |

---

## Ch 13 — Equality of Covariance (`13-eqcov.qmd`)

No TODOs found.

---

## Ch 14 — Influence & Robust (`14-infl-robust.qmd`)

| Line | Status | Note |
|------|--------|------|
| 282 | ~~visible~~ hidden | Check how studentized residuals are defined in `mvinfluence` — deferred |
| 643 | ~~done~~ | Add "What have we learned?" chapter summary |

---

## Ch 15 — Case Studies (`15-case-studies.qmd`)

No TODOs found.

---

## Ch 15 — Discriminant Analysis (`21-discrim.qmd`) — **in print PDF**

| Line | Status | Note |
|------|--------|------|
| 361 | **visible** | Re-write below to use `scores.lda()` / `cor_lda()` — but `predict_discrim()` already used at line 371; may just need narrowing or removal |
| 747 | hidden | `posterior` now defaults to `FALSE` in `predict()` — update code accordingly |
| 770 | hidden | Flip sign of LD1 in the plot |
| 1057 | hidden | Mention recursive partition methods as another topic |
| 187 | hidden | Add History Corner on development of LDA: Fisher (1936) → Rao (1948) → Bayesian |

`child/10-discrim.qmd` — **deleted** (superseded by `21-discrim.qmd`; remove from any remaining references)

---

## Child documents

### `child/04-network.qmd`

| Line | Status | Note |
|------|--------|------|
| 265 | hidden | Move `pvPlot()` function into `heplots` or `car` package |
| 263 | hidden | Two figures side-by-side — `car::scatterplot()` may not allow `layout-ncol` |

### `child/04-grand-tour.qmd`

| Line | Status | Note |
|------|--------|------|
| 572 | hidden | Clean up package references (some are links rather than `citation()`) |

### `child/10-discrim.qmd`

| Line | Status | Note |
|------|--------|------|
| 218 | **visible** | Move `predict_discrim()` helper to `candisc` package |

---

## Summary counts

| | Visible | Hidden | Total |
|-|---------|--------|-------|
| index.qmd | 1 | 3 | 4 |
| Ch 03 | 2 | 0 | 2 |
| Ch 04 | 5 | 1 | 6 |
| Ch 05 | 2 | 5 | 7 |
| Ch 06 | 1 | 3 | 4 |
| Ch 07 | 1 | 1 | 2 |
| Ch 08 | 1 | 0 | 1 |
| Ch 09 | 0 | 2 | 2 |
| Ch 11 | 0 | 11 | 11 |
| Ch 12 | 0 | 4 | 4 |
| Ch 14 | 0 | 1 | 1 |
| Ch 15 (21-discrim) | 1 | 4 | 5 |
| child/ | 0 | 2 | 2 |
| **Total** | **18** | **33** | **51** |
