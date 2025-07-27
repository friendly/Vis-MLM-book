# test gggda::geom_bagplot

library(gggda)
source(here::here("R", "penguin", "penguin-colors.R"))


p <- mtcars %>% 
  transform(cyl = factor(cyl)) %>% 
  ggplot(aes(x = wt, y = disp)) +
  geom_point() +
  theme_bw()
# basic bagplot
p + geom_bagplot()

p + geom_bagplot(
#  fraction = 0.4, coef = 1.2,
  bag.alpha = 0.5,
  aes(fill = cyl, linetype = cyl, color = cyl))

data(peng, package = "heplots")

ggplot(peng, 
       aes(x = bill_length, y = bill_depth,
           color = species, shape = species, fill=species)) +
  geom_smooth(method = "lm", formula = y ~ x,
              se=FALSE, linewidth=2) +
  theme_penguins("dark") +
  geom_bagplot(bag.alpha = 0.5,
               coef = 2.5,
               show.legend = FALSE) +
  theme_bw(base_size = 14) +
  theme(legend.position = "inside",
        legend.position.inside = c(0.85, 0.15)) 

