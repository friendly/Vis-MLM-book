library(partykit)
data(Prestige, package="carData")

ptree <- ctree(prestige ~ education + income + women, data=Prestige)
ptree

plot(ptree, tp_args=gpar(fill=c("pink")), 
            ip_args=gpar(fill=adjustcolor("lightgreen", alpha=0.4)))


ptree2 <- ctree(prestige ~ education + income + women + type, data=Prestige)
ptree2



library(rpart)       # performing regression trees
library(rpart.plot)  # plotting regression trees

rmod <- rpart(prestige ~ education + income + women + type, 
              data=Prestige,
              method = "anova")

rmod
rpart.rules(rmod)

rpart.plot(rmod, tweak=1.2)
rpart.plot(rmod, tweak=1.4, extra=1, prefix="prestige=")
