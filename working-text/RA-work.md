# RA Work

## Woriking with the Vis-MLM-book rep0

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
   for now, but new ones would go here

* Reviews: Michael Truong worked through the book and made comments as he went along. See 
  `reviews/reviewer-MichaelT-*.md` for the style he used to make comments, which you should
  try to follow. As I went through these, I often marked them a [DONE] or [FIXED] to keep track
  
  CRC reviewers: `reviews/Reviewer {1,2}.pdf` are the main ones I want to work on now. I'll make
  a list of tasks you can work on from these.


