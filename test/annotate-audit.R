# Annotate reviewer-GavinK-CodeAudit.Rmd with fold_status from chunks.RData
# Run from project root.

load("data/chunks.RData")

# Build lookup: label -> fold_status (take first match if duplicated)
lookup <- with(chunks, setNames(fold_status, label))

audit_file <- "reviews/reviewer-GavinK-CodeAudit.Rmd"
lines <- readLines(audit_file, warn = FALSE)

pat <- "^(\\*\\*\\*Label: ([^*]+)\\*\\*\\*)(.*)"

for (i in seq_along(lines)) {
  m <- regmatches(lines[i], regexec(pat, lines[i]))[[1]]
  if (length(m) == 0) next

  bold_part <- m[2]   # ***Label: fig-xxx***
  label     <- trimws(m[3])
  rest      <- m[4]   # anything already appended

  # Skip if already annotated
  if (grepl("\\[FOLDED:", rest)) next

  status <- if (label %in% names(lookup)) {
    lookup[[label]]
  } else {
    "NOT IN DATASET"
  }

  lines[i] <- paste0(bold_part, " [FOLDED: ", status, "]", rest)
}

writeLines(lines, audit_file)
cat("Done. Annotated label lines:\n")
cat(grep("\\[FOLDED:", lines, value = TRUE), sep = "\n")
