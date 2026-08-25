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
  
- **2026-08-23:** Resolved step 2 (necessary) for the whole tracked set — MF's call:
  every figure reused in the book illustrates a specific point made in the text (none
  are decorative), so none are candidates for dropping on necessity grounds alone;
  nothing gets deleted to shrink the permission list. Rather than hand-fill 21 identical
  `necessary` cells that would be wiped on the next regeneration, changed
  `build-permissions-csv.R` to default `necessary = "Y"` for every row. Regenerated the
  CSV to confirm (21/21 rows `Y`).

- **2026-08-23:** Researched step-4 contact routes for all 20 `permission_required` rows
  (17 distinct rightsholders/routes, since `Cover-GEB.png` and the `datasauRus`-derived
  pair each fold to shared contacts). Added a `route` column to
  `build-permissions-csv.R`'s schema (manual, like `contact`) and hand-filled both from
  the research: publisher permissions systems (CCC/RightsLink, publisher forms) where
  available, direct contacts (email, LinkedIn, ResearchGate, contact forms) otherwise,
  `internal-T&F` for CRC Press's own titles, `regenerate-instead` where a CC0 data
  alternative sidesteps the request entirely, and `manual-followup-needed` where no
  contact could be found by automated search. Full write-up in "Permission requests"
  below.

- **2026-08-23:** Two calls from MF that change the step-4 plan:
  (1) not regenerating the Datasaurus Dozen images (`DataSaurusDozen.gif`,
  `datasaurus-dozen.jpg`) even though the CC0 `datasauRus` data would allow it — pursuing
  permission instead, so both move out of "regenerate" and into "Ready to apply" /
  "Nearly ready to apply" depending on how solid their contact is; (2) not dropping
  `wheres-waldo.png` despite the high-risk flag — proceeding with the request anyway so
  the diligence is on record either way, even if it's slow or refused. Updated
  `fig-permission-list.md` (Ch. 3 and Ch. 9 entries + both consolidated-table rows) and
  `permissions-tracking.csv` (`route`/`contact`) accordingly, and restructured
  "Permission requests" below to match. MF is handing step 4 execution off to Gavin from
  here — see "Gavin tasks" at the end of this file.

