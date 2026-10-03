# Dual-Build Cleanup Plan: HTML + PDF

**Status: RESOLVED 2026-06-01** by the GK-work4 merge.
The resolution went in the opposite direction from the plan below: appendices were removed
from `_quarto.yml` (base) rather than from `_quarto-online.yml`, restoring the correct
separation. All four planned steps are now complete. See "Actual resolution" section below.

---

**Original context (2026-05-29):** After a session that restored appendices to `_quarto.yml`
to make `Build -> HTML` work without `--profile online`, the three config files were in a
conflicting state. This document recorded the diagnosis and the planned cleanup.

---

## Actual resolution (2026-06-01)

Gavin's `GK-work4` branch (developed independently with Codex) removed the `appendices:`
key from `_quarto.yml` entirely, keeping appendices only in `_quarto-online.yml`. This is
the correct design.

**Config state after merge:**

| File | Appendices? | Notes |
|------|-------------|-------|
| `_quarto.yml` (base) | **No** | Base represents PDF chapter list only |
| `_quarto-online.yml` | **Yes** — 3 appendices | HTML-only; appended by `--profile online` |
| `_quarto-print.yml` | No | Comment is accurate: "base has none; appendices in online profile" |

**Verified 2026-06-01** via `./build.sh --all --authorindex`:
- PDF appendix check passed (no appendices in `Vis-MLM.tex` / `.toc`)
- HTML output check passed (all 22 chapters + 3 appendices in `docs/`)
- Author index generated and re-render completed
- Result: `pdf/Vis-MLM.pdf` with author index; `docs/` HTML with appendices

**Step 2 from the plan (drop `--profile online`) is NOT correct:** appendices remain only in
`_quarto-online.yml`, so `--profile online` is still required for the HTML build.

---

## Config state (as of 2026-05-29, now historical)

| File | Appendices? | Notes |
|------|-------------|-------|
| `_quarto.yml` (base) | **Yes** — 3 appendices restored | Enables `Build -> HTML` |
| `_quarto-online.yml` | **Yes** — same 3 appendices | Now redundant / conflicting |
| `_quarto-print.yml` | No | Comment "base has none" is now stale |

---

## What's working and why

**PDF via `./build.sh --pdf`** (`--profile print --to pdf`): The print profile redefines
`book.chapters` entirely. Quarto appears to treat this as overriding the full book structure,
suppressing the base config's appendices from the PDF output. This works empirically but is
not explicitly guaranteed by Quarto docs — it is worth verifying (see Step 3 below).

**HTML via `Build -> HTML`** (RStudio button, no profile, single pass): Works because appendices
are now in the base `_quarto.yml`. The cost is a single-pass render — cross-refs in `index.html`
that point to later chapters may show section titles instead of "Chapter N" on first render, but
resolve correctly on a second build.

---

## The latent problem

`_quarto-online.yml` lists the same 3 appendices as the base config. When `./build.sh --html`
runs with `--profile online`, Quarto merges arrays (appends), so the appendices are listed
**twice**. Whether Quarto deduplicates or renders each appendix chapter twice is untested —
this is a real risk if `./build.sh --html` is used for the deployed site.

---

## Planned cleanup (do on weekend)

### Step 1 — Remove appendices from `_quarto-online.yml`

They are now in the base; the online profile only needs to add content that the base does not
have. If a future HTML-only appendix is needed, add it only in `_quarto-online.yml` at that
time.

Result of edit — `_quarto-online.yml` becomes:

```yaml
# Quarto "online" profile — extends _quarto.yml for the HTML build.
# Adds online-only content excluded from PDF.
# Currently empty: all appendices are in the base _quarto.yml.
# Add HTML-only chapters/appendices here if needed in future.
book: {}
```

### Step 2 — Drop `--profile online` from `build.sh`

Since appendices are now in the base, `--profile online` adds nothing and causes the
duplication above. The two-pass render still handles the `index.html` cross-ref issue.

In `build.sh`, change lines 144/146 (html case) and 156/158 (all case):

```bash
# Before:
run quarto render --to html --profile online

# After:
run quarto render --to html
```

Also update the comment on those lines to remove the `--profile online` mention.

### Step 3 — Verify PDF has no appendices

Open `pdf/Vis-MLM.pdf` and check the TOC. Appendices should **not** appear.

- **If absent:** current setup is confirmed correct; update the stale comment in
  `_quarto-print.yml` ("base _quarto.yml has none" → "base _quarto.yml has appendices;
  print profile's book.chapters replacement suppresses them").
- **If present:** add explicit suppression to `_quarto-print.yml`:
  ```yaml
  book:
    appendices: []   # suppress base config appendices from PDF
  ```
  Then test — Quarto's array-merge behavior (append) may mean `[]` does nothing; if so,
  the fallback is to remove appendices from the base config and accept that `Build -> HTML`
  won't include them (use `./build.sh --html` for deployed HTML instead).

### Step 4 — Update stale comment in `_quarto-print.yml`

Line 40 currently reads:
```
# No appendices — base _quarto.yml has none; all appendices are in _quarto-online.yml.
```
Update to reflect the new state after Steps 1–3.

---

## Resulting workflow after cleanup

| Task | Command | Notes |
|------|---------|-------|
| Day-to-day editing | `Build -> HTML` or `quarto preview` | Single pass; fine for editing |
| Deploy HTML to site | `./build.sh --html` | Two passes, all appendices included |
| PDF for submission | `./build.sh --pdf` | Print profile; chapters-only |
| Both formats | `./build.sh --all` | Three steps (2× HTML + 1× PDF) |

The `--profile online` experiment is resolved. The online profile now only exists as a
hook for future HTML-only content.

---

## Related files

- `_quarto.yml` — base config (chapters + appendices)
- `_quarto-online.yml` — online profile (currently redundant after Step 1)
- `_quarto-print.yml` — print profile (chapters only for PDF)
- `build.sh` — build script (needs Step 2 edits)
- `issues/task-online-only.md` — original profile design decisions
