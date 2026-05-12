# Quarto Discussion question: build efficiency with profiles + two-pass HTML

**Target:** https://github.com/orgs/quarto-dev/discussions (new discussion)
**Related:** task-online-only.md (profiles implementation, 2026-05-05)

---

## Draft question

**Title:** Most efficient build for a book with online-only chapters and two-format output?

I maintain a large Quarto book (~15 chapters) that produces both HTML (GitHub Pages)
and PDF (CRC Press). I am using Quarto 1.9.36 (latest is 1.9.37). Some chapters are **online-only** (HTML appendices, absent from PDF),
implemented using Quarto profiles as described in
[discussion #14365](https://github.com/orgs/quarto-dev/discussions/14365).

My current build script is at:
https://github.com/friendly/Vis-MLM-book/blob/master/build.sh

### How the script is organized

The script has three modes (`--html`, `--pdf`, `--all`) built around one constraint:
**the two formats must be rendered separately**, because `quarto render` (all formats at once)
fails on this book — during PDF cross-ref resolution it looks for `.html` files at the
project root, but HTML output goes to `docs/`.

For HTML, a **two-pass render** is needed:

```bash
quarto render --to html --profile online   # pass 1: builds the xref database
quarto render --to html --profile online   # pass 2: resolves forward xrefs in index.html
```

Pass 1 is necessary because `index.qmd` is rendered before later chapters exist in the
xref database, so forward cross-references (e.g. `@sec-pca-biplot`) show section titles
instead of numbers. Pass 2 picks up the completed database and fixes them.

For PDF, a single pass suffices, using the base config (no profile), which naturally
excludes the online-only appendices:

```bash
quarto render --to pdf
```

A full `--all` build therefore runs **three complete renders** sequentially:

```
HTML pass 1  →  HTML pass 2  →  PDF
```

This takes **~25–30 minutes** on my machine. The freeze cache speeds up partial
rebuilds (chapters whose source hasn't changed are skipped), but a full cold build
or one after editing a widely-used child doc still takes the full time.

### Questions

1. **Is the two-pass HTML render still necessary in current Quarto versions?**
   Is there a flag or config option that forces `index.qmd` to wait for the full
   xref database before rendering, avoiding the second pass?

2. **Is there a faster way to build both formats with profile-based chapter exclusion?**
   For example, is there a way to run `quarto render` for all formats at once that
   avoids the root-vs-`docs/` HTML path issue, perhaps via an output config option?

3. **Any other known strategies for cutting build time on large Quarto books?**
   (Beyond freeze cache, which we already use.)
