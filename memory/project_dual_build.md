---
name: Dual-build cleanup plan
description: Weekend task to fix conflicting HTML/PDF build config; full plan in issues/dual-build-plan.md
type: project
---

Appendices (`15-case-studies.qmd`, `30-Rcode.qmd`, `31-exercises.qmd`) were restored to
`_quarto.yml` on 2026-05-29 so that RStudio's `Build -> HTML` button works without needing
`--profile online`. This created a conflict: `_quarto-online.yml` still lists the same 3
appendices, causing duplication when `./build.sh --html` (which uses `--profile online`) runs.

**How to apply:** See `issues/dual-build-plan.md` for the full step-by-step plan. The three steps are:

1. **Remove appendices from `_quarto-online.yml`** (now duplicated from base config)
2. **Drop `--profile online` from `build.sh`** — both the `html` and `all` cases (~lines 144/146 and 156/158)
3. **Verify PDF TOC has no appendices**; if they appear, add `book.appendices: []` to `_quarto-print.yml`

Current state (2026-05-29): PDF via `./build.sh --pdf` is OK; HTML via `Build -> HTML` is OK.
The `./build.sh --html` path is untested/risky due to potential appendix duplication.
