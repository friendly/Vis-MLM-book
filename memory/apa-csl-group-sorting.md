---
name: apa-csl-group-sorting
description: apa.csl sorts multi-key citation groups alphabetically — a prefix must be attached to the alphabetically-first key or it renders mid-group
metadata: 
  node_type: memory
  type: project
  originSessionId: 7b44fc13-1d4e-459a-b152-e99ac0ed751d
---

In this book (bib/apa.csl), Pandoc citation groups like `[e.g., @KeyB; @KeyA]` are
re-sorted alphabetically by author at render time, and any prefix text travels with the
key it precedes. If the prefix is attached to a key that does not sort first, it lands in
the middle of the rendered group, e.g. `[e.g., @Peddle:1910; @Haskell:1919]` →
"(Haskell, 1919; e.g., Peddle, 1910)". Fix: order the keys alphabetically by first author
in the source so the prefix sits on the group's first-rendered item. Bit us on
2026-07-11 in the paren-citations cleanup (rows 2 and 17 of issues/paren-citations.md).

Related lesson from the same incident: [[verify-rendered-output-per-change]].
