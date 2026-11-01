# Hex logo for the Vis-MLM book: the penguin data ellipses from the cover, on the cover's blue
library(ggplot2)

setwd("C:/R/Projects/Vis-MLM-book/images/Vis-MLM-logo")
data(peng, package = "heplots")

# medium shades from R/penguin/penguin-colors.R: Adelie, Chinstrap, Gentoo
cols <- c(Adelie = "#F89D38", Chinstrap = "#9A78B8", Gentoo = "#73C05B")
navy <- "#16325C"

# pointy-top hexagon, circumradius 1
hexagon <- function(r = 1) {
  a <- pi / 2 + (0:5) * pi / 3
  data.frame(x = r * cos(a), y = r * sin(a))
}

# 95% data ellipse of bill length and depth for each species, standardized over all penguins
# and moved into the upper part of the hexagon
Y <- as.data.frame(scale(peng[, c("bill_length", "bill_depth")]))
circle <- cbind(cos(seq(0, 2 * pi, length.out = 200)), sin(seq(0, 2 * pi, length.out = 200)))
to_hex <- function(m) cbind(x = -0.03 + 0.215 * m[, 1], y = 0.12 + 0.215 * m[, 2])

ell <- do.call(rbind, lapply(names(cols), function(s) {
  y <- Y[peng$species == s, ]
  e <- sweep(sqrt(qchisq(0.95, 2)) * circle %*% chol(cov(y)), 2, colMeans(y), "+")
  data.frame(species = s, to_hex(e))
}))
ctr <- do.call(rbind, lapply(names(cols), function(s) {
  data.frame(species = s, to_hex(matrix(colMeans(Y[peng$species == s, ]), 1)))
}))

logo <- ggplot() +
  geom_polygon(data = hexagon(), aes(x, y), fill = "#DCE6F4", colour = navy, linewidth = 5) +
  geom_polygon(data = ell, aes(x, y, fill = species, colour = species),
               alpha = 0.5, linewidth = 1.2) +
  geom_point(data = ctr, aes(x, y, colour = species), shape = 3, size = 5, stroke = 1.6) +
  annotate("text", 0, -0.30, label = "Vis-MLM", colour = navy, fontface = "bold", size = 23) +
  scale_fill_manual(values = cols, guide = "none") +
  scale_colour_manual(values = sapply(cols, \(x) adjustcolor(x, red.f = .7, green.f = .7, blue.f = .7)),
                      guide = "none") +
  coord_equal(xlim = c(-0.92, 0.92), ylim = c(-1.05, 1.05), expand = FALSE) +
  theme_void() +
  theme(plot.background = element_rect(fill = "transparent", colour = NA),
        panel.background = element_rect(fill = "transparent", colour = NA))

ggsave("Vis-MLM-logo.png", logo, width = 1.84 * 3, height = 2.1 * 3, dpi = 300, bg = "transparent")

# version with a few points drawn from each species' bivariate normal, kept inside its ellipse.
# Draws are skipped if they would crowd another point or the mean, or be hidden by the title
set.seed(20261101)
pts <- do.call(rbind, lapply(names(cols), function(s) {
  y <- Y[peng$species == s, ]
  z <- matrix(rnorm(2000), ncol = 2)
  z <- z[rowSums(z^2) < qchisq(0.95, 2), ]
  xy <- to_hex(sweep(z %*% chol(cov(y)), 2, colMeans(y), "+"))
  keep <- to_hex(matrix(colMeans(y), 1))
  for (i in seq_len(nrow(xy))) {
    if (xy[i, "y"] > -0.15 && min(sqrt(colSums((t(keep) - xy[i, ])^2))) > 0.09) keep <- rbind(keep, xy[i, ])
  }
  data.frame(species = s, keep[2:7, ])
}))

logo_pts <- logo
logo_pts$layers <- append(logo$layers, list(geom_point(data = pts, aes(x, y, colour = species), size = 3.2)),
                          after = 2)
ggsave("Vis-MLM-logo-pts.png", logo_pts, width = 1.84 * 3, height = 2.1 * 3, dpi = 300, bg = "transparent")
