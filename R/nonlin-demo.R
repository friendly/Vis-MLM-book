library(ggplot2)
library(patchwork)

#' Generate random points on a circular anulus
#'
#' @param n  Number of points
#' @param R1 Inside radius
#' @param R2 Outside radius
#' @param a1 Start angle
#' @param a2 End angle
#'
#' @return A data.frame with columns [x], [y], [r], [theta]
#' @export
#'
#' @examples
#' #none
ranulus <- function(n, R1, R2, a1=0, a2=2*pi) {
  theta <- runif(n, a1, a2)
  u <- runif(n) + runif(n)
  r <- ifelse(u>1, 2-u, u)
  r <- ifelse(r < R2, R2 + r*((R1-R2)/R2), r)
  df <- data.frame(x = r * cos(theta),
                   y = r * sin(theta),
                   r = r,
                   theta = theta)
  df
}

n <- 250
df1 <- ranulus(n, R1=0.5,  R2=0.8, a1=0,        a2=1.5 * pi )
df2 <- ranulus(n, R1=0.75, R2=3.5,  a1=.25 * pi, a2=2*pi )
df <- rbind(cbind(gp = 1, df1),
            cbind(gp = 2, df2))

# plot(y ~ x, data = df, col=gp)
# plot(theta ~ r, data=df, col = gp)

plt1 <- ggplot(data = df, 
               aes(x = x, y = y, 
                   color=factor(gp), shape=factor(gp))) +
  geom_point(size=2) +
  theme_bw(base_size = 14) +
  theme(legend.position = "none")
plt1

plt2 <- ggplot(data = df, 
               aes(x = r, y = theta, 
                   color=factor(gp), shape=factor(gp))) +
  geom_point(size = 2) +
  xlim(c(0,4)) +
  labs(x = "radius", y = "angle") +
  theme_bw(base_size = 14) +
  theme(legend.position = "none")
plt2

plt1 + plt2

ggsave("images/nonlin-demo.png", height=4, width=8)

