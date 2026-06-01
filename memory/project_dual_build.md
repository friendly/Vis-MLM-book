---
name: Dual-build cleanup plan
description: RESOLVED 2026-06-01 — dual build (HTML + PDF) working correctly; see issues/dual-build-plan.md
metadata:
  type: project
---

**RESOLVED 2026-06-01.** The GK-work4 merge (Gavin's branch) fixed the conflicting config state
by removing `appendices:` from `_quarto.yml` (base) entirely and keeping them only in
`_quarto-online.yml`. This is the correct design.

**Current working config:**
- `_quarto.yml`: base config, chapters only, no appendices
- `_quarto-online.yml`: adds 3 appendices for `--profile online` HTML builds
- `_quarto-print.yml`: PDF profile, chapters only, no appendices

**Verified 2026-06-01** via `./build.sh --all --authorindex`: both PDF appendix check and
HTML output check passed. `pdf/Vis-MLM.pdf` has author index; `docs/` HTML includes appendices.

**Why:** The GK-work4 branch resolved the conflict the right way — cleaner than the original plan.
**How to apply:** No further action needed. Build with `./build.sh --all --authorindex` for full build.
