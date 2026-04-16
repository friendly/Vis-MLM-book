---
name: task-*.md convention
description: Purpose and conventions for issues/task-*.md files in the Vis-MLM-book project
type: project
---

Files named `issues/task-*.md` each document a **single specific problem** and the full path to solving it. They serve as a running log, not just a to-do list — they record what was tried, what failed, why it failed, and what ultimately worked.

**Why:** The problems in this project (Quarto/pandoc pipeline gaps) are non-obvious and hard to rediscover. These files preserve the reasoning so future sessions don't repeat past debugging.

**How to apply:**
- When starting work on a known issue, read the relevant `task-*.md` first — it has the prior context.
- When work on an issue produces new findings (errors, fixes, workarounds), update the task file immediately.
- Mark the status header when solved: `← **SOLVED**` with a date.
- Keep a checklist of remaining steps at the bottom; check off items as they are completed.
- Existing files: `task-authorindex.md` (author index pipeline — SOLVED 2026-04-05).
