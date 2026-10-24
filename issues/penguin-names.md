# Penguin names: Hook Nose -> Socrates, and a name for case 35 (Falstaff)

Status (2026-10-24): **not yet applied to the book.** Waiting until the blog post is published, so the
changes can point to it.

## Background

The book names two of the three "noteworthy" penguins found by Mahalanobis D² in Ch 4
(`fig-peng-cqplot`): case 283 "Cyrano" (long bill) and case 10 "Hook Nose". Case 35 has no name.

Doubts about "Hook Nose" led to a blog post, *Palmer Penguins Cry Out: "Call Me by My Name"*:

- draft: `friendly.github.io/blog/drafts/VisMLM/penguin-names/index.qmd`
- planning notes, with the full analysis: `.../penguin-names/planning.md`
- analysis code: `.../penguin-names/R/penguin-names.R`
- published URL (when it is): `https://friendly.github.io/blog/posts/<slug>/` -- slug TBD

It re-expresses the measures as bill shape, log(L/D), and stoutness, log(M^(1/3)/F) (from the two
earlier posts, `2026-10-peng-altviews` and `2026-10-peng-body`), standardized within species.

## What was found

- **Case 10 is not hook-nosed.** Bill depth is measured top to bottom at the base: it is thickness,
  not curvature. Nothing in the data measures a hook. His bill is short (34.6 mm, 4th percentile of
  Adelies) and deep (21.1 mm, 97th): L/D = 1.64, the stubbiest bill of all 333 as measured.
  A snub nose, the opposite of Cyrano's. New name: **Socrates** (the famous snub nose; Plato, Xenophon).
- **Case 35 is the stout one.** Ordinary bill; 4650 g on 184 mm flippers. M/F³ = 0.75, the stoutest
  penguin in the data (next 0.69). Ch 5's guess, "much heavier than most and has short flippers", is
  right. New name: **Falstaff** (Shakespeare's fat knight).
- **Cyrano (283)** holds up: the bill is long *relative to its depth* (L/D 3.26, a Gentoo's bill on a
  Chinstrap), and she is also stout.
- Cara Thompson's other names (useR! 2022 poster, where "Cyrano" originally came from): **The BFG**
  (124), **Tinkerbell** (304), **Average Joe** (166). Cite as `@Thompson2022`.

## Where to change "Hook Nose" -> "Socrates"

| Where | Now | Change |
|---|---|---|
| `04-multivariate_plots.qmd:1817` | "I'll call case 10, with a very short and curved bill, "Hook Nose"." | "...with a very short, deep bill, "Socrates"" + footnote (see below) |
| `05-pca-biplot.qmd:2341` | "Case 10 (Hook Nose) ... with a highly curved beak." | "Case 10 (Socrates) ... with a short, stubby bill." |
| `14-infl-robust.qmd:494` | "case 10 is the Adélie bird we labeled "Hook Nose"" | "Socrates" |
| `14-infl-robust.qmd:622` | `name = c("HookNose", "Cyrano")` | `"Socrates"` |
| `14-infl-robust.qmd:636` | ""Hook Nose" (10) gets a weight of 0.13" | "Socrates" |
| `R/penguin/peng-manova.R:160, 180` | `name = c("HookNose", "Cyrano")` | `"Socrates"` |

Also: the talk decks `talks/Vis-MLM-talk.pptx` and `talks/Vis-MLM-talk4.pptx` (outlier, influence and
robust-MLM slides; search for "Hook"), and the notes `talks/talk4-notes.md`, `talks/outline.md`,
`talks/styles/section-header-handoff.md`, `production/abstract-notes.md`.

## Where "Falstaff" could be used for case 35

| Where | Now | Suggestion |
|---|---|---|
| `04-multivariate_plots.qmd:1778` | "The other two (10, 35) are well within the confidence envelope." | no name needed yet |
| `04-multivariate_plots.qmd:1817-1824` | Names 283 and 10; "Case 35 is well inside the Adélie ellipse, so perhaps it is unusual on one of the other variables." | Keep 35 unnamed here: the mystery is the point. Optionally "...we'll meet him again in @sec-..." |
| `05-pca-biplot.qmd:2342` | "case 35 is at the high end of dimension 4, so probably is much heavier than most and has short flippers." | **Name him here**, where his oddity is explained: "Case 35 ... has short flippers. Let's call him "Falstaff".[^falstaff]" (Also capitalize "case" -- the sentence starts lowercase.) |
| `05-pca-biplot.qmd:2253` | "three Penguins (283, 10, 35) were identified as noteworthy" | could become "(Cyrano, Socrates and 35)"; probably leave as numbers |

Footnote suggestions (once the post is published):

- Ch 4, on Socrates: `[^socrates]: The snub nose of Socrates is described by Plato and Xenophon. In earlier drafts I called him "Hook Nose", reading bill depth as curvature; it measures thickness. See [the blog post](URL) for why these penguins are unusual, and whether their names fit.`
- Ch 5, on Falstaff: `[^falstaff]: After Shakespeare's fat knight in *Henry IV*. Relative to his flipper length, he is the stoutest penguin in the data; see [the blog post](URL).`

## Other things noticed along the way

- `14-infl-robust.qmd:639`: `cases <- c(10, 124, 179, 283)` -- the four lowest robust weights. **124 is
  the BFG.** Could be named in the text after the chunk ("the BFG (124), an Adélie with the longest
  flippers of his species, ...").
- `05-pca-biplot.qmd:2339-2340`: "Our friend Cyrano ... with **his** exceptionally long, straight bill."
  Cyrano is female (the Ch 4 footnote says so): "her".
- `04-multivariate_plots.qmd:1819-1820`, the Cyrano footnote: "Edmund Rostand" should be **Edmond**;
  "Rozanne" should be **Roxane** (the heroine of the play). Could also credit Cara Thompson here as the
  source of the name (`@Thompson2022`), since the blog post now says I got it from her.
