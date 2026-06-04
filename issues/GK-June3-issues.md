# Issues I (GK) noticed with the latest build (June 3rd, 2026 @ ~2pm)

## Index.qmd

**Thinking about "coding"**

- In PDF, there appears to be a div that was commented out halfway (e.g., with \-\-\> after but not \<\!\-\- before)
  + This does not appear in the HTML version or the `index.qmd` file (as far as I can tell)
  + [PENDING] The `.qmd` source has proper complete `<!-- ... -->` blocks at lines 33-36 and 260-264; cannot confirm without a fresh PDF build.
- In both PDF and HTML, there is a missing `Wickham:2014:tidy` reference. [FIXED]

## Chapter 13: Visualizing Equality of Covariance Matrices

**13.7 --- Low-rank views**

- In first paragraph, a citation appears as "(Friendly & Sigal (2018))" instead of "(Friendly & Sigal, 2018)"
  + [FIXED 2026-06-03] Changed `(@FriendlySigal:2018:eqcov)` → `[@FriendlySigal:2018:eqcov]` in `13-eqcov.qmd` line 552.
  + [FIXED 2026-06-03] Same pattern in Ch14 para 1: `(@Belsley-etal:80; @CookWeisberg:82)` → `[@...]` in `14-infl-robust.qmd` line 31.
  + Broader scan found similar `(@...)` patterns in Ch01, 03, 04, 05, 06, 07, 11 — lower-priority cleanup, not yet done.

**What Have We Learned?**

- Need a space between colon and rest of text, e.g., "Visualization beats test statistics alone*:*While ..." -> "Visualization beats test statistics alone*: *While ...
  + [FIXED 2026-06-03] Space added after colon in all 6 bullet points in `summary/Ch13-summary.qmd`.

## Colophon

**Package versions**

- `spida2` not listed. Is this a result of it not having a `pkg()` or `package()` call in-text?
  + [CONFIRMED] Yes — `spida2` is used via `spida2::` namespace only (to avoid masking `ggplot2::labs()`), so `write_pkgs()` never captures it. Decision needed: add a silent `pkg()` call somewhere, or handle specially in colophon.
  + [PENDING] Broader scan for other packages with the same issue not yet done.

## Author Index

- This is missing. Codex had changed the path from being hardcoded to your system when I was implementing the dual-build fixes--I wonder if this change is the cause of this issue.
  + [FIXED 2026-06-03] Root cause confirmed and fixed. Two bugs: (1) `make-authorindex.sh` used a POSIX path for BIBINPUTS that MiKTeX's BibTeX couldn't resolve; (2) `latex/authorindex` Perl script path-conversion regex didn't handle Cygwin's `/cygdrive/c/...` format, and used `:` instead of `;` as path separator. Fix: `make-authorindex.sh` now uses TinyTeX's BibTeX (via PATH prepend) and `cygpath -w` for BIBINPUTS; `latex/authorindex` updated to handle Cygwin paths. Verified: 390 authors generated.