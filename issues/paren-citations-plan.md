# Plan: Fix Parenthesized Narrative Citations `(@key)` → `[@key]`

**Status: RESOLVED — STAGE 2 COMPLETE 2026-07-11** — all `OK` rows from the reviewed
inventory in `issues/paren-citations.md` applied on the `citation-fixes` branch (22 edits;
row 3 was already fixed in the source). Deviations from the plan, per GK: work done on the
existing `citation-fixes` branch rather than a fresh one. Build verification completed
2026-07-11: full rebuild (`./build.sh --all --authorindex` + fix-index pass) succeeded and
the rendered-HTML symptom grep found zero doubled citations. The detection
grep was re-run post-fix: only row 9 (Cat. E, intentional) and row 26 (dead file
`04b-higher.qmd`, no decision) still match. Rows 26–27 (dead files) remain unfixed.
Cross-referenced in `issues/GK-June3-issues.md`.

## The problem

Throughout the book, some citations are written as a *bare* (narrative) citation wrapped
in literal parentheses, e.g. in `01-Prelude.qmd` line 52:

```markdown
college courses (@Costelloe:1915).
```

Pandoc renders the bare `@key` in narrative style — "Costelloe (1915)" — and the typed
parentheses then wrap it, producing the doubled form **"(Costelloe (1915))"** in both HTML
and PDF. The correct source for a parenthetical citation uses square brackets, letting the
APA CSL style supply the parentheses:

```markdown
college courses [@Costelloe:1915].     → (Costelloe, 1915)
```

Prior history: two instances were hand-fixed on 2026-06-03 (`13-eqcov.qmd:552`,
`14-infl-robust.qmd:31` — see `issues/GK-June3-issues.md`), and a broader cleanup was
deferred. A scan on 2026-07-09 found **~24 remaining instances** across 12 files.

## Fix categories

Not every instance gets the same treatment, which is why a human review stage is required:

| Category | Example | Fix |
|----------|---------|-----|
| **A. Mechanical** | `(@Tufte:83)` | `[@Tufte:83]` |
| **B. Prefix moves inside brackets** | `(e.g., @Gittins:85)` | `[e.g., @Gittins:85]` |
| **C. Multi-cite, fix separator too** | `(@Yee2015, @R-VGAM)` | `[@Yee2015; @R-VGAM]` — Pandoc requires `;` between keys |
| **D. Complex suffix/prose in parens** | `("AV plot", also called _partial regression_ plot, @MostellerTukey-1977)` | Judgment call: either bracket the whole thing or restructure the sentence |
| **E. Leave alone (intentional narrative)** | `(the @PineoPorter2008 prestige score for ...)` | Citation used as a noun inside a parenthetical remark; "Pineo & Porter (2008)" is grammatically intended |

Note: `[-@key]` (suppressed-author, e.g. `McLachlan's [-@McLachlan2004]`) and
cross-references like `(@fig-...)`, `(@sec-...)`, `(@exm-...)` are **correct** Quarto
syntax and must be excluded from detection.

## Stage 1 — Detect and inventory (Claude, no edits to book text)

1. Run the detection scan over all book source files:

   ```bash
   grep -nE '\([^()]*@[A-Za-z][^)]*\)' *.qmd child/*.qmd summary/*.qmd \
     | grep -vE '@(fig|tbl|sec|eq|exm|exr|lst|def|thm)-' \
     | grep -v 'vis.social'          # excludes a Mastodon URL false positive
   ```

   Supplement with a second pass for citations that span a line break inside
   parentheses (the single-line grep misses these): search for `\(` ... `@` spanning
   two lines, or simply grep rendered `docs/*.html` for the symptom pattern
   `[A-Za-z] \(\d{4}\)\)` as a cross-check.

   *Verified 2026-07-09:* the multiline pass was run and found **zero** target-pattern
   instances spanning line breaks (one multiline hit already uses correct `[@...]`
   brackets), so the single-line grep currently has full recall on the sources. Re-run
   both passes fresh in Stage 1 anyway, since text will have changed.

2. Write every hit to **`issues/paren-citations.md`** as a review table, one row per
   instance, with columns:

   | # | File:line | Current source text | Proposed fix | Category | Decision |
   |---|-----------|--------------------|--------------|----------|----------|

   - **Proposed fix** shows the exact replacement string.
   - **Category** is A–E per the table above; Category E rows are pre-marked
     "recommend: leave as is".
   - **Decision** is left blank for GK / Michael to fill in: `OK` / `skip` / or an
     edited replacement.

3. Flag known wrinkles in the inventory file:
   - `04b-higher.qmd:167` and `04-multivariate_plots.qmd:2652` contain the *same*
     sentence (`following @VanderPlas2023`). Determine which file is actually included
     in the build (check `_quarto.yml` / child includes) — fix the real source; note
     whether the other is dead text.
   - `11-mlm-review.qmd:22` (`(@Yee2015, @R-VGAM)`) — comma between keys renders
     incorrectly even after bracketing; must become `;` (Category C).

4. Stop. **No book text is edited in Stage 1.**

## Review gate (GK + Michael)

- Review `issues/paren-citations.md`; fill in the Decision column.
- Special attention to Category D and E rows — these change sentence structure or are
  intentionally narrative.
- Give Claude the go-ahead for Stage 2 (fixes applied only to rows marked `OK` or with
  an edited replacement).

## Stage 2 — Fix (Claude, after go-ahead)

1. Work on a fresh branch (e.g. `fix-paren-citations`).
2. Apply each approved row with exact-string edits (Edit tool, not blind sed — several
   patterns are near-duplicates and context matters).
3. Update the Decision column in `issues/paren-citations.md` to `FIXED <date>` per row.
4. Verify:
   - Re-run the Stage 1 detection grep → only `skip`/Category-E rows remain.
   - Render at least one affected chapter to HTML and confirm citations now appear as
     "(Author, Year)"; grep rendered HTML for the doubled pattern `\(\d{4}\)\)` as a
     smoke test.
   - Full `Build -> All Formats` before the next PDF submission (per CLAUDE.md, HTML-only
     builds leave `docs/` inconsistent).
5. Cross-reference the fix in `issues/GK-June3-issues.md` (the "broader scan ... not yet
   done" bullet) and mark this plan **RESOLVED**.

## Current instance inventory (scan of 2026-07-09, for reference)

24 instances found (excluding cross-refs and URL false positive):

| File | Lines |
|------|-------|
| `index.qmd` | 362 |
| `01-Prelude.qmd` | 52 (two instances on one line) |
| `03-getting_started.qmd` | 26 |
| `04-multivariate_plots.qmd` | 341, 343, 355, 385, 938 (Cat. E), 2652 |
| `04b-higher.qmd` | 167 (duplicate of 04:2652) |
| `05-pca-biplot.qmd` | 1835, 1980 |
| `06-linear_models.qmd` | 91 |
| `07-linear_models-plots.qmd` | 733 (Cat. D), 954 (Cat. D) |
| `09-collinearity-ridge.qmd` | 60, 824 |
| `11-mlm-review.qmd` | 22 (Cat. C), 2071 |
| `12-mlm-viz.qmd` | 674 |
| `21-discrim.qmd` | 209, 882, 970 |

Line numbers will drift as other edits land; Stage 1 re-runs the scan fresh and the
review file is built from that run, not from this table.
