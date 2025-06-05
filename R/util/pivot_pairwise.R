# from: https://blog.djnavarro.net/posts/2025-06-03_ggplot2-scatterplot-pairs/

#' Pivot a dataset to pairwise format to support pairs() plots al la \code{\link[GGally]{ggpairs}} or
#' \code{\link[GGally]{ggduo}} 
#'
#' @param data 
#' @param pivot_cols Provides a tidy selection of columns. These columns are the ones that we need in “pairwise” format
#' @param other_cols a tidy selection of columns, but for those variables that you will want to use in 
#'        your plot but aren’t actually part of the “pairwise” specification. 
#' @param xvars A character vector of variable names, used to select the X variables to keep
#' @param yvars A character vector of variable names, used to select the Y variables to keep
#' @param names_to specify the name of the column that stores the variable names
#' @param values_to a string specifying the name of the column storing the measured values for each variable
#' @param pair_labels labels for the \code{x} and \code{y} variables in each pair
#' @param pair_label_sep separator to construct the combination of variable label and \code{values_to} and \code{names_to}
#' @param row_id name for row ID variable
#' @importFrom dplyr mutate select row_number rename full_join relocate left_join
#' @importFrom tidyselect all_of
#' @author Daniel Navarro

pivot_pairwise <- function(data, 
                           pivot_cols, 
                           other_cols = !pivot_cols,
                           xvars = NULL,
                           yvars = NULL,
                           names_to = "name",
                           values_to = "value",
                           pair_labels = c("x", "y"),
                           pair_label_sep = "_",
                           row_id = "row_id") {
  
  # construct variable names
  x_value <- paste(pair_labels[1], values_to, sep = pair_label_sep)
  y_value <- paste(pair_labels[2], values_to, sep = pair_label_sep)
  x_name  <- paste(pair_labels[1], names_to, sep = pair_label_sep)
  y_name  <- paste(pair_labels[2], names_to, sep = pair_label_sep)
  
  # create an id column
  base <- data |> 
    dplyr::mutate({{row_id}} := dplyr::row_number())
  
  # variables to be retained but not pairwise-pivoted
  if (!is.null({other_cols})) {
    fixed_data <- base |> 
      dplyr::select(
        {{other_cols}}, 
        tidyselect::all_of(row_id)
      )
  }
  
  # select pivoting X columns, pivot to long, and relabel as x-var 
  long_x <- base |>
    dplyr::select(
      {{pivot_cols}},  
#      all_of(xvars),
      tidyselect::all_of(row_id)
    ) |>
    tidyr::pivot_longer(
      cols = {{pivot_cols}},
#      cols = all_of(yvars),
      names_to = {{x_name}},
      values_to = {{x_value}}
    )
  
  # same data frame, but with new variable names for pivoted vars
  long_y <- long_x |> 
    dplyr::rename(
      {{y_name}} := {{x_name}}, 
      {{y_value}} := {{x_value}}
    )
  
  # full join with many-to-many gives all pairs; then restore other columns
  pairs <- dplyr::full_join(
    x = long_x,
    y = long_y,
    by = row_id,
    relationship = "many-to-many"
  ) |>
    dplyr::relocate({{y_name}}, .after = {{x_name}}) 
  
  if (!is.null({other_cols})) {
    pairs <- pairs |>
    dplyr::left_join(fixed_data, by = row_id)
  }
  
  # allow to select only some of the pairs
  if (!is.null(xvars)) {
    pairs <- pairs |> dplyr::filter({x_var} %in% xvars)
  }
  if (!is.null(yvars)) {
    pairs <- pairs |> dplyr::filter({y_var} %in% yvars)
  }
  
  return(pairs)
}

if(FALSE){
  data(peng, package ="heplots")
  penguins <- peng |>
    tibble::as_tibble()

  penguin_paired <- penguins |>
    pivot_pairwise(
      pivot_cols = bill_length:body_mass,
      other_cols = species,
      row_id = "penguin",
      names_to = "var",
      values_to = "val"
    )
  
  penguin_paired
  
  penguin_paired |>
    ggplot(aes(x_val, y_val, colour = species)) +
    geom_point() +
    facet_grid(y_var ~ x_var, scales = "free") + 
    theme_bw()

  # omit diagonals
  penguin_paired |>
    dplyr::filter(y_var != x_var) |>
    ggplot(aes(x_val, y_val, colour = species)) +
    geom_point() +
    ggh4x::facet_grid2(
      y_var ~ x_var,
      scales = "free",
      render_empty = FALSE
    ) +
    labs(x = NULL, y = NULL) +
    theme_bw()

  # lower triangle
  penguin_paired |>
    dplyr::filter(y_var > x_var) |>
    ggplot(aes(x_val, y_val, colour = species)) +
    geom_point() +
    ggh4x::facet_grid2(
      y_var ~ x_var,
      scales = "free",
      switch = "both",
      render_empty = FALSE
    ) +
    labs(x = NULL, y = NULL) +
    theme_bw()

  # NLSY data -- plot only yvars vs xvars
  data(NLSY, package = "heplots")
  xvars <- names(NLSY)[c(5, 6, 3, 4)]
  yvars <- names(NLSY)[1:2]
  
  NLSY_pairs <- NLSY |>
    pivot_pairwise(
      pivot_cols = math:educ,
      other_cols = NULL,
      row_id = "case",
      names_to = "var",
      values_to = "val"
    )
  NLSY_pairs
  
  NLSY_pairs |>
    dplyr::filter(x_var %in% xvars,
                  y_var %in% yvars) |>
    ggplot(aes(x_val, y_val)) +
    geom_point() +
    geom_smooth(method = "lm", se = FALSE, formula = y ~ x) +
    facet_grid(y_var ~ x_var, scales = "free") + 
    theme_bw()
    
  NLSY_xypairs <- NLSY |>
    pivot_pairwise(
      pivot_cols = math:educ,
      other_cols = NULL,
      xvars = xvars,
      yvars = yvars,
      row_id = "case",
      names_to = "var",
      values_to = "val"
    )
  NLSY_xypairs
  
}