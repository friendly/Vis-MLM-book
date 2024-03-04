
library(car)
library(heplots)
library(candisc)

data(peng, package="heplots")
contrasts(peng$species)<-matrix(c(1,-1,0, -1, -1, -2), 3,2)
contrasts(peng$species)


peng.mod0 <-lm(cbind(bill_length, bill_depth, flipper_length, body_mass) ~
                 species, data=peng)
Anova(peng.mod0)

# all main effects
peng.mod1 <-lm(cbind(bill_length, bill_depth, flipper_length, body_mass) ~
                 species + island + sex, data=peng)
Anova(peng.mod1)

# two-way interactions
peng.mod2 <-lm(cbind(bill_length, bill_depth, flipper_length, body_mass) ~
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




