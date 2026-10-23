# penguin-names.R: what makes penguins 283, 10 and 35 unusual?
#
# The book (Ch 4, 5, 14) and the talk name case 283 "Cyrano" (very long bill)
# and case 10 "Hook Nose" (reading bill depth as curvature); case 35 is unnamed.
# The vignettes R/penguin/peng-bill-size-shape-altviews.qmd and
# R/penguin/body-flipper.qmd re-express the four measures as
#   bill size  = log L + log D,   bill shape = log L - log D   (L / D, slender vs. stubby)
#   body size  = log F + log M/3, stoutness  = log M/3 - log F (heavy for its flippers)
# Here: describe the three birds in those terms, relative to their own species
# (and sex), to see whether the names fit.  Notes in test/penguin-names.md.

library(dplyr)
library(tidyr)
library(heplots)

data(peng, package = "heplots")

peng <- peng |>
  mutate(
    id          = row_number(),       # case numbers used in the book
    bill_size   = log(bill_length) + log(bill_depth),
    bill_shape  = log(bill_length) - log(bill_depth),
    ratio_LD    = bill_length / bill_depth,
    body_size   = log(flipper_length) + log(body_mass) / 3,
    stoutness   = log(body_mass) / 3 - log(flipper_length)
  )
birds <- c(283, 10, 35)

## 1. The birds as recorded --------------------------------------------------
peng |>
  filter(id %in% birds) |>
  select(id, species, sex, island, year,
         bill_length, bill_depth, flipper_length, body_mass, ratio_LD) |>
  print()

# species x sex means, for comparison
peng |>
  filter(species %in% c("Adelie", "Chinstrap")) |>
  group_by(species, sex) |>
  summarise(n = n(), across(c(bill_length, bill_depth, flipper_length,
                              body_mass, ratio_LD), mean), .groups = "drop") |>
  print()

## 2. How the book found them: D^2 ignoring species (Ch 4) --------------------
D2_total <- Mahalanobis(peng[, c("bill_length", "bill_depth",
                                 "flipper_length", "body_mass")])
peng$D2_total <- D2_total
peng$rank_total <- rank(-D2_total)

## 3. Within-group standardized scores -----------------------------------------
vars <- c("bill_length", "bill_depth", "flipper_length", "body_mass",
          "bill_size", "bill_shape", "body_size", "stoutness")

z_within <- function(data, ...) {
  data |>
    group_by(...) |>
    mutate(across(all_of(vars), \(v) (v - mean(v)) / sd(v))) |>
    ungroup()
}

z_sp  <- z_within(peng, species)
z_sx  <- z_within(peng, species, sex)

show_z <- function(z, label) {
  cat("\n---", label, "---\n")
  z |>
    filter(id %in% birds) |>
    select(id, species, sex, all_of(vars)) |>
    mutate(across(all_of(vars), \(v) round(v, 2))) |>
    print(width = Inf)
}
show_z(z_sp, "z-scores within species")
show_z(z_sx, "z-scores within species x sex")

# Where does each bird rank on each variable, among all 333 (|z| within species)?
ranks <- z_sp |>
  mutate(across(all_of(vars), \(v) rank(-abs(v)))) |>
  filter(id %in% birds) |>
  select(id, all_of(vars))
cat("\nRank of |z within species| among 333 birds (1 = most extreme)\n")
print(ranks, width = Inf)

## 4. Within-species D^2, and which directions carry it -----------------------
# Residuals from the species means; D^2 uses the pooled within-species covariance.
# The value is the same in (L, D, F, M) logs and in (bill size, bill shape, body
# size, stoutness), since one is a nonsingular linear transformation of the other.
logs <- peng |>
  transmute(lL = log(bill_length), lD = log(bill_depth),
            lF = log(flipper_length), lM3 = log(body_mass) / 3)
new  <- peng |> select(bill_size, bill_shape, body_size, stoutness)

within_D2 <- function(Y, group) {
  R <- as.matrix(Y) - apply(as.matrix(Y), 2, \(v) ave(v, group))
  S <- crossprod(R) / (nrow(R) - nlevels(group))
  list(D2 = mahalanobis(R, rep(0, ncol(R)), S), R = R, S = S)
}
wl <- within_D2(logs, peng$species)
wn <- within_D2(new,  peng$species)
peng$D2_within  <- wn$D2
peng$rank_within <- rank(-wn$D2)
stopifnot(isTRUE(all.equal(wl$D2, wn$D2)))      # invariance check

cat("\nWithin-species correlations of the re-expressed variables (pooled)\n")
print(round(cov2cor(wn$S), 2))

# Approximate share of each bird's D^2 due to each re-expressed variable:
# z^2 using the pooled within-species SD (exact shares only if uncorrelated)
zz <- sweep(wn$R, 2, sqrt(diag(wn$S)), "/")
share <- cbind(id = peng$id, round(zz^2, 2), D2 = round(wn$D2, 2))
cat("\nSquared pooled-within z for the re-expressed variables, and within-species D^2\n")
print(share[peng$id %in% birds, ])

peng |>
  filter(id %in% birds) |>
  select(id, species, D2_total, rank_total, D2_within, rank_within) |>
  mutate(across(starts_with("D2"), \(v) round(v, 2))) |>
  print()

cat("\nTop 8 by within-species D^2\n")
peng |>
  arrange(desc(D2_within)) |>
  slice(1:8) |>
  select(id, species, sex, bill_length, bill_depth, flipper_length,
         body_mass, D2_within, D2_total) |>
  mutate(across(starts_with("D2"), \(v) round(v, 2))) |>
  print()

## 5. Where they sit in each species' distribution (percentiles) --------------
pct <- peng |>
  group_by(species) |>
  mutate(across(all_of(vars), \(v) round(100 * percent_rank(v)))) |>
  ungroup() |>
  filter(id %in% birds) |>
  select(id, species, all_of(vars))
cat("\nPercentile within species (0 = smallest, 100 = largest)\n")
print(pct, width = Inf)
