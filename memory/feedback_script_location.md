---
name: Issue-related scripts belong in issues/, not R/
description: One-off diagnostic or generation scripts go in issues/, not R/
type: feedback
---

Place one-off scripts that relate to a specific issue or task in `issues/`, not in `R/`. The `R/` directory is for scripts that generate figures and analyses used in the book chapters. Scripts that are tools for investigating or fixing issues (e.g., `find-uncovered-figures.R`, `make-rcode-appendix.R`) belong in `issues/` alongside the task files they support.

**Why:** `R/` is the book's production code directory. Issue-related scripts are editorial/maintenance tools, not book content. Keeping them in `issues/` makes their purpose clear and avoids cluttering `R/`.

**How to apply:** When writing a script to scan, generate, or fix something related to an open issue, default to `issues/` as the location. Only put scripts in `R/` if they produce figures or analyses that appear in a chapter.
