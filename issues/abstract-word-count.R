# abstract-word-count.R
# Verify word counts of chapter abstracts in issues/chapter-abstracts.md
# (Step 4 of issues/abstract-plan.md). Flags any abstract outside the
# strict 100-200 word limit. Run from the project root or issues/:
#   Rscript issues/abstract-word-count.R

path <- if (file.exists("issues/chapter-abstracts.md")) {
  "issues/chapter-abstracts.md"
} else if (file.exists("chapter-abstracts.md")) {
  "chapter-abstracts.md"
} else {
  stop("chapter-abstracts.md not found; run from the project root or issues/")
}

lines <- readLines(path, encoding = "UTF-8")

heads <- grep("^## ", lines)
if (length(heads) == 0) stop("No '## Chapter N' headings found in ", path)

ends <- c(heads[-1] - 1L, length(lines))

results <- data.frame(chapter = character(), words = integer(),
                      status = character(), stringsAsFactors = FALSE)

for (i in seq_along(heads)) {
  title <- sub("^## +", "", lines[heads[i]])
  body <- lines[(heads[i] + 1L):ends[i]]
  body <- body[!grepl("^#", body)]           # ignore any nested headings
  text <- trimws(paste(body, collapse = " "))
  n <- if (nchar(text) == 0) 0L else length(strsplit(text, "\\s+")[[1]])
  status <- if (n < 100) "TOO SHORT (<100)" else if (n > 200) "TOO LONG (>200)" else "OK"
  results <- rbind(results, data.frame(chapter = title, words = n, status = status))
}

print(results, row.names = FALSE)

bad <- results$status != "OK"
if (any(bad)) {
  cat("\nFAIL:", sum(bad), "abstract(s) outside the 100-200 word limit.\n")
  quit(status = 1)
} else {
  cat("\nAll", nrow(results), "abstracts are within the 100-200 word limit.\n")
}
