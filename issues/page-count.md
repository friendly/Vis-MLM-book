# Page Count Comparison

**Goal:** Track how many pages each chapter occupies across builds, to monitor growth
and plan submission length.

## Files being compared

| Version | PDF | TOC source | Date |
|---------|-----|------------|------|
| Previous | `pdf/Vis-MLM.pdf` | `Vis-MLM.toc` (project root) | May 4 / May 12 2026 |
| Current  | `docs/Vis-MLM.pdf` | `index.toc` (project root)   | May 16 2026 |

Note: the current build still includes Appendices A, B, C (R code appendices that will
be dropped once separate HTML / PDF builds are in place). See `task-r-code.md`.

## Approach

Use `pdftools::pdf_toc()` to read the embedded PDF bookmark outline — simpler than
parsing `.toc` files because it works directly from the PDF and does not require a
LaTeX build artifact. `pdftools::pdf_info()$pages` gives the total page count.

See `issues/toc-compare.R` for the script.

**Caveat on page numbers:** `pdf_toc()` returns *physical* PDF page numbers (1-based
from the first page of the PDF file), not the printed book page numbers. For computing
*pages per chapter* this does not matter — the differences are the same. The printed
book number for the first arabic-numbered page (Ch 1, p. 3) tells you the physical
offset: `physical_page = printed_page + front_matter_pages - 1`.

**Bookmark depth:** For a `krantz`-class book the PDF outline is typically structured as
Parts → Chapters. Call `pdf_toc()` and inspect the result to confirm depth before
running the full comparison. With Parts at depth 1, chapters are at depth 2.

## Comparison table (from .toc files)

Pages per chapter computed by differencing consecutive start pages. Last entry per
version needs `pdf_info()$pages` to close the interval; shown as `?` below.

```
Chapter                                          p_prev n_prev  p_curr n_curr  diff
---------------------------------------------------------------------------
Preface                                          xiii   —        xv    —       +2 (front matter)
Author / front matter                               1   —         1    —
---  Part I  ---
 1  Warm-up Exercises                               3   10        3    10       0
 2  Introduction                                   13    8       13     8       0
 3  Getting Started                                21   20       21    20       0
---  Part II  ---
 4  Plots of Multivariate Data                     41   76       41    78      +2
 5  Dimension Reduction                           117   60      119    60       0
---  Part III  ---
 6  Overview of Linear models                     177   18      179    18       0
 7  Plots for Univariate Response Models          195   46      197    46       0
 8  Topics in Linear Models                       241   14      243    14       0
 9  Collinearity & Ridge Regression               255   40      257    40       0
---  Part IV  ---
10  Hotelling's T²                                295   20      297    22      +2
11  Multivariate Linear Models                    315   58      319    58       0
12  Visualizing Multivariate Models               373   40      377    40       0
13  Visualizing Equality of Covariance Matrices   413   20      417    20       0
14  Multivariate Influence and Robust Estimation  433   16      437    16       0
15  Discriminant analysis                         449   28      453    28       0
---  Part V / End matter  ---
    Colophon                                      477    4      481     4       0
    References                                    481   14      485    16      +2
---  Appendices (to be removed from PDF)  ---
  A  Case Studies                                 495   18      501    18       0
  B  R Code for Figures and Analyses              513    4      519     2      -2
  C  R Code for Figures and Analyses              —     —       521     4     new
---  Back matter  ---
    Subject Index                                 517    5      525     6      +1
    Author Index                                  522    ?      531     ?
```

**Net change in numbered chapters (1–15):** +4 pages (Ch 4 +2, Ch 10 +2).  
**References:** +2 pages.  
**Front matter:** +2 pages (Preface grew from p. xiii to p. xv).

Total growth (excluding appendices) ≈ +8 pages before closing the Author Index interval.

## Outstanding

- Run `issues/toc-compare.R` to get `pdf_info()$pages` for both PDFs and fill in the
  Author Index length and true totals.
- Once clean PDF builds (no appendices) are available, rerun and record the baseline.
