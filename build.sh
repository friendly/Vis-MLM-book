#!/usr/bin/env bash
# build.sh — Build HTML and/or PDF for Vis-MLM-book
# Run from a terminal (not RStudio Build button) for reliable results.
#
# Usage:
#   ./build.sh [OPTIONS]
#
# Options:
#   --pdf             Build PDF only (base config; online-only chapters excluded)
#   --html            Build HTML only (uses --profile online; all chapters included)
#   --all             Build both formats (default; PDF first, HTML last)
#   --clean-cache     Delete all tex.json freeze caches before building.
#                     REQUIRED after editing latex/latex-commands.qmd or any
#                     other {{< include >}}'d file — Quarto does not track
#                     included-file changes for cache invalidation.
#   --authorindex     Re-run the authorindex Perl script after PDF build,
#                     regardless of whether citations appear to have changed.
#   --full, -full     Equivalent to: --all --clean-cache --authorindex
#   -n, --dry-run     Show what would be done without doing it
#   -h, --help        Show this help
#
# Authorindex auto-detection:
#   After each successful authorindex run, a fingerprint of all @citation-key
#   references across the .qmd files is saved to .authorindex-fingerprint.
#   On subsequent builds, if citations appear to have changed, a reminder is
#   printed. Use --authorindex to re-run explicitly.
#
# Notes:
#   - Close index.pdf in Acrobat before building PDF (Windows locks the file)
#   - Full build takes ~18 min; freeze cache makes partial rebuilds faster
#   - Running from a terminal (this script) is more reliable than RStudio's
#     Build button, which uses a slightly different execution path
#   - Combined builds render PDF first, archive it, render HTML last, then copy
#     pdf/Vis-MLM.pdf back to docs/Vis-MLM.pdf so docs/ remains deployable.
#   - index.{log,ind,idx,ain,...} remain at the project root
#   - Vis-MLM.ain is kept in sync with index.ain for manual TeXStudio builds

set -euo pipefail
cd "$(dirname "$0")"   # always run from project root

# ---------------------------------------------------------------------------
# Defaults
# ---------------------------------------------------------------------------
FORMAT="all"
CLEAN_CACHE=false
RUN_AUTHORINDEX=false
DRY_RUN=false

FINGERPRINT_FILE=".authorindex-fingerprint"
AUX="index.aux"
AIN="index.ain"

# ---------------------------------------------------------------------------
# Parse arguments
# ---------------------------------------------------------------------------
while [[ $# -gt 0 ]]; do
  case "$1" in
    --pdf)          FORMAT="pdf";  shift ;;
    --html)         FORMAT="html"; shift ;;
    --all)          FORMAT="all";  shift ;;
    --clean-cache)  CLEAN_CACHE=true; shift ;;
    --authorindex)  RUN_AUTHORINDEX=true; shift ;;
    --full|-full)   FORMAT="all"; CLEAN_CACHE=true; RUN_AUTHORINDEX=true; shift ;;
    -n|--dry-run)   DRY_RUN=true; shift ;;
    -h|--help)      sed -n 's/^# \{0,1\}//p' "$0" | head -40; exit 0 ;;
    *) echo "Unknown option: $1.  Use --help for usage."; exit 1 ;;
  esac
done

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
run() {
  if $DRY_RUN; then
    echo "  [dry-run] $*"
  else
    "$@"
  fi
}

