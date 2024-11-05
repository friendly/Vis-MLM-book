# ggspring example, using gapminder data

source(here::here("R", "ggspring.R"))

data(gapminder, package="gapminder")
gm2007 <- filter(gapminder, year == 2007, continent == "Asia")
regression_model <- lm(lifeExp ~ log10(gdpPercap), gm2007)
gm2007 <- gm2007 %>% mutate(
  yhat = predict(regression_model),
  diameter = .02,
  tension = 5 + (lifeExp - yhat)^2)

xbar <- 10^mean(log10(gm2007$gdpPercap))
ybar <- mean(gm2007$lifeExp)

simple_plot <- ggplot(gm2007, aes(x = gdpPercap, y = lifeExp)) +
  geom_point(size = 2) + 
  geom_point(aes(x = xbar, y = ybar), color = "blue", size = 3) +
  scale_x_log10() + 
  ylim(c(40, 85))

spring_plot <- simple_plot + 
  geom_spring(aes(x = gdpPercap,
                  xend = gdpPercap,
                  y = lifeExp,
                  yend = yhat,
                  diameter = diameter,
                  tension = tension), color = "darkgray") +
  stat_smooth(method = "lm", se = FALSE) +
  geom_point(size = 2) 

spring_plot

#-------------------- workers data

data(workers, package = "matlib")   
#head(workers)


workers.mod <- lm(Income ~ Experience, data = workers)
workdat <- workers |>
  select(Experience, Income) |>
  mutate(yhat = predict(workers.mod),
         residual = residuals(workers.mod))
         # diameter = 0.1,
         # tension =  0.1* (yhat - residual)^2 )
head(workdat)

ggplot(workdat, aes(x=Experience, y = Income)) +
  geom_point(size = 2) +
  geom_spring(aes(xend = Experience,
                  yend = yhat,
                  diameter = 0.5,
                  tension =  0.1* (yhat - residual)^2), 
              color = "darkgrey")+
  stat_smooth(method = "lm", formula = y~x, se = FALSE) +
  geom_point(size = 2) 


  
