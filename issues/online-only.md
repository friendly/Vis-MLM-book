# Online-only chapters: HTML vs PDF conditional compilation

This problem was discussed at: https://github.com/orgs/quarto-dev/discussions/14365 
The answer seems to be to use profile groups, e.g., a `_quarto-print.yml` for
the pdf and a `_quarto-online.yml` for the HTML version, which should be the default.
There is an example of this at: https://github.com/mcanouil/quarto-issues-experiments/tree/main/quarto-cli-14365


## Problem

My book, [_Visualizing Multivariate Data and Models in R](https://friendly.github.io/Vis-MLM-book/)
book has grown long enough that some chapters will be **online-only** (HTML)
and excluded from the printed PDF:

- `21-discrim.qmd` — Appendix on discriminant analysis (already listed as an
  appendix in `_quarto.yml`)
- `15-case-studies.qmd` — possibly; decision pending on length budget. This could be moved to Appendices if necessary.

The current `_quarto.yml` lists all chapters under `chapters:` and `appendices:`,
so both formats always receive all chapters. There does not seem to be any built-in Quarto mechanism
for per-chapter format exclusion in a book project or for conditional compilation.

---

## What I want

1. All chapters & appendices appear in HTML output normally (full content, numbered in TOC, cross-references work).
2. Some chapters are **absent** from the PDF entirely — not just blank pages or stubs.
3. Cross-references from other chapters to these chapters:
   - HTML: resolve correctly.
   - PDF: either suppressed or replaced with a note like "see online version".
4. Ideally: single build command produces both formats with correct behavior.

---

## Options considered

Here are a few things I'm considering. I would appreciate guidance from anyone on this discussion forum.

### Option 1: Remove from `_quarto.yml`; maintain separate HTML-only config

Keep a second `_quarto-online.yml` (or `_quarto-html.yml`) that lists all chapters including the online-only ones. The main `_quarto.yml` omits them.

- **Build PDF:** `quarto render --to pdf` (uses `_quarto.yml`, skips online-only chapters)
- **Build HTML:** `quarto render --to html --config _quarto-online.yml`

**Pros:** Clean separation; each format gets exactly the chapters it should.

**Cons:**
- Two config files to maintain in sync (book title, bib, theme, etc. — lots of duplication).
- Can be mitigated by using YAML merging or a shared partial, but Quarto doesn't natively support config inheritance AFAICS.
- Cross-refs from PDF chapters to online-only chapters (`@sec-discrim` etc.) will produce broken links in the PDF build — need to audit and guard them.
  
I've developed a custom bash script, [build.sh](https://github.com/friendly/Vis-MLM-book/blob/master/build.sh)
to help with building HTML/PDF versions. Could be updated to use different `.yml` configs.

### Option 2: Single config, use `format: pdf: eval: false` in the chapter YAML

Each online-only chapter's YAML front matter would include:

```yaml
format:
  pdf: false
```

Unfortunately, **Quarto does not support per-chapter format suppression** in book projects. A `format: pdf: false` in a chapter's YAML is silently ignored — the chapter is still included in the PDF.

**Status**: Not viable in Quarto 1.8.x / 1.9.x.

### Option 3: Wrap entire chapter body in the `.qmd` file in a content-visible block

```markdown
::: {.content-visible when-format="html"}
< entire chapter content >
:::
```

This compiles the chapter into PDF (it appears in the LaTeX source) but produces no visible output — the chapter still occupies a page in the PDF book, and its TOC entry and numbering shift all subsequent chapters.

**Status: Not viable** — the chapter must be absent from the PDF, not just blank.

### Option 4: Quarto profiles

Quarto 1.4+ supports [project profiles](https://quarto.org/docs/projects/profiles.html): different `_quarto-<profile>.yml` files that **override or extend** the base `_quarto.yml`.

**Confirmed by Quarto maintainer (cderv, discussion #14365, 2026-04-16):** Objects and arrays in profile YAML are **merged, not overwritten**. So listing additional entries under `appendices:` in a profile appends to the base list — it does not replace it. This is the key fact that makes profiles work for this use case.

```
_quarto.yml          # base config — PDF chapter list only; omits online-only chapters
_quarto-online.yml   # "online" profile — appends online-only chapters/appendices
```

`_quarto-online.yml` only needs to contain the additions:
```yaml
book:
  appendices:
    - 21-discrim.qmd
    # - 15-case-studies.qmd   # add if/when decided
```

Build commands:
```bash
quarto render --to html --profile online   # HTML: all chapters
quarto render --to pdf                     # PDF: base config only, no profile
```

Note: the `--config` flag suggested in some sources **does not exist** in Quarto (confirmed by mcanouil). The correct flag is `--profile`.

Profile-conditional content blocks are also possible using `when-profile`:
```markdown
::: {.content-visible when-profile="online"}
This paragraph appears only in the online (HTML) build.
:::
```
This is an alternative to `when-format="html"` and is useful for content that is profile-specific rather than format-specific (e.g., a note saying "see the online appendix" in the PDF version).

**Status: Confirmed working approach. Ready to implement once online-only chapter list is decided.**

### Option 5: Post-process the PDF

Build both formats normally (all chapters in both). After the PDF build, remove
the online-only chapters from the LaTeX source (`index.tex`) and recompile. This is fragile
and manual.

**Status: Not recommended.**

---

## Solution: Quarto profiles (Option 4, confirmed)

### Implementation steps

1. Remove online-only chapters from `_quarto.yml` (the base config used for PDF). Currently `21-discrim.qmd` is under `appendices:`; remove it (and `15-case-studies.qmd` if that is also decided).

2. Create `_quarto-online.yml` with only the additions:
   ```yaml
   book:
     appendices:
       - 21-discrim.qmd
   ```
   Quarto merges arrays, so this appends rather than replaces the base list.

3. Audit and guard cross-references (see section below).

4. Update `build.sh` (see section below).

### `build.sh` changes

The `--html` and `--all` cases need `--profile online` added to the HTML render commands:

```bash
# HTML build
quarto render --to html --profile online

# All formats
quarto render --to html --profile online   # pass 1 (builds xref database)
quarto render --to html --profile online   # pass 2 (resolves index.html cross-refs)
quarto render --to pdf                     # no profile — base config only
```

The `--profile` flag should also be exposed as a `build.sh` option if fine-grained control is needed, but the defaults above (always use `online` profile for HTML) are probably right since we always want all chapters in the HTML output.

---

## Cross-reference implications

**Confirmed by cderv:** Cross-references to chapters absent from the PDF build will produce `??` in PDF and `?@sec-label` in HTML (if the profile is not active). There is no built-in graceful degradation.

Options for guarding cross-refs from PDF chapters to online-only chapters:

- **Remove the cross-ref** if it is purely navigational and not essential to the text.
- **Wrap in a conditional block:**
  ```markdown
  ::: {.content-visible when-format="html"}
  See @sec-discrim for a full treatment of discriminant analysis.
  :::
  ::: {.content-visible when-format="pdf"}
  Discriminant analysis is covered in the online appendix.
  :::
  ```
- **Lua filter approach (mcanouil):** A filter (`offpage-crosslinks.lua`) can rewrite relative cross-page links to absolute URLs pointing to the live HTML site, so PDF readers can follow a hyperlink to the online chapter. This is the most elegant option if there are many such references.

Steps before implementation:
1. Search all `.qmd` files for references to online-only chapter sections (e.g., `@sec-discrim`, any section labels defined in `21-discrim.qmd` or `15-case-studies.qmd`).
2. Decide per-reference: remove, wrap conditionally, or rely on a Lua filter.
3. Implement the Lua filter if the number of references is large.

---

## Discussion reference

https://github.com/orgs/quarto-dev/discussions/14365 (2026-04-15/16)

Key answers from that thread:
- **Array merging confirmed** (cderv): `appendices:` in a profile appends, not replaces.
- **`when-profile` blocks** (mcanouil): use these for profile-specific visibility in addition to `when-format`.
- **`--config` flag does not exist** (mcanouil): always use `--profile`.
- **Lua filter for cross-refs** (mcanouil): `offpage-crosslinks.lua` rewrites links to absolute URLs for non-HTML formats.
- **No graceful xref degradation built-in** (cderv): broken refs produce `??` / `?@label`; must be handled manually or via filter.

Docs: https://quarto.org/docs/projects/profiles.html

---

## Status

- [ ] Decide which chapters are online-only (confirm `21-discrim.qmd`; assess `15-case-studies.qmd`)
- [ ] Remove online-only chapters from `_quarto.yml` appendices/chapters
- [ ] Create `_quarto-online.yml` with the additions
- [ ] Audit cross-references to online-only chapters in all remaining `.qmd` files
- [ ] Handle each cross-ref: remove, wrap conditionally, or implement Lua filter
- [ ] Update `build.sh`: add `--profile online` to all HTML render calls