- **2026-08-25:** MF asked for a route breakdown for a note to his CRC/T&F editor: of the
  20 `permission_required` rows, 6 go through a formal publisher system (RightsLink/CCC
  or a permissions-page form) and 11 require contacting an individual directly, with 2
  internal (T&F's own titles) and 1 piggyback (`books.jpg`) not fitting either bucket.
  Added as "Summary by route" at the top of "Permission requests" below.

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
| `necessary` | script, defaults `"Y"` | step 2 — every tracked figure is judged necessary (decided 2026-08-23, MF: each illustrates a specific point in the text); override by hand for a genuine individual exception |
| `route`, `contact` | manual (from research) | step 4 — `route` is one of `CCC`, `publisher-page`, `direct-contact`, `internal-T&F`, `nearly-ready` (a contact exists but isn't a confirmed email/response channel), `manual-followup-needed`; `contact` is the actual email/URL/note. See "Permission requests" below |
| `applied_date`, `applied_by` | manual | step 4 |
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
- [x] Resolve `necessary` (step 2) — every row defaults `Y`; none dropped
- [x] Research step 4 contact routes for every `permission_required` row — see "Permission requests"
- [x] Decide the Datasaurus (no regenerate) and Waldo (request anyway) open questions — MF, 2026-08-23
- [ ] Handed off to Gavin (2026-08-23) — work through step 4 (apply) per "Gavin tasks"
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

## Permission requests

Step-4 contact research (2026-08-23), one row per rightsholder — full detail lives in
`permissions-tracking.csv`'s `route`/`contact` columns; this is the actionable summary.
Fig numbers are from the current HTML build (`docs/*.html`); a few Preface items are
plain `<img>` tags with no Quarto figure number.

### Summary by route (2026-08-25, for MF's editor correspondence)

Counting the 20 `permission_required` rows (the 1 `[TFQ]` row is a separate question for
T&F, not a rightsholder request):

| Category | Count | Rightsholders |
|---|---|---|
| **Formal publisher system** (RightsLink/CCC, or a publisher's own permissions-page form) | **6** | Springer, SAGE, O'Reilly, Princeton UP, Hachette (Basic Books — used twice, `Cover-GEB.png`, counted once as a rightsholder) |
| **Direct contact with an individual** (author, blogger, or content creator — email, LinkedIn, contact form, etc.) | **11** | Selçuk Korkmaz, Gabriel Rodrigues, Ou Zhang, Tomio Kobayashi, Tomàs Aluja-Banet, Arndt Regorz, Gayan De Silva, Martin Handford/Walker/Candlewick (Waldo), Autodesk Research/Matejka, "ediacura" (YouTube — used twice, `tesseract.gif`+`tesseract-frames.png`, counted once) |
| **Internal — T&F's own titles**, not an external request | 2 | Rennie, Unwin covers |
| **No separate request** | 1 | `books.jpg` montage, piggybacks on the 4 book-cover permissions |

So: **6 go through a formal publisher/RightsLink-style process, 11 require contacting an
individual directly** (5 distinct rightsholders in the formal-system bucket, 10 distinct
individuals/parties in the direct-contact bucket, once the two duplicated figures are
collapsed to one contact each).

### Ready to apply — publisher permissions systems (CCC/RightsLink or a permissions page)

| Fig | Figure | Rightsholder | Contact |
|---|---|---|---|
| 1.7 | `ReavenMiller-3d-annotated.png` | Springer (*Diabetologia*, 1979) | RightsLink via the article's "Reprints and Permissions" link on link.springer.com; CCC support springernaturesupport@copyright.com |
| 2.3 / 4.41 | `Cover-GEB.png` (used twice) | Basic Books / Hachette | Permission request form (hachettebookgroup.com) → permissions.Generic@hbgusa.com; expect a fee, multi-week turnaround |
| 9.3 | `collin-demo.png` | SAGE Publications | RightsLink via us.sagepub.com/en-us/nam/books-permissions |
| — | `Wilke-FundamentalsOfDataVis.png` (Preface) | O'Reilly Media | copyright.com, or +1 (707) 827-7000 |
| — | `healy-dava-vis-cover-pupress.jpg` (Preface) | Princeton University Press | Online form: press.princeton.edu/resources/permissions (2–4 wk) |

### Ready to apply — direct email/contact confirmed

| Fig | Figure | Rightsholder | Contact |
|---|---|---|---|
| 9.1 | `collinearity-diagnostics-SPSS.png` | Arndt Regorz | mail@regorz-statistik.de |
| 4.8 | `mahalanobis.png` | Ou Zhang | ouzhang.rbind.io/contact, or X/Twitter @zhangou888 |
| 4.52 | `big5-qgraph-rodrigues.png` | Gabriel R. Rodrigues | Contact form at reisrgabriel.com |
| 5.30 | `image-compression-SVD.png` | Tomio Kobayashi | LinkedIn (linkedin.com/in/tomio-kobayashi-9869ba30/) — no email found; source Medium post blocked automated fetch |
| 5.17 | `pca4ds-figure-2-11.png` | Tomàs Aluja-Banet (per MF: contact first author directly) | Professor of Statistics, EIO Dept., UPC BarcelonaTech. No direct email confirmed (`imp.upc.edu` profile 404'd); try LinkedIn (linkedin.com/in/tomas-aluja-b0b24713/) or the EIO department contact page. Site states "© 1998-2020 ... All Rights Reserved" — permission genuinely required |
| 12.3 | `iris-diagram.jpg` | Gayan De Silva (per MF: track down via the DOI) | DOI `10.13140/RG.2.2.14790.14406` resolves to a **ResearchGate self-upload**, confirming `publisher = Unpublished` — De Silva is the rightsholder directly, no publisher intermediary. Contact via his ResearchGate profile (researchgate.net/profile/Gayan-De-Silva) |
| 3.x (PDF only) | `datasaurus-dozen.jpg` | Selçuk Korkmaz (X post; underlying art: Autodesk Research) | selcuk.korkmaz@hacettepe.edu.tr. MF decided 2026-08-23 not to regenerate from the CC0 `datasauRus` data — pursuing permission instead |
| 9.2 | `wheres-waldo.png` | Martin Handford / Walker Books / Candlewick | Candlewick permissions@candlewick.com; Walker Books UK permissions@walker.co.uk (both ~6-week, formal-license processes). **High risk** — commercially-owned character art, permission may be slow/expensive/refused — but MF decided 2026-08-23 to request anyway rather than drop the figure. Send to both; document whatever comes back either way |

### Nearly ready to apply — contact needs manual completion

| Fig | Figure | Rightsholder | Note |
|---|---|---|---|
| 3.2 | `DataSaurusDozen.gif` | Autodesk Research (Matejka & Fitzmaurice) | No confirmed email found for Autodesk Research or Matejka. Best available contact is Justin Matejka's LinkedIn (linkedin.com/in/justinmatejka/) — send a connection/message request there, or keep searching for a direct email before falling back to LinkedIn. MF decided 2026-08-23 not to regenerate from the CC0 `datasauRus` data — pursuing permission instead |

### Internal — raise with T&F editor, no external request

| Fig | Figure | Rightsholder | Note |
|---|---|---|---|
| — | `Rennie-cover.png` (Preface) | CRC Press | `bib/references.bib` confirms `publisher = CRC Press` for `Rennie2025` — T&F's own title |
| — | `Unwin-GmooG.webp` (Preface) | CRC Press / T&F | Same situation — T&F's own title |

### Needs manual follow-up — no automated contact found

| Fig | Figure | Rightsholder | Note |
|---|---|---|---|
| 1.3 | `tesseract.gif` + `tesseract-frames.png` | "ediacura" (YouTube) | WebFetch can't render YouTube's channel page (JS-heavy); check the video's "About" tab by hand: youtube.com/watch?v=5xN4DxdiFrs |

### No separate request needed

`images/icons/books.jpg` (Preface montage) is covered by the four individual book-cover
permissions above (Wilke, Healy, Unwin, Rennie) — no fifth request.

## Gavin tasks

Handoff point (2026-08-23, MF): the identification, categorization, and contact research
above is as far as MF is taking this for now. Everything from here is send-the-requests-
and-track-the-results — over to Gavin.

**For every request sent:** use the guide's permission email template
(`production/Permissions_guide.pdf`, p. 6) where a direct email applies, always including
the required rights language — *"commercial, non-exclusive, worldwide English language
rights in all forms and media, including print and eBook form, for the lifetime of the
edition."* Afterward, record in `permissions-tracking.csv`: `applied_date`, `applied_by`,
and confirm/update `contact` with the actual address or route used; set `status` (suggest
`applied` → `granted` / `denied` / `no response`). When a permission comes back, save the
evidence (email, signed form, confirmation page) somewhere under `issues/` — a new
`issues/permissions/` folder would work — record its path in `doc_path`, the
`received_date`, and `submitted_date` once it goes in with the manuscript. Don't re-run
`build-permissions-csv.R` once requests are in flight — it regenerates the whole CSV from
`fig-permission-list.md` and would wipe these columns (see "What the script does" above).

1. Send the 5 rows in "Ready to apply — publisher permissions systems" (Springer,
   Hachette, SAGE, O'Reilly, Princeton UP) through their respective CCC/RightsLink or
   permissions-page routes.

2. Send the 8 rows in "Ready to apply — direct email/contact confirmed" (Regorz, Zhang,
   Rodrigues, Kobayashi, Aluja-Banet, De Silva, Korkmaz, and the two `wheres-waldo.png`
   contacts) directly. For Waldo specifically: send to both Candlewick and Walker Books,
   expect ~6 weeks and a real chance of refusal — MF wants it sent anyway, so document
   whatever comes back rather than substituting a different figure on your own call.

3. `DataSaurusDozen.gif` ("Nearly ready to apply"): try to find a firmer contact than
   LinkedIn for Autodesk Research/Matejka before falling back to a LinkedIn message.

4. `tesseract.gif` / `tesseract-frames.png` ("Needs manual follow-up"): check the YouTube
   video's "About" tab for a contact. If truly nothing is findable, the guide's own rule
   applies — remove the material and find an alternative rather than stalling on it
   indefinitely.

5. `Rennie-cover.png` and `Unwin-GmooG.webp` (internal): raise with the T&F Editorial
   Assistant directly — these are T&F's own titles, not an external request; don't email
   a publisher's general permissions desk for these two.

6. `MV-juicer.png` (`[TFQ]`, Ch. 5) isn't part of the normal apply flow — it's the open
   question for T&F, going in with the Permissions Summary file (see "T&F Submission"
   above) rather than a request you'd send yourself.

7. Once every row above has a `status`, revisit "T&F Submission" above and compile the
   Permissions Summary file for CRC/T&F from the finished CSV.
