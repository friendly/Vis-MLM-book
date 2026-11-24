# Tasks

Living task/cleanup tracker for this project, replacing `issues/Tasks-Issues.md` as the
place to log new items. `Tasks-Issues.md` stays where it is as the original project notes
(mostly historical/superseded at this point — most of its items are marked `[DONE]` or
`[FIXED]`); it isn't being rewritten, just no longer the place new items get added.

---

## Open items

### datavis.ca links: fix if York UIT can't restore the site (ON HOLD)

  (2026-11-16) www.datavis.ca was taken offline by York UIT (PHP security issue); `https://`
  links now fail with a certificate error, `http://` ones redirect to York's "unavailable"
  page. **Don't fix yet**: wait to see whether UIT restores the site. If it can't, these links
  matter for the book (printed URLs can't be changed after publication).

  Papers have moved to <https://friendly.github.io/papers/> (repo `friendly/papers`, same
  paths), so most links can be fixed with `C:\R\Projects\papers\dev\rewrite_datavis_urls.R`
  (dry run first; it uses DOIs where known, and fixes the broken `effect.pdf` and
  `Corrgrams.pdf` paths). Non-paper links (`gallery/animation/manova/`, `duncanAV/`,
  `milestones/...`) need a decision by hand. `vita.bib` has already been updated.

  Files with links (2026-11-16): `bib/references.bib` (11), `00-Author.qmd` (3),
  `01-Prelude.qmd` (3), `11-mlm-review.qmd` (2), `07-linear_models-plots.qmd` (1),
  `_quarto.yml` (1), `_quarto-test.yml` (1).
  Overall plan: `C:\Dropbox\GitHub\datavis\GH-migration-plan.md`.

