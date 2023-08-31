
#' Mahalanobis D2 - Animals data
#' from: https://ouzhang.rbind.io/2020/11/16/outliers-part4/

library(car)
library(dplyr)

# Load library and pull out data
library(MASS)
data(Animals, package = "MASS")

#attach(Animals)

# check data structure.
head(Animals)

Y <- Animals |>
  mutate(
    body = log10(body),
    brain = log10(brain)
  )

# Create Scatterplot
plot_fig <- ggplot(Y, aes(x = body, y = brain)) + 
  geom_point(size = 5) +
  xlab("log(body)") + 
  ylab("log(brain)") + 
  ylim(-5, 15) +
  scale_x_continuous(limits = c(-10, 16), 
                     breaks = seq(-15, 15, 5))

plot_fig

# Add the data ellipse

Y_center <- colMeans(Y)
Y_cov <- cov(Y)
Y_radius <- sqrt(qchisq(0.975, df = ncol(Y)))
Y_ellipse <- data.frame(ellipse(center = Y_center,
                                shape = Y_cov,radius = Y_radius, 
                                segments = 100, draw = FALSE))

colnames(Y_ellipse) <- colnames(Y)

plot_fig <- plot_fig +
  geom_polygon(data=Y_ellipse, color = "dodgerblue",
               fill = "dodgerblue", alpha = 0.2) +
  geom_point(aes(x = Y_center[1], y = Y_center[2]),
             color = "blue", size = 6)
plot_fig

# robust 

Y_mcd <- robustbase::covMcd(Y)
ellipse_mcd <- data.frame(car::ellipse(center = Y_mcd$center,
                                       shape = Y_mcd$cov,
                                       radius= Y_radius, 
                                       segments=100,draw=FALSE))
colnames(ellipse_mcd) <- colnames(Y)

plot_fig <- plot_fig +
  geom_polygon(data=ellipse_mcd, color="red", fill="red", 
               alpha=0.3) +
  geom_point(aes(x = Y_mcd$center[1], y = Y_mcd$center[2]),
             color = "red", size = 6)
plot_fig

# Distance-Distance plot The distance-distance plot shows the robust distance 
# of each observation versus its classical Mahalanobis distance, obtained immediately from MCD object.

robustbase::plot(Y_mcd, which = "dd")
