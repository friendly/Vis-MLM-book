# Codex analysis: dual HTML/PDF build

Date: 2026-05-31

## Executive summary

The dual-build problem is not one issue; it is three interacting issues:

1. The Quarto config state is internally inconsistent. `_quarto.yml` now includes the online-only appendices, while `_quarto-online.yml` still lists the same appendices. Claude's `issues/dual-build-plan.md` correctly noticed this conflict, but its assumption that the print profile suppresses base appendices is not reliable and is contradicted by `quarto inspect --profile print` in this checkout.
2. `build.sh --all` renders HTML first and PDF last into the same `project.output-dir: docs`. Quarto book renders treat `docs/` as the active output directory and can remove outputs from the prior format. That explains the reported behavior: the PDF can be correct while the HTML site is wiped or left incomplete.
3. The PDF TOC/bookmark issues are mostly separate from the HTML/PDF profile issue. The part-heading TOC bug comes from `krantz.cls`'s deferred `\l@part` implementation; the duplicate index bookmarks come from `krantz`/`imakeidx`/manual `\addcontentsline` interactions.

I would not treat `issues/dual-build-plan.md` as a safe implementation plan without modification. It is directionally useful, but it understates the output-directory cleanup problem and over-trusts profile behavior around `book.appendices`.

## Current build topology

Base config:

- `_quarto.yml` defines `project.type: book` and `project.output-dir: docs`.
- `_quarto.yml` lists the main chapters under `book.chapters`.
- `_quarto.yml` also currently lists these appendices:
  - `15-case-studies.qmd`
  - `30-Rcode.qmd`
  - `31-exercises.qmd`
- Both `html` and `pdf` formats are defined in the base config.

Profiles:

- `_quarto-online.yml` also lists the same three appendices.
- `_quarto-print.yml` redefines `book.chapters`, but does not set `book.appendices: []`.
- The comment in `_quarto-print.yml` saying the base config has no appendices is stale.

Script:

- `build.sh --html` runs two HTML passes with `--profile online`.
- `build.sh --all` runs HTML pass 1, HTML pass 2, then PDF with `--profile print`.
- `build.sh --full` adds cache cleaning and author-index generation.
- In this checkout, `build.sh` is not executable (`-rw-r--r--`), so `./build.sh ...` fails with permission denied. `bash build.sh ...` works.
- The script accepts `--full`, not `-full`.

## Confirmed observations

`quarto inspect --profile online` on Quarto 1.8.27 reports the effective book render list with the three appendices once. So the duplicate appendices in `_quarto.yml` and `_quarto-online.yml` do not currently show as duplicated in inspect output. That weakens the specific "appendices will render twice" fear in `issues/dual-build-plan.md`, at least for Quarto 1.8.27.

However, `quarto inspect --profile print` also reports the three appendices in the effective `book.appendices` and `book.render` list. That directly contradicts the plan's assumption that redefining `book.chapters` in `_quarto-print.yml` suppresses base appendices.

Render attempt on 2026-05-31:

- Command: `bash build.sh --full`.
- The render hung in the first HTML pass after processing `index.qmd`, `00-Author.qmd`, and `01-Prelude.qmd`.
- The process tree showed `bash build.sh --full`, `quarto render --to html --profile online`, Quarto's `deno` process, and an R process that had been running for about six minutes.
- The render had already emptied `docs/` and started writing HTML output at the project root (`index.html`, `00-Author.html`, `01-Prelude.html`, `site_libs/`) before it was terminated.
- The tracked `docs/` files and one modified figure were restored from git after the interrupted render; the root-level partial HTML files were removed.

Generated artifacts show a mixed history:

- `pdf/index.toc` is clean and has no `Case Studies`, `R Code`, or `Exercises` appendix chapters.
- Current root `index.toc` includes Appendix A/B/C.
- Current `Vis-MLM.tex` includes `\appendix`, `\chapter{Case Studies}`, `\chapter{R Code for Figures and Analyses}`, and `\chapter{Exercises}`.

That means root build artifacts are not a trustworthy single source of truth unless they are tied to a known command and timestamp. `pdf/index.toc` appears to be from a clean archived print build; root `index.toc`/`Vis-MLM.tex` appear to be from a build that included appendices.

## Likely root cause of HTML being wiped by `--all`

The most plausible explanation is the shared output directory:

```yaml
project:
  output-dir: docs
```

`build.sh --all` renders HTML into `docs/`, then renders PDF into the same `docs/`. Quarto book renders clean or reconcile the output directory for the active render. When the later PDF render runs, Quarto can remove HTML files and HTML support directories because they are not outputs for the PDF render.

This matches the reported symptom: "proper PDF but wiping out HTML." It also matches older issue notes in `issues/build-problems/quarto-latex-woes.md`, which say that rendering PDF deleted `docs/*.html` and images under `docs/`.

