# Merging master into part-pages-test: conflict resolution, rebuild, and build.sh macOS fixes

**Date:** 2026-07-03
**Branch:** `part-pages-test`
**Commits:** `6e082b49` (merge), `d3041457` (rebuild + build.sh fixes)

## Problem

Running `git merge master` on `part-pages-test` produced merge conflicts in 187 files, including many "Cannot merge binary files" warnings for PDFs.

## Diagnosis

Every conflicted file was a generated build artifact — nothing hand-authored was in conflict:

| Category | Files | Source |
|----------|-------|--------|
| `figs/chNN/fig-*-1.pdf`, `figs/discrim/fig-*-1.pdf` | 171 | knitr chunk output |
| `Vis-MLM.tex` | 1 | Quarto `keep-tex: true` intermediate |
| `docs/Vis-MLM.pdf`, `docs/index.html`, `docs/sitemap.xml` | 3 | Quarto render output |
| `index.aux/.idx/.ilg/.ind/.log/.toc` | 6 | xelatex/makeindex auxiliary files |
| `pdf/Vis-MLM.pdf`, `pdf/index.*` | 8 | Archived copies of build outputs |

The actual source files touched on both branches (`01-Prelude.qmd`, `13-eqcov.qmd`, `R/common.R`, `build.sh`, `latex/preamble.tex`) all auto-merged cleanly. Both branches had committed full rebuilds (master's R 4.6.1 rebuild vs. this branch's part-pages rebuild), so their generated artifacts diverged file-by-file. Since artifacts are regenerated from sources anyway, the conflicts carried no information worth hand-resolving.

## Resolution

1. Took master's version of all 187 conflicted files (fresher baseline — the R 4.6.1 rebuild):

   ```bash
   git diff --name-only --diff-filter=U -z | xargs -0 git checkout --theirs --
   git diff --name-only --diff-filter=U -z | xargs -0 git add --
   ```

2. Committed the merge → `6e082b49` ("Merge branch 'master' into part-pages-test"). The merge also brought in files new on master: `index.pdf`, `issues/duplicate-index-entries.md`, `issues/dup-index.txt`, `issues/dup-index.txt.bak`.

3. Rebuilt everything from the merged sources with `./build.sh --all --fix-index` (same invocation as master's last build), so all artifacts — including the part-page diagrams — are consistent again.

## Two build.sh failures on macOS (both fixed)

The rebuild failed twice. Both were environment portability bugs in `build.sh` (written for Windows/GNU tools), not problems with the book. In both failed runs the PDF itself compiled cleanly (538 pages).

### 1. BSD sed rejects `sed -i -e` (`fix_index()`)

**Symptom:** `sed: -e: No such file or directory`, immediately after "Normalizing index.idx".

**Cause:** macOS BSD sed treats the argument after `-i` as the backup-file extension, so `sed -i -e 's/...'` consumes `-e` as the extension. GNU sed (Windows/Linux) accepts `-i` with no attached extension.

**Fix:** use the attached-suffix form, which both GNU and BSD sed accept, and delete the backup afterwards:

```bash
sed -i.bak -e 's/\\texttt  {/\\texttt{/g' ... index.idx
rm -f index.idx.bak
```

### 2. `makeindex: command not found` (`fix_index()`)

**Symptom:** exit 127 at "Running makeindex on normalized index.idx".

**Cause:** on this Mac, TeX binaries live in TinyTeX at `~/Library/TinyTeX/bin/universal-darwin/`, which is not on the default PATH of non-interactive shells. Quarto locates its TeX distribution internally (so `quarto render` works), but `build.sh`'s direct `makeindex` and `xelatex` calls need PATH.

**Fix:** near the top of `build.sh`, when `makeindex` is not found, append the first existing TeX bin directory to PATH — `$HOME/Library/TinyTeX/bin/universal-darwin`, then `/Library/TeX/texbin` (MacTeX) as fallback.

## Outcome

Third run of `./build.sh --all --fix-index` completed end-to-end:

- PDF compiled (538 pages), appendix check passed
- Duplicate-index fix applied (makeindex + final xelatex pass)
- Both HTML passes rendered; HTML output check passed
- `pdf/Vis-MLM.pdf` restored into `docs/` for site download

Committed as `d3041457` (202 files: regenerated artifacts + the two build.sh fixes). Nothing pushed yet.

## Follow-ups (not done)

- **Prevent recurring artifact conflicts:** stop tracking the LaTeX aux files (`index.aux/.idx/.ilg/.ind/.log/.toc`), and/or add a `.gitattributes` marking `figs/**/*.pdf`, `docs/**`, `pdf/**` as `-diff -merge`. Until then, any merge between branches that both rebuilt will conflict the same way; the bulk `checkout --theirs` + rebuild recipe above resolves it.
- **CLAUDE.md** still describes the build environment as "this Windows machine"; this session ran on macOS (Darwin), and build.sh now works on both.
