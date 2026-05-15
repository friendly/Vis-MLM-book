parse_toc <- function(file) {
  lines <- readLines(file)
  lines <- grep("^\\\\contentsline \\{(chapter|part)\\}", lines, value = TRUE)

  type      <- sub("^\\\\contentsline \\{([^}]+)\\}.*", "\\1", lines)
  page_str  <- sub(".*\\}\\{([^}]+)\\}\\{[^}]+\\}%?$", "\\1", lines)

  raw_title <- sub("^\\\\contentsline \\{[^}]+\\}\\{(.*)\\}\\{[^}]+\\}\\{[^}]+\\}%?$", "\\1", lines)
  title <- raw_title
  title <- gsub("\\\\numberline \\{[^}]+\\}", "", title)
  title <- gsub("\\\\hspace \\{[^}]+\\}", " ", title)
  title <- gsub("\\\\[a-zA-Z]+\\{([^}]*)\\}", "\\1", title)
  title <- gsub("\\\\[a-zA-Z]+", "", title)
  title <- trimws(title)

  to_int <- function(s) {
    n <- suppressWarnings(as.integer(as.roman(toupper(s))))
    if (is.na(n)) n <- suppressWarnings(as.integer(s))
    n
  }
  page <- sapply(page_str, to_int)
  data.frame(type = type, title = title, page = page, stringsAsFactors = FALSE)
}

pages_per_chapter <- function(df, total) {
  ch <- df[df$type == "chapter", ]
  # drop front matter (pages in roman numerals = large numbers before p1)
  ch <- ch[ch$page >= 1, ]
  # sort by page
  ch <- ch[order(ch$page), ]
  ch$next_page <- c(ch$page[-1], total + 1)
  ch$pages <- ch$next_page - ch$page
  ch[, c("title", "page", "pages")]
}

prev_total <- 543  # pdf/Vis-MLM.pdf (Apr 17 2026), confirmed via pdftools
curr_total <- NA   # PDF not yet generated; TOC dated May 15 2026

prev <- parse_toc("Vis-MLM.toc")
curr <- parse_toc("index.toc")

cat("Previous total pages:", prev_total, "\n")
cat("Current total pages: not yet available\n\n")

pp <- pages_per_chapter(prev, prev_total)
pc <- pages_per_chapter(curr, ifelse(is.na(curr_total), 999, curr_total))

# merge by title
merged <- merge(pp, pc, by = "title", all = TRUE, suffixes = c("_prev", "_curr"))
merged <- merged[order(merged$page_prev), ]
merged$diff <- merged$pages_curr - merged$pages_prev

cat(sprintf("%-48s %5s %5s %5s %5s\n", "Chapter", "p_prev", "n_prev", "p_curr", "n_curr"))
cat(strrep("-", 70), "\n")
for (i in seq_len(nrow(merged))) {
  r <- merged[i, ]
  cat(sprintf("%-48s %5s %5s %5s %5s\n",
    substr(r$title, 1, 48),
    ifelse(is.na(r$page_prev), "—", r$page_prev),
    ifelse(is.na(r$pages_prev), "—", r$pages_prev),
    ifelse(is.na(r$page_curr), "—", r$page_curr),
    ifelse(is.na(r$pages_curr), "—", r$pages_curr)))
}
