#' ---
#' title: "Corrgram renderings (@fig-corrgram-renderings, 04-multivariate_plots.qmd)"
#' ---
#' Redraws images/corrgram-renderings.png: the "Correlation value (x 100)" demo of
#' corrgram renderings from Friendly (2002), shown for r = -1, -0.85, ..., 0.95.
#'
#' - The old PNG (656 x 245) had no source file. It was R base graphics, probably a
#'   screenshot of a Windows graphics window. This script redraws it.
#' - All coordinates are in the old image's pixel space (656 x 245, y downward),
#'   measured from that PNG, so the layout matches it.
#' - Fill colours run linearly from red (r = -1) through white to blue (r = 1),
#'   the scale measured from the old image.
#' - Circle: wedge starts at 12 o'clock and runs clockwise for r > 0, as in
#'   corrgram::panel.pie. Ellipse: Murdoch & Chow (1996) contour, a line at |r| = 1.
#'   Bars: negative bars rise from the bottom, positive ones hang from the top, as in
#'   corrgram::panel.bar. Shaded: fill plus white hatching ("\" for r < 0, "/" for
#'   r > 0), as in corrgram::panel.shade.
#' - Text is Arial. The old text was a little taller for its width (Windows
#'   screen-font rendering), so sizes are a compromise fitted to the old widths.
#' - Rendered at 4x: 2624 x 980 px, about 600 dpi at the printed 80% width (4.4").
#'
#' Requires: ragg, and the Arial font.
#' Usage: Rscript R/corrgram-renderings.R [PNG path, default images/corrgram-renderings.png] [PDF path, optional]
#' A PDF path also writes a vector PDF of the figure (cairo_pdf).

draw_corrgram_renderings <- function() {
  op <- par(mar = c(0, 0, 0, 0), family = "Arial")
  on.exit(par(op))
  plot.new()
  plot.window(xlim = c(0, 656), ylim = c(245, 0), xaxs = "i", yaxs = "i")

  r    <- seq(-1, 0.95, by = 0.15)            # -100, -85, ..., 95
  cx   <- 34.5 + 36.54 * (seq_along(r) - 1)   # column centres
  rowy <- c(num = 66.5, circle = 106, ellipse = 142.5, bars = 179, shaded = 215.5)
  h    <- 16.4                                 # half glyph size
  bord <- "gray50"
  lw   <- 0.75

  fillcol <- function(r) ifelse(r < 0, rgb(1, 1 + r, 1 + r), rgb(1 - r, 1 - r, 1))
  txtcol  <- ifelse(r < 0, "red", "blue")

  # text sizes fitted to the ink widths in the old image, then enlarged a little
  cex_fit   <- function(s, w) w / strwidth(s, units = "user", cex = 1)
  cex_title <- cex_fit("Correlation value (x 100)", 326) * 1.05
  cex_num   <- cex_fit("-100", 36) * 1.07
  cex_lab   <- cex_fit("Number", 67) * 1.15

  text(272, 26, "Correlation value (x 100)", cex = cex_title)
  text(cx, rowy["num"] - 1, round(100 * r), col = txtcol, cex = cex_num)
  text(561, rowy["num"] - 1, "Number", adj = c(0, 0.5), cex = cex_lab)
  text(561, rowy[-1] - 2, c("Circle", "Ellipse", "Bars", "Shaded"), adj = c(0, 0.5), cex = cex_lab)

  th <- seq(0, 2 * pi, length.out = 200)
  for (i in seq_along(r)) {
    ri <- r[i]; x <- cx[i]; col <- fillcol(ri)

    ## Circle ("pac-man")
    y <- rowy["circle"]
    if (abs(ri) > 0) {
      a <- seq(pi / 2, pi / 2 - 2 * pi * ri, length.out = max(2, round(200 * abs(ri))))
      polygon(c(x, x + h * cos(a)), c(y, y - h * sin(a)), col = col,
              border = if (abs(ri) >= 1) NA else bord, lwd = lw)
    }
    lines(x + h * cos(th), y - h * sin(th), col = bord, lwd = lw)

    ## Ellipse
    y <- rowy["ellipse"]
    if (abs(ri) >= 1) {
      segments(x - h, y + h * sign(ri), x + h, y - h * sign(ri), col = col, lwd = 1.2)
    } else {
      d <- acos(ri)
      polygon(x + h * cos(th + d / 2), y - h * cos(th - d / 2), col = col, border = bord, lwd = lw)
    }

    ## Bars
    y <- rowy["bars"]
    if (ri < 0) rect(x - h, y + h - 2 * h * abs(ri), x + h, y + h, col = col, border = bord, lwd = lw)
    else        rect(x - h, y - h, x + h, y - h + 2 * h * ri, col = col, border = bord, lwd = lw)

    ## Shaded: hatch lines through the cell diagonal, spaced h apart
    y <- rowy["shaded"]
    rect(x - h, y - h, x + h, y + h, col = col, border = NA)
    clip(x - h, x + h, y + h, y - h)
    for (k in -2:2) {
      off <- k * h
      if (ri < 0) segments(x - h + off, y - h, x + h + off, y + h, col = "white", lwd = 1)
      else        segments(x - h + off, y + h, x + h + off, y - h, col = "white", lwd = 1)
    }
    do.call(clip, as.list(par("usr")))
    rect(x - h, y - h, x + h, y + h, col = NA, border = bord, lwd = lw)
  }
}

args <- commandArgs(trailingOnly = TRUE)
png_out <- if (length(args) >= 1) args[1] else here::here("images", "corrgram-renderings.png")
pdf_out <- if (length(args) >= 2) args[2] else NULL

k <- 4   # pixel density relative to the old 656 x 245 image
ragg::agg_png(png_out, width = 656 * k, height = 245 * k, res = 96 * k, background = "white")
draw_corrgram_renderings()
invisible(dev.off())

if (!is.null(pdf_out)) {
  grDevices::cairo_pdf(pdf_out, width = 656 / 96, height = 245 / 96, family = "Arial")
  draw_corrgram_renderings()
  invisible(dev.off())
}