Rendering formats separately avoids some cross-reference resolution failures, but it does not by itself protect the earlier format's output when both formats target `docs/`.

## Profile design problem

There are two viable designs. The repo currently sits between them.

### Design A: base is HTML/full book; print profile subtracts appendices

This is the current shape, but Quarto profiles do not provide a clearly reliable "subtract these appendices" mechanism. Setting `book.appendices: []` in `_quarto-print.yml` should be tested, but profile/list merge semantics may not remove base entries. Current `quarto inspect --profile print` shows that merely redefining `book.chapters` is not enough.

This design has the advantage that RStudio's ordinary HTML build includes appendices. The disadvantage is that excluding appendices from PDF is fighting Quarto's merge semantics.

### Design B: base is print/PDF book; online profile appends HTML appendices

This was the earlier implemented design described in `issues/task-online-only.md`: keep online-only appendices out of `_quarto.yml`, add them only in `_quarto-online.yml`, and render HTML with `--profile online`.

This design aligns with Quarto profile semantics because the profile only adds content. It is the safer design for guaranteeing a chapters-only PDF. The cost is workflow discipline: deployed/full HTML must use `--profile online`; a plain base HTML build will omit online-only appendices.

My recommendation is Design B. It is easier to reason about and avoids relying on a profile to remove inherited book entries.

## TOC and bookmark issues

The PDF TOC part-heading issue is not primarily a dual-build problem. `issues/task-TOC.md` correctly identifies the cause in `krantz.cls`:

```tex
\def\l@part#1#2{%
\toc@draw
 \gdef\toc@draw{\draw@part{\large #1}{\large #2}}}
```

`krantz` defers drawing each part until the next part entry. Without a flush before chapters, part headings visually appear after their chapters in the TOC. The current `latex/preamble.tex` already contains a patch that redefines `\l@chapter` and calls `\toc@draw` first. That patch should be verified in a fresh print build, but it is conceptually the right target.

The duplicate Subject Index / Author Index bookmarks are also LaTeX-side:

- Subject Index uses `\makeindex[..., intoc=true, ...]` in `latex/preamble.tex` and `\printindex` in `latex/after-body.tex`.
- Author Index manually does `\addcontentsline{toc}{chapter}{Author Index}` before `\chapter*{Author Index}`.
- Older `Vis-MLM.toc` shows duplicate `fm` and `chapter` entries for indexes; `pdf/index.toc` still shows duplicate-looking entries for Subject and Author Index.

These should be fixed independently from the profile cleanup, probably by making one component responsible for each TOC/bookmark entry rather than combining `intoc=true`, `\chapter*`, and manual `\addcontentsline`.

## Problems in `build.sh`

1. It renders HTML before PDF in `--all`/`--full`, which means the final render can wipe the earlier HTML output.
2. It assumes `docs/index.html` surviving to the final summary means HTML is intact; this does not verify the full site or assets.
3. It uses `--profile online` for HTML even though the base config currently already includes appendices. This is redundant at best.
4. Its comments still reflect the older "base excludes appendices; online adds them" design, while `_quarto.yml` no longer follows that design.
5. It is not executable in this checkout, so the documented `./build.sh` invocation does not work unless file mode is fixed.
6. It recognizes `--full`, not `-full`.

## Recommended cleanup path

I would handle this in two phases: first make the build topology unambiguous, then improve verification.

1. Return to the safer profile model:
   - Remove `book.appendices` from `_quarto.yml`.
   - Keep the three appendices only in `_quarto-online.yml`.
   - Update stale comments in `_quarto.yml`, `_quarto-online.yml`, `_quarto-print.yml`, and `build.sh`.

2. Change `build.sh --all` / `--full` ordering:
   - Build PDF first with the print/base config.
   - Archive/copy `docs/Vis-MLM.pdf` to `pdf/`.
   - Build HTML last with `--profile online`, two passes if still needed.
   - Copy the archived PDF back into `docs/Vis-MLM.pdf` after the final HTML pass if the website should include a downloadable PDF.

3. Add explicit post-build checks:
   - For PDF: fail or warn if `index.toc` or `Vis-MLM.tex` contains `\chapter{\numberline {A}Case Studies}` / `\chapter{Case Studies}` / `30-Rcode` / `31-exercises`.
   - For HTML: fail or warn if `docs/index.html`, all expected chapter HTML files, and the three appendix HTML files are absent after `--all`.
   - For the downloadable PDF: verify `docs/Vis-MLM.pdf` exists after the final HTML pass.

4. Fix script ergonomics:
   - Make `build.sh` executable.
   - Optionally accept `-full` as an alias for `--full`, since that exact form is already being used in notes/conversation.

