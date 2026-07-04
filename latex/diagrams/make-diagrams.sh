#!/bin/sh
# Rebuild the part-page and chapter-opener mindmap diagrams.
# Compiles every part*.tex and chap*.tex here with xelatex and moves the
# resulting PDFs to figs/diagrams/, where latex/preamble.tex picks them up
# (\IfFileExists) on part pages and chapter opening pages.
#
# Run after editing any diagram source or latex/part-colors.tex:
#   sh latex/diagrams/make-diagrams.sh
#
# Requires the pgf-blur package (soft bubble shadows):
#   tlmgr install pgf-blur
set -e
cd "$(dirname "$0")"
mkdir -p ../../figs/diagrams
for f in part*.tex chap*.tex; do
  echo "== $f"
  xelatex -interaction=nonstopmode -halt-on-error "$f" >/dev/null
  mv "${f%.tex}.pdf" ../../figs/diagrams/
done
rm -f ./*.aux ./*.log
echo "Done: diagrams rebuilt in figs/diagrams/"
