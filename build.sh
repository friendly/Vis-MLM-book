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
#   --all             Build both formats (default; HTML uses --profile online)
#   --clean-cache     Delete all tex.json freeze caches before building.
#                     REQUIRED after editing latex/latex-commands.qmd or any
#                     other {{< include >}}'d file — Quarto does not track
#                     included-file changes for cache invalidation.
#   --authorindex     Re-run the authorindex Perl script after PDF build,
#                     regardless of whether citations appear to have changed.
#   --full            Equivalent to: --all --clean-cache --authorindex
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
#   - After a successful PDF build, Quarto renames index.tex → Vis-MLM.tex
#     and copies index.pdf → docs/Vis-MLM.pdf
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
    --full)         FORMAT="all"; CLEAN_CACHE=true; RUN_AUTHORINDEX=true; shift ;;
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
  compute_fingerprint > "$FINGERPRINT_FILE"
  echo "    Fingerprint saved to $FINGERPRINT_FILE"
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
  pdf)  run quarto render --profile print --to pdf  ;;
  html)
    # Two HTML passes: index.qmd is rendered first (before other chapters'
    # xref data exists), so cross-refs in index.html to later chapters show
    # section titles instead of numbers on the first pass. The second pass
    # finds the complete xref database and resolves them correctly.
    # --profile online adds 15-case-studies.qmd and Rcode.qmd as appendices.
    echo "    Pass 1/2: HTML (builds xref database)"
    run quarto render --to html --profile online
    echo "    Pass 2/2: HTML (resolves cross-refs in index.html)"
    run quarto render --to html --profile online
    ;;
  all)
    # Render formats sequentially, not combined.
    # quarto render (all at once) fails on books: it tries to readfile
    # '04-xxx.html' at the project root during PDF cross-ref resolution,
    # but HTML output goes to docs/.  Separate renders avoid this.
    # Two HTML passes needed so index.html cross-refs resolve (see --html note).
    # --profile online adds online-only appendices to HTML; PDF uses base config only.
    echo "    Step 1/3: HTML pass 1 (builds xref database)"
    run quarto render --to html --profile online
    echo "    Step 2/3: HTML pass 2 (resolves cross-refs in index.html)"
    run quarto render --to html --profile online
    echo "    Step 3/3: PDF (print profile — no online-only appendices)"
    run quarto render --profile print --to pdf
    ;;
esac
echo ""

# ---------------------------------------------------------------------------
# Step 3: Post-build — authorindex
# ---------------------------------------------------------------------------
if [[ "$FORMAT" == "html" ]]; then
  echo "--> HTML-only build: skipping authorindex."
else
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
    if command -v authorindex &>/dev/null; then
      run authorindex -i "$AUX"
      echo "    Generated: $AIN"
      if [[ -f "$AIN" ]]; then
        run cp "$AIN" Vis-MLM.ain
        echo "    Copied:    $AIN → Vis-MLM.ain"
      fi
      save_fingerprint
    else
      echo "    WARNING: 'authorindex' not found on PATH."
      echo "    Typical MiKTeX location:"
      echo "      C:/Program Files/MiKTeX/scripts/authorindex/authorindex.pl"
      echo "    Run manually:  perl <path>/authorindex.pl -i $AUX"
    fi
  fi
fi

# ---------------------------------------------------------------------------
# Step 4: Archive PDF build artifacts to pdf/
# ---------------------------------------------------------------------------
if [[ "$FORMAT" != "html" ]]; then
  echo "--> Archiving PDF build artifacts to pdf/..."
  [[ -f "docs/Vis-MLM.pdf" ]] && run cp "docs/Vis-MLM.pdf" "pdf/Vis-MLM.pdf"
  [[ -f "Vis-MLM.tex"      ]] && run cp "Vis-MLM.tex"      "pdf/index.tex"
  for f in index.aux index.ain index.idx index.ilg index.ind index.log index.toc; do
    [[ -f "$f" ]] && run cp "$f" "pdf/$f"
  done
  echo "    Done."
  echo ""
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
