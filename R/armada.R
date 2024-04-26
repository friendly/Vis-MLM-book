library(ggbiplot)
library(ggplot2)
data(Armada, package = "HistData")

# delete character and redundant variable (men = soldiers + sailors)
fleet <- Armada[, 1]
armada <- Armada[,-c(1,6)]

armada.pca <- prcomp(armada, scale.=TRUE)
summary(armada.pca)

biplot(armada.pca)

ggbiplot(armada.pca, 
         labels = fleet,
         labels.size = 4,
         varname.color = "blue",
         varname.size = 4) +
  labs(title = "Fleets of the Spanish Armada") +
  theme_bw(base_size = 14)
  

