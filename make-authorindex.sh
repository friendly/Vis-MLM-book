#!/usr/bin/env bash
# make-authorindex.sh
# Run after PDF compilation to generate the author index (.ain file).
# Usage: bash make-authorindex.sh
# Then recompile the PDF to incorporate the author index.

set -u

cd "$(dirname "$0")"
ROOT="$(pwd -P)"

# Use TinyTeX's BibTeX (same binary Quarto uses for PDF builds) rather than
# MiKTeX's, which appears first on PATH on Windows but fails to find
# project-local .bib files when BIBINPUTS is set as a POSIX path.
TINYTEX_BIN="${HOME}/AppData/Roaming/TinyTeX/bin/windows"
if [ -f "${TINYTEX_BIN}/bibtex.exe" ]; then
    export PATH="${TINYTEX_BIN}:${PATH}"
fi

# Make BibTeX search the repo bibliography directory first.
# On Windows, BibTeX needs a native path; use cygpath if available.
if command -v cygpath &>/dev/null; then
    export BIBINPUTS="$(cygpath -w "${ROOT}/bib");"
else
    export BIBINPUTS="${ROOT}/bib:"
fi
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
