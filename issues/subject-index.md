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
