library(parameters)
library(performance)
library(see)
library(car)
#library(arm)

data("Prestige", package="carData")

# remove missing cases
Prestige <- na.omit(Prestige)

mod1 <- lm(prestige ~ income + education, data=Prestige)
mod2 <- lm(prestige ~ income + education + women, data=Prestige)                
mod3 <- lm(prestige ~ income + education + women + type, data=Prestige) 
mod4 <- lm(prestige ~ income*type + education + women, data=Prestige) 

anova(mod1, mod2, mod3, mod4)

res <- compare_parameters(mod1, mod2, mod3, mod4)
res
plot(res)


compare_performance(mod1, mod2, mod3, mod4, rank=TRUE)

plot(compare_performance(mod1, mod2, mod3, mod4, rank=TRUE))



