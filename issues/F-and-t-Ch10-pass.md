# F and t italicization pass — Chapter 10 (10-hotelling.qmd)

**Date:** 2026-05-24  
**Reviewer:** GK

## Summary

Checked all prose instances of $F$ and $t$ as test statistics for proper math-mode italicization.
The chapter is **well-formatted**: every instance is already wrapped in `$...$`.

## Instances checked

| Line | Usage | Status |
|------|-------|--------|
| 14, 52, 57, 208, 223, 485, 646 | `$t$-test(s)` | ✓ |
| 54, 60, 148 | `$t$ statistic` | ✓ |
| 120, 128, 149, 375 | `$t^2$` / `$t^2(\mathbf{a})$` | ✓ |
| 156 | `$t$ test` (in footnote) | ✓ |
| 148–151 | `$F (1, N-1)$`, `$F$ test` | ✓ |
| 630, 639 | `$F$-statistic`, `$F$-statistics` | ✓ |
| 646, 651 | `$F = t^2$`, `$F$ statistics` | ✓ |
| 661–664 | `$F_{(1,198)}$`, `$F_{(6,193)}$`, `$F$s` | ✓ |
| 750 | `$F$ statistic` | ✓ |

## Minor issue noted (not F or t)

**Line 112** — `fig-cap` for `fig-T2-diagram` has `Hotelling's T^2 statistic` as a plain string.
Since Quarto processes `#|` figure captions as Markdown, this should be `$T^2$`:

```
#| fig-cap: "Hotelling's $T^2$ statistic as the squared distance..."
```

[GK: FIXED]
