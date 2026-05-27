---
name: PDF build task — create final Vis-MLM.pdf
description: Planned task to build a clean PDF reflecting only final book content, then archive outputs to pdf/
type: project
---

Build a clean `Vis-MLM.pdf` reflecting ONLY what will be in the final printed book (i.e. using the base config, no online-only appendices).

**Why:** The current PDF may not be up to date or may include content not intended for print. This is the reference copy for CRC Press.

**Steps:**
1. Run `./build.sh --pdf` (base config only, no `--profile online`)
2. Close `index.pdf` in Acrobat first — Windows file lock will cause build to fail
3. Once successful, copy to archive:
   - `docs/Vis-MLM.pdf` → `pdf/` folder
   - `index.{tex,log,toc,idx,ind,ilg,ain,...}` → `pdf/` folder for safekeeping
4. Verify chapter list matches `_quarto.yml` (no `15-case-studies.qmd`, no `Rcode.qmd`/`30-Rcode.qmd`)

**Relevant notes in issues/:**
- `issues/quarto-pdf-help.md` — PDF build reliability notes, LaTeX workarounds
- CLAUDE.md § Build — PDF build caveats (TinyTeX vs MikTeX, keep-tex, TeXStudio fallback)

**How to apply:** Remind user of these steps and point to `issues/quarto-pdf-help.md` when this task comes up.
