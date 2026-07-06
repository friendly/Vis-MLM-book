# index-add-chapters.R
# Reads issues/index-terms.csv and pdf/index.toc, assigns a chapter number
# and short title to each index entry, writes issues/index-terms-ch.csv.

library(dplyr)
library(readr)
library(stringr)

# ── 1. Parse chapter boundaries from index.toc ────────────────────────────────

toc_raw <- readLines("pdf/index.toc")

# Extract numbered chapters: \contentsline {chapter}{\numberline {N}Title}{page}
ch_lines <- toc_raw[str_detect(toc_raw, fixed("\\numberline"))]
ch_lines <- ch_lines[str_detect(ch_lines, fixed("\\contentsline {chapter}"))]

parse_ch <- function(line) {
  num   <- str_match(line, "\\\\numberline \\{(\\d+)\\}")[,2]
  title <- str_match(line, "\\\\numberline \\{\\d+\\}([^}]+)")[,2] |>
    str_trim() |>
    str_replace_all("\\\\&", "&") |>
    str_replace_all("\\\\\\(|\\\\\\)", "") |>   # strip \( and \)
    str_replace_all("\\\\[a-zA-Z]+\\{([^}]*)\\}", "\\1") |>  # \cmd{x} -> x
    str_trim()
  page  <- str_match(line, "\\}\\{(\\d+)\\}\\{")[,2]
  if (any(is.na(c(num, title, page)))) return(NULL)
  tibble(chapter = as.integer(num), title = title, start_page = as.integer(page))
}

chapters <- bind_rows(lapply(ch_lines, parse_ch))

# Add a sentinel end_page (start of next chapter) for interval lookup
chapters <- chapters |>
  arrange(start_page) |>
  mutate(end_page = lead(start_page, default = 99999L))

cat("Chapters found:\n")
print(chapters, n = Inf)

# ── 2. Roman numeral converter (for front-matter pages) ───────────────────────

from_roman <- function(x) {
  # returns NA for pages that aren't parseable as roman or arabic
  suppressWarnings({
    arabic <- as.integer(x)
    roman  <- as.integer(as.numeric(utils::as.roman(toupper(x))))
    ifelse(!is.na(arabic), arabic, ifelse(!is.na(roman), -roman, NA_integer_))
  })
}
# Front-matter roman pages get negative numbers so they sort before p.1
# and are assigned chapter 0 = "Preface / Front Matter".

# ── 3. Assign chapter to each index entry ─────────────────────────────────────

idx <- read_csv("issues/index-terms.csv", show_col_types = FALSE)

idx <- idx |>
  mutate(
    page_num = from_roman(page),
    chapter = case_when(
      is.na(page_num)  ~ NA_integer_,
      page_num <= 0    ~ 0L,                       # roman = front matter
      TRUE ~ {
        # find which chapter interval each page falls in
        sapply(page_num, function(p) {
          row <- which(chapters$start_page <= p & chapters$end_page > p)
          if (length(row) == 0) NA_integer_ else chapters$chapter[row[1]]
        })
      }
    ),
    ch_title = case_when(
      is.na(chapter) ~ NA_character_,
      chapter == 0L  ~ "Front Matter",
      TRUE           ~ chapters$title[match(chapter, chapters$chapter)]
    )
  )

# ── 4. Summary ─────────────────────────────────────────────────────────────────

cat("\nEntries per chapter:\n")
idx |>
  count(chapter, ch_title) |>
  arrange(chapter) |>
  print(n = Inf)

# ── 5. Write updated CSV ───────────────────────────────────────────────────────

out <- idx |> select(term, page, page_num, chapter, ch_title, formatted)
write_csv(out, "issues/index-terms-ch.csv")
cat("\nWrote", nrow(out), "rows to issues/index-terms-ch.csv\n")
