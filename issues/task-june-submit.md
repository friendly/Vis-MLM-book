# Task: Interim PDF submission to editor — by June 7, 2026

**Goal:** Submit a clean interim `Vis-MLM.pdf` to Lara Spinker, my CRC editor showing the current state
of the book. Must be chapters-only (no appendices), with a matching author index.

I'm leaving June 7, but whatever can be done must be ready by Fri., June 5 so I can send it in, with
a cover email. This needs to mention the current page length, perhaps with some justification.

---

## 1. Build requirements

- [ ] PDF containing only the 15 chapters + front/end matter — no Appendices A, B, C
  (see `issues/task-r-code.md` for the separate HTML/PDF build plan; for now, simplest
  fix is to comment out appendix includes in `_quarto.yml` before the submission build)
- [ ] Author index re-run against that build (Perl `authorindex` script; see `issues/authorindex.md`)
- [ ] Cover page inserted manually in Acrobat (as before)
- [ ] Confirm page count and header fix hold (double-chapter-number bug fixed 2026-05-23)

---

## 2. What has been fixed since Gavin's review (General Issues + Ch 4–5.3)

- **Double chapter number in even-page headers** — fixed in `latex/preamble.tex` [2026-05-23]
- **Code overflow** — `breaklines=true` added to fancyvrb in `preamble.tex`; `issues/wide-code.R`
  for any residual cases [2026-05-24]
- **Ch 4** text fixes: \$10,000 formatting, "on average" duplicate, section title caps,
  `peng.mod` / `peng.lda` chunk labels
- **Ch 5.2.5** nested bullet-list indentation (Quarto requires 4 spaces)

---

## 3. MF to do before June 7

Items requiring author judgement, R/LaTeX knowledge, or a decision:

- [X] **Ch 6** "The General Linear Model" heading — all initial caps is correct here (§6.1)
- [ ] Resolve remaining visible **TODO** items which appear in the text
- [X] **Ch 7** `spida2` not in Packages list — fixed by adding missing `library(spida2)` call (§7)
- [ ] **Ch 11** blurry figures `fig-visualizing-SSP` and `fig-manova-diagram` — recreate or leave
- [X] **Ch 13** `$\mathcal{M}$` fix (§13.4 — LaTeX); reword ", here," sentence (§13.5)
- [X] **Ch 21** `EnisGeisser1974` BibTeX error in `references.bib` (§21.2)
- [X] **Heading capitalisation** policy pass — sentence case; cap after ":" only for proper terms
      (e.g., "4.2.4 --- Handling nonlinearity: Plotting on a log scale" → "Plotting" stays capped)

---

## 4. Assign to Gavin

Simple text/prose fixes with "MF: Fix this" or "MF: Yes" sign-off in the review.
Gavin should edit the `.qmd` files directly and submit a PR.

**Ch 5:**
- §5.4: "variable" → "variables" (one word) [GK: DONE]

**Ch 6:**
- §6.1.1: add commas to dollar amounts: `$29162` → `$29,162`; `$1119` → `$1,119`;
  `$23,068` already correct; `$2295` → `$2,295` [GK: DONE]

**Ch 7:**
- §7.1.1: `confidenceEllipse(...)` → `car::confidenceEllipse(...)` in text and/or code [GK: DONE]

**Ch 8:**
- §8.1.2: "Stress" and "Coffee" → `` `Stress` `` and `` `Coffee` `` in the two prose passages [GK: DONE]

**Ch 9:**
- §9.6: "generalized cross validation, bootstrap methods" → "..., or bootstrap methods" [GK: DONE]

**Ch 10:**
- §10.8: all plain *F* and *t* in prose → `$F$` and `$t$` (systematic pass through chapter) [GK: DONE; see `issues/F-and-t-Ch10-pass.md`]

**Ch 11 prose fixes:**
- §11.2.1: decide if `formula` needs code formatting [GK: DONE]
- §11.3.1: round both numbers to same digits [GK: DONE]; add units if known
- §11.4: "highly difference" → "large difference" [GK: DONE]; reword "however" sentence [GK: DONE]; "ANOVAS" → "ANOVAs" [GK: DONE]
- §11.4.3: missing closing `$` around $R^2$ [GK: DONE]; "at" → "as" [GK: DONE]
- §11.6: "the the" → "in the" [GK: DONE; changed to just "the"]; "at" → "as" [GK: DONE]; sentence-after-comma fix (§11.6.1)
- §11.8: comma fixes (§§11.8, 11.8.1)
- §11.9: comma + missing "they" fix

**Ch 12:**
- §12.9: comma before "but"; "parent's" → "parental" or "parents'"; "students" → "students'";
  remove first "and" in the list

**Ch 13:**
- §13.4: comma after "otherwise"
- §13.5: quotation mark style: ` ``why?'' ` → `"why?"`

**Ch 14:**
- §14.2.1: missing closing backtick: `` `type = "stres" `` → `` `type = "stres"` ``
- §14.4: "if of course" → "is of course"

**Ch 21:**
- §21.2: `mda` → `` `r pkg("mda")` `` in text (§21.2)
- §21.6: move paragraph ("You can see that Betsy and Dave…") to after the figure
- §21.7.1: remove "and" from "All the Chinstraps appear mixed in with the Adélies and, giving…"
- §21.9: "In the table printed" → "In the printed table"

**Case Studies:**
- Canonical-space paragraph: add comma after "variables"

---

## 5. Remaining open / deferred

Items noted in the review but not targeted for this submission:

- Fig label `fig-crime-factominer` font size (§5.3.5) — acceptable for now
- `diabetes-scatter3d` label legibility (§5.3.6) — deferred
- `fig-peng-simpsons` size (§4.5) — acceptable
- `fig-peng-mosaic` overlapping labels (§4.9) — acceptable
- *x*-axis overlap in `fig-prestige-allEffects` (§7.4.1) — not worth fixing
- Duplicate `coef()` call in §11.4.3 — low priority
- Appendix B labelling inconsistency — acceptable (will be removed from PDF anyway)
- Example heading format consistency (§§11.5) — deferred
- `pvPlot()` / `dataEllipse` PR to **car** — separate task, not submission-blocking
