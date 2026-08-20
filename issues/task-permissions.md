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

## What the script does

`issues/build-permissions-csv.R` does **not** re-derive copyright status — that
judgment already lives in `issues/fig-permission-list.md` (step 1 + 3, done by GK).
It only:

- Parses the "Permission required" and "Verify before deciding" tables at the end of
  that file (skipping the one now-resolved strikethrough entry, `images/1D-4D.png`).
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
| `copyright_status` | script, from `fig-permission-list.md` | `permission_required` or `verify` |
| `rightsholder_or_route` | script, from `fig-permission-list.md` | likely rightsholder / route, or what to verify |
| `necessary` | manual | step 2 — is the third-party figure actually needed? |
| `applied_date`, `applied_by`, `contact` | manual | step 4 |
| `received_date`, `doc_path` | manual | step 5 — `doc_path` should point to the saved permission evidence |
| `submitted_date` | manual | step 6 |
| `status` | manual | overall row status; script initializes every row to `not started` |
| `notes` | script (from table), then manual | free text |

### Known gaps (fill in manually)

- 6 rows have no `fig_label`: 5 book-cover images embedded as plain `<img>` tags in
  `index.qmd` (Preface — not numbered Quarto figures) and
  `images/history/hertzsprung1-annotated.jpg` (same, Ch. 1 milestones montage).
- The 7 `verify` rows aren't necessarily third-party at all — resolve authorship/
  license first (per `fig-permission-list.md`'s "Verify before deciding" notes);
  most will drop out of the permission-required set entirely once resolved.
- ~~`images/Cover-GEB.png` appears identically in both `04-multivariate_plots.qmd`
  and `child/04-grand-tour.qmd`~~ — resolved 2026-08-20: `child/04-grand-tour.qmd`
  was an orphaned file (its content was fully duplicated into
  `04-multivariate_plots.qmd`, not `{{< include >}}`d — confirmed no `.qmd` in the
  book actually includes it). Removed the duplicate `fig-cover-GEB2` chunk from the
  child file; it now appears once per real chapter (Ch. 2 and Ch. 4).

## Status

- [x] Build `issues/build-permissions-csv.R` and generate `issues/permissions-tracking.csv`
- [ ] Resolve the 7 `verify` rows (authorship/license) — most likely become NPR

  GK: See `issues/verify-NPR.R` for a small filter/select script

- [ ] Fill in `necessary` (step 2) for every `permission_required` row
- [ ] Work through step 4 (apply) for rows confirmed necessary
- [ ] Record evidence (step 5) and submission (step 6) as they land
