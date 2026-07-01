# Subject Index: Review and Improvement

## Current state

Manual `\ix{}` / `\ixon{}` / `\ixoff{}` entries are sparse and uneven.
Auto-generated entries (packages via `\ixp{}`, datasets via `\ixd{}`, functions via
`\ixfunc{}{}`) are handled separately and not the concern here.

### Entry counts by chapter (manual `\ix{}` only)

| Chapter | `\ix{}` calls |
|---------|--------------|
| Ch 01 Prelude | 1 |
| Ch 02 Introduction | 6 |
| Ch 03 Getting Started | 31 |
| Ch 04 Multivariate Plots | 29 |
| Ch 05 PCA & Biplots | 13 |
| Ch 06 Linear Models | 11 |
| Ch 07 LM Plots | 9 |
| Ch 08 LM Topics | 2 |
| Ch 09 Collinearity & Ridge | 23 |
| Ch 10 Hotelling T² | 1 |
| Ch 11 MLM Review | 17 |
| Ch 12 MLM Visualization | 4 |
| Ch 13 Equality of Covariances | 1 |
| Ch 14 Influence & Robust | 1 |
| Ch 15/21 Discriminant Analysis | 1 |

Chapters 10, 12–15, and 21 are essentially unindexed for conceptual content.
Ch 03 and Ch 09 are the best-covered; Ch 04 has good coverage for visualization terms.

### Macros available

- `\ix{term}` — simple entry (current page)
- `\ix{main term!sub term}` — hierarchical entry
- `\ixmain{term}` — bold page number (principal reference)
- `\ixon{term}` / `\ixoff{term}` — page range (open/close)

---

## What belongs in a manual subject index

A professional indexer would target:

- **Statistical concepts**: data ellipse, Mahalanobis distance, eigenvalue, singular
  value decomposition, hypothesis matrix, error matrix, effect size, ...
- **Visualization displays**: biplot, scatterplot matrix, corrgram, parallel coordinate
  plot, HE plot, added-variable plot, ridge trace, influence plot, ...
- **Statistical methods/tests**: principal components analysis, canonical correlation,
  discriminant analysis, Box M test, Pillai trace, Wilks' lambda, Hotelling T², MANOVA,
  MANCOVA, ridge regression, LASSO, ...
- **Named concepts and principles**: Anscombe's quartet, Mahalanobis distance, data
  space, parameter space, visual thinning, grand tour, ...
- **Key datasets** (if not already covered by `\ixd{}`): Iris, Penguins, Prestige, ...
- **Book-specific vocabulary**: HE framework, hypothesis-error plot, ...

Terms that appear in *multiple* chapters are especially important: a reader looking up
"data ellipse" should find all significant discussions, not just the first mention.

---

## Approaches

### A. Review the compiled PDF index directly (start here)

Open `docs/Vis-MLM.pdf` or `pdf/Vis-MLM.pdf` and page through the subject index.
Look for:
1. **Important terms that are absent entirely** — concepts central to the book that have
   no entry at all.
2. **Under-indexed terms** — entries with only one page reference where there should be
   many (e.g., "data ellipse" should appear in nearly every chapter).
3. **Missing sub-entries** — a top-level entry like "PCA" with no sub-entries when the
   chapter covers scree plots, biplots, loadings, scores separately.
4. **Inconsistent naming** — same concept indexed under two different terms
   (e.g., "scatterplot matrix" vs. "scatter plot matrix").

This gives a quick qualitative feel for what's missing before doing any text scanning.

### B. Chapter-by-chapter term extraction (most thorough)

For each chapter, read the section headings and key paragraphs and draft a list of
index-worthy terms. Then check which are already indexed and add `\ix{}` calls for the
rest.

Claude can assist: given a chapter file, it can propose `\ix{}` calls with approximate
line numbers, which you then accept/reject. A chapter takes ~15–30 minutes this way.

Priority order (least-indexed first): Chs 10, 13, 14, 21, 12, 08.

### C. Section-heading audit

Every `##` and `###` heading is a candidate for an index entry. Extract all headings
across chapters and compare against the current `.ind` file to find conceptual gaps
quickly. This catches the most prominent terms without reading body text.

```r
# Quick heading extraction
qmd_files <- list.files(".", pattern = "^[0-9].*\\.qmd$")
headings <- lapply(qmd_files, function(f) {
  lines <- readLines(f, warn = FALSE)
  grep("^#{1,3} ", lines, value = TRUE)
})
cat(unlist(headings), sep = "\n")
```

### D. Key-term concordance

Identify a list of ~50–100 important terms for this book (statistical methods,
visualization types, key concepts) and grep for them across all chapters. Where a term
appears substantively but has no `\ix{}` call nearby, that's a gap.

A starter list would include: data ellipse, Mahalanobis distance, biplot, HE plot,
grand tour, Pillai trace, Wilks lambda, MANOVA, canonical correlation, ridge regression,
influential observation, leverage, Cook's distance, collinearity, VIF, scatterplot
matrix, parallel coordinates, corrgram, ...

