# Task: Author Index Generation

## Problem summary

The book needs an **Author Index** listing cited authors and the pages where they are cited.
In traditional LaTeX/BibTeX workflows this is handled by the `authorindex` Perl script, which:

1. Reads the `.aux` file produced by LaTeX (which contains `\bibcite` entries from BibTeX)
2. Reads the `.bib` file(s) to get author names
3. Writes a `.ain` file containing `\indexentry{LastName, First}{page}` entries
4. LaTeX then typesets this like a normal index via `\printauthorindex`

### What is already in place

- `latex/preamble.tex` loads `\usepackage[small,firstabbrev]{authorindex}` (twice — duplicate at lines 136 and 176; one should be removed)
- `\aimaxauthors{5}` limits indexing to ≤5 authors per citation
- `latex/after-body.tex` has the `\printauthorindex` call commented out
- The Perl script itself is at `latex/authorindex` (and `latex/authorindex_debug`)
- The required env vars are documented in `preamble.tex`:
  ```
  setx BSTINPUTS "C:/Dropbox/localtexmf/bibtex/bst"
  setx BIBINPUTS "C:/R/Projects/Vis-MLM-book/bib"
  ```
- The TeX StackExchange question is at:
  https://tex.stackexchange.com/questions/752340/running-authorindex-on-windows-mingw64-setting-bibinputs-bstinputs

### Why it fails

The `authorindex` Perl script relies on `BIBINPUTS` and `BSTINPUTS` environment variables to
locate `.bib` files and the `.bst` style file. On Windows with MINGW64/TinyTeX, these are not
set correctly, so the script cannot find what it needs. The `.bst` file (`authorindex.bst`) also
needs to be on the path TinyTeX knows about.

The Quarto-generated `.aux` file is now named `index.aux` (Quarto artifact names differ from
the output file name), which further complicates running the script.

---

## Approaches / Solutions

### Option A: Fix the Perl script invocation (minimal change)

Make the existing `authorindex` Perl script work by:

1. Setting env vars explicitly before running, in a `.bat` or PowerShell script:
   ```bat
   set BIBINPUTS=C:/R/projects/Vis-MLM-book/bib
   set BSTINPUTS=C:/Users/friendly/AppData/Roaming/TinyTeX/texmf-dist/bibtex/bst
   perl latex/authorindex -d index
   ```
   (`-d` = use BibTeX directly; `index` = base name of the `.aux` file Quarto generates)

2. The `.bst` file `authorindex.bst` must be findable by BibTeX. Check with:
   ```
   kpsewhich authorindex.bst
   ```
   If not found, copy it into `bib/` or the TinyTeX local tree.

3. After running, uncomment `\printauthorindex` in `latex/after-body.tex` and recompile.

**Pros:** Uses existing infrastructure, minimal new code.  
**Cons:** Requires Perl working in the shell; env var setup is fragile across machines.

---

### Option B: Rewrite in R (no Perl dependency)

Parse the `.aux` and `.bib` files in R to produce the `.ain` file directly.
The logic is:

1. Read `index.aux`, extract all `\bibcite{key}{number}` entries to get key→page mappings
2. Read the `.bib` files with `bibtex::read.bib()` or `bib2df::bib2df()` to get author lists per key
3. For each citation key on each page, emit author index entries
4. Write an `.ain` file in the format `authorindex` produces, or write a `.tex` file directly

This is a self-contained R script that could live at `R/make-authorindex.R` and be run once
after PDF compilation.

**Pros:** No Perl, no env var issues, works identically on all machines, easy to debug.  
**Cons:** Some effort to write; need to match `authorindex.bst` formatting exactly.

---

### Option C: Use `biblatex` + `biber` instead of BibTeX

`biblatex` has native support for author indexing via `\indexnames` — no separate script needed.
However, switching from BibTeX to biblatex/biber is a significant change to the build pipeline
and may conflict with the CRC `krantz` class requirements.

**Pros:** Clean, modern, no external script.  
**Cons:** Large migration effort; uncertain compatibility with krantz class and Quarto's PDF pipeline.

---

### Option D: Post-process with Python / regex (quick hack)

Similar to Option B but parse the `.aux` file with a simple Python or R script using regex,
without needing a proper BibTeX parser. Suitable if the `.bib` files are well-formed.

---

## Recommendation

**Start with Option A** to confirm the script logic is sound (i.e., that `authorindex` would
produce correct output if it could run). Set `BIBINPUTS` and `BSTINPUTS` explicitly in a
one-off batch script and run manually after PDF compile.

**If Option A proves too fragile**, implement **Option B** (R script). The `bib2df` or `RefManageR`
packages make `.bib` parsing straightforward. This is the most maintainable long-term solution
on Windows without a reliable Perl environment.

---

## Immediate next steps

- [ ] Check whether Perl is available: `perl --version` in terminal
- [ ] Check whether `authorindex.bst` is findable: `kpsewhich authorindex.bst`
- [ ] Try Option A with explicit env vars in a batch script
- [ ] Remove duplicate `\usepackage[small,firstabbrev]{authorindex}` in `preamble.tex` (lines 136 and 176)
- [ ] Decide on `.aux` base name: confirm Quarto produces `index.aux` or `Vis-MLM.aux`
- [ ] Once script produces `.ain`, uncomment `\printauthorindex` in `latex/after-body.tex`

## Related files

- `latex/authorindex` — the Perl script
- `latex/authorindex_debug` — debug version of same
- `latex/preamble.tex` — loads `authorindex` package, documents env vars
- `latex/after-body.tex` — `\printauthorindex` call (commented out)
- `issues/build-problems/authorindex.md` — original problem note + links
