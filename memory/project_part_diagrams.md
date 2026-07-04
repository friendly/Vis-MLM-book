---
name: Part & chapter diagrams
description: DDAR-style bubble diagrams on PDF part pages and chapter openers; sources in latex/diagrams/, hooks in preamble.tex
metadata:
  type: project
---

DDAR-style bubble diagrams added to the PDF book (2026-07-02, branch `part-pages-test`).
Full write-up for Michael: `issues/GK-part-pages.md` (architecture, maintenance, dependencies, print notes).
Part pages show part → chapters; chapter openers show chapter → numbered sections,
colored with the [[part-color-themes]] accents (root = full color/white text,
satellites = 30% tint/black text, tapered shaded connection bands).

**Architecture (PDF-only; zero .qmd changes, HTML unaffected):**
- `latex/diagrams/part1..4.tex`, `chap1..15.tex` — hand-editable TikZ sources
  (plain TikZ + calc; NOT the mindmap library — its connection bars leave hairline
  seams between fill segments, so connections are custom single-path shaded bands).
- `latex/diagrams/diagram-common.tex` — shared `\band` macro + bubble styles
  (`rootbubble`/`satbubble`: vertical top-lit gradients, soft blur shadows via
  the `pgf-blur` package — `tlmgr install pgf-blur` needed to regenerate;
  `\bubbletitle` = number + white divider rule + title in the center bubble).
  Blur shadows use PDF transparency; if CRC's print workflow ever demands
  flattened/no-transparency PDFs, swap `softshadow` for a plain `drop shadow`.
- `sh latex/diagrams/make-diagrams.sh` — compiles all sources → `figs/diagrams/*.pdf`.
- `latex/part-colors.tex` — part accent colors, now \input by both preamble.tex
  and the diagram sources (single place to retheme).
- `latex/preamble.tex` — two `\pretocmd` hooks: `\@endpart` (diagram below part
  title) and `\@makechapterhead` (diagram top-right above chapter head). Both
  guarded by `\IfFileExists{figs/diagrams/...}` so End Matter / front matter are
  untouched. Chapter files are NOT zero-padded (`chap4.pdf`) because the hook
  uses `\thechapter`.
- `issues/make-part-diagrams.py` — the one-off generator that wrote the sources;
  re-running OVERWRITES hand edits.

**Section lists were taken from the built Vis-MLM.tex (2026-07-01), not raw qmds**
(qmds contain commented-out/HTML-only headings). Trailing "What have we learned?"
sections are omitted from diagrams (safe: always last, numbering unaffected).
When chapter sections change, edit the matching `latex/diagrams/chapN.tex` and
re-run make-diagrams.sh.

**Verified:** full one-pass xelatex of patched Vis-MLM.tex (524 pp) — part pages
I–IV, chapter openers 1/4/10, End Matter all render correctly.

**Why:** Michael wanted part/chapter mind-map pages like his DDAR book.
**How to apply:** retheme via latex/part-colors.tex, then re-run make-diagrams.sh;
tweak individual diagrams by editing their .tex source directly.