### E. Cross-check against a similar book's index

The index in a comparable multivariate statistics/visualization book (e.g., Johnson &
Wichern, Friendly & Meyer DDAR) can suggest terms that belong in any book of this kind.
Use it as a checklist rather than copying verbatim.

---

## Recommended workflow

1. **First**: Skim the compiled PDF index (Approach A) to get a feel for the gaps and
   identify the most glaring omissions. Note 10–20 terms that should be there but aren't.

2. **Then**: Do a chapter-by-chapter pass (Approach B) for the weakest chapters (10,
   13, 14, 21, 12), using Claude to draft `\ix{}` proposals.

3. **Finally**: After adding entries, rebuild the PDF and re-read the index to check
   for inconsistent naming and missing cross-references (e.g., `see also` entries).

---

## Notes on style

- Use **sentence case** for index entries (consistent with section headings): "data
  ellipse" not "Data Ellipse".
- Prefer the **reader's term** over the author's shorthand: "principal components
  analysis" not "PCA" (or index both with a `see` cross-reference).
- Use `\ixon{}`/`\ixoff{}` for extended discussions spanning multiple pages; use
  `\ix{}` for a single page or paragraph reference.
- Use `\ixmain{}` for the primary defining occurrence of a term.
- Sub-entries (`!` in makeindex) are worth adding for terms with many references:
  `\ix{smoother!loess}`, `\ix{smoother!spline}` etc.

---

## Work log

### Ch 10 — Hotelling's T² (2026-06-30)

Added 30 new entries; chapter went from 1 `\ix{}` call to 39 total entries.

Existing `\ixon{}`/`\ixoff{}` ranges (already in place):
- `Hotelling $T^2$` (full chapter intro through T² properties)
- `HE plot` (§10.3)
- `discriminant analysis` (§10.4)
- `biplot` (§10.5.1)
- `$\eta^2$` (single `\ix{}`, §10.6)

New entries added by section:

| Section | Entries added |
|---------|--------------|
| §10.1 T² as generalized t-test | `variance-covariance matrix`, `Mahalanobis distance` (`\ixmain`) |
| §10.2 T² properties | `linear combination`, `eigenvalue`, `Wilks lambda`, `Pillai trace`, `Roy maximum root test`, `eigenvector`, `discriminant analysis!coefficients`, `exact test`, `invariance!linear transformation`, `pooled covariance matrix` |
| §10.2.1 Mathscore example | `data ellipse`, `discriminant analysis!axis` |
| §10.3 HE plot | `hypothesis matrix`, `sum of squares and products`, `error matrix`, `visual test of significance` |
| §10.4 Discriminant analysis | `prior probabilities`, `discriminant analysis!linear`, `discriminant analysis!scores`, `violin plot` |
| §10.5 Banknote / testing | `multivariate test statistics`, `Pillai trace` (2nd), `Wilks lambda` (2nd) |
| §10.6 Variance accounted for | `coefficient of determination`, `effect size`, `canonical discriminant analysis` |
| §10.7 Grand scheme | `HE framework`, `canonical space` |

Four discriminant-related sub-entries (`!coefficients`, `!axis`, `!linear`, `!scores`) roll up under "discriminant analysis" in the index.

Several entries here (`Mahalanobis distance`, `data ellipse`, `eigenvalue`, `discriminant axis`, `Pillai trace`, `Wilks lambda`, `pooled covariance matrix`) appear in multiple chapters — adding them to remaining chapters will build up multi-page index entries for these key terms.

**Next chapters to index** (priority order): Ch 13, Ch 14, Ch 08.

---

### Ch 12 — Visualizing Multivariate Models (2026-06-30)

Added 33 new entries (plus 1 upgrade); chapter went from 5 to 38 total entries.

Existing entries (carried forward):
- `\ix{HE plot}` at intro bullet → **upgraded to `\ixmain{HE plot}`** (Ch 12 is the principal reference)
- `\ix{contrasts}`, `\ix{canonical discriminant analysis}` (intro bullets)
- `\ixd{dogfood}`, `\ix{quartets!dogfood}` (auto/manual)

New `\ixon{}`/`\ixoff{}` ranges added:

| Range | Section |
|-------|---------|
| `significance scaling` | §12.4 Significance scaling vs. effect scaling |
| `canonical discriminant analysis` | §12.7 Low-D views: Canonical analysis |
| `factorial MANOVA` | §12.8 Factorial MANOVA |
| `multivariate multiple regression` | §12.9 Quantitative predictors: MMRA |
| `canonical correlation analysis` | §12.10 Canonical correlation analysis |
| `MANCOVA` | §12.11 MANCOVA models |

New single entries by section:

