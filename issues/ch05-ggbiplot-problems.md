# Ch05 ggbiplot regressions

Problems in `05-pca-biplot.qmd` figures noticed after installing the updated `ggbiplot`
(0.6.5, which now draws variable-vector arrows via `ggarrow::geom_arrow_segment()` instead of
`grid::arrow()` — see the package's own `TASKS-all.md` entry for that migration). Started
2026-09-05.

Notes: 

- The file `pdf/Vis-MLM.pdf` can be used as a reference for the previous state of these figures.
- A lot of other packages have changed since I last compiled the book
- Figs 5.13 - 5.15, using `ggbiplot()` on the `crime` data look great! The arrow heads on the variable vectors are better, and the default vector thickness works well here. 

---

## 1. Fig 5.20  (`fig-diabetes-ggbiplot`, ~line 1420) — all text tiny

**Symptom**: Axis titles, axis tick labels, the rotated variable-vector name labels (`glutest`,
`sspg`, etc., drawn by `ggbiplot()`/`ggvector()`), and the `geom_label()` cluster labels
(`Normal`, `Chemical_Diabetic`, `Overt_Diabetic`, added by this chunk's own code *after* the
`ggbiplot()` call, line ~1445) all render at a drastically smaller size than expected — the
whole plot's text, not just anything `ggbiplot` draws. The arrows themselves render at a normal,
correct length and style.

**Ruled out** (extensive investigation with Claude, 2026-09-05):

- Not a bug in `ggbiplot`/`ggvector` code: `varname.size = 4` correctly reaches
  `ggplot2::geom_text(size = 4)` internally; since axis text (controlled purely by
  `theme_bw()`/`theme_minimal()`, which `ggbiplot()` never touches) is *also* shrunk, the cause
  can't be isolated to anything the package draws.
  
- Not an R-version or package-version mismatch: `sessionInfo()` run in the actual RStudio session
  used to render confirmed R 4.6.1, `ggbiplot` 0.6.5, `ggarrow` 0.2.0.9000, `ggplot2` 4.0.3, a
  single `.libPaths()` — exactly matching 5+ independent reproduction attempts (`ggsave()` at
  several sizes/dpi, `knitr::knit()`, `quarto render` via the CLI, a full chapter-order replay
  from the `crime.pca` chunks through this one) that all rendered correctly, every time.
  
- Not stale session/font contamination: the project had a leftover `.RData` (from 2026-01-01)
  that RStudio silently restores on startup, which was reloading `extrafont`/`extrafontdb`/
  `Rttf2pt1` (and much else) even after Session → Restart R. Renamed it to `.RData-bak`,
  restarted R fresh, rebuilt — bug persisted, so this wasn't it either (though the stale
  `.RData` auto-restore is worth fixing regardless, as general hygiene).

**Status**: UNRESOLVED. Root cause unknown.

## Fig 5.23 (`fig-diabetes-mds`, ~lines 1593:1607) 

- This is not a ggbplot-- it's produced using `ggpubr::ggscatter()`. But all text is also tiny in this plot

- Also, variable names are missing on the vectors vs. the previous version.
- Can we replace the use of `geom_segment()` with ggarrow?

## Fig 5.28 (`fig-mtcars-biplot`, ~lines 1901:1907) 

Variable names are missing in this plot

## Figs 5.36, 5.37 (`fig-peng-out-biplot1`, `fig-peng-out-biplot2`)

These just use `kintr::include_graphics()`. Should they be re-run to get nicer arrows?

---

## Other figures in this chapter affected

Noted but not yet itemized individually — other figures in `05-pca-biplot.qmd` reportedly
changed for the worse after the same `ggbiplot` update. Add each as its own numbered entry above
(figure number, `#| label`, approximate line, symptom, what's been ruled out).
