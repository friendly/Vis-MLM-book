# Special request from Michael to investigate
library(car)
library(heplots)
library(candisc)
library(ggplot2)
library(dplyr)
library(tidyr)
library(ppcor)
library(corrplot)

data(NLSY, package = "heplots")
NLSY.mod1 <- lm(
  cbind(read, math) ~ log2(income) + educ, 
  data = NLSY |>
    dplyr::filter(income != 0)
)


heplot(NLSY.mod1,
       fill = TRUE,
       fill.alpha = 0.2, 
       cex = 1.5, cex.lab = 1.5,
       lwd=c(2, 3, 3),
       label.pos = c("bottom", "top", "top"))

NLSY_notlogged <- lm(
  cbind(read, math) ~ income + educ, 
  data = NLSY 
)

heplot(NLSY_notlogged,
       fill = TRUE,
       fill.alpha = 0.2, 
       cex = 1.5, cex.lab = 1.5,
       lwd=c(2, 3, 3),
       label.pos = c("bottom", "top", "top"))

data(NLSY, package = "heplots")
cor(log2(NLSY$income[NLSY$income!=0]), NLSY$educ[NLSY$income!=0])
cor(log2(NLSY$income[NLSY$income!=0]*10000), NLSY$educ[NLSY$income!=0])
stem(log2(NLSY$income))
stem(log2(NLSY$income*10000))

cor(NLSY$income, NLSY$educ)
cor(NLSY$income[NLSY$income !=0], NLSY$educ[NLSY$income!=0])

NLSY.logged <- NLSY |> 
  dplyr::mutate(incomelg2 = log2(income),
                incomeln = log(income))  |> 
  dplyr::select(-antisoc, -hyperact) 
NLSY.logged |> 
  dplyr::filter(income != 0) |> 
  cor() |> 
  round(digits = 2) |> 
  corrplot::corrplot.mixed()

# No appreciable diff due to filter
# NLSY.logged |> 
#   cor() |> 
#   round(digits = 2) |> 
#   corrplot::corrplot.mixed()

NLSY.logged |> 
  dplyr::filter(income != 0) |> 
  dplyr::select(-incomelg2, -incomeln) |> 
  {\(x) ppcor::pcor(x)[["estimate"]]}() |> 
  round(digits = 2) |> 
  corrplot::corrplot.mixed()

NLSY.logged |> 
  dplyr::filter(income != 0) |> 
  dplyr::select(-income, -incomeln) |> 
  {\(x) ppcor::pcor(x)[["estimate"]]}() |> 
  round(digits = 2) |> 
  corrplot::corrplot.mixed()