#' ---
#' title: Penguin Statistical Research Station, with real plots on the bulletin board
#' ---

# Composites three small plots onto the blank panels of the bulletin board in
#   talks/images/penguin-statistical-research-station.png   (ChatGPT scene, 1774 x 887)
# Two versions:
#   talks/images/penguin-station-talk.png    -- data ellipses, biplot, HE plot (the title-slide trio)
#   images/penguin-station-bodies.jpg        -- flipper & mass, size & stoutness, canonical plot
# The output is twice the size of the scene, so the plots stay sharp.
# Run from the project root.

library(dplyr)
library(car)
library(heplots)
library(candisc)

data(peng, package = "heplots")
source("R/penguin/penguin-colors.R")

peng <- peng |>
  mutate(
    log_flipper = log(flipper_length),
    log_mass3   = log(body_mass) / 3,
    body_size   = log_flipper + log_mass3,
    stoutness   = log_mass3 - log_flipper,
    bill_size   = log(bill_length) + log(bill_depth),
    bill_shape  = log(bill_length) - log(bill_depth)
  )

col  <- peng.colors("dark")
lcol <- peng.colors("medium")
ink  <- "#2B2B2B"
windowsFonts(hand = windowsFont("Segoe Print"))

scene <- png::readPNG("talks/images/penguin-statistical-research-station.png")

# white panels in scene pixels (measured), inset a little so the corner nails stay visible
panels <- data.frame(x0 = c(1083, 1288, 1493), x1 = c(1267, 1472, 1682),
                     y0 = 362, y1 = 632)
inset <- 9

# --- helpers ------------------------------------------------------------------

# a data ellipse (68%) for x, y, as a polygon
ell <- function(x, y, level = 0.68, ...) {
  e <- car::ellipse(c(mean(x), mean(y)), cov(cbind(x, y)),
                    radius = sqrt(qchisq(level, 2)), draw = FALSE)
  polygon(e, ...)
}

# points + species ellipses, in the current plot region
species_ellipses <- function(x, y, g = peng$species, pts = TRUE) {
  if (pts) points(x, y, col = adjustcolor(lcol[g], 0.55), pch = 16, cex = 0.7)
  for (s in levels(g)) {
    i <- g == s
    ell(x[i], y[i], col = adjustcolor(col[s], 0.12), border = col[s], lwd = 4)
  }
}

# one panel, drawn to a transparent png the size of 3x the panel
panel_png <- function(file, k, draw) {
  w <- (panels$x1[k] - panels$x0[k] - 2 * inset) * 3
  h <- (panels$y1[k] - panels$y0[k] - 2 * inset) * 3
  png(file, width = w, height = h, res = 150, bg = "transparent")
  par(family = "hand", mar = c(2.6, 2.4, 3.2, 0.8), mgp = c(1.4, 0.4, 0),
      col = ink, col.axis = ink, col.lab = ink, fg = ink, tcl = -0.25,
      cex.axis = 0.75, cex.lab = 1.05, lwd = 1.5, bty = "l")
  draw()
  dev.off()
  png::readPNG(file)
}

# labels for variable vectors: at the arrow tips, with a white halo so they read over the points
vec_labels <- function(v, labels, pos, cex = 1) {
  for (d in seq(0, 2 * pi, length.out = 13))
    text(v, labels = labels, pos = pos, cex = cex, col = "white", offset = 0.35,
         x = v[, 1] + 0.04 * diff(par("usr")[1:2]) * cos(d) / 4,
         y = v[, 2] + 0.04 * diff(par("usr")[3:4]) * sin(d) / 4)
  text(v, labels = labels, pos = pos, cex = cex, col = ink, offset = 0.35)
}

title_hand <- function(txt) title(txt, line = 1.0, cex.main = 1.55, font.main = 1)

# --- the talk version: data ellipses, biplot, HE plot ---------------------------

draw_ellipses <- function() {
  x <- peng$bill_length; y <- peng$bill_depth
  plot(x, y, type = "n", xlab = "bill length", ylab = "bill depth", xaxt = "n", yaxt = "n")
  species_ellipses(x, y)
  ell(x, y, border = ink, lwd = 3, lty = 2)          # ignoring species: Simpson's paradox
  title_hand("Data ellipses")
}

draw_biplot <- function() {
  X  <- scale(peng[, c("bill_length", "bill_depth", "flipper_length", "body_mass")])
  pc <- prcomp(X)
  s  <- pc$x[, 1:2]
  plot(s, type = "n", xlab = "PC1", ylab = "PC2", xaxt = "n", yaxt = "n")
  species_ellipses(s[, 1], s[, 2])
  v <- pc$rotation[, 1:2] * 3.2
  arrows(0, 0, v[, 1], v[, 2], length = 0.08, lwd = 3, col = ink)
  vec_labels(v, c("bill length", "bill depth", "flipper", "mass"), pos = c(4, 4, 3, 1))
  title_hand("Biplot")
}

draw_heplot <- function() {
  mod <- lm(cbind(bill_length, bill_depth) ~ species, data = peng)
  means <- aggregate(cbind(bill_length, bill_depth) ~ species, data = peng, mean)
  heplot(mod, size = "effect", fill = TRUE, fill.alpha = 0.12, col = c("#C0392B", ink),
         lwd = 4, label.pos = c(1, 3), cex = 1.1, xlab = "bill length", ylab = "bill depth",
         xaxt = "n", yaxt = "n")
  points(means$bill_length, means$bill_depth, pch = 16, cex = 2.6, col = col[means$species])
  title_hand("HE plot")
}

# --- the vignette version: flipper & mass, size & stoutness, canonical ----------

draw_flipper_mass <- function() {
  x <- peng$log_flipper; y <- peng$log_mass3
  plot(x, y, type = "n", asp = 1, xlab = "log flipper", ylab = "log mass / 3",
       xaxt = "n", yaxt = "n")
  species_ellipses(x, y)
  abline(mean(y) - mean(x), 1, lty = 2, lwd = 2.5, col = ink)    # isometry: slope 1
  title_hand("Flipper & mass")
}

draw_size_stout <- function() {
  x <- peng$body_size; y <- peng$stoutness
  plot(x, y, type = "n", xlab = "body size", ylab = "stoutness", xaxt = "n", yaxt = "n")
  species_ellipses(x, y)
  title_hand("Size & stoutness")
}

draw_canonical <- function() {
  mod4 <- lm(cbind(bill_size, bill_shape, body_size, stoutness) ~ species + sex, data = peng)
  cd <- candisc(mod4, term = "species")
  s  <- cd$scores
  plot(s$Can1, s$Can2, type = "n", xlab = "Can1", ylab = "Can2",
       xaxt = "n", yaxt = "n")
  species_ellipses(s$Can1, s$Can2, g = s$species)
  v <- cd$structure[, 1:2] * 4.5
  arrows(0, 0, v[, 1], v[, 2], length = 0.08, lwd = 3, col = ink)
  vec_labels(v, c("bill size", "bill shape", "body size", "stoutness"), pos = c(3, 3, 1, 4))
  title_hand("Canonical")
}

# --- composite -------------------------------------------------------------------

composite <- function(out, draws, tag) {
  imgs <- lapply(1:3, \(k) panel_png(file.path(tempdir(), sprintf("%s-%d.png", tag, k)),
                                     k, draws[[k]]))
  W <- dim(scene)[2]; H <- dim(scene)[1]
  if (grepl("[.]jpg$", out)) jpeg(out, width = 2 * W, height = 2 * H, quality = 92)
  else png(out, width = 2 * W, height = 2 * H)
  par(mar = rep(0, 4))
  plot.new()
  plot.window(c(0, W), c(H, 0), xaxs = "i", yaxs = "i")
  rasterImage(scene, 0, H, W, 0, interpolate = TRUE)
  for (k in 1:3)
    with(panels[k, ],
         rasterImage(imgs[[k]], x0 + inset, y1 - inset, x1 - inset, y0 + inset,
                     interpolate = TRUE))
  dev.off()
}

composite("talks/images/penguin-station-talk.png",
          list(draw_ellipses, draw_biplot, draw_heplot), "talk")
composite("images/penguin-station-bodies.jpg",
          list(draw_flipper_mass, draw_size_stout, draw_canonical), "bodies")
