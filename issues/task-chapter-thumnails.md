# Task: Chapter Thumbnail Overviews

## Goal

Provide a compact, single-image visual overview of all the figures in a book
chapter (HTML version only), for quickly reviewing a chapter's visual content
without paging through the rendered HTML or the `.qmd` source. Built on
`myutil::magick_collage()`, a general-purpose montage function added to the
`myutil` package for exactly this kind of use.

## Motivation

- Chapters can have a dozen or more knitr-generated figures; there's no quick
  way to see them all together to spot missing figures, inconsistent theming
  (font size, color palette), duplicate/near-duplicate plots, or figures that
  render at the wrong size.
- A thumbnail grid, generated straight from `figs/chNN/`, is a much faster
  review pass than opening the built HTML chapter.

## Status: prototype working, one known gap

`test/chapter_collage.R` has two functions:

- `chapter_figs_ordered(chapter, book_dir)` -- finds the `.qmd` file(s) whose
  `knitr::opts_chunk$set(fig.path = "figs/<chapter>/")` matches (a chapter can
  span more than one file -- ch04 is split across `04-multivariate_plots.qmd`
  and `04b-higher.qmd`, both writing into `figs/ch04/`), extracts `#| label:
  fig-*` lines in source order, and matches each label to its
  `<label>-<N>.png` output(s) in `figs/<chapter>/`. Anything left over in the
  folder that can't be traced to a label is appended alphabetically at the
  end, with a message.
  
- `chapter_collage(chapter, book_dir, geometry, ...)` -- wraps the above with
  `columns = ceiling(sqrt(n))` and a smaller-than-default `geometry =
  "x250+5+5"` (vs. `magick_collage()`'s own default `"x500+10+5"`), since this
  is meant as a compact overview, not full-size figures. Writes the result to
  `images/<chapter>_collage.jpg` -- deliberately *not* `figs/<chapter>/`,
  which is knitr's own generated-figure output directory and could be wiped
  on a full rebuild; `images/` is already this book's convention for
  hand-placed static assets (e.g. `images/anscombe1.png`, see the gap below).
  Writing into `figs/<chapter>/` would also risk `chapter_figs_ordered()`
  picking up the collage from a previous run as an "orphan" file on the next.

Verified on ch03: 7 PNGs correctly assembled into a 3x3 grid, in the order
they appear in `03-getting_started.qmd` rather than filename-alphabetical
order (which would have put `fig-davis-diagnostic-1.png` before
`fig-davis-reg1-1.png`/`fig-davis-reg2-1.png`, even though the diagnostic
plot appears later in the chapter). It also correctly flagged
`ch02-anscombe1-old.png` as an orphaned leftover file with no matching
chunk label, rather than sorting it in alphabetically.

Also tried on ch04 (spans `04-multivariate_plots.qmd` +
`04b-higher.qmd`, both writing to `figs/ch04/`): 40 PNGs correctly matched
and ordered across both source files into a 7x6 grid. It also flagged
`proj-vectors-1.png`, `proj-vectors-2.png`, and `proj-P2-vec-1.png` as
orphans -- these are stale renders from chunks `proj-vectors` and
`proj-P2-vec`, both now `eval: false` (their output was replaced by
hand-tuned static images, same pattern as ch03's `ch02-anscombe1-old.png`).
This run is also what surfaced the scale of the gap below: ch04 has 61
`#| label: fig-*` chunks total, but only 40 made it into the collage.

Also tried on ch05 (`05-pca-biplot.qmd`): 20 PNGs correctly matched and
ordered into a 5x4 grid. Same recurring pattern again, at smaller scale --
orphans `04-outlier-demo1.png`/`04-outlier-demo2.png` trace to
`fig-outlier-demo` (now `knitr::include_graphics("images/outlier-demo.png")`)
and `fig-outlier-animation` (`images/outlier-demo.gif`), out of 22 `fig-*`
labels in the chapter. No new wrinkle beyond what ch03/ch04 already showed.

### Known gap: `knitr::include_graphics()` figures are silently skipped

Some figures aren't knitr chunk *output* -- they're pre-made images pulled in
via `knitr::include_graphics("images/....png")` inside a chunk that still
carries a `#| label: fig-*`. ch03 alone has three of these:

- `fig-anscombe1` -> `knitr::include_graphics("images/anscombe1.png")`
  (this is *why* `figs/ch03/ch02-anscombe1-old.png` exists as an orphan --
  it's an old, no-longer-used render of what's now a hand-tuned static image)
- `fig-datasaurus-html` -> `knitr::include_graphics("images/DataSaurusDozen.gif")`
- `fig-draft-lottery-photo` -> `knitr::include_graphics("images/1969_draft_lottery_photo.jpg")`

`chapter_figs_ordered()` only looks for `<label>-N.png` inside
`figs/<chapter>/`, so these labels currently contribute nothing to the
ordered list -- not even a leftover warning, since there's no filename to
not-match. The collage is silently incomplete for any chapter with
`include_graphics()` figures.

Fixing this means parsing chunk *bodies*, not just the `#| label:` option
line -- i.e. tracking chunk boundaries (` ```{r} ` ... ` ``` `) and checking
whether the body contains an `include_graphics("path")` call, then resolving
that path (relative to the book root, e.g. `images/anscombe1.png`) instead of
looking in `figs/<chapter>/`. Also need a decision on the animated-gif case
(`fig-datasaurus-html`) -- `magick_collage()` currently only matches
`png`/`jpe?g` by pattern, so a `.gif` wouldn't be picked up even once path
resolution is fixed; probably fine to just skip non-static formats, but worth
deciding deliberately rather than by accident.

**ch04 shows this is a bigger problem than ch03 suggested.** Of ch04's 61
`fig-*` labels, roughly 20 resolve via `include_graphics()` to something
`chapter_figs_ordered()` currently can't find -- e.g. `fig-mahalanobis`,
`fig-galton-corr`, `fig-penguin-species`, `fig-corrgram-renderings`,
`fig-cover-GEB2`, `fig-projection`, `fig-proj-combined`,
`fig-proj-vectors`/`fig-proj-P2-vec` (the two noted above),
`fig-peng-tourr-diagram`, `fig-peng-tour-demo` (4 frames, under
`images/tours/`), `fig-peng-tour-grand`/`fig-peng-tour-lda` (animated
`.gif`s), `fig-peng-tour-grand-frames` (3 frames), `fig-peng-tour-guided`
(2 frames), `fig-big5-qgraph-rodrigues`, `fig-crime-cor-image`,
`fig-crime-pvPlots`. So the current ch04 collage (40 panels) is missing
roughly a third of the chapter's actual figures, not just one or two edge
cases -- the include_graphics gap is the main blocker for this task now,
not a nice-to-have.

A few `include_graphics()`-based labels are *already* handled correctly by
accident: `fig-peng-ggpairs1`, `fig-peng-ggpcp1`, `fig-peng-ggpcp2` point at
`figs/ch04/<label>-1.png` (i.e. back at the normal knitr output location),
which is exactly the filename pattern `chapter_figs_ordered()` already
matches. Separately: `fig-peng-ggpcp1`/`fig-peng-ggpcp2` are each *defined
twice* -- once in `04-multivariate_plots.qmd` (pointing at
`images/fig-peng-ggpcp1-1.png`, itself a redundant include_graphics of an
existing figs/ch04 png), and again in `04b-higher.qmd` (pointing at
`figs/fig-peng-ggpcp1-1.png`, note: no `ch04/`). That's a pre-existing
book-authoring inconsistency (duplicate label, inconsistent path), unrelated
to the collage tooling -- flagged here since this task is what surfaced it,
but it's the book author's call whether/how to clean it up, not something
`chapter_collage()` should try to paper over.

## Use in book

The collage is a plain static image once generated -- not something a knitr
chunk builds inline -- so including it is just a conditional markdown image,
matching the `.content-visible when-format=` pattern already used elsewhere
in the book (see `issues/conditional-content.md`). HTML-only, per the Goal
above; no PDF fallback is planned (a page-filling thumbnail grid doesn't
carry over well to a printed book).

```markdown
::: {.content-visible when-format="html"}

## Chapter figures at a glance

![All figures in this chapter](images/ch03_collage.jpg){#fig-ch03-overview fig-alt="Thumbnail grid of every figure in this chapter, in the order they appear."}

:::
```

Each chapter's copy just changes `ch03` -> `chNN` in both the path and the
`#fig-chNN-overview` id; no templating needed, in keeping with how
`conditional-content.md`'s own example hardcodes per-chapter paths rather
than computing them.

Open question is placement within the chapter: an "at a glance" preview near
the top (right after the chapter intro) vs. a recap at the end. Either works
content-wise -- the image reference doesn't care where it sits in the
document -- so this is really an editorial call, not a technical one.

### Workflow: this has to be a two-pass build, not a live chunk

The collage can't be produced by a chunk *inside* the chapter it summarizes:
`chapter_collage()` needs that chapter's own figures to already exist on
disk in `figs/chNN/`, which is only true after the chapter has been rendered
once. So the actual sequence is:

1. `quarto render` (or render just the chapter) -- produces `figs/chNN/*.png`
2. Run `chapter_collage("chNN")` -- produces `images/chNN_collage.jpg`
   from those
3. `quarto render` again -- this pass picks up the now-existing collage via
   the static `![]()` reference above

Steps 2-3 only need re-running when a chapter's figures actually change, not
on every build. Wiring step 2 into Quarto's `project: pre-render:` hook in
`_quarto.yml` would automate this, but that's not set up yet -- for now it's
a manual step (see Next steps below).

## Next steps

- [ ] Extend `chapter_figs_ordered()` to parse chunk bodies so labeled chunks
      whose only output is `knitr::include_graphics("path")` resolve to that
      path instead of being silently skipped -- now the main blocker, per
      ch04 (missing ~1/3 of that chapter's figures), not an edge case
- [ ] Decide how to handle a `fig-*` label with no image at all (e.g.
      `eval: false`, chunk disabled) -- skip silently vs. warn
- [ ] Decide whether/how to represent non-static formats (e.g. the
      `DataSaurusDozen.gif`) in a static collage
- [ ] Once the gap is fixed, run across all chapters (ch01, ch03-ch15) and
      sanity-check each collage
- [ ] Firm up default `columns`/`geometry` choices based on real review use,
      not just the ch03 trial
- [ ] Longer-term: HTML lightbox treatment for the book website (click a
      thumbnail to view the figure full-size) -- not started, out of scope
      for now
- [ ] Longer-term: wire collage regeneration into `project: pre-render:` in
      `_quarto.yml` so it's automatic instead of a manual step per chapter

## Related files

- `test/chapter_collage.R` -- prototype script (`chapter_figs_ordered()`,
  `chapter_collage()`)
- `myutil` package (`C:\Dropbox\R\projects\myutil`, `R/magick_collage.R`) --
  the general-purpose montage function this depends on
- `images/ch03_collage.jpg` -- first working example output (incomplete,
  per the gap above -- missing `fig-anscombe1`, `fig-datasaurus-html`,
  `fig-draft-lottery-photo`)
- `images/ch04_collage.jpg` -- second trial, larger chapter (40 of 61
  figures; see the gap discussion above for what's missing and why)
- `images/ch05_collage.jpg` -- third trial (20 of 22 figures)
