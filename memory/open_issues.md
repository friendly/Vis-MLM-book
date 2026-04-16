---
name: Open Issues
description: Tracked open issues for Vis-MLM-book — sync from project memory/project_context.md
type: project
---

See authoritative source: `C:\R\Projects\Vis-MLM-book\memory\project_context.md`

## Resolved
- PDF build works end-to-end (Quarto v1.9.36 + TinyTeX)
- MikTeX/TinyTeX conflict resolved (TinyTeX only)
- 21-discrim.qmd appendix complete (online-only)
- Robust PCA section done (14-infl-robust.qmd)

## Resolved this session (2026-04-15/16)
- `Extra }, or forgotten \endgroup` PDF build error: root cause was `latex/latex-commands.qmd` multi-line `\providecommand` + stale freeze cache + parse-latex filter. Fix: single-line definitions + delete tex.json caches. parse-latex moved to `format: html: filters:` only.
- `build.sh` created at project root — handles `--html`, `--pdf`, `--all`, `--clean-cache`, `--authorindex`, `--full`, `--dry-run`. HTML render runs twice (two-pass needed for `index.html` cross-ref resolution).
- Stale `.quarto/xref/` cache from old chapter numbering deleted — had duplicate entries causing cross-ref fallback to titles.
- `quarto-pandoc-test.qmd` minimal repro + `quarto-disc-reply.md` filed; resolved and closed.
- `issues/online-only.md` written and updated with confirmed Quarto profiles solution (see below).

## Open (as of 2026-04-16)
1. **HTML cross-refs in index.html** — `@sec-*` refs to later chapters show section titles instead of "Section X.Y". Root cause: `index.qmd` renders first so xref data for other chapters doesn't exist yet. Fix: two-pass HTML render (already in `build.sh`). **Needs verification** — user ran single-pass HTML; two-pass not yet tested. Run `./build.sh --html` and check `docs/index.html` for "Section 4.5" etc.
2. **Online-only chapters** — `21-discrim.qmd` (confirmed), `15-case-studies.qmd` (pending decision) should be HTML-only, excluded from PDF. Solution designed in `issues/online-only.md`: Quarto profiles. **Not yet implemented** — waiting on decision about which chapters to exclude. Steps when ready:
   - Remove online-only chapters from `_quarto.yml` appendices/chapters
   - Create `_quarto-online.yml` appending them
   - Add `--profile online` to HTML render calls in `build.sh`
   - Audit and guard cross-refs to those chapters in other .qmd files
3. PDF sub-issues: author index (authorindex Perl), cover page (manual Acrobat), part-page content, indexing functions with underscores
4. Conditional content: hrefs as footnotes in PDF, GIFs HTML-only, code-fold audit
5. pkg() formatting: needs \index{} for PDF + different HTML/PDF styling
6. Content: 3D plots (rgl), effect plots for MLM, dominance analysis viz
7. Reviewer comments: reviewer-MichaelT-*.Rmd and reviews/*.pdf
8. Exercises: format unsettled