# Fingerprint: sorted unique @citation-keys across all .qmd files.
# New or removed citations change the fingerprint → prompt authorindex re-run.
compute_fingerprint() {
  grep -ohE '@[A-Za-z0-9_:.-]+' ./*.qmd 2>/dev/null \
    | sort -u | md5sum 2>/dev/null || echo "no-md5"
}

citations_changed() {
  [[ ! -f "$FINGERPRINT_FILE" ]] && return 0   # no prior fingerprint → assume changed
  local current
  current=$(compute_fingerprint)
  [[ "$current" != "$(cat "$FINGERPRINT_FILE")" ]]
}

save_fingerprint() {
  if $DRY_RUN; then
    echo "  [dry-run] compute_fingerprint > $FINGERPRINT_FILE"
  else
    compute_fingerprint > "$FINGERPRINT_FILE"
  fi
  echo "    Fingerprint saved to $FINGERPRINT_FILE"
}

render_html() {
  # Two HTML passes: index.qmd is rendered first (before other chapters'
  # xref data exists), so cross-refs in index.html to later chapters show
  # section titles instead of numbers on the first pass. The second pass
  # finds the complete xref database and resolves them correctly.
  # --profile online adds HTML-only appendices.
  echo "    HTML pass 1/2: builds xref database"
  run quarto render --to html --profile online
  echo "    HTML pass 2/2: resolves cross-refs in index.html"
  run quarto render --to html --profile online
}

render_pdf() {
  run quarto render --profile print --to pdf
}

check_pdf_no_appendices() {
  if $DRY_RUN; then
    echo "  [dry-run] check PDF artifacts for excluded appendices"
    return 0
  fi

  local pattern='\\chapter\{Case Studies\}|\\chapter\{R Code for Figures and Analyses\}|\\chapter\{Exercises\}|\\contentsline \{chapter\}\{\\numberline \{A\}Case Studies|\\contentsline \{chapter\}\{\\numberline \{B\}R Code for Figures and Analyses|\\contentsline \{chapter\}\{\\numberline \{C\}Exercises'
  local files=()
  [[ -f "index.toc" ]] && files+=("index.toc")
  [[ -f "Vis-MLM.tex" ]] && files+=("Vis-MLM.tex")

  if [[ ${#files[@]} -eq 0 ]]; then
    echo "    WARNING: no PDF artifacts found to check for appendices."
    return 1
  fi

  if rg -n "$pattern" "${files[@]}" >/tmp/vis-mlm-pdf-appendix-check.txt; then
    echo "    ERROR: PDF artifacts include online-only appendices:"
    cat /tmp/vis-mlm-pdf-appendix-check.txt
    return 1
  fi

  echo "    PDF appendix check passed."
}

check_html_outputs() {
  if $DRY_RUN; then
    echo "  [dry-run] check expected HTML outputs in docs/"
    return 0
  fi

  local missing=()
  local expected=(
    docs/index.html
    docs/00-Author.html
    docs/01-Prelude.html
    docs/02-intro.html
    docs/03-getting_started.html
    docs/04-multivariate_plots.html
    docs/05-pca-biplot.html
    docs/06-linear_models.html
    docs/07-linear_models-plots.html
    docs/08-lin-mod-topics.html
    docs/09-collinearity-ridge.html
    docs/10-hotelling.html
    docs/11-mlm-review.html
    docs/12-mlm-viz.html
    docs/13-eqcov.html
    docs/14-infl-robust.html
    docs/21-discrim.html
    docs/91-colophon.html
    docs/95-references.html
    docs/15-case-studies.html
    docs/30-Rcode.html
    docs/31-exercises.html
  )

  for f in "${expected[@]}"; do
    [[ -f "$f" ]] || missing+=("$f")
  done

  if [[ ${#missing[@]} -gt 0 ]]; then
    echo "    ERROR: missing expected HTML output(s):"
    printf '      %s\n' "${missing[@]}"
    return 1
  fi

  echo "    HTML output check passed."
}

post_pdf_authorindex() {
  # Keep Vis-MLM.ain in sync with index.ain for TeXStudio
  if [[ -f "$AIN" ]]; then
    run cp "$AIN" Vis-MLM.ain
    echo "--> Copied $AIN → Vis-MLM.ain  (for TeXStudio manual compilation)"
  fi

  echo ""

  if $RUN_AUTHORINDEX; then
    echo "--> Running authorindex (--authorindex requested)..."
    _do_authorindex=true
  elif citations_changed; then
    echo "NOTE: Citation fingerprint has changed — new or removed @keys detected."
    echo "      The author index may be out of date."
    echo "      Re-run with --authorindex (or --full) to regenerate index.ain."
    _do_authorindex=false
  else
    echo "--> Citations unchanged since last authorindex run. Skipping."
    _do_authorindex=false
  fi

  if ${_do_authorindex:-false}; then
    if [[ -f "make-authorindex.sh" ]]; then
      run bash make-authorindex.sh
      if [[ -f "$AIN" ]]; then
        run cp "$AIN" Vis-MLM.ain
        echo "    Copied:    $AIN → Vis-MLM.ain"
      fi
      save_fingerprint
    else
      echo "    WARNING: make-authorindex.sh not found."
      echo "    Run manually: bash make-authorindex.sh"
    fi
  fi
}

archive_pdf_artifacts() {
  echo "--> Archiving PDF build artifacts to pdf/..."
  [[ -f "docs/Vis-MLM.pdf" ]] && run cp "docs/Vis-MLM.pdf" "pdf/Vis-MLM.pdf"
  [[ -f "Vis-MLM.tex"      ]] && run cp "Vis-MLM.tex"      "pdf/index.tex"
  for f in index.aux index.ain index.idx index.ilg index.ind index.log index.toc; do
    [[ -f "$f" ]] && run cp "$f" "pdf/$f"
  done
  echo "    Done."
  echo ""
}

restore_archived_pdf_to_docs() {
  if [[ -f "pdf/Vis-MLM.pdf" ]]; then
    run cp "pdf/Vis-MLM.pdf" "docs/Vis-MLM.pdf"
    echo "--> Restored pdf/Vis-MLM.pdf → docs/Vis-MLM.pdf"
  else
    echo "    WARNING: pdf/Vis-MLM.pdf not found; docs/ will not include downloadable PDF."
  fi
}

# ---------------------------------------------------------------------------
# Pre-build checks
# ---------------------------------------------------------------------------
echo "============================================================"
echo " Vis-MLM-book build  |  format: $FORMAT"
echo "============================================================"

if [[ "$FORMAT" != "html" ]]; then
  # Warn if index.pdf is likely open (Windows file-lock)
  if [[ -f "index.pdf" ]]; then
    echo "NOTE: Make sure index.pdf is closed in Acrobat before continuing."
    echo "      (Windows locks the file and the PDF build will fail.)"
    echo ""
  fi
fi

# ---------------------------------------------------------------------------
# Step 1: Clean freeze cache
# ---------------------------------------------------------------------------
if $CLEAN_CACHE; then
  echo "--> Deleting tex.json freeze caches..."
  if $DRY_RUN; then
    echo "  [dry-run] find .quarto/_freeze -name 'tex.json' -delete"
  else
    local_count=$(find .quarto/_freeze -name "tex.json" 2>/dev/null | wc -l)
    find .quarto/_freeze -name "tex.json" -delete 2>/dev/null || true
    echo "    Deleted $local_count file(s)."
  fi
  echo ""
fi

# ---------------------------------------------------------------------------
# Step 2: Build
# ---------------------------------------------------------------------------
echo "--> Running quarto render..."
case "$FORMAT" in
  pdf)
    render_pdf
    check_pdf_no_appendices
    ;;
  html)
    render_html
    check_html_outputs
    ;;
  all)
    # Render formats sequentially, not combined.
    # quarto render (all at once) fails on books: it tries to readfile
    # '04-xxx.html' at the project root during PDF cross-ref resolution,
    # but HTML output goes to docs/.  Separate renders avoid this.
    # Build PDF first because the later HTML render should own docs/.
    # After HTML, copy the archived PDF back into docs/ for site downloads.
    echo "    Step 1/4: PDF (print profile — no online-only appendices)"
    render_pdf
    check_pdf_no_appendices
    echo ""
    post_pdf_authorindex
    archive_pdf_artifacts
    echo "    Step 2/4: HTML pass 1 (builds xref database)"
    run quarto render --to html --profile online
    echo "    Step 3/4: HTML pass 2 (resolves cross-refs in index.html)"
    run quarto render --to html --profile online
    echo "    Step 4/4: Restore downloadable PDF into docs/"
    restore_archived_pdf_to_docs
    check_html_outputs
    ;;
esac
echo ""

# ---------------------------------------------------------------------------
# Step 3: Post-build — authorindex
# ---------------------------------------------------------------------------
if [[ "$FORMAT" == "html" ]]; then
  echo "--> HTML-only build: skipping authorindex."
elif [[ "$FORMAT" == "pdf" ]]; then
  post_pdf_authorindex
fi

# ---------------------------------------------------------------------------
# Step 4: Archive PDF build artifacts to pdf/
# ---------------------------------------------------------------------------
if [[ "$FORMAT" == "pdf" ]]; then
  archive_pdf_artifacts
fi

# ---------------------------------------------------------------------------
# Done
# ---------------------------------------------------------------------------
echo ""
echo "============================================================"
echo " Done."
if [[ "$FORMAT" != "html" ]]; then
  [[ -f "docs/Vis-MLM.pdf" ]] && echo " PDF  → docs/Vis-MLM.pdf  (archived to pdf/)"
fi
if [[ "$FORMAT" != "pdf" ]]; then
  [[ -f "docs/index.html" ]] && echo " HTML → docs/index.html"
fi
echo "============================================================"
