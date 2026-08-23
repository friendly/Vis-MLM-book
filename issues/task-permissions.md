# Third-party image permissions

Tracks work on clearing third-party figures for CRC/Taylor & Francis submission, per
`production/Permissions_guide.pdf`. The guide's process:

1. Identify third-party material
2. Confirm that third-party material is necessary
3. Determine copyright status of third-party material
4. Apply for permission
5. Document permission
6. Submit permission

## History

- **2026-06-30 (GK):** First pass, `issues/fig-permission-list.md` — prose list of
  candidate third-party figures through Ch. 8, by chapter.
- **2026-07-08 (GK):** Re-assessed every entry against the Permissions guide; tagged
  each as `[NPR]` (no permission required, with a documented basis — public domain,
  CC license, or author-generated-from-data) or left untagged. Added two consolidated
  tables at the end of the file: "Permission required" (18 figures) and "Verify before
  deciding" (8 figures, authorship/license unresolved).
- **2026-08-20:** `issues/fig-permission-list.md` is prose and doesn't carry
  per-request tracking fields (contact, dates, doc paths). Built
  `issues/build-permissions-csv.R` to turn it into a working dataset,
  `issues/permissions-tracking.csv`, that can carry status through steps 2–6 above.
- **2026-08-20:** Resolved the `images/corrgram-renderings.png` "verify" row. It isn't
  from Kevin Wright's **corrgram** package vignette (no match there). The image was
  added in commit `dcaf1f4f`, the same commit that wrote the @sec-corrgram text citing
  `@Friendly:02:corrgram` (Friendly 2002, *The American Statistician* 56(4):316–324) —
  GK confirmed it is in fact a figure from that paper. Per guide rule 6, sole MF
  authorship doesn't make it NPR; it needs the same journal reuse-rights check as
  `images/ridge-demo.png` (ASA/T&F, since T&F already publishes *The American
  Statistician* for ASA). Updated `fig-permission-list.md`'s Ch. 4 entry and "Verify
  before deciding" table accordingly and regenerated the CSV.
- **2026-08-23:** Resolved the `images/weight-functions.jpg` (`fig-weight-fns`, Ch. 14)
  "verify" row — MF confirmed he drew the hand-drawn sketch himself, so it's original
  work with no third-party material. Tagged `[NPR]` in `fig-permission-list.md`'s Ch. 14
  entry, struck the row in the "Verify before deciding" table, and regenerated the CSV
  (drops out entirely — NPR images aren't tracked there). 6 `verify` rows remain.
- **2026-08-23:** Resolved the `images/techniques-table.png` (`fig-techniques`, Ch. 6)
  "verify" row — MF confirmed he made the table himself. Tagged `[NPR]` in
  `fig-permission-list.md`'s Ch. 6 entry, struck the row in the "Verify before deciding"
  table, and regenerated the CSV. 5 `verify` rows remain.
- **2026-08-23:** Resolved the `images/history/hertzsprung1-annotated.jpg` (Ch. 1)
  "verify" row — it was already `[NPR]` in the Ch. 1 entry, with the UK/EU life+70
  caveat (Hertzsprung d. 1967, term runs to 2038) fully documented there; the "verify"
  table row was just a leftover reminder to carry that caveat into the T&F permissions
  log, not an unresolved question in this repo. Struck the row and regenerated the CSV.
  4 `verify` rows remain.
- **2026-08-23:** Resolved the `images/cancor-diagram-udi.png` (`fig-cancor-diagram`,
  Ch. 12) "verify" row — MF decided the substantially-transformed-redraw claim over CC
  BY-SA attribution: Udi Alter's redraw takes only the geometric concept (angle between
  variates) from the Cross Validated discussion, not the original's expression, and
  counts as a new work under the guide's footnote 1. Courtesy credit to the original
  author, user 'ttnphns', was already in the caption. Tagged `[NPR]` in
  `fig-permission-list.md`'s Ch. 12 entry, struck the row in the "Verify before
  deciding" table, and regenerated the CSV. 3 `verify` rows remain.
