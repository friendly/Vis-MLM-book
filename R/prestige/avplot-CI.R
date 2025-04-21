#' ---
#' title: Add confidence band to an avPlot
#' ---
data(Prestige, package="carData")
library(car)
library(ggplot2)


#' Main effects model
prestige.mod <- lm(prestige ~ education + income + women,
                    data=Prestige)

#' ## avPlots
out <- avPlots(prestige.mod, terms = ~education + income,
        ellipse = list(levels = 0.68),
        pch = 19,
        id = list(n = 3, cex = 0.7),
        main = "Added-variable plots for prestige")

# re-do using ggplot
theme_set(theme_bw(base_size = 14))
ggplot(data=out[[1]],
       aes(x=education, y=prestige)) +
  geom_point() +
  stat_ellipse(level = 0.68,
               color = "blue", fill="blue",
               geom = "polygon", 
               alpha = 0.2) +
  geom_smooth(method = "lm", color = "red", fill = "red", alpha = 0.2) +
  geom_hline(yintercept = 0) +
  labs(x = "education | others",
       y = "prestige | others") 

ggplot(data=out[[2]],
       aes(x=income, y=prestige)) +
  geom_point() +
  stat_ellipse(level = 0.68,
               color = "blue", fill="blue",
               geom = "polygon", 
               alpha = 0.2) +
  geom_smooth(method = "lm", color = "red", fill = "red", alpha = 0.2) +
  geom_hline(yintercept = 0) +
  labs(x = "income | others",
       y = "prestige | others") 
