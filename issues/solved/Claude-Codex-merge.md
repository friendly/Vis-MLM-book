# Merging GK-work4 (Codex) into master (Claude)

**Date:** 2026-06-01  
**Context:** Gavin used ChatGPT Codex (transcript in `issues/GK-codex-transcript2.md`) to
fix (a) the duplicate-TOC-entry problem and (b) dual-build appendix issues, working on his
`GK-work4` branch. Claude applied its own fixes on `master` in the same session. This note
records the differences and the safe merge path.

---

## Summary

GK-work4 does **not conflict** with master — it is a strict superset. Codex identified a
real bug in Claude's TOC fix that must be incorporated.

---

## File-by-file comparison

### `latex/preamble.tex`

Both branches apply the same two-part TOC fix:

1. Override `\@schapter` to drop the automatic `{fm}` TOC entry that krantz adds for every
   `\chapter*`, eliminating the duplicate Preface/Author entries.
2. Override `\l@chapter` to call `\toc@draw` before rendering each chapter entry, so the
   deferred part header fires before (not after) its own chapters.

**Critical bug in Claude's version:** `\toc@draw` is called but never reset. Without
`\let\toc@draw\relax` immediately after, the same part header re-fires before every
subsequent chapter in that part (Part I appears before Ch 1, Ch 2, Ch 3, …). Codex caught
this and added the reset.

**Additional improvement in GK-work4:** Widened `\l@section`, `\l@subsection`, and
`\l@subsubsection` number-column widths to prevent entries like `12.10` from running into
their titles.

Correct `\l@chapter` (Gavin's version):
```latex
\renewcommand*\l@chapter[2]{%
  \toc@draw
  \let\toc@draw\relax          % <-- required; missing from Claude's version
  \ifnum \c@tocdepth >\m@ne
    ...
  \fi}
```

Section width additions (not in Claude's version):
```latex
\renewcommand*\l@section{\@dottedtocline{1}{1.5em}{3.0em}}
\renewcommand*\l@subsection{\@dottedtocline{2}{4.5em}{3.8em}}
\renewcommand*\l@subsubsection{\@dottedtocline{3}{8.3em}{4.6em}}
```

**Resolution:** Take GK-work4's `preamble.tex` in full.

---

### `_quarto.yml`

- **master:** still has `appendices: [15-case-studies.qmd, 30-Rcode.qmd, 31-exercises.qmd]`
  in the base config, so `quarto render --profile print --to pdf` pulls them in and the
  PDF includes the appendices.
- **GK-work4:** appendices removed from `_quarto.yml`; they live only in
  `_quarto-online.yml`.

This is exactly the fix that was planned (task-june-submit.md §1) but never completed on
master.

**Resolution:** Take GK-work4's `_quarto.yml` (appendices removed).

---

### `_quarto-online.yml`

Both branches have the same content (appendices listed there for the HTML `--profile online`
build). No conflict.

---

### `build.sh`

GK-work4 adds an automatic second PDF render after the authorindex step. Without this, the
author index is generated *after* the first PDF pass and the PDF never gets recompiled to
include it — the user has to do it manually. This was exactly the problem encountered
during the June 1 build session.

**Resolution:** Take GK-work4's `build.sh`.

---

### `make-authorindex.sh`

GK-work4 generalizes the hard-coded Windows paths so the script works on any machine
(Gavin's Mac, CI, etc.). No functional change on Michael's Windows machine.

**Resolution:** Take GK-work4's `make-authorindex.sh`.

---

### Content files (`21-discrim.qmd`, etc.)

Gavin has been editing chapter content on his branch (LOO CV accuracy added to Ch 21, other
edits). These should be preserved as-is from GK-work4.

---

## Merge plan

**Preferred:** open a PR on GitHub merging `GK-work4` → `master`. Reasons:

- Gives a full diff to review before any destructive action.
- Conflicts (likely in `preamble.tex` and `_quarto.yml`) can be resolved in the GitHub UI
  or locally with a clear audit trail.
- Keeps history clean with a merge commit that documents the integration.

**Expected conflicts and resolutions:**

| File | Expected conflict | Resolution |
|------|-------------------|------------|
| `latex/preamble.tex` | Both branches modified | Take GK-work4; it is a superset with the bug fix |
| `_quarto.yml` | Master has appendices; GK-work4 does not | Take GK-work4 (remove appendices from base) |
| `build.sh` | GK-work4 adds second-PDF-render logic | Take GK-work4 |
| `make-authorindex.sh` | GK-work4 generalizes paths | Take GK-work4 |

No conflicts expected in content `.qmd` files — Gavin and Michael worked on different
chapters.

---

## What to do on master before the PR lands

The `\let\toc@draw\relax` bug means `master`'s current `preamble.tex` will produce
repeated part headers in any TeXStudio recompile. Apply the one-line fix to master now if
a PDF build is needed before the merge completes.
