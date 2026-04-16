---
name: No hard line wrapping in prose files
description: Do not wrap prose lines at a fixed column width in markdown/Rmd files
type: feedback
---

Do not insert hard line breaks to keep lines under a fixed width (e.g., 80 chars) in markdown, Rmd, or `.md` files written for forum posts, issue write-ups, or any prose document.

**Why:** Forum input boxes and most markdown renderers honor literal newlines, so forced wraps appear as awkward mid-sentence breaks when pasted. The user edits these files for posting and finds the extra breaks intrusive.

**How to apply:** Let paragraphs flow as single long lines. Only break at natural paragraph or list-item boundaries. This applies to `issues/*.md`, `issues/*.Rmd`, discussion drafts, and similar prose files. Code blocks and YAML are unaffected.