- **2026-08-23:** Resolved the `images/ridge-demo.png` (Ch. 9) and
  `images/corrgram-renderings.png` (Ch. 4) "verify" rows together — MF verified both
  against their journals' author-reuse policies: ASA/T&F journal authors generally
  retain the right to reuse their own figures/tables in future non-commercial works
  (including a book they author or edit) without formal permission, given full
  attribution; IMS/*Statistical Science* authors similarly retain the right to reuse
  their own figures in subsequent scholarly work with proper citation. Both captions
  already cite the original publication (`@Friendly:02:corrgram`,
  `@Friendly-etal:ellipses:2013`). Tagged both `[NPR]`, struck both rows in the
  "Verify before deciding" table (and dropped the now-moot `corrgram-renderings.png`
  regeneration note from "Action items"), and regenerated the CSV. 1 `verify` row
  remains.
- **2026-08-23:** Resolved the last "verify" row, `images/MV-juicer.png` (`fig-MV-juicer`,
  Ch. 5), but not as NPR or permission-required — MF has no record of the individual
  clipart elements' source, they aren't watermarked, but per guide rule 2 that isn't
  proof of public domain, and a reverse image search isn't guaranteed to be conclusive.
  Rather than claim NPR on an assumption or block indefinitely on an unresolvable
  search, introduced a third status, **`[TFQ]`** ("question for T&F"): due diligence is
  recorded, but the copyright call is left to the publisher. Added a caption source note
  ("Source: Author image, using publicly available clipart") to `fig-MV-juicer` in
  `05-pca-biplot.qmd` so the flag is visible in the book text too, not just this log.
  Added a "Flagged for T&F (TFQ)" consolidated table to `fig-permission-list.md`
  (parallel to "Permission required"/"Verify before deciding"), taught
  `build-permissions-csv.R` to parse it (`copyright_status = "TFQ"`, `status` initializes
  to `"flagged for T&F"` instead of `"not started"`), and regenerated the CSV. All 7
  "verify" rows tracked since the CSV was built are now resolved: 6 became `[NPR]`, 1
  became `[TFQ]`. 0 `verify` rows remain.

## What the script does

`issues/build-permissions-csv.R` does **not** re-derive copyright status — that
judgment already lives in `issues/fig-permission-list.md` (step 1 + 3, done by GK).
It only:

- Parses the "Permission required", "Verify before deciding", and "Flagged for T&F
  (TFQ)" tables at the end of that file (skipping resolved/strikethrough entries).
- Cross-references each filename against every `.qmd` file (`include_graphics()`,
  `here::here("images", "...")`, `<img src=...>`, and pandoc `![...](images/...)`
  syntax, skipping HTML comment blocks) to recover the chapter, the figure's
  `fig-*` label, and a source/attribution string pulled from `fig-cap`/alt text.
- Writes one row per **occurrence** (a filename reused across chapters, e.g.
  `images/Cover-GEB.png` in both Ch. 2 and `child/04-grand-tour.qmd`, gets one row
  each) to `issues/permissions-tracking.csv`.

Run with `Rscript issues/build-permissions-csv.R`. Safe to re-run after editing
`fig-permission-list.md` — it fully regenerates the CSV, so **manual status edits
made directly in the CSV will be overwritten**. Until there's a need to preserve
in-progress status across regeneration, do the edits in the CSV and don't re-run the
script casually; if regeneration is needed later, re-merge tracked rows by
`filename` first.

### CSV columns

| Column | Filled by | Meaning |
|---|---|---|
| `chapter`, `fig_label`, `filename`, `qmd_file`, `qmd_line` | script | where the figure lives — `chapter` is the source `.qmd` filename (sorts by chapter number; note file-name prefixes and printed chapter numbers diverge for Ch. 15 / the online-only appendix, per project `CLAUDE.md`) |
| `source` | script (best-effort) | attribution text extracted from the caption/alt text |
| `copyright_status` | script, from `fig-permission-list.md` | `permission_required`, `verify`, or `TFQ` (question for T&F — diligence done, status unresolvable from this end) |
| `rightsholder_or_route` | script, from `fig-permission-list.md` | likely rightsholder / route, what to verify, or `"flagged for T&F"` |
| `necessary` | manual | step 2 — is the third-party figure actually needed? |
| `applied_date`, `applied_by`, `contact` | manual | step 4 |
| `received_date`, `doc_path` | manual | step 5 — `doc_path` should point to the saved permission evidence |
| `submitted_date` | manual | step 6 |
| `status` | manual | overall row status; script initializes to `not started` (`flagged for T&F` for `TFQ` rows) |
| `notes` | script (from table), then manual | free text |

### Known gaps (fill in manually)

- 5 rows have no `fig_label`: book-cover images embedded as plain `<img>` tags in
  `index.qmd` (Preface — not numbered Quarto figures).
- No `verify` rows remain. 1 `TFQ` row (`images/MV-juicer.png`, Ch. 5) is genuinely
  unresolved and stays that way pending T&F's answer — see the "T&F Submission" section
  below.
- ~~`images/Cover-GEB.png` appears identically in both `04-multivariate_plots.qmd`
  and `child/04-grand-tour.qmd`~~ — resolved 2026-08-20: `child/04-grand-tour.qmd`
  was an orphaned file (its content was fully duplicated into
  `04-multivariate_plots.qmd`, not `{{< include >}}`d — confirmed no `.qmd` in the
  book actually includes it). Removed the duplicate `fig-cover-GEB2` chunk from the
  child file; it now appears once per real chapter (Ch. 2 and Ch. 4).

## Status

- [x] Build `issues/build-permissions-csv.R` and generate `issues/permissions-tracking.csv`
- [x] Resolve the 7 `verify` rows (authorship/license) — 6 became `[NPR]`, 1 became `[TFQ]`
- [ ] Fill in `necessary` (step 2) for every `permission_required` row
- [ ] Work through step 4 (apply) for rows confirmed necessary
- [ ] Record evidence (step 5) and submission (step 6) as they land
- [ ] Get T&F's ruling on the 1 `TFQ` row (`images/MV-juicer.png`) and resolve it to NPR/permission-required/replace
- [ ] Compile the Permissions Summary file for CRC/T&F (see "T&F Submission" below)

## T&F Submission

`issues/fig-permission-list.md` and `issues/permissions-tracking.csv` are internal
working files — the audit trail and the tracking spreadsheet. Neither is meant to go to
the publisher as-is. Decided 2026-08-23 (MF): a separate **Permissions Summary** file
will be compiled once the tracking work here is essentially done, and submitted to
CRC/T&F alongside the manuscript, documenting the permissions status of every
third-party (and TFQ) image in one place for their review.

**Rationale:** this project's due-diligence process — checking actual license tags
rather than assuming, distinguishing genuine public domain from "just not watermarked,"
documenting substantial-transformation claims, verifying journal author-reuse policies
rather than assuming sole authorship is enough — is already more thorough than what most
authors submit. But diligence has a limit: some questions (like the untraceable
`MV-juicer.png` clipart) are legitimately the publisher's call, not something an author
can resolve alone. The `[TFQ]` status exists for exactly that boundary — flag it clearly,
with the history, and let T&F decide, rather than the author guessing at NPR or stalling
indefinitely on an unresolvable search.

**When to compile:** near the end, once the `permission_required` rows have actually
been applied for (or replaced/dropped) and the `TFQ` row has either been answered by T&F
or is being submitted *as* the open question.

**Likely contents** (derived from `permissions-tracking.csv`, not hand-maintained
separately): figure, chapter, one-line status (cleared/NPR with basis, permission
obtained with doc reference, or open TFQ question), and — for the `TFQ` row(s)
specifically — the explicit question being put to T&F, matching the in-book caption note
(e.g. `fig-MV-juicer`'s "Source: Author image, using publicly available clipart").