| Section | Entries added |
|---------|--------------|
| §12.1 HE plot framework | `data space`, `canonical space`, `sum of squares and products` |
| §12.2 HE plot construction | `effect size scaling`, `significance scaling` (first mention) |
| §12.4 Significance scaling | `visual test of significance`, `Roy maximum root test` |
| §12.5 Contrasts | `linear hypothesis`, `orthogonal contrasts`, `conjugate axes` |
| §12.6 HE plot matrices | `HE plot!matrix` |
| §12.7 Canonical analysis | `Wilks lambda`, `canonical correlation`, `canonical structure coefficients`, `canonical scores` |
| §12.8 Factorial MANOVA | `MANOVA!factorial`, `interaction` |
| §12.9 MMRA | `joint linear hypothesis` |
| §12.10 CCA | `canonical variates`, `eigenvalue!generalized` |
| §12.11 MANCOVA | `homogeneity of regression`, `heterogeneous regression` |

Sub-entries: `HE plot!matrix`, `MANOVA!factorial`, `eigenvalue!generalized`.

Terms shared with Ch 10 (building multi-page entries): `sum of squares and products`, `visual test of significance`, `Roy maximum root test`, `Wilks lambda`, `canonical discriminant analysis`, `canonical space`, `effect size scaling`.

**Next chapters to index** (priority order): Ch 13, Ch 14, Ch 08.

---

### Ch 13 — Equality of Covariance Matrices (2026-06-30)

Added 23 new entries; chapter went from 1 conceptual `\ix{}` call (dataset only) to 34 total entries.

Existing entries (carried forward):
- `\ixon{peng data}` / `\ixoff{peng data}`, `\ixon{datasets!peng}` / `\ixoff{datasets!peng}` — dataset ranges

New `\ixmain{}` entries:
- `\ixmain{covariance matrices!equality}` — at formal definition (§13.3)
- `\ixmain{Box's M test}` — at §Box's M section heading

New `\ixon{}`/`\ixoff{}` ranges:

| Range | Section |
|-------|---------|
| `covariance matrices!equality` | whole chapter |
| `covariance matrices!heterogeneity` | whole chapter |
| `Box's M test` | §Box M through §other measures |
| `Levene's test` | §13.1 univariate through §visualizing Levene |
| `Levene's test!multivariate` | §13.7 multivariate Levene analog |
| `canonical discriminant analysis` | §13.7.1 candisc subsection |

New single entries by section:

| Section | Entries added |
|---------|--------------|
| §intro | `discriminant analysis!quadratic` (LDA vs QDA choice) |
| §13.1 Homogeneity of variance | `homogeneity of variance`, `Brown-Forsythe test` |
| §13.3 MANOVA setting | `data ellipse`, `centered ellipses`, `pooled covariance matrix` |
| §Box M section | `likelihood-ratio test`, `log determinant` |
| §13.5 Low-rank views | `principal components` |
| §13.6 Other measures | `generalized variance`, `precision matrix`, `eigenvalue!maximum` |
| §13.7 Multivariate Levene | `MANOVA`, `HE plot` |
| §13.7.1 Canonical DA | `canonical structure coefficients` |

Sub-entries: `covariance matrices!equality`, `covariance matrices!heterogeneity`, `discriminant analysis!quadratic`, `Levene's test!multivariate`, `eigenvalue!maximum`.

Terms shared with Ch 10/12 (building multi-page entries): `data ellipse`, `pooled covariance matrix`, `canonical discriminant analysis`, `HE plot`, `MANOVA`, `eigenvalue!maximum`.

**Next chapters to index** (priority order): Ch 14, Ch 08.

---

### Ch 14 — Multivariate Influence and Robust Estimation (2026-07-01)

Added 18 new entries; chapter went from 3 entries (robust estimation range + M-estimators) to 21 total.

Existing entries (carried forward):
- `\ixon{robust estimation}` / `\ixoff{robust estimation}` — already present
- `\ix{M-estimators}` — already present

New `\ixmain{}` entries:
- `\ixmain{influential observations}` — at §multivariate influence section heading
- `\ixmain{Cook's distance!multivariate}` — at multivariate extension definition

New `\ixon{}`/`\ixoff{}` ranges:

| Range | Section |
|-------|---------|
| `influential observations` | §14.1–§14.4 (whole influence section) |
| `Cook's distance` | §14.1.3 Cook's distance through toy example |

New single entries by section:

| Section | Entries added |
|---------|--------------|
| §intro | `outliers` |
| §14.1 Multivariate influence | `case deletion` |
| §14.1.2 Hat values | `hat matrix`, `leverage` |
| §14.1.3 Cook's distance | `Cook's distance`, `Cook's distance!multivariate` (ixmain) |
| §14.1.4 Leverage/residual | `studentized residuals` |
| §14.2 Toy example | `influence plot` |
| §14.2.2 DFBETAS | `DFBETAS` |
| §robust estimation | `weighted least squares`, `robust estimation!S-estimator`, `robust estimation!MM-estimator`, `biweight function`, `iteratively reweighted least squares` |

Sub-entries: `Cook's distance!multivariate`, `robust estimation!S-estimator`, `robust estimation!MM-estimator`.

Terms shared with other chapters (building multi-page entries): `outliers`, `leverage`, `studentized residuals`, `Cook's distance`.

**Next chapters to index** (priority order): Ch 08.
