# verify-dpi-fixes.R
# Independent check of CMYK-checklist.md (the LOW-DPI image list) after the
# dpi-fixes merge. For each checklist row it re-measures the image file now in
# images/, finds how the book prints it now (current out-width in the .qmd, or a
# vector PDF substitute for LaTeX), and recomputes the effective print DPI.
# It also checks the file was actually changed after the July audit.
#
# Run from the project root:
#   Rscript issues/image-quality/verify-dpi-fixes.R
# Writes issues/image-quality/verify-dpi-results.csv and prints a summary.

suppressPackageStartupMessages({
  library(stringr); library(dplyr); library(magick)
})

textwidth_in <- 5.48   # krantz2 \textwidth, from cmyk-image-audit.R's probe
audit_date   <- as.Date("2026-07-10")

# ── 1. checklist rows ─────────────────────────────────────────────────────────
ck   <- readLines("issues/image-quality/CMYK-checklist.md", encoding = "UTF-8")
rows <- ck[str_detect(ck, "^\\| \\[[ X]\\] \\|")]
cells <- str_split(rows, "\\s*\\|\\s*")
chk <- tibble(
  done    = str_detect(rows, "^\\| \\[X\\]"),
  file    = str_match(rows, "\\]\\(\\.\\./\\.\\./([^)]+)\\)")[, 2],
  ck_eff  = as.numeric(sapply(cells, `[`, 5)),
  ck_pct  = as.numeric(str_match(sapply(cells, `[`, 6), "^([0-9.]+)%")[, 2]),
  ck_in   = as.numeric(str_match(sapply(cells, `[`, 6), "\\(([0-9.]+)")[, 2]),
  action  = sapply(cells, `[`, 9)
)

# ── 2. how each image is printed now ──────────────────────────────────────────
qmds <- c(list.files(".", "\\.qmd$"), list.files("child", "\\.qmd$", full.names = TRUE))
src  <- setNames(lapply(qmds, readLines, encoding = "UTF-8"), qmds)

find_use <- function(file) {
  base <- basename(file); stem <- tools::file_path_sans_ext(base)
  hits <- list(); pdf_sub <- FALSE
  for (q in names(src)) {
    lines <- src[[q]]
    # a vector PDF of the same stem used anywhere (LaTeX branch) counts as substitute
    if (any(str_detect(lines, fixed(paste0(stem, ".pdf"))))) pdf_sub <- TRUE
    for (i in which(str_detect(lines, fixed(base)))) {
      if (str_detect(lines[i], "^\\s*(<!--|#[^|])")) next          # commented out
      back <- lines[max(1, i - 15):i]
      ow <- str_match(back, '#\\|\\s*out-width:\\s*"?([0-9.]+)%')[, 2]
      ow <- tail(ow[!is.na(ow)], 1)
      wa <- str_match(lines[i], "width\\s*=\\s*\"?([0-9.]+)%")[, 2]   # markdown {width=}
      # multi-panel figure: each panel gets out-width / ncol of the text width
      nc <- str_match(back, "#\\|\\s*layout-ncol:\\s*([0-9]+)")[, 2]
      nc <- tail(nc[!is.na(nc)], 1)
      pct <- if (length(ow)) as.numeric(ow) else if (!is.na(wa)) as.numeric(wa) else if (length(nc)) 100 else NA
      if (length(nc)) pct <- pct / as.numeric(nc)
      hits[[length(hits) + 1]] <- data.frame(qmd = q, line = i, out_pct = pct)
    }
  }
  h <- if (length(hits)) do.call(rbind, hits) else data.frame(qmd = NA, line = NA, out_pct = NA)
  list(where = paste(unique(paste0(h$qmd, ":", h$line)), collapse = "; "),
       out_pct = suppressWarnings(max(h$out_pct, na.rm = TRUE)),
       pdf_sub = pdf_sub)
}

info <- lapply(chk$file, function(f) {
  u <- find_use(f)
  px <- if (file.exists(f)) image_info(image_read(f))[, c("width", "height")] else data.frame(width = NA, height = NA)
  last <- system2("git", c("log", "-1", "--format=%ad", "--date=short", "--", shQuote(f)), stdout = TRUE)
  data.frame(exists = file.exists(f), width_px = px$width, height_px = px$height,
             changed = if (length(last)) last else NA,
             used_at = u$where, now_pct = ifelse(is.finite(u$out_pct), u$out_pct, NA),
             pdf_sub = u$pdf_sub)
})
res <- bind_cols(chk, bind_rows(info)) |>
  mutate(
    # checklist's printed width is the fallback (layout panels, markdown sizing)
    print_in = ifelse(!is.na(now_pct) & now_pct < ck_pct, textwidth_in * now_pct / 100, ck_in),
    eff_dpi  = round(width_px / print_in),
    changed_since_audit = as.Date(changed) >= audit_date,
    verdict = case_when(
      !exists                 ~ "MISSING FILE",
      pdf_sub                 ~ "OK (vector PDF for print)",
      eff_dpi >= 300          ~ "OK",
      eff_dpi >= 250          ~ "BORDERLINE (250-299)",
      TRUE                    ~ "LOW"
    )
  )

write.csv(res, "issues/image-quality/verify-dpi-results.csv", row.names = FALSE)

cat("\nRows:", nrow(res), "  marked done:", sum(res$done), "\n\n")
print(table(done = res$done, verdict = res$verdict))
cat("\nDone rows not verified OK, or not changed since the audit:\n")
print(res |> filter(done, !str_starts(verdict, "OK") | !changed_since_audit) |>
        select(file, action, width_px, print_in, eff_dpi, changed, verdict), width = 200)
cat("\nOpen rows:\n")
print(res |> filter(!done) |> select(file, width_px, print_in, eff_dpi, used_at, verdict), width = 200)
