
library(car)
library(heplots)
library(candisc)

data(peng, package="heplots")

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

heplot(peng.mod1, fill=TRUE, fill.alpha=0.1, 
       size="effect",
       xlim=c(35,52), ylim=c(14,20))

heplot(peng.mod2, fill=TRUE, fill.alpha=0.1, 
       size="effect",
       xlim=c(35,52), ylim=c(14,20))


pairs(peng.mod1)
pairs(peng.mod2)

(peng.can0 <- candisc(peng.mod0))

(peng.can1 <- candisc(peng.mod1))




