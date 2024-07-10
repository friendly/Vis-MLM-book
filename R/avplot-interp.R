# Load required libraries
library(car)
library(ggplot2)
library(dplyr)
library(gganimate)

# Create sample dataset with an influential observation
set.seed(123)
n <- 50
x1 <- rnorm(n)
x2 <- rnorm(n)
y <- 2 * x1 + 0.5 * x2 + rnorm(n)

# Add an influential observation
x1[n+1] <- 4
x2[n+1] <- 4
y[n+1] <- 15

data <- data.frame(y, x1, x2)

# Fit multiple linear regression model
model <- lm(y ~ x1 + x2, data = data)

# Create added variable plot for x1
res <- avPlot(model, "x1", 
       ellipse = list(levels=0.68, fill = TRUE, fill.alpha=0.1))

mod.mat <- model.matrix(model) |> as.data.frame()
var <- which(colnames(mod.mat) == "x1")
marginal    <- data[, c("x1", "y")]
conditional <- lsfit(mod.mat[, -var], cbind(mod.mat[, var], y), intercept=FALSE) |>
               residuals() |> as.data.frame()
colnames(conditional) <- colnames(marginal)

# interpolate

stacked <- marginal |>
  mutate(state = "marginal", alpha=0, id = 1:nrow(marginal))

for (alpha in seq(.1, .9, .2)) {
  interp <- marginal + alpha * conditional |> as.data.frame()
  colnames(interp) <- colnames(marginal)
  interp$state <- paste("interp", alpha)
  interp$alpha <- alpha
  interp$id <- 1:nrow(marginal)
  stacked <- bind_rows(stacked, interp)
}

stacked <- bind_rows(stacked, 
                     conditional |> mutate(state = "conditional",
                                           alpha = 1,
                                           id = 1:nrow(marginal))) |>
  mutate(state = forcats::fct_inorder(state))



anim <- ggplot(stacked, aes(x1, y, color=alpha)) +
  geom_point() +
  geom_text(data=stacked |> filter(id %in% c(25, 44, 51)), aes(label=id), nudge_x = -.2) +
  geom_smooth(method = "lm", se = FALSE, formula = y~x) +
  stat_ellipse(aes(fill=state), level = 0.68, geom = "polygon", alpha = 0.2) +
  transition_states(state, transition_length = 3, state_length = 1) +
  enter_fade() +
#  shadow_wake(wake_length = .1) +
  scale_color_gradient(low = "red", high = "blue") +
  labs(title = "Marginal - Conditional interpolations for x1",
       subtitle = "{closest_state}",
       x = "x1 | others",
       y = "y | others") +
  theme_bw(base_size = 14) +
  theme(legend.position = "none") 

animate(anim, end_pause = 10)





  