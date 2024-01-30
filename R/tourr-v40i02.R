library(tourr)

# Examples

animate(flea[, 1:6], grand_tour(d = 2), display = display_xy()) 
animate(flea[, 1:6], grand_tour(d = 3), display = display_depth())
animate(flea[, 1:6], grand_tour(d = 4), display = display_pcp())

animate_xy(flea[, 1:6], guided_tour(index = holes))
animate_xy(flea[, 1:6], little_tour(d = 2))

# History

f1 <- save_history(flea[, 1:6],grand_tour(d = 1), max_bases = 10)
render(flea[, 1:6], planned_tour(f1), display_dist(), frames = 50, 
  "pdf", "tour1d-animation.pdf", width = 4, height = 4)
f1interp <- interpolate(f1)

d <- path_dist(f1)
ord <- as.data.frame(MASS::isoMDS(d)$points)
qplot(V1, V2, data = ord, geom="path") + 
  coord_equal() + labs(x = NULL, y = NULL)

gt <- grand_tour(d = 4)
animate_pcp(flea[, 1:6], gt)
animate_pcp(flea[, 1:6], gt) # Will take a different path!

set.seed(1410)
animate_pcp(flea[, 1:6], gt)
set.seed(1410)
animate_pcp(flea[, 1:6], gt) # Will take the same path.

path <- save_history(flea[, 1:6], gt, 10)
animate_pcp(flea[, 1:6], planned_tour(path))
animate_pcp(flea[, 1:6], planned_tour(path)) # The same path again


# Extending the package ------------------------------------------------------

# Closures

power <- function(exponent) {
  function(x) x ^ exponent
}

square <- power(2)
square(2) # -> [1] 4
square(4) # -> [1] 8

cube <- power(3)
cube(2) # -> [1] 8
cube(4) # -> [1] 64


new_counter <- function() {
  i <- 0
  function() {
    # do something useful, then ...
    i <<- i + 1
    i
  }
}
counter_one <- new_counter()
counter_two <- new_counter()

counter_one() # -> [1] 1
counter_one() # -> [1] 2
counter_two() # -> [1] 1

# New tour path

grand_tour <- function(d = 2) {
  generator <- function(current, data) {
    if (is.null(current)) return(basis_init(ncol(data), d))

    basis_random(ncol(data), d)      
  }
  new_geodesic_path(generator, name = "grand") 
}

basis_random <- function(n, d = 2) {  
  mvn <- matrix(rnorm(n * d), ncol = d)
  orthonormalise(mvn)
}

basis_init <- function(n, d) {
  start <- matrix(0, nrow = n, ncol = d)
  diag(start) <- 1    
  start
}

# New index for guided tour

holes <- function(mat) {
  n <- nrow(mat)
  d <- ncol(mat)

  num <- 1 - 1/n * sum(exp(-0.5 * rowSums(mat ^ 2)))
  den <- 1 - exp(-d / 2)

  num / den
}

lda_pp <- function(cl) {
  if (length(unique(cl)) == 0)
    stop("ERROR: You need to select the class variable!")
  if (length(unique(cl)) == 1)
    stop("LDA index needs at least two classes!")

  function(mat) {
    fit <- manova(mat ~ cl)                      

    1 - summary(fit, test = "Wilks")$stats[[3]]    
  }
}
