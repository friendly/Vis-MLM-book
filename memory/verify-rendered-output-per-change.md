---
name: verify-rendered-output-per-change
description: "After batch edits to book source, verify each changed location in the rendered output — a symptom-pattern grep is not enough"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 7b44fc13-1d4e-459a-b152-e99ac0ed751d
---

After the 2026-07-11 citation cleanup, my "verification" only grepped rendered HTML for
the old doubled-parens symptom, and GK caught 2 of 22 fixes rendering wrong in a new way
(prefix mid-group from CSL sorting) that the symptom grep could not detect.

**Why:** Edits can introduce new failure modes that differ from the one being fixed;
checking only for the original symptom verifies the absence of the old bug, not the
correctness of the new text.

**How to apply:** After batch source edits, extract and eyeball the rendered text at
every changed location (e.g. grep each edit's surrounding phrase in docs/*.html and strip
tags). For citation syntax, a fast pre-build check is standalone
`quarto pandoc --citeproc --bibliography=bib/references.bib --csl=bib/apa.csl -t plain`
on a snippet file.
