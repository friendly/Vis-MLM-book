---
name: Part color themes
description: PDF part accent colors implemented in preamble.tex; green (partIII) too light, needs darkening
metadata:
  type: project
---

Part accent colors added to `latex/preamble.tex` (2026-06-10). Single place to retheme the whole book.
UPDATE 2026-07-02: color definitions moved to `latex/part-colors.tex` (\input by preamble.tex),
shared with the part-page/chapter-opener diagrams — see [[part-chapter-diagrams]].

**Current colors:**
- `partI` = blue (Part I: Orienting Ideas)
- `partII` = teal (Part II: Exploratory Methods)
- `partIII` = green — **TOO LIGHT on white; needs darkening** (candidates: `olive`, or custom CMYK like `mygreen` already in preamble)
- `partIV` = orange (Part IV: Multivariate LM)

**What's implemented:**
- `\colorlet{partI..IV}` defined in preamble after xcolor
- `\pretocmd{\part}` hook switches `partcol`/`partcol80`/`partcol50`/`partcol20` at each part boundary
- `\SectionHeadFont`, `\SubsectionHeadFont`, `\SubsubsectionHeadFont` now use `\color{partcol}`
- Test file: `test/test-part-colors.qmd` — also demonstrates `\partrule`, Key Point box (`mdframed`), colored table header (`colortbl`)

**Not yet done:**
- `index.qmd` smartdiagram: still uses `blue!35, teal!40, green!35, orange!40` — update to `partI!35` etc.
- HTML side (SCSS variables) — deferred; see `issues/task-color-themes.md`
- Verify colors switch correctly in a full book PDF render

**Why:** partcol design means all colored elements update automatically when base colors change.
**How to apply:** To adjust partIII color, change only the `\colorlet{partIII}{...}` line in `preamble.tex`.
