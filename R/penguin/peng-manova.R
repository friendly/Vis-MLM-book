#' ---
#' title: Penguins MANOVA
#' ---


library(car)
library(heplots)
library(candisc)
library(mvinfluence)
library(dplyr)

data(peng, package="heplots")
contrasts(peng$species) <- matrix(c(1,-1,0, -1, -1, -2), 3,2)
contrasts(peng$species)


peng.mod0 <- lm(cbind(bill_length, bill_depth, flipper_length, body_mass) ~
                 species, data=peng)
Anova(peng.mod0)

# all main effects
peng.mod1 <- lm(cbind(bill_length, bill_depth, flipper_length, body_mass) ~
                 species + island + sex, data=peng)
Anova(peng.mod1)

# two-way interactions
peng.mod2 <- lm(cbind(bill_length, bill_depth, flipper_length, body_mass) ~
                 species + island * sex, data=peng)
Anova(peng.mod2)


heplot(peng.mod0, fill=TRUE, fill.alpha=0.1, 
       size="effect",
       xlim=c(35,52), ylim=c(14,20))

# show contrasts
hyp <- list("A:C"="species1","AC:G"="species2")
heplot(peng.mod0, fill=TRUE, fill.alpha=0.1, 
       hypotheses=hyp, 
       size="effect",
       )


heplot(peng.mod1, fill=TRUE, fill.alpha=0.1, 
       size="effect",
       xlim=c(35,52), ylim=c(14,20))

heplot(peng.mod2, fill=TRUE, fill.alpha=0.1, 
       size="effect",
       xlim=c(35,52), ylim=c(14,20))


pairs(peng.mod1)
pairs(peng.mod2)

# equality of covariance matrices
cols = c(scales::hue_pal()(3), "black")
covEllipses(peng[, 3:6], 
            group = peng$species,
            col = cols,
            variables = 1:4,
            fill = TRUE,
            fill.alpha = 0.1)

covEllipses(peng[, 3:6], group = peng$species,
            center = TRUE,
            col = cols,
            variables = 1:4,
            fill = TRUE,
            fill.alpha = 0.1)

(bm <- boxM(peng.mod0))

plot(bm)


(peng.can0 <- candisc(peng.mod0))

(peng.can1 <- candisc(peng.mod1))



# influence
op <- par(mar = c(5,5,2,1))
res <- influencePlot(peng.mod0, id.n=3, type="stres")
res |> arrange(desc(CookD))

loc <- merge(peng, res, 
              by = "row.names") |>
  group_by(species) |>
  slice(1) |>
  ungroup() |>
  select(species, H)
text(loc$H, 0.10, loc$species, xpd=TRUE)
par(op)

# same, but add n= to each label
op <- par(mar = c(5,5,2,1))
res <- influencePlot(peng.mod0, id.n=3, type="stres")
res |> arrange(desc(CookD))

loc <- merge(peng |> add_count(species), 
             res, 
             by = "row.names") |>
  add_count(species) |>
  group_by(species) |>
  slice(1) |>
  ungroup() |>
  select(species, H, n) |>
  mutate(label = glue::glue("{species}\n(n={n})"))
text(loc$H, 0.10, loc$label, xpd=TRUE)
par(op)

op <- par(mar = c(5,5,2,1))
res <- influencePlot(peng.mod0, id.n=3, type="LR")
loc <- merge(peng, res, 
             by = "row.names") |>
  group_by(species) |>
  slice(1) |>
  ungroup() |>
  select(species, L) |>
  mutate(logL = log(L))
text(loc$logL, -2, loc$species, xpd=TRUE)
par(op)

res <- influencePlot(peng.mod0, id.n=3, type="cookd")


influencePlot(peng.mod1, id.n=4, type="stres")
influencePlot(peng.mod0, id.n=4, type="stres")




