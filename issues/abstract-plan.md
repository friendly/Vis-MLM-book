# Plan: Chapter Abstracts for Publisher Metadata

**Goal:** Produce `chapter-abstracts.docx` — one abstract per chapter, 100–200 words each (strict), optimized for search discoverability. The abstracts go into the book's metadata (CRC Press), not the book itself, so their sole job is to make each chapter surface at the top of relevant searches (Google, Google Scholar, library discovery systems, CRC/Taylor & Francis online).

**Deliverable format:**

- Final deliverable: a **Word document**, `chapter-abstracts.docx` (publisher accepts Word or text; NOT PDF or LaTeX). Word is preferred over `.txt` because plain text cannot carry the desired formatting — true heading sizes and an italicized book title.
- Title (Heading 1 style): "Chapter Abstracts for the Metadata of *Visualizing Multivariate Data and Models in R*" — book title in true italics.
- Section headings (Heading 2 style): "Chapter 1", "Chapter 2", … with the abstract as a single body-text paragraph beneath each.
- Source of truth in the repo: a Markdown file `chapter-abstracts.md` (`#`/`##` headings, `*italics*`), from which the `.docx` is generated via Claude's Word skill or Pandoc. All editing happens in the `.md`; the `.docx` is regenerated, never hand-edited.
- Per project convention: no hard line-wrapping of prose in the `.md`; each abstract is one long line.

## Scope decision (confirm with Michael first)

**Note the current book structure (differs from source-file numbering):** Discriminant Analysis (`21-discrim.qmd`) is now **Chapter 15**, and Case Studies (`15-case-studies.qmd`) is now the **Appendix**. Abstract headings must follow the rendered book's numbering, not the `.qmd` file prefixes.

Which units get abstracts? Proposed: the 15 numbered chapters — `01-Prelude.qmd` through `14-infl-robust.qmd`, plus `21-discrim.qmd` as Chapter 15. Open questions:

1. Does the Appendix (Case Studies, `15-case-studies.qmd`) get an abstract? Publishers usually index appendices with substantive content, and case studies are exactly what practitioners search for — recommend **yes**, labeled "Appendix" or per the final book numbering.
2. Front matter (index.qmd/Preface) and end matter (colophon, references) — recommend **no**, publishers rarely want these.
3. Confirm remaining numbering against `_quarto.yml` chapter order before labeling (e.g., 04b-higher.qmd — is it part of Chapter 4 or its own chapter?).

## Step-by-step workflow with Claude Fable

### Step 1 — Extract source material per chapter

For each chapter `.qmd`, have Claude read and distill:

- Chapter title and all section/subsection headings (the skeleton of what's covered).
- The chapter's opening paragraphs and any "What you will learn" / "packages used" blocks.
- **Exclude the chapter summary files** (`summary/ChNN-summary.qmd`, included as children at the end of each chapter): abstracts must be drafted from the chapter content itself, not from the "What have we learned?" summaries.
- Datasets used by name (e.g., `iris`, `peng`/Palmer penguins, `crime`, `NLSY`) — dataset names are search terms.
- R packages featured (e.g., **ggplot2**, **car**, **heplots**, **candisc**, **ggbiplot**, **matlib**) — package names are high-value search terms because R users search for them directly.
- Statistical methods and named techniques (e.g., HE plots, canonical discriminant analysis, Hotelling's T², ridge regression, biplots, data ellipses, MANOVA).

Practical approach: process chapters in batches of 3–5 per Claude session/turn so each chapter gets a careful read rather than a skim. Save the distilled notes to a working file (e.g., `issues/abstract-notes.md`) so drafting is decoupled from extraction and survives context compaction.

### Step 2 — Build a shared keyword strategy

Before drafting, compile a master keyword list from Step 1 and decide, per chapter, the 5–8 terms that MUST appear. Principles for search optimization:

- **Front-load**: the first sentence should contain the chapter's primary topic phrase (e.g., "principal component analysis (PCA) and biplots in R"), because search engines and abstract-truncating indexes weight early text heavily.
- **Spell out + abbreviate**: give both forms on first use — "multivariate analysis of variance (MANOVA)", "hypothesis-error (HE) plots" — so both query forms match.
- **Use the words people actually type**: "how to visualize", "R packages for", "regression diagnostics", "outlier detection" — natural phrasing beats formal prose for query matching.
- **Name the software**: "R", specific package names, and function-level concepts. Every abstract should contain "R" and at least one package name.
- **No markdown, LaTeX, citations, or special characters** inside abstract text — metadata systems render plain text only. Write "Hotelling's T-squared (T^2)" style fallbacks where needed.
- **Avoid keyword stuffing**: terms must appear in fluent sentences; modern search engines penalize unnatural repetition, and CRC editors will read these.

### Step 3 — Draft the abstracts

Have Claude draft each abstract from the Step 1 notes + Step 2 keyword list, with these constraints stated explicitly in the prompt:

- 100–200 words, hard limits both directions. Target 150–180 to leave editing headroom.
- Structure: (a) opening sentence stating topic + "in R"; (b) 2–4 sentences on methods, visualizations, and packages covered; (c) sentence naming datasets/examples; (d) closing sentence on what the reader gains.
- Third person, present tense ("This chapter introduces…"), self-contained (no references to other chapters by number alone, since abstracts appear in isolation in search results).
- Consistent voice across all chapters — draft them all in one or two sessions, or give Claude 2–3 approved abstracts as style exemplars for later batches.

### Step 4 — Automated word-count verification

Write a small script in `issues/` (per project convention — not in `R/`) that parses `chapter-abstracts.md` and prints the word count per chapter, flagging any outside 100–200. Run it after every edit. Do not trust eyeballed counts; the limit is strict.

### Step 5 — Search-optimization review pass

A second Claude pass, separate from drafting, that checks each abstract against a checklist:

- Primary topic phrase in sentence 1?
- "R" plus at least one package name present?
- Both spelled-out and abbreviated forms of key methods?
- Dataset names included where they're well-known (Palmer penguins, iris)?
- No markdown/LaTeX/citation artifacts?
- Reads naturally (no stuffing)?

Optionally: for 2–3 chapters, do a reality check by searching the chapter's target phrases (e.g., "HE plots MANOVA R") and comparing the vocabulary of top-ranking results against the draft abstract; adjust terminology to match how the field actually writes about these topics.

### Step 6 — Cross-abstract consistency check

Read all abstracts as a set: consistent terminology (always "multivariate linear models", not sometimes "MLMs" unexplained), no two abstracts opening with identical phrasing, coverage of the book's throughline ("A Romance in Many Dimensions" themes) without redundancy. Distinct openings also help each chapter rank for its own queries rather than competing with sibling chapters.

### Step 7 — Author review

Michael reviews all abstracts for technical accuracy and emphasis — Claude can summarize what a chapter covers, but only the author knows what a chapter is *for*. Iterate; re-run the Step 4 word-count script after every revision.

### Step 8 — Finalize the file

- Assemble the approved abstracts in `chapter-abstracts.md`, then generate `chapter-abstracts.docx` from it via Claude's Word-document skill (or Pandoc): Heading 1 for the title (book title italicized), Heading 2 per chapter, body text for each abstract.
- Open the `.docx` and visually verify heading styles, italics, and that no Markdown artifacts (`#`, `*`) leaked into the text.
- Commit both files to the repo; this is publisher-facing metadata, worth version-tracking. The `.docx` is what gets sent to CRC.

## Estimated effort

Steps 1–3 are the bulk: ~16 abstracts × (read chapter + draft) — realistically 2–3 working sessions. Steps 4–6 are fast (one session). Step 7 depends on Michael's turnaround.

## Risks / gotchas

- **Word count drift during editing** — mitigated by the Step 4 script; run it before sending anything to the publisher.
- **Chapter numbering mismatch** — file prefixes no longer match book order (discrim is Chapter 15, case studies is the Appendix; CLAUDE.md's chapter table is also stale on this). Resolve the 04b-higher.qmd question and verify all headings against `_quarto.yml` before writing them.
- **Abstracts written from headings alone** will be generic and rank poorly; Step 1 must actually read chapter content, not just the TOC.
- **.md/.docx drift** — if someone edits the `.docx` directly, it silently diverges from the repo source. Rule: edit only `chapter-abstracts.md`, regenerate the `.docx` (Step 8), and re-run the word-count script before each send to the publisher.
