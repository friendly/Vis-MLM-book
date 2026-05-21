# Test cases for pvPlot()
# Explores what can be passed via ellipse.args and via ...

source(here::here("R/pvPlot.R"))

library(dplyr)
library(tibble)

data(crime, package = "ggbiplot")
crime.num <- crime |>
  column_to_rownames("st") |>
  select(where(is.numeric))

# ── 1. Basic defaults ─────────────────────────────────────────────────────────
pvPlot(crime.num, vars = c("burglary", "larceny"))

# ── 2. ellipse.args: col ──────────────────────────────────────────────────────
# BUG was here: col was silently ignored before fix (2026-05-21)
pvPlot(crime.num, vars = c("auto", "robbery"),
       ellipse.args = list(col = "red"))

# ── 3. ellipse.args: separate point and ellipse colours ───────────────────────
pvPlot(crime.num, vars = c("auto", "robbery"),
       col = "darkblue",
       ellipse.args = list(col = "red"))

# Control xlim / ylim because parts are cutoff in this plot
pvPlot(crime.num, vars = c("robbery", "auto"),
       col = "darkblue",
       ellipse.args = list(col = "red"),
       xlim = c(-150, 300), ylim = c(-300, 600),
       id = list(n = 5, cex=1.5))
 

# ── 4. ellipse.args: fill and fill.alpha ─────────────────────────────────────
pvPlot(crime.num, vars = c("burglary", "larceny"),
       ellipse.args = list(col = "blue", fill = TRUE, fill.alpha = 0.2))

# ── 5. ellipse.args: multiple levels ─────────────────────────────────────────
pvPlot(crime.num, vars = c("burglary", "larceny"),
       ellipse.args = list(levels = c(0.50, 0.95)))

# ── 6. ellipse.args: robust covariance ───────────────────────────────────────
pvPlot(crime.num, vars = c("burglary", "larceny"),
       ellipse.args = list(robust = TRUE, col = "darkgreen"))

# ── 7. ellipse = FALSE ────────────────────────────────────────────────────────
pvPlot(crime.num, vars = c("burglary", "larceny"), ellipse = FALSE)

# ── 8. id: label n most unusual points ───────────────────────────────────────
pvPlot(crime.num, vars = c("burglary", "larceny"),
       id = list(n = 5, cex=1.5))

# ── 9. id + cex.lab passed via ... to dataEllipse/plot() ─────────────────────
pvPlot(crime.num, vars = c("burglary", "larceny"),
       id = list(n = 5),
       cex.lab = 1.5)

# ── 10. cex for points ────────────────────────────────────────────────────────
pvPlot(crime.num, vars = c("burglary", "larceny"), cex = 1.5)

# ── 11. show.partial options ──────────────────────────────────────────────────
pvPlot(crime.num, vars = c("burglary", "larceny"), show.partial = FALSE)
pvPlot(crime.num, vars = c("burglary", "larceny"),
       show.partial = list(loc = c(0.7, 0.1), cex = 1.5))

# ── 12. regline: FALSE / styled list ─────────────────────────────────────────
pvPlot(crime.num, vars = c("burglary", "larceny"), regline = FALSE)
pvPlot(crime.num, vars = c("burglary", "larceny"), regline = list(col = "red", lwd = 3))
pvPlot(crime.num, vars = c("burglary", "larceny"), regline = list(col = "blue"))

# ── 13. Combined: kitchen-sink ────────────────────────────────────────────────
pvPlot(crime.num, vars = c("burglary", "larceny"),
       col = "steelblue",
       ellipse.args = list(col = "red", fill = TRUE, fill.alpha = 0.1,
                           levels = c(0.68, 0.95)),
       id = list(n = 3),
       cex = 1.2,
       cex.lab = 1.3,
       show.partial = list(loc = c(0.02, 0.97), cex = 1.2))
