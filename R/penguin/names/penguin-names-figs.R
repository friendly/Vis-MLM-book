# penguin-names-figs.R: figures for the "Call me by my name" blog post
#
# 1. Cara Thompson's view (useR! 2022): flipper length vs bill length, point
#    size for body mass, with the six named birds labeled.
# 2. Bill shape vs stoutness, standardized within species, with the same birds:
#    each named bird is extreme on one of these, or (Average Joe) on neither.
# Run from the project root.  Notes in R/penguin/names/penguin-names.md.

library(dplyr)
library(ggplot2)
library(ggrepel)

data(peng, package = "heplots")
source("R/penguin/penguin-colors.R")
col <- peng.colors("dark")
outdir <- "R/penguin/names/figs"
dir.create(outdir, showWarnings = FALSE)

# the named birds (heplots::peng case numbers). 10 and 35: proposed names
named <- tibble::tribble(
  ~id, ~name,         ~namer,
  283, "Cyrano",       "Thompson",
  124, "The BFG",      "Thompson",
  304, "Tinkerbell",   "Thompson",
  166, "Average Joe",  "Thompson",
   10, "Socrates?",    "Friendly",
   35, "Falstaff?",    "Friendly"
)

peng <- peng |>
  mutate(id         = row_number(),
         bill_shape = log(bill_length) - log(bill_depth),
         stoutness  = log(body_mass) / 3 - log(flipper_length)) |>
  group_by(species) |>
  mutate(z_shape = c(scale(bill_shape)),
         z_stout = c(scale(stoutness))) |>
  ungroup() |>
  left_join(named, by = "id") |>
  mutate(label = ifelse(is.na(name), NA, paste0(name, " (", id, ")")))
birds <- filter(peng, !is.na(name))

## 1. Thompson's view ----------------------------------------------------------
p1 <- ggplot(peng, aes(bill_length, flipper_length, colour = species)) +
  geom_point(aes(size = body_mass), alpha = 0.5) +
  geom_point(data = birds, aes(size = body_mass), shape = 21,
             colour = "black", stroke = 1.1) +
  geom_label_repel(data = birds, aes(label = label),
                   size = 4, fontface = "bold", fill = alpha("white", 0.85),
                   box.padding = 0.6, min.segment.length = 0, seed = 2022,
                   show.legend = FALSE) +
  scale_colour_manual(values = col) +
  scale_size_area(max_size = 4, breaks = c(3000, 4500, 6000),
                  labels = \(x) paste(x / 1000, "kg")) +
  labs(x = "Bill length (mm)", y = "Flipper length (mm)",
       colour = "Species", size = "Body mass",
       title = "Perfectly proportional penguins, with a few exceptions",
       subtitle = "After Cara Thompson (useR! 2022), with two more birds named") +
  theme_bw(base_size = 14) +
  guides(size = guide_legend(override.aes = list(colour = "grey50")),
         colour = guide_legend(override.aes = list(size = 3, alpha = 1))) +
  theme(legend.position = "inside", legend.position.inside = c(0.02, 0.98),
        legend.justification = c(0, 1), legend.box = "horizontal",
        legend.background = element_rect(colour = "grey80"))

ggsave(file.path(outdir, "names-thompson-view.png"), p1,
       width = 8, height = 6, dpi = 200)

## 2. Bill shape vs stoutness, within species ----------------------------------
lim <- c(-4.2, 4.2)
p2 <- ggplot(peng, aes(z_shape, z_stout, colour = species)) +
  geom_hline(yintercept = 0, colour = "grey70") +
  geom_vline(xintercept = 0, colour = "grey70") +
  stat_ellipse(aes(group = 1), level = 0.95, colour = "grey40",
               linetype = "dashed", linewidth = 0.7) +
  stat_ellipse(aes(group = 1), level = 0.68, colour = "grey40",
               linewidth = 0.7) +
  geom_point(alpha = 0.5, size = 2) +
  geom_point(data = birds, shape = 21, size = 3.5, colour = "black",
             aes(fill = species), stroke = 1.1, show.legend = FALSE) +
  geom_label_repel(data = birds, aes(label = label),
                   size = 4, fontface = "bold", fill = alpha("white", 0.85),
                   box.padding = 0.7, min.segment.length = 0, seed = 2022,
                   show.legend = FALSE) +
  scale_colour_manual(values = col) +
  scale_fill_manual(values = col) +
  coord_equal(xlim = lim, ylim = lim) +
  labs(x = "← stubby    Bill shape, log(length / depth)    slender →",
       y = "← lean    Stoutness, log(mass^(1/3) / flipper)    stout →",
       colour = "Species",
       title = "What makes each bird unusual",
       subtitle = "z-scores within species; ellipses hold 68% and 95% of all birds") +
  theme_bw(base_size = 14) +
  guides(colour = guide_legend(override.aes = list(size = 3, alpha = 1))) +
  theme(legend.position = "inside", legend.position.inside = c(0.88, 0.14),
        legend.background = element_rect(colour = "grey80"))

ggsave(file.path(outdir, "names-shape-stoutness.png"), p2,
       width = 7.5, height = 7.5, dpi = 200)
