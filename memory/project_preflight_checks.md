---
name: project-preflight-checks
description: "CRC print preflight checks to run after every PDF build (glyphs, fonts, RGB images), and the fixes already in place"
metadata:
  node_type: memory
  type: project
  originSessionId: 8a3c39e1-6e72-41a0-a178-5b004641c0b4
  modified: 2026-11-23T21:34:06.489Z
---

CRC's production preflight (copy-editing note 2026-11-19, `production/copy-editing-note-11-19-2026.md`) flagged undefined glyphs, non-embedded fonts, RGB images, prelims, and Fig 7.17. After any PDF build meant for CRC, check:

1. `index.log` (or the TeXStudio `.log`) has no `Missing character` lines. Each one is a blank glyph in print.
2. `pdffonts index.pdf` shows no font with `emb = no`.
3. `pdfimages -list index.pdf` shows no `rgb`, `index` or `icc` images (cover excepted). Vector content is already CMYK; RGB comes only from rasters in `images/`.

Fixes already in place (2026-11-23), so these should stay clean:
- `R/common.R` output hook replaces ✓/✔ → `+` and ✗/✘ → `x` in PDF output (Latin Modern Mono lacks them; came from `MVN::mvn()`).
- `R/common.R` `fig.process` hook embeds fonts in each PDF figure via Ghostscript (R's `pdf()` never embeds Helvetica/Symbol). It finds any installed gs version and warns "Ghostscript not found" if none. One-off repair for existing figures: `issues/embed-fig-fonts.R`.
- Never write `\vec{<lowercase Greek>}` or `\mathbf{\beta}`: `\vec` = `\mathbf` and the bold roman font has no lowercase Greek. Use `\boldsymbol{}`.

**Why:** printed errors are permanent, and CRC's preflight caught these only at copy-edit stage.

**How to apply:** after a build, run the three checks before telling the user the PDF is ready. New causes to watch: package print methods that emit unusual Unicode (arrows, emoji), and new raster images (convert to CMYK; see `issues/image-quality/cmyk-next-steps.md`, delegated to Gavin 2026-11-23).
