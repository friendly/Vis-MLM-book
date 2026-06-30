# idx_terms.R — Extract unique index terms from a LaTeX .idx file
#
# Produces a file with one index term per line, surrounded by | |, sorted.
# Useful for spotting near-duplicate entries that makeindex treats as separate.
#
# Usage (from project root):
#   Rscript R/idx_terms.R [input.idx [output.txt]]
#
# Defaults:
#   input  : pdf/index.idx
#   output : issues/index-terms.txt

args <- commandArgs(trailingOnly = TRUE)
idx_file  <- if (length(args) >= 1) args[1] else "pdf/index.idx"
out_file  <- if (length(args) >= 2) args[2] else "issues/index-terms.txt"

lines <- readLines(idx_file, warn = FALSE, encoding = "latin1")

# Extract the spec inside \indexentry{SPEC}{PAGE}
specs <- regmatches(lines,
                    regexpr("(?<=\\\\indexentry\\{)[^\\}]+", lines, perl = TRUE))

# Strip makeindex format modifiers (|hyperpage, |textbf, etc.)
specs <- sub("\\|[^\\|]*$", "", specs)

# Unique terms, sorted case-insensitively
terms <- sort(unique(specs), method = "radix")

out <- paste0("|", terms, "|")
writeLines(out, out_file)

message(sprintf("Read %d entries from '%s'", length(specs), idx_file))
message(sprintf("Wrote %d unique terms to '%s'",  length(terms), out_file))
