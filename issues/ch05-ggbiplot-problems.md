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

## ROOT CAUSE FOUND (2026-09-06, with Claude) — not ggbiplot at all

The tiny-text bug below is **not** caused by `ggbiplot`/`ggarrow`. It's caused by
`FactoMineR::plot.PCA()` at the `fig-crime-factominer` chunk (~line 1313), which as of
FactoMineR 2.16 defaults to `graph.type = "ggplot"`. In that mode it applies its own
`theme_factominer()`, which — as a side effect, unconditionally — calls
`showtext::showtext_auto(enable = TRUE)` to support its default Google Fonts. That call installs
a **global, session-wide** hook (`setHook("plot.new", ...)` / `setHook("grid.newpage", ...)`) that
changes how *all* text is rendered on *any* device for the rest of the R session — not scoped to
that one plot or device.

`showtext_auto()` defaults to rendering text assuming 96 dpi. This book's chunks render at
`dpi = 300` (`R/common.R`). Once the hook is active, every later ggplot2 figure in the chapter
draws its text at roughly 96/300 ≈ 32% of the intended size — while points, lines, and arrows
(not routed through the font hook) render at normal size. This exactly matches every reported
symptom: only text shrinks, it persists across all subsequent chunks in the same render, and the
"tiny" labels in `fig-crime-factominer` itself, `fig-diabetes-mds`, and `fig-mtcars-biplot` are
this same shrink, sometimes small enough to look "missing" rather than just small.

**Verified mechanism directly**: reproduced the exact bug with nothing but
`showtext::showtext_auto(enable = TRUE)` followed by an ordinary `ggplot()` call at `dpi = 300` —
title/axis text shrank identically to the book's figures, while `showtext::showtext_opts(dpi = 300)`
before plotting fixed it completely.

**Verified by bisection**: extracted `05-pca-biplot.qmd` lines 1–1449 (start of chapter through
`fig-diabetes-ggbiplot`) into a standalone test document and rendered with `quarto render`.
Reproduced the bug reliably. Disabling only the `fig-crime-factominer` chunk (`eval: false`)
made the downstream `fig-diabetes-ggbiplot` render with normal-sized text — confirming that one
call is the trigger.

**Fix applied**: added `graph.type = "classic"` to the `plot()` call:

```r
plot(crime.PCA_sup, choix = "var", graph.type = "classic")
```

This skips FactoMineR's ggplot/`theme_factominer()`/showtext code path entirely (confirmed via
`FactoMineR:::plot.PCA` source — `theme_factominer()` is only invoked inside
`if (graph.type == "ggplot")`), avoids a dependency on downloading Google Fonts for
reproducibility, and should restore the figure's original base-R appearance matching
`pdf/Vis-MLM.pdf`.

**Status of verification**: confirmed working in isolated/bisected test renders (direct `Rscript`
calls with the real `crime.PCA_sup` object, and a full-chapter-prefix `quarto render`) — the
`showtext` hook (checked directly via `getHook("plot.new")`/`getHook("grid.newpage")`) stays
inactive throughout, and `fig-diabetes-ggbiplot` renders at normal text size in that test.
**However**, a `quarto render 05-pca-biplot.qmd` of the real chapter file after applying the fix
still showed tiny text in `figs/ch05/fig-diabetes-ggbiplot-1.png` — this is unreconciled and needs
a clean re-render + re-check before considering this closed. (Possibly a red herring from output-
path overlap: bisection scratch test files were also writing into the same `figs/ch05/` directory
during the same investigation session — needs a from-scratch verification render with no test
files present.)

**Separate, lower-priority issue**: even with `graph.type = "classic"`, `fig-crime-factominer`
itself may still be worth a look — before this fix, the active-variable labels (black) rendered
noticeably smaller than the supplementary-variable labels (blue) *within that single figure*,
which looks like a distinct FactoMineR quirk unrelated to the showtext leak. Not yet re-checked
with `graph.type = "classic"`.

**For Gavin**: the diagnosis and fix mechanism above are solid (directly verified via the
showtext hook state and isolated reproductions), but the final "does the real chapter render
clean end-to-end" check is not yet confirmed — see the unreconciled note above. Worth a second
pair of eyes on both the mechanism and that last verification step.

