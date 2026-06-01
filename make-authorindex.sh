#!/usr/bin/env bash
# make-authorindex.sh
# Run after PDF compilation to generate the author index (.ain file).
# Usage: bash make-authorindex.sh
# Then recompile the PDF to incorporate the author index.

set -u

cd "$(dirname "$0")"
ROOT="$(pwd -P)"

# Make BibTeX search the repo bibliography directory first, then fall back to
# the TeX distribution's normal search path.  The trailing ":" preserves the
# default kpathsea paths and keeps this portable across macOS, Linux, and Git
# Bash on Windows.
export BIBINPUTS="${ROOT}/bib:"
export BSTINPUTS="${BSTINPUTS:-}:"

echo "Running authorindex on index.aux ..."
perl latex/authorindex -d index

if [ $? -eq 0 ]; then
    echo "Success: index.ain written."
    echo "Recompile the PDF to incorporate the author index."
else
    echo "authorindex failed. Check output above."
    echo "(For deeper debugging, try: perl latex/authorindex_debug -d index)"
fi
