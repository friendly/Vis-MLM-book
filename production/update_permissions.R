#' ---
#' title: Update a row of the permissions-tracking CSV
#' ---
#'
#' Update one row of production/permissions-tracking.csv as permission
#' requests progress, without needing to hand-edit the CSV.
#'
#' Identify the row with `fig_label` and/or `filename`. `fig_label` alone is
#' usually enough, but is NOT always unique on its own -- one Quarto figure
#' can cover more than one image file (e.g. `fig-tesseract` covers both
#' `tesseract.gif` and `tesseract-frames.png`), so pass both when `fig_label`
#' alone is ambiguous. The function errors rather than guessing.
#'
#' `status` follows the vocabulary already used in task-permissions.md's
#' Gavin-tasks section: "not started" -> "applied" -> "granted" / "denied" /
#' "no response", plus "flagged for T&F" for TFQ rows (not normally set by
#' hand -- build-permissions-csv.R assigns it at generation time).
#'
#' Setting `status = "applied"` auto-stamps `applied_date` to today unless
#' you pass one explicitly; `status = "granted"` does the same for
#' `received_date`. `submitted_date` is deliberately NOT tied to any status
#' value -- "permission granted" and "included with the submitted
#' manuscript" are genuinely separate events (steps 5 and 6 of the guide)
#' that can happen weeks apart, so set it explicitly whenever it happens.
#'
#' Safe to use interleaved with re-running build-permissions-csv.R in either
#' order -- that script now merge-preserves these columns instead of
#' resetting them (see its own header comment).
#'
#' @param fig_label,filename Identify the row. At least one is required;
#'   pass both if `fig_label` alone matches more than one row.
#' @param status One of `STATUS_LEVELS`, or `NULL` to leave unchanged.
#' @param applied_date,applied_by,contact Step 4 fields.
#' @param received_date,doc_path Step 5 fields.
#' @param submitted_date Step 6 field.
#' @param notes If given, appended to any existing notes with a date stamp
#'   (rather than overwriting), so the research trail accumulates.
#' @param csv_path Path to the tracking CSV.
#'
#' @return Invisibly, the updated row.
#'
#' @examples
#' # Not run:
#' # update_permissions(fig_label = "fig-ReavenMiller-3d", status = "applied",
#' #                     applied_by = "Gavin")
#' # update_permissions(fig_label = "fig-tesseract", filename = "images/tesseract.gif",
#' #                     status = "granted", doc_path = "production/permissions/tesseract-ok.pdf")
#' # update_permissions(fig_label = "fig-mahalanobis",
#' #                     notes = "No response after a week, trying X/Twitter")

STATUS_LEVELS <- c("not started", "applied", "granted", "denied", "no response", "flagged for T&F")

update_permissions <- function(fig_label = NULL, filename = NULL, status = NULL,
                                applied_date = NULL, applied_by = NULL, contact = NULL,
                                received_date = NULL, doc_path = NULL,
                                submitted_date = NULL, notes = NULL,
                                csv_path = "production/permissions-tracking.csv") {

  if (is.null(fig_label) && is.null(filename)) {
    stop("Provide fig_label and/or filename to identify the row.")
  }
  if (!is.null(status) && !status %in% STATUS_LEVELS) {
    stop(sprintf('status must be one of: %s', paste(dQuote(STATUS_LEVELS, q = FALSE), collapse = ", ")))
  }
  if (!file.exists(csv_path)) {
    stop(sprintf("Can't find %s -- pass csv_path explicitly, or run from the project root.", csv_path))
  }

  # read every column as character -- otherwise readr's type-guessing turns
  # a date column into a Date the moment it has real values in it, and later
  # element-wise assignment from a Date into a character column silently
  # serializes it as a raw day-count integer instead of "YYYY-MM-DD"
  tracking <- readr::read_csv(csv_path, show_col_types = FALSE,
                               col_types = readr::cols(.default = "c"))

  match_idx <- rep(TRUE, nrow(tracking))
  if (!is.null(fig_label)) match_idx <- match_idx & !is.na(tracking$fig_label) & tracking$fig_label == fig_label
  if (!is.null(filename))  match_idx <- match_idx & tracking$filename == filename
  match_idx <- which(match_idx)

  if (length(match_idx) == 0) {
    stop("No matching row for fig_label = ", deparse(fig_label), ", filename = ", deparse(filename))
  }
  if (length(match_idx) > 1) {
    stop(sprintf(
      "%d rows matched fig_label = %s alone -- also pass filename to disambiguate. Matches: %s",
      length(match_idx), deparse(fig_label),
      paste(tracking$filename[match_idx], collapse = ", ")
    ))
  }

  i <- match_idx
  today <- as.character(Sys.Date())

  if (!is.null(status)) {
    tracking$status[i] <- status
    if (status == "applied"  && is.null(applied_date))  applied_date  <- today
    if (status == "granted"  && is.null(received_date)) received_date <- today
  }

  set_if_given <- function(col, value) {
    if (!is.null(value)) tracking[[col]][i] <<- value
  }
  set_if_given("applied_date", applied_date)
  set_if_given("applied_by",   applied_by)
  set_if_given("contact",      contact)
  set_if_given("received_date", received_date)
  set_if_given("doc_path",      doc_path)
  set_if_given("submitted_date", submitted_date)

  if (!is.null(notes)) {
    old_notes <- tracking$notes[i]
    stamped <- paste0(today, ": ", notes)
    tracking$notes[i] <- if (is.na(old_notes) || !nzchar(old_notes)) stamped
                          else paste(old_notes, stamped, sep = " | ")
  }

  readr::write_csv(tracking, csv_path, na = "")

  key_label <- if (!is.na(tracking$fig_label[i])) tracking$fig_label[i] else tracking$filename[i]
  message(sprintf("Updated %s: status = %s", key_label, tracking$status[i]))
  invisible(tracking[i, ])
}
