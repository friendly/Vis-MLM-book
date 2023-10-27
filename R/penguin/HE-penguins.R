
library(dplyr)
library(readr)
#library(tidyr)
library(car)
library(heplots)
library(candisc)
library(palmerpenguins)


#url <- "https://raw.githubusercontent.com/friendly/penguins/master/data/penguins_size.csv"
#url <- "https://raw.githubusercontent.com/allisonhorst/penguins/master/data/penguins_size.csv"
#
#penguins <-read_csv(url)

# peng <- penguins %>%
# 	rename(
#          bill_length = bill_length_mm, 
#          bill_depth = bill_depth_mm, 
#          flipper_length = flipper_length_mm, 
#          body_mass = body_mass_g
#          ) %>%
#   mutate(species = as.factor(species),
#          island = as.factor(island),
#          sex = as.factor(substr(sex,1,1))) %>%
#   filter(!is.na(bill_depth),
#          !is.na(sex))
# 
# str(peng)
# View(peng)

load(here::here("data", "peng.RData"))


# vars <- paste(names(peng)[-1], collapse="\n")
# cat(vars)

# island
# bill_length
# bill_depth
# flipper_length
# body_mass
# sex


#peng.pca <- prcomp(peng[,3:6], scale=TRUE, na.action=na.omit)
peng.pca <- prcomp (~ bill_length + bill_depth + flipper_length + body_mass,
                    data=peng,
                    na.action=na.omit,
                    scale. = TRUE)

peng.pca

screeplot(peng.pca, type = "line", lwd=3, cex=3, 
		main="Variances of PCA Components")

library(ggbiplot)
ggbiplot(peng.pca, obs.scale = 1, var.scale = 1,
         groups = peng$species, 
         ellipse = TRUE, circle = TRUE) +
  scale_color_discrete(name = 'Penguin Species') +
  theme_minimal() +
  theme(legend.direction = 'horizontal', legend.position = 'top') 

# outliers appear on the last dimensions
ggbiplot(peng.pca, obs.scale = 1, var.scale = 1, choices = 3:4,
         groups = peng$species, 
         ellipse = TRUE, varname.size=5) +
  scale_color_discrete(name = 'Penguin Species') +
  theme_minimal() +
  theme(legend.direction = 'horizontal', legend.position = 'top') 

# island, bill_length_mm, bill_depth_mm, flipper_length_mm, body_mass_g, sex"
scatterplotMatrix(peng[,3:5], groups=peng[,1] ) 

scatterplotMatrix(~ bill_length + bill_depth + flipper_length + body_mass | species,
                  data=peng,
                  ellipse=list(levels=0.68))

# boxplots

peng_long <- peng %>% 
  gather(Measure, Size, bill_length:body_mass) 
 
ggplot(peng_long, aes(x=species, y=Size, fill=species)) +
  geom_boxplot() + 
  facet_wrap(. ~ Measure, scales="free_y", nrow=1)


cols = c(scales::hue_pal()(3), "black")
covEllipses(peng[,3:4], peng$species, 
            col=cols,
            fill=c(rep(FALSE,3), TRUE), fill.alpha=.1)

## MANOVA

contrasts(peng$species)<-matrix(c(1,-1,0, -1, -1, -2), 3,2)
contrasts(peng$species)


peng.mod0 <-lm(cbind(bill_length, bill_depth, flipper_length, body_mass) ~ species, data=peng)
Anova(peng.mod0)

heplot(peng.mod0, fill=TRUE, fill.alpha=0.2)

heplot(peng.mod0, variables=3:4,  fill=TRUE, fill.alpha=0.2, size="effect")

hyp <- list("A:C"="species1","AC:G"="species2")
heplot(peng.mod0, fill=TRUE, fill.alpha=0.2, hypotheses=hyp, size="effect")


heplot(peng.mod0, size="effect", fill=TRUE, fill.alpha=0.2)
pairs(peng.mod0)
pairs(peng.mod0, size="effect", fill=c(TRUE, FALSE))

heplot3d(peng.mod0, fill=TRUE, fill.alpha=0.2, size="effect")


### Add other predictors

peng.mod2 <-lm(cbind(bill_length, bill_depth, flipper_length, body_mass) ~ species + sex, data=peng)
Anova(peng.mod2)

heplot(peng.mod2, size="effect", fill=TRUE, fill.alpha=0.2)

peng.mod3 <-lm(cbind(bill_length, bill_depth, flipper_length, body_mass) ~ species : sex, data=peng)
Anova(peng.mod3)


## CDA


(peng.can <- candisc(peng.mod0))

#heplot(peng.can)
heplot(peng.can, size="effect", fill=c(TRUE, FALSE))




