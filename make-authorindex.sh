#!/bin/bash
# make-authorindex.sh
# Run after PDF compilation to generate the author index (.ain file).
# Usage: bash make-authorindex.sh
# Then recompile the PDF to incorporate the author index.

export BIBINPUTS="C:/R/Projects/Vis-MLM-book/bib"
export BSTINPUTS="C:/Users/friendly/AppData/Roaming/TinyTeX/texmf-dist/bibtex/bst"

cd "C:/R/Projects/Vis-MLM-book"

echo "Running authorindex on index.aux ..."
perl latex/authorindex_debug -d index

if [ $? -eq 0 ]; then
    echo "Success: index.ain written."
    echo "Now uncomment \\printauthorindex in latex/after-body.tex and recompile."
else
    echo "authorindex failed. Check output above."
fi
