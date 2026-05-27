# Task: Interim PDF submission to editor — by June 7, 2026

**Goal:** Submit a clean interim `Vis-MLM.pdf` to Lara Spinker, my CRC editor showing the current state
of the book. Must be chapters-only (no appendices), with a matching author index.

I'm leaving June 7, but whatever can be done must be ready by Fri., June 5 so I can send it in, with
a cover email. This needs to mention the current page length, perhaps with some justification.

---

## 1. Build requirements

- [X] PDF containing only the 15 chapters + front/end matter — no Appendices A, B, C
  Fixed: appendices moved out of `_quarto.yml` into `_quarto-online.yml` only;
  `_quarto-print.yml` profile used for PDF; command: `./build.sh --pdf --authorindex`
- [X] Author index re-run against that build — `build.sh` now calls `make-authorindex.sh`
  (sets BIBINPUTS/BSTINPUTS, runs `perl latex/authorindex -d index`); 529 pages [2026-05-26]
- [X] Cover page inserted manually in Acrobat (as before)
- [X] Confirm page count and header fix hold (double-chapter-number bug fixed 2026-05-23)

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
- [ ] **Exercises appendix** (`31-exercises.qmd`) — online-only; Ch 4 exercises moved there;
      add exercises for other chapters as written
- [ ] **Ch 9 "What have we learned?" summary** (`summary/Ch09-summary.qmd`) — current prose
      needs rewriting as bullet-point take-aways before embedding in `09-collinearity-ridge.qmd`
- [ ] **Ch 2 (Introduction) "What have we learned?" summary** — no summary file exists and none
      is embedded in `02-intro.qmd`; decide whether to write one

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
- §11.6: "the the" → "in the" [GK: DONE; changed to just "the"]; "at" → "as" [GK: DONE]; sentence-after-comma fix (§11.6.1) [GK: DONE]
- §11.8: comma fixes (§§11.8 [GK: DONE], 11.8.1 [GK: DONE])
- §11.9: comma + missing "they" fix [GK: DONE]

**Ch 12:**
- §12.9: comma before "but"; "parent's" → "parental" or "parents'"; "students" → "students'";
  remove first "and" in the list [GK: DONE]

**Ch 13:**
- §13.4: comma after "otherwise" [MF: DONE]
- §13.5: quotation mark style: ` ``why?'' ` → `"why?"` [MF: DONE]

**Ch 14:**
- §14.2.1: missing closing backtick: `` `type = "stres" `` → `` `type = "stres"` `` [GK: DONE]
- §14.4: "if of course" → "is of course" [GK: DONE]

**Ch 21:**
- §21.2: `mda` → `` `r pkg("mda")` `` in text (§21.2) [GK: DONE]
- §21.6: move paragraph ("You can see that Betsy and Dave…") to after the figure
- §21.7.1: remove "and" from "All the Chinstraps appear mixed in with the Adélies and, giving…" [GK: DONE]
- §21.9: "In the table printed" → "In the printed table" [GK: DONE]

**Case Studies:**
- Canonical-space paragraph: add comma after "variables" [GK: DONE; worked better if I removed initial comma, see `reviews/reviewer-GavinK-comments.Rmd`]

**GK --- Tasks from above that I was not able to complete:**
- §11.3.1: add units if known

    - Units unknown

- §21.6: move paragraph ("You can see that Betsy and Dave…") to after the figure

    - This paragraph is already *after* the figure. There is a comment in `reviews/reviewer-GavinK-comments.Rmd` that asks if this paragraph should be moved to be *before* the figure. Is this what was meant?

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

## 6. Submission notes

* The previous chapter, **Case studies* has been moved to an online-only, Appendix A

* The previous Appendix A, **Discriminant analysis** has become Chapter 15, in print & online. The content here is integral to representing the methods for multivariate data discussed here, and nicely rounds out Part IV

* Exercises, once thought to be important to appear in print for teaching purposes, have been moved to an online-only Appendix C. This will allow them to
be developed further, over time.

* **TODO** items, sprinkled throughout the text have all been resolved [Confirm when done]

* An **R Code appendix** (online-only, Appendix B) has been added, listing all figure and analysis scripts with links to the GitHub source. This gives readers direct access to the complete, reproducible code for nearly every example in the book.

* **Style consistency** has been improved throughout: section headings now follow "Sentence case"", and other typographic conventions have been applied uniformly across chapters.

* **Reviewer corrections** from a detailed chapter-by-chapter review (Chapters 5–14 and 21) have been incorporated: prose edits, typographic fixes, cross-reference repairs, and code-formatting consistency.

* **Code display** in the PDF has been improved: long code lines now wrap automatically within their shaded box, eliminating the margin overflows noted in the review.