5. Keep TOC/bookmark fixes separate:
   - Verify the `\l@chapter`/`\toc@draw` patch in a clean print PDF.
   - Then address duplicate index TOC/bookmark entries by simplifying index TOC insertion.

## Implemented on `GK-work4`

Implemented 2026-05-31:

- Restored the safer profile model: `_quarto.yml` is chapters-only; `_quarto-online.yml` owns the three HTML-only appendices.
- Made `build.sh` executable.
- Added `-full` as an alias for `--full`.
- Changed `build.sh --all` / `--full` order to build PDF first, run/refresh author index and archive PDF artifacts, then render HTML last and restore `pdf/Vis-MLM.pdf` into `docs/Vis-MLM.pdf`.
- Added dry-run-safe author-index fingerprint handling. The previous dry run still wrote `.authorindex-fingerprint`.
- Added post-render checks:
  - PDF artifacts are checked for excluded appendix chapters.
  - HTML output is checked for all expected chapter and appendix HTML files.
- Added project `.Rprofile` settings to force headless `rgl` during non-interactive renders:
  ```r
  options(rgl.useNULL = TRUE)
  Sys.setenv(RGL_USE_NULL = "TRUE")
  ```

Verification performed:

- `bash -n build.sh` passed.
- `./build.sh --full --dry-run` passed and shows the intended PDF-first / HTML-last sequence.
- `./build.sh -full --dry-run` passed.
- `quarto inspect --profile print | rg 'appendices|15-case-studies|30-Rcode|31-exercises|Appendices'` returned no matches.
- `quarto inspect --profile online | rg 'appendices|15-case-studies|30-Rcode|31-exercises|Appendices'` confirmed the three appendices are present in the online profile.
- The local HTML render hang was sampled and traced to R blocking in `rgl_init()` while trying to `XOpenDisplay`. With the project `.Rprofile`, `R --no-echo --no-restore -e 'library(rgl)'` completes locally.
- `./build.sh --full` completed successfully on 2026-05-31 after installing missing local render dependencies:
  - CRAN: `qgraph`, `broom.helpers`, `mclust`
  - GitHub: `gmonette/spida2`, `gmonette/spida`
  - TinyTeX filled missing TeX packages on demand, including `pdfpages`, `fvextra`, `tabularray`, `ulem`, `siunitx`, `tikzfill`, `pdfcol`, `fontawesome5`, and `makeindex`.
- The completed full build produced:
  - `docs/index.html`
  - `docs/Vis-MLM.pdf`
  - `pdf/Vis-MLM.pdf`
- The build script's final HTML output check passed.

Warnings from the completed full build scan:

- The command exited successfully and the warnings found were non-fatal PDF/log quality issues, not dual-build failures.
- `pdf/index.log` contains 4 LaTeX/package/font warnings:
  - `caption`: unknown document class, so default caption settings were used.
  - `\thesubtable` already defined.
  - `hyperref`: suppressing an empty link around generated TeX line 3432.
  - `\large` invalid in math mode around generated TeX line 11501.
- `pdf/index.log` contains layout warnings:
  - 214 `Overfull \hbox` entries.
  - 2 `Underfull \hbox` entries.
  - Most large `395.75pt` overfull warnings appear structural/repeated from the book layout/class.
  - Smaller content-level overfulls appear around generated TeX lines 13450--13451 and 26574--26584.
- `pdf/index.log` contains missing-character warnings:
  - 4 occurrences for Unicode mathematical beta `𝛽`.
  - 8 occurrences for check mark `✓` in monospaced font.
- The captured render output also included non-fatal runtime noise:
  - TinyTeX installed missing TeX packages during the run.
  - Author-index BibTeX reported missing database entries / no database file during `_autidx_` generation, but the script continued and wrote `index.ain`.
  - R printed package/S3 overwrite messages and one font substitution warning for `≥`.
- Remaining cleanup targets are PDF polish: Unicode glyphs, the empty hyperlink, the math sizing command, author-index BibTeX noise, and overfull boxes.

## Suggested target workflow

After cleanup, the commands should mean:

```bash
bash build.sh --pdf
```

Build a chapters-only PDF, no online appendices, then archive it.

```bash
bash build.sh --html
```

Build the complete HTML site, including appendices, leaving `docs/` as a deployable GitHub Pages directory.

```bash
bash build.sh --full
```

Clean caches, build/archive the chapters-only PDF first, build the complete HTML site last, then put `Vis-MLM.pdf` back into `docs/` so the final `docs/` contains both the deployable site and the downloadable PDF.

## Bottom line

The safest mental model is: PDF and HTML are not two independent outputs inside one stable `docs/` directory. Each Quarto render can treat `docs/` as its own output tree. Therefore the final render in a combined build should be the format whose output tree you want to preserve. For this repo, that should be HTML, with the PDF copied back into `docs/` afterward.
