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

# ── 7. others: partial out a subset only ─────────────────────────────────────
pvPlot(crime.num, vars = c("burglary", "larceny"),
       others = c("murder", "rape"))          # compare with default (all others)

pvPlot(crime.num, vars = c("burglary", "larceny"),
       others = c("murder", "rape", "assault"))

# ── 8. ellipse = FALSE ────────────────────────────────────────────────────────
pvPlot(crime.num, vars = c("burglary", "larceny"), ellipse = FALSE)

# ── 9. id: label n most unusual points ───────────────────────────────────────
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

# ── 14. Factor variables: mtcars ──────────────────────────────────────────────
# Goal: see whether factor/binary variables in `vars` or `others` need special
# treatment (jittering for vars; model.matrix expansion for others).
#
# mtcars structure: all columns stored as numeric.
#   cyl:  4/6/8  — ordinal, 3 levels
#   am:   0/1    — binary (automatic / manual)
#   vs:   0/1    — binary (V / straight engine)
#
# mtcars is all-numeric so lsfit() handles it without conversion.
# The interesting question is what happens visually when a binary/count
# variable appears in `vars`.

# 14a. Both vars numeric, binary variable in others: should work fine
pvPlot(mtcars, vars = c("mpg", "hp"),
       others = c("am", "cyl"),
       id = list(n = 3))

# 14b. One of vars is binary (am = 0/1): points collapse onto two horizontal
# bands — jittering would help legibility
# RESULT: CHECK calculations here: the values of am | others are not discrete!
pvPlot(mtcars, vars = c("am", "mpg"),
       id = list(n = 3))

# 14c. Same with jitter applied manually before calling pvPlot():
# Build a version of mtcars with am jittered, then pass it in.
# RESULT: CHECK calculations here: the values of am | others are not discrete!
mtcars_j <- mtcars
mtcars_j$am_j <- jitter(mtcars$am, amount = 0.05)
pvPlot(mtcars_j, vars = c("am_j", "mpg"),
       id = list(n = 3))

# 14d. cyl (3-level ordinal) as one of vars: points collapse onto three bands
# 
pvPlot(mtcars, vars = c("cyl", "mpg"))

# 14e. Color points by a factor level — pass a colour vector derived from am
# RESUlT: Does not work as expected. All points are 'tomato'
pvPlot(mtcars, vars = c("mpg", "hp"),
       col = c("steelblue", "tomato")[mtcars$am + 1L],
       ellipse = FALSE,
       id = list(n = 3))

# 14f. Explicit factor column in X: does lsfit() error on a true factor?
# Convert am to a proper factor first:
# RESULT: Fails as expected.
mtcars_f <- mtcars
mtcars_f$am <- factor(mtcars$am, labels = c("auto", "manual"))
# This is expected to FAIL — lsfit() cannot handle a factor column.
# If so, we need model.matrix() conversion in pvPlot() for the others.
tryCatch(
  pvPlot(mtcars_f, vars = c("mpg", "hp")),
  error = function(e) message("Expected error with factor in others: ", conditionMessage(e))
)
