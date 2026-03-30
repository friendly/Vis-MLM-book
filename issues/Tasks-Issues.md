# Tasks and Issues for Revisions of Book
# 

## Getting started

Scan the contents of this project to understand the organization of the files for producing both an HTML and PDF version of the book.
Make a summary of this that can be read in in a new session, to pick up on new work to be done, perhaps in a CLAUDE.md file under `./claude`.

### Goals

* Produce a camera-ready PDF of the book, suitable for direct printing. It must build correctly from `Build -> Render Book` in RStudio. Currently
  I often have problems with this (some LaTeX error or something from the `_quarto.yml` file), so that I have to compile the generated `.tex` file
  separately using TeXStudio. At present, Quarto compiles the files in the root directory, and I copy these to `pdf/` because compiling to HTML
  wipes these out.

* Produce a web HTML version of the book, allowing features that can't be done in a printed version. Currently, this is hosted from the `docs/` folder
  to `https://friendly.github.io/Vis-MLM-book/`. 
  
* This repo, `https://github.com/friendly/vis-MLM-book` contains all the working files in this project. It would be better to have the web version hosted
  from a separate GitHub repo, by copying only the relevant files from here. This is something for the end, after all revisions have been done.

## Organize files related to unsolved issues

The folders `working-text/` and `test/` contain a variety of files detailing problems and issues in the book files I worked through.
Some of these have been solved (sometimes noted explicitly as `[**Status**: Solved]` in the file), sometimes not.
But there are lots of files here that were simply test files for some things I wanted to do in the text, but needed to try out separately.
Scan these folders and move files that are actually tasks or issues to the `issues/` folder.

Make an overall list of these things to prioritize work, by inserting / appending to this file.


## PDF issues

* Unable to create an Author index. For LaTex, this should be done by the `authorindex` perl script, but I've been unable to make this run. 
  See: `issues/build-problems/authorindex.md`

* Cover page: I've been unable to include a cover page image, "C:\R\Projects\Vis-MLM-book\images\cover\cover-peng.jpg" using Quarto, nor indeed
  any other front matter. What I've done so far is to use Adobe Acrobat to add the cover image manually after compiling the PDF

## HTML issues





