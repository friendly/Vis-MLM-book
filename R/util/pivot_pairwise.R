# from: https://blog.djnavarro.net/posts/2025-06-03_ggplot2-scatterplot-pairs/

#' Pivot a dataset to pairwise format to support pairs() plots al la GGally::ggpairs
#'
#' @param data 
#' @param pivot_cols provides a tidy selection of columns. These columns are the ones that we need in “pairwise” format
#' @param other_cols also a tidy selection of columns, but this time for those variables that you will want to use in your plot but aren’t actually part of the “pairwise” specification. 
#' @param names_to specify the name of the column that stores the variable names
#' @param values_to a string specifying the name of the column storing the measured values for each variable
#' @param pair_label 
#' @param pair_label_sep 
#' @param row_id 

pivot_pairwise <- function(data, 
                           pivot_cols, 
                           other_cols = !pivot_cols,
                           names_to = "name",
                           values_to = "value",
                           pair_label = c("x", "y"),
                           pair_label_sep = "_",
                           row_id = "row_id") {
  
  # construct variable names
  x_value <- paste(pair_label[1], values_to, sep = pair_label_sep)
  y_value <- paste(pair_label[2], values_to, sep = pair_label_sep)
  x_name  <- paste(pair_label[1], names_to, sep = pair_label_sep)
  y_name  <- paste(pair_label[2], names_to, sep = pair_label_sep)
  
  # create an id column
  base <- data |> 
    dplyr::mutate({{row_id}} := dplyr::row_number())
  
  # variables to be retained but not pairwise-pivoted
  fixed_data <- base |> 
    dplyr::select(
      {{other_cols}}, 
      tidyselect::all_of(row_id)
    )
  
  # select pivoting columns, pivot to long, and relabel as x-var 
  long_x <- base |>
    dplyr::select(
      {{pivot_cols}},            
      tidyselect::all_of(row_id)
    ) |>
    tidyr::pivot_longer(
      cols = {{pivot_cols}},
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
    dplyr::relocate({{y_name}}, .after = {{x_name}}) |>
    dplyr::left_join(fixed_data, by = row_id)
  
  return(pairs)
}

if(FALSE){
  penguins <- datasets::penguins |>
    tibble::as_tibble()

  penguin_paired_measurements <- penguins |>
    pivot_pairwise(
      pivot_cols = bill_len:body_mass,
      other_cols = species,
      row_id = "penguin",
      names_to = "var",
      values_to = "val"
    )
  
  penguin_paired_measurements
  
  penguin_paired_measurements |>
    ggplot(aes(x_val, y_val, colour = species)) +
    geom_point() +
    facet_grid(y_var ~ x_var, scales = "free") + 
    theme_bw()
  
}