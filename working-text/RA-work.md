# RA Work

## Woriking with the Vis-MLM-book repo

* Become familiar with the repo file structure

  * Chapter files: `00-Author.qmd` ... `95-references.qmd` + `Rcode.qmd` (just added)
  
  * Main folders:

```
├── bib     .bib files
├── blogs   potential blog posts (moved to friendly.github.io )
├── child   included chapter sections via {r child=} 
├── data    datasets used in book, but most moved to packages
├── docs    where the book gets built
├── exercises chapter exercises (WIP)
├── figs    all R-generated images (png, pdf) get written here 
├── images  other images, mostly via knitr::includegraphics()
├── issues  technical issues I'm working on
├── latex   LaTeX files for PDF
├── memory  Claude memory (here so travels with repo)
├── papers  a few papers I parked here
├── pdf     saved copies of PDF version
├── R       all R code for the book
├── reviews reviews of the book
├── summary chapter summaries included via {r child=}
├── test    tests of various things
├── working-text  notes, in-progress work, ...
├── _extensions Quarto extensions
```


* Branches: Do **all** your work on a branch, not master. Let me know when 
you have something to submit as a PR. You'll have to sync your branch with master.

## Tasks

* `issues/Tasks-Issues.md` has a list of technical issues related to LaTeX, 
   building both HTML & PDF and other things I've been working on, mainly with Claude.
   Some of these are broken out into specific `task-*.md` files. Just be aware of these
   for now, but new ones would go here.

* **TODOs**: There are many **TODO** notes in the book. Those that have been resolved are commented out.
  There is a list of these in `issues/TODOs,md`. The ones still visible should be resolved.
  This is largely a task for me, but you could help as you read through the text of the `.qmd` files.
  
* **Online-only content**: Ch 15 and what appears as Appendix A are most likely only to appear in the HTML version
  (with some reference to them in the printed PDF). An approach to doing this is described in `issues/online-only.md`,
  which involves Quarto process groups, with different `_quarto.yml` files.

* **Reviews**: Michael Truong worked through the book and made comments as he went along. See 
  `reviews/reviewer-MichaelT-*.md` for the style he used to make comments, which you should
  try to follow. As I went through these, I often marked them a [DONE] or [FIXED] to keep track
  
* **CRC reviewers**: `reviews/Reviewer {1,2}.pdf` are the main ones I want to work on now. I'll make
  a list of tasks you can work on from these.
  
  + Code in the HTML version: I've `code-fold: true/show` for code chunks inconsistently. Not all code needs
    to be shown explicitly as long as it can be toggled on. Suggest chunks that can easily appear folded
    when they are not essential to the narrative
    
  + Too much code in the PDF book?: One reviewer commented that there was too much code displayed in the book and
    length could be shortened by excluding some. This can be done selectively using the `knitr` option
    `echo=knitr::is_html_output()`:

````markdown
`{r, echo=knitr::is_html_output()}
# This code will be visible in HTML, but hidden in PDF/Word
print("Hello World")
`
````

  + Reviewer 2 makes many specific comments that should be addressed. It would be good to edit the `reviews/Reviewer 2.pdf`
    file to mark them FIXED when done to keep track.

* **DOIs in R pkg references**: With R 4.6.0, DOIs are now included in the results of `\citation{}`. 
  The package bibliography files under `bib/` should be regenerated once I switch to this version of R.
