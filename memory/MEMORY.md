# Memory Index

- [User Profile](user_profile.md) — Michael Friendly, book author, R/LaTeX expert, Quarto newcomer
- [Project Overview](project_overview.md) — Vis-MLM-book structure, goals, build setup
- [Open Issues](open_issues.md) — Tracked issues: PDF build, author index, cover page, content tasks
- [task-*.md convention](task_files.md) — issues/task-*.md files document one problem each: history, failures, and solution path
- [Duplicate Index Fix](index_duplicates_fix.md) — root cause (\texttt spacing) + fix applied 2026-04-07; needs recompile to verify
- [No hard line wrapping](feedback_line_wrapping.md) — don't wrap prose lines at fixed width in .md/.Rmd files (breaks forum posts)
- [Scripts in issues/](feedback_script_location.md) — one-off diagnostic/generation scripts go in issues/, not R/ (R/ is for book production code only)
- [Quarto LLM docs](reference_quarto_llms.md) — https://quarto.org/llms.txt for authoritative Quarto documentation lookup
- [Quarto skills collection](reference_quarto_skills.md) — posit-dev/skills on GitHub: Claude skills/knowledge for Quarto authoring
- [DeepWiki Quarto CLI](reference_deepwiki_quarto.md) — internal architecture docs; useful for diagnosing *why* Quarto behaves a certain way, not for authoring
- [git pull --rebase](feedback_git_pull_rebase.md) — use --rebase not plain pull when push is rejected; avoids cluttering history with merge commits
- [PDF build task](project_pdf_build_task.md) — build final Vis-MLM.pdf (print config only), then archive outputs to pdf/ folder; see issues/quarto-pdf-help.md
- [Dual-build cleanup plan](project_dual_build.md) — RESOLVED 2026-06-01: base config has no appendices; online profile adds them; both PDF and HTML verified working
- [Part color themes](project_part_colors.md) — PDF part colors in preamble.tex; partIII (green) too light, needs darkening; smartdiagram + HTML side still todo
