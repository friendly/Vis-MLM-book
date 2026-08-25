# Tasks

Living task/cleanup tracker for this project, replacing `issues/Tasks-Issues.md` as the
place to log new items. `Tasks-Issues.md` stays where it is as the original project notes
(mostly historical/superseded at this point — most of its items are marked `[DONE]` or
`[FIXED]`); it isn't being rewritten, just no longer the place new items get added.

---

## Open items

- **`issues/` cleanup: `rcode-appendix/` grouping + a top-level `scripts/` folder?**
  (2026-08-25) During the `issues/` reorganization (moving solved items to `solved/`,
  grouping `indexing/` and `image-quality/`, moving CRC-metadata files to `production/`),
  held off on grouping `task-r-code.md`, `figcode-gaps.md`, `find-uncovered-figures.R`,
  `make-rcode-appendix.R`, `scan_fig_files.R` into an `issues/rcode-appendix/` folder.

  MF's reasoning: `make-rcode-appendix.R` is still an **active** script — it needs to run
  again whenever new R files are added for HTML figures, not a closed issue to file away.
  That raises a broader question worth deciding deliberately rather than folding into the
  same "topic subfolder" move as the genuinely-closed stuff: should there be a top-level
  `scripts/` folder for scripts that are part of the ongoing HTML/PDF production workflow
  (this one plus whatever else turns out to be "active tooling" rather than "issue
  investigation"), separate from `issues/` entirely? MF said he'll take this up shortly —
  revisit then, and figure out which of the 5 files are genuinely active vs. which are
  one-off investigation notes that *do* belong in `issues/rcode-appendix/`.