## Fig 5.18 (`fig-crime-factominer`, ~ lines 1313:1318) - all text tiny

Explained by the root cause above.

## Fig 5.20  (`fig-diabetes-ggbiplot`, ~line 1420) — all text tiny

**Symptom**: Axis titles, axis tick labels, the rotated variable-vector name labels (`glutest`,
`sspg`, etc., drawn by `ggbiplot()`/`ggvector()`), and the `geom_label()` cluster labels
(`Normal`, `Chemical_Diabetic`, `Overt_Diabetic`, added by this chunk's own code *after* the
`ggbiplot()` call, line ~1445) all render at a drastically smaller size than expected — the
whole plot's text, not just anything `ggbiplot` draws. The arrows themselves render at a normal,
correct length and style.

**Ruled out** (extensive investigation with Claude, 2026-09-05 and 2026-09-06):

- Not a bug in `ggbiplot`/`ggvector` code: `varname.size = 4` correctly reaches
  `ggplot2::geom_text(size = 4)` internally; since axis text (controlled purely by
  `theme_bw()`/`theme_minimal()`, which `ggbiplot()` never touches) is *also* shrunk, the cause
  can't be isolated to anything the package draws.
  
- Not an R-version or package-version mismatch: `sessionInfo()` run in the actual RStudio session
  used to render confirmed R 4.6.1, `ggbiplot` 0.6.5, `ggarrow` 0.2.0.9000, `ggplot2` 4.0.3, a
  single `.libPaths()` — exactly matching 5+ independent reproduction attempts (`ggsave()` at
  several sizes/dpi, `knitr::knit()`, `quarto render` via the CLI, a full chapter-order replay
  from the `crime.pca` chunks through this one) that all rendered correctly, every time. (In
  hindsight: these isolated attempts didn't reproduce because they didn't happen to execute the
  `fig-crime-factominer` chunk first in the same session — see root cause above.)
  
- Not stale session/font contamination: the project had a leftover `.RData` (from 2026-01-01)
  that RStudio silently restores on startup, which was reloading `extrafont`/`extrafontdb`/
  `Rttf2pt1` (and much else) even after Session → Restart R. Renamed it to `.RData-bak`,
  restarted R fresh, rebuilt — bug persisted, so this wasn't it either (though the stale
  `.RData` auto-restore is worth fixing regardless, as general hygiene).
  
- To test, I ran the code it uses, `R/diabetes/diabetes-ggbiplot.R`, and the figure looks fine.
  (Consistent with root cause: that standalone script never runs `fig-crime-factominer`.)

- Confirmed reproducible even after `Session → Restart R` + rendering only `05-pca-biplot.qmd`
  directly (fresh session, still broken) — this initially seemed to rule out "session state",
  but is fully explained by the showtext hook getting (re-)installed by `fig-crime-factominer`
  early in that same fresh-session render.

**Status**: Root cause identified and fix applied (see above) — needs a final clean verification
render.

## Fig 5.23 (`fig-diabetes-mds`, ~lines 1593:1607) 

- This is not a ggbplot-- it's produced using `ggpubr::ggscatter()`. But all text is also tiny in this plot
- Also, variable names are missing on the vectors vs. the previous version.
- Can we replace the use of `geom_segment()` with ggarrow?
- Very likely the same showtext root cause (comes later in the chapter than `fig-crime-factominer`)
  — should clear once the fix is verified, but not yet individually re-checked.

## Fig 5.28 (`fig-mtcars-biplot`, ~lines 1901:1907) 

- Variable names are missing in this plot.
- Very likely the same showtext root cause — not yet individually re-checked after the fix.

## Figs 5.36, 5.37 (`fig-peng-out-biplot1`, `fig-peng-out-biplot2`)

These just use `kintr::include_graphics()`. Should they be re-run to get nicer arrows?

---

## Other figures in this chapter affected

Noted but not yet itemized individually — other figures in `05-pca-biplot.qmd` reportedly
changed for the worse after the same `ggbiplot` update. Add each as its own numbered entry above
(figure number, `#| label`, approximate line, symptom, what's been ruled out). Given the root
cause above, any figure *after* `fig-crime-factominer` in render order is a candidate; anything
*before* it (e.g., Figs 5.13–5.15, the crime `ggbiplot()` figures) should be unaffected.