### Scripts

 **`issues/` cleanup: `rcode-appendix/` grouping + a top-level `scripts/` folder?**
  (2026-08-25) During the `issues/` reorganization (moving solved items to `solved/`,
  grouping `indexing/` and `image-quality/`, moving CRC-metadata files to `production/`),
  held off on grouping `task-r-code.md`, `figcode-gaps.md`, `find-uncovered-figures.R`,
  `make-rcode-appendix.R`, `scan_fig_files.R` into an `issues/rcode-appendix/` folder.

  MF's reasoning: `make-rcode-appendix.R` is still an **active** script — it needs to run
  again whenever new R files are added for HTML figures, not a closed issue to file away.
  That raises a broader question worth deciding deliberately rather than folding into the
  same "topic subfolder" move as the genuinely-closed stuff: should there be a top-level
  `scripts/` folder for scripts that are part of the ongoing HTML/PDF production workflow
  (this one plus whatever else turns out to be "active tooling" rather than "issue
  investigation"), separate from `issues/` entirely? MF said he'll take this up shortly —
  revisit then, and figure out which of the 5 files are genuinely active vs. which are
  one-off investigation notes that *do* belong in `issues/rcode-appendix/`.

### CRC preflight list (copy-editing note, 2026-11-19)

  The production team's preflight flagged five things. Full notes (causes, fixes, file:line refs) and the draft reply to Lara: `production/copy-editing-note-11-19-2026.md`; reply as Word: `production/reply-Lara-preflight.docx`.

  - [x] Undefined glyphs (pp. 224, 238, 240, 360) --- 2026-11-23. `\vec{\beta}` (= `\mathbf`, no lowercase Greek) → `\boldsymbol{\beta}` in Ch 7/8; ✓/✗ in `MVN::mvn()` output replaced by `+`/`x` in PDF output via the output hook in `R/common.R`.

  - [x] Non-embedded fonts (162 pages) --- 2026-11-23. R's `pdf()` doesn't embed Helvetica/Symbol. `issues/embed-fig-fonts.R` fixed the 223 figures in `figs/`; a `fig.process` hook in `R/common.R` embeds fonts in every new PDF figure (finds any installed Ghostscript).

  - [x] Fig 7.17 overlapping x-axis labels --- 2026-11-23. `income*type` panel now one multiline plot.

  - [ ] RGB → CMYK --- delegated to Gavin 2026-11-23; images converted and filter in place 2026-11-24; waiting on his test build and PR (see next item).

  - [ ] Prelims --- CRC inserts them; asked Lara whether to remove our placeholder copyright page (`latex/before-body.tex`).

  - [ ] Send the reply to Lara --- **on hold** until the CMYK work is checked.

  - [ ] Next full build: check `index.log` has no `Missing character` lines, `pdffonts index.pdf` has no `emb no` rows, and Fig 7.17 looks right.

### Image quality: CMYK conversion + low-DPI images for CRC print submission

  **Update 2026-11-23:** Gavin's `dpi-fixes` branch merged. Independently verified (`issues/image-quality/verify-dpi-fixes.R`): 64 of 69 low-DPI images fixed (≥ 317 dpi or vector). `MF-gray.jpg` accepted (no better source). Still below 300 dpi, noted as special cases with no guarantee they'll be fixed: `datasaurus-dozen.jpg`, `iris-diagram.jpg`, `tesseract-frames.png`, `heatmap.png`. Vector content in the PDF is already all CMYK; the RGB is only the ~80 raster images from `images/`. Revised plan and Gavin/MF split: `issues/image-quality/cmyk-next-steps.md` (Lua filter instead of the `img_path()` call-site rewrite; commit `images-cmyk/`). Tasks sent to Gavin: `issues/image-quality/email-Gavin-cmyk.md`.

  **Update 2026-11-24:** Gavin converted the images on branch `convert-CMYK` (80 files in `images-cmyk/`: 71 CMYK, PNGs wrapped as PDF; 8 grayscale) and made a contact sheet. Checked: conversion correct, colour shifts accepted. The Lua filter `filters/cmyk-images.lua` is written, tested and wired into `_quarto.yml` on master (no-op until `images-cmyk/` exists). The title-page "images" are vector diagrams with no RGB: nothing to do. Details: `cmyk-next-steps.md`.

  - [x] **Gavin:** conversion script → `images-cmyk/` (committed on `convert-CMYK`); before/after contact sheet --- 2026-11-24.

  - [x] **MF:** review the contact sheet for colour shifts --- accepted 2026-11-24.

  - [x] Lua filter --- written by Claude, on master 2026-11-24.

  - [ ] **Gavin:** merge master into `convert-CMYK`; full PDF build; acceptance test (`pdfimages -list` shows no rgb/index/icc images except the cover; no `Missing character` in the log; all fonts embedded); then a PR with the summary.

  - [ ] **MF:** review and merge the PR; final build; send PDF + reply to Lara.

  - [ ] Optional: the four low-DPI special cases (e.g. redraw `datasaurus-dozen` from the **datasauRus** package).

  *Original notes (2026-08-25), superseded by the update above:*

  (2026-08-25) CRC requires the final PDF in CMYK; static raster images in `images/`
  aren't converted yet, and a chunk of them are below CRC's 300 dpi print minimum.
  Full status, plan, and per-image checklist: `issues/image-quality/CMYK-colors.md`
  (status summary), `issues/image-quality/cmyk-conversion-plan.md` (8-step
  implementation plan), `issues/image-quality/CMYK-checklist.md` (per-image DPI/CMYK
  checklist, ~90 rows), `issues/image-quality/cmyk-image-audit-results.csv` (latest
  audit data), `issues/image-quality/email-CRC-cmyk.md` (CRC's requirements reply:
  ICC profile US Web Coated SWOP, PNG/JPG fine, 300 dpi minimum).

  Latest audit (`cmyk-image-audit-results.csv`, run 2026-07-16 — rerun to refresh):
  85 raster images actually used in the PDF, **0/85 converted to CMYK** (82 sRGB,
  3 Gray), **69/85 flagged LOW-DPI** (below 300 dpi at their largest used print size).

  - [x] Resolve the 69 LOW-DPI images --- 64 done, 1 accepted, 4 special cases (2026-11-23)
  - [ ] Run the conversion script (`cmyk-conversion-plan.md` step 5) to produce
        `images-cmyk/` from the RGB originals --- Gavin
  - [ ] ~~Wire up the `img_path()` helper~~ → Lua filter instead (`cmyk-next-steps.md`) --- Gavin
  - [ ] Confirm 0 RGB images in the PDF after conversion (`pdfimages -list`) --- Gavin
  - [ ] Final verification pass: Ghostscript ink-coverage check + Acrobat Pro
        Separations panel on the submission-ready PDF (`cmyk-conversion-plan.md` step 7)

### Permissions: send requests, track responses, resolve the TFQ, submit to CRC

  (2026-08-25) Full write-up, history, and the step-4 contact research live in
  `production/task-permissions.md`; the working spreadsheet is
  `production/permissions-tracking.csv`; the original audit trail is
  `production/fig-permission-list.md`. Execution was handed off to Gavin on
  2026-08-23 (see "Gavin tasks" at the end of `task-permissions.md`).

  - [ ] Send the 6 "Ready to apply — publisher permissions systems" requests
        (Springer, Hachette, SAGE, O'Reilly, Princeton UP — CCC/RightsLink or a
        publisher permissions-page form)
  - [ ] Send the remaining direct-contact requests (individual authors/creators,
        including the two `wheres-waldo.png` contacts, sent anyway despite the
        high-risk flag per MF's call)
  - [ ] Chase a firmer contact for `DataSaurusDozen.gif` (Autodesk Research/Matejka —
        currently LinkedIn-only) and for `tesseract.gif`/`tesseract-frames.png`
        ("ediacura" on YouTube — no contact found yet, check the video's About tab)
  - [x] Raise the two CRC-owned book covers (`Rennie-cover.png`, `Unwin-GmooG.webp`)
        with the T&F Editorial Assistant directly — internal, not an external request.
        DONE 2026-10-27: T&F editor ruled all book covers NPR (no permission required)
  - [ ] Record `applied_date`/`contact`/`status`/`doc_path` in
        `permissions-tracking.csv` as responses land (evidence under
        `production/permissions/`)
  - [x] Get T&F's ruling on the 1 `[TFQ]` row (`images/MV-juicer.png`, untraceable
        clipart) and resolve it to NPR / permission-required / replace.
        Ruling 2026-10-27: remove or replace if the clipart sources can't be traced.
        DONE 2026-10-27: replaced by `images/MV-juicer-gpt.png` (ChatGPT), row set to NPR
  - [ ] Compile the final Permissions Summary file for CRC/T&F submission once the
        above is done (see "T&F Submission" in `task-permissions.md`)

### License for the online (HTML) edition -- waiting on the editor

(2026-10-27) The HTML book carries no reuse licence, and the existing footer
(`_quarto.yml:102`, `page-footer: "Copyright 2024, Michael Friendly"`) never shows: it is at the
top level, and Quarto only reads `page-footer` under `book:`.

Proposal, sent to the editor for feedback (also check the CRC contract):

- Text and the author's own figures: **CC BY-NC-ND 4.0** (attribution, non-commercial, no
  derivatives). Alternative: CC BY-NC-SA 4.0, if adapting figures for teaching should be allowed.
  Precedents: *Geocomputation with R* (CRC) uses BY-NC-ND; *Advanced R* (CRC) uses BY-NC-SA.

- Third-party material (Waldo, permissioned figures) explicitly **excluded** from the licence.

- R code under the **MIT** licence.

Draft notice (Preface or Colophon, HTML only):

> The online version of this book is free to read. © 2026 Michael Friendly. The text and the
> author's own figures are licensed under a Creative Commons Attribution-NonCommercial-NoDerivatives
> 4.0 International License (CC BY-NC-ND 4.0). Figures and other material from other sources are
> excluded and remain the property of their copyright holders, as noted in their captions. The R
> code in the book is available under the MIT License.

Notes on BY-NC-SA vs. getting proper credit (2026-10-27):

- BY-NC-SA 4.0 lets anyone share and adapt for non-commercial purposes, if they give credit
  (BY) and release adaptations under the same licence (SA). Irrevocable; MF can still license
  differently to others (e.g. CRC for print).

- Attribution is required "in any reasonable manner", and the licensor may specify it. So the
  notice should include a "Please cite as" line, which makes that citation a condition for text
  and figures: "Friendly, M. (2026). *Visualizing Multivariate Data and Models in R*. CRC Press.
  https://friendly.github.io/Vis-MLM-book/"

- Code: MIT only requires keeping the copyright notice in substantial copies, not a citation.
  CC licences are not recommended for software, and NC would block use at work. Proposal: MIT
  plus a (non-binding) request to cite the book in published work that uses the code.

  - [ ] Get the editor's feedback on the licence (and whether the contract specifies one) --
        MF is first asking the editor the general question (is a CC licence for the HTML
        edition OK, and which one?) before proposing the specifics above

  - [ ] Move `page-footer` under `book:` with the year and a CC badge:
        "© 2026 Michael Friendly · CC BY-NC-ND 4.0" (linking to the licence)

  - [ ] Add the licence notice, in a `.content-visible when-format="html"` block

  - [ ] Re-render HTML

### Indexing: subject-index coverage + supporting cleanup

  (2026-08-25) `\index{}` entries have been started but coverage is uneven across
  chapters (per project `CLAUDE.md`: "being added incrementally; systematic pass still
  needed"). Work log and per-chapter entry counts: `issues/indexing/subject-index.md`.
  Also in `issues/indexing/`: `duplicate-index-entries.md` (mixed-mechanism duplicate
  fix, applied 2026-07-01), `missing-func-scan.md` (bare `` `func()` `` refs not yet
  converted to `` `r func("func()")` `` so they generate index entries), `authorindex-style.md`,
  `package-formatting.md` (package-name index macro reference), plus the
  extraction/plotting tooling (`idx_terms.R`, `index-add-chapters.R`, `index-plots.R`,
  `index-distribution.R`).

  Work-log status: **5 of ~15 chapters indexed so far** (Ch 08, 10, 12, 13, 14 —
  2026-06-30/07-01). Ch 15 (case-studies appendix) and Ch 21 (discriminant analysis,
  printed Ch 15) haven't been started at all; Ch 01, 02, 06, 07, 11 have lighter manual
  coverage than the recommended workflow targets (see entry-count table in
  `subject-index.md`).

  - [ ] Index Ch 15 (case-studies appendix) and Ch 21 (discriminant analysis) — currently
        no manual `\ix{}` entries
  - [ ] Continue the chapter-by-chapter pass on the lighter chapters (01, 02, 06, 07, 11),
        following `subject-index.md`'s recommended workflow
  - [ ] Work through `missing-func-scan.md`'s flagged bare `` `func()` `` references,
        converting to `` `r func("func()")` `` where appropriate
  - [ ] Final systematic pass once every chapter has a first index pass (the
        `Tasks-Issues.md` Priority 7 item this supersedes)
