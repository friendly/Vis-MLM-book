---
name: Use git pull --rebase when push is rejected
description: When git push is rejected because remote has new commits, use git pull --rebase instead of plain git pull
type: feedback
---

Use `git pull --rebase` (not plain `git pull`) when a push is rejected because the remote has commits not in the local branch.

**Why:** The repo sees frequent commits from another machine/session, making push rejections common. Plain `git pull` creates extra merge commits cluttering the history; `--rebase` replays local commits on top of the remote ones for a cleaner linear history.

**How to apply:** As soon as `git push` fails with "fetch first", run `git pull --rebase` then retry `git push`.
