#' ---
#' title: "Penguin tours: static frames for the PDF (04-multivariate_plots.qmd)"
#' ---
#' Re-renders, at 3x the original pixel size, the five static tour images used in
#' Ch. 4:
#'
#' - @fig-peng-tour-grand-frames: images/tours/peng-tour-grand-lbls-split/
#'   frame_00.png, frame_10.png, frame_26.png
#' - @fig-peng-tour-guided: images/tours/peng-tour-lda-final.png and
#'   peng-tour-anomalies-final.png
#'
#' Grand-tour frames: frames 1, 11 and 27 of the seeded grand tour that
#' R/penguin/peng-tourr.R renders to images/tours/peng-tourr-grand-lbls.gif
#' (tourr 1.2.7). Settings were matched to that GIF:
#' - labels for the 3 largest Mahalanobis D^2 (283, 10, 35)
#' - Chinstrap drawn as diamonds (pch 18); peng-tourr.R now says pch 16
#'
#' Guided-tour final frames: the original images came from interactive runs that
#' can't be reproduced (one had no seed), so their projections were recovered
#' from the images themselves. A 4 x 2 basis was fitted so that a display_xy()
#' rendering overlays the original image; the four starting points tried for the
#' anomaly frame all converged to the same basis. The fitted bases are below.
#'
#' All images use png(type = "cairo"), which keeps the exact penguin colors
#' (macOS's default png device shifts them).
#'
#' Usage: Rscript R/penguin/peng-tour-frames.R [output directory, default images/tours] [grand|guided]
#'
#' Run with Rscript, the script renders each group in its own fresh R session: cairo's
#' text metrics depend on what was drawn earlier in a session, so in a single session
#' the second group's text can shift by a pixel or two. Sourced interactively, it
#' renders both groups in the current session.

args <- commandArgs(trailingOnly = TRUE)
out_dir <- if (length(args) >= 1) args[1] else here::here("images", "tours")
part <- if (length(args) >= 2) args[2] else "both"
self <- sub("^--file=", "", grep("^--file=", commandArgs(FALSE), value = TRUE))
if (part == "both" && length(self) == 1) {
  rscript <- file.path(R.home("bin"), "Rscript")
  for (p in c("grand", "guided")) system2(rscript, c(shQuote(self), shQuote(out_dir), p))
  quit(save = "no")
}

library(heplots)
library(tourr)

dir.create(file.path(out_dir, "peng-tour-grand-lbls-split"), showWarnings = FALSE, recursive = TRUE)

data(peng, package = "heplots")
source(here::here("R", "penguin", "penguin-colors.R"))

peng_scaled <- scale(peng[, 3:6])
colnames(peng_scaled) <- c("BL", "BD", "FL", "BM")

# labels for the 3 most extreme observations (as in peng-tourr.R)
D2 <- heplots::Mahalanobis(peng_scaled)
top3 <- order(D2, decreasing = TRUE)[1:3]
lbls <- rep("", nrow(peng_scaled))
lbls[top3] <- as.character(top3)

cex <- 1.2

# --- Grand-tour frames ------------------------------------------------------
if (part %in% c("both", "grand")) {
  k <- 3    # 3 x the original 480 x 480 px
  tmp <- tempfile("grand"); dir.create(tmp)
  set.seed(1234)
  render(peng_scaled,
         tour_path = grand_tour(d = 2),
         display_xy(col = peng$species, palette = peng.colors("dark"),
                    obs_labels = lbls,
                    pch = c(15, 18, 17)[peng$species], cex = cex,
                    axis.col = "black", axis.text.col = "black", axis.lwd = 1.5),
         dev = "png", file.path(tmp, "g%03d.png"),
         width = 480 * k, height = 480 * k, res = 72 * k, frames = 27,
         type = "cairo", antialias = "default")
  for (i in c(0, 10, 26)) {
    file.copy(file.path(tmp, sprintf("g%03d.png", i + 1)),
              file.path(out_dir, "peng-tour-grand-lbls-split", sprintf("frame_%02d.png", i)),
              overwrite = TRUE)
  }
}

# --- Guided-tour final frames -----------------------------------------------
# projection bases recovered from the original 460 x 460 images (rows BL, BD, FL, BM)
proj_lda <- matrix(c(-0.87405561112960617,  0.46185126693099288, -0.10523573528933282,  0.10791494755223199,
                      0.30701002252689596,  0.59870140415988571, -0.49039858329599639, -0.55390495956102026),
                   4, 2)
proj_anomalies <- matrix(c(0.95023772491423697, -0.021806061063214643, 0.064497543239669469, -0.30399478411112418,
                           -0.28325152033975026, -0.10910794300928002, -0.22623573668239014, -0.9255708640862027),
                         4, 2)

draw_frame <- function(proj, file) {
  png(file, width = 460 * 3, height = 460 * 3, res = 96 * 3, type = "cairo")
  d <- display_xy(col = peng$species, palette = peng.colors("dark"),
                  pch = c(15, 16, 17)[peng$species], cex = cex)
  d$init(peng_scaled)
  d$render_frame()
  d$render_data(peng_scaled, proj)
  dev.off()
}
if (part %in% c("both", "guided")) {
  draw_frame(proj_lda,       file.path(out_dir, "peng-tour-lda-final.png"))
  draw_frame(proj_anomalies, file.path(out_dir, "peng-tour-anomalies-final.png"))
}
