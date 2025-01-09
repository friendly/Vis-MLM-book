# outlier detection
library(heplots)
library(dplyr)

data(peng, package="heplots")
source(here::here("R", "penguin", "penguin-colors.R"))

clr <- peng.colors("dark")
pch <- c(19, 17, 15)   # ggplot defaults for a factor

cqplot(peng[, 3:6], 
   id.n = 3,
   col = clr[peng$species],
   pch = pch[peng$species],
   ref.col = "grey",
   what = "Penguin numeric variables") -> out

# extreme cases
cbind(id=rownames(out), 
      peng[rownames(out), c(1,3:6)])

alpha = 0.001
cutoff <- qchisq(p = 1-alpha, df = 4)

DSQ <- Mahalanobis(peng[, 3:6])
#outlier <- DSQ > cutoff
noteworthy <- order(DSQ, decreasing = TRUE)[1:3] |> print()

peng$size <- ifelse(1:nrow(peng) %in% noteworthy, 4, 2)
ggplot(peng, 
       aes(x = bill_length, y = bill_depth,
           color = species, shape = species, fill=species)) +
  geom_point(aes(size=size), show.legend = FALSE) +
  geom_text(data = subset(peng, ))
  geom_smooth(method = "lm", formula = y ~ x,
              se=FALSE, linewidth=2) +
  stat_ellipse(geom = "polygon", level = 0.95, alpha = 0.1) +
  theme_penguins +
  theme(legend.position = "inside",
        legend.position.inside=c(0.85, 0.15))
