#' Create options for data import
#' 
#' @description Provide a list of options to the general plotting functions such as 
#' \code{xplot_scatter} in order to create appropriate data input for ggplot2.
#' 
#' @param problem The problem to be used, by default returns the last one.
#' @param subprob The subproblem to be used, by default returns the last one.
#' @param source Define the location of the data in the xpdb. Should be either 'data' 
#' to use the output tables or the name of an output file attached to the xpdb.
#' @param simtab Only used when 'data' is defined as the source and `problem` is default. Should the data be coming 
#' from an estimation or a simulation table.
#' @param filter A function used to filter the data e.g. filter = function(x) x[x$TIME > 20, ] where x is the data.
#' @param tidy Logical, whether the data should be transformed to tidy data.
#' @param index_col Only used when 'tidy' is defined a \code{TRUE}. Data to use as index 
#' when tidying the data.
#'
#' @seealso \code{{xplot_scatter}}
#' 
#' @examples
#' data_opt_set(problem = 1, source = 'data', simtab = TRUE)
#' 
#' @export
data_opt_set <- function(problem   = NULL, 
                         subprob   = NULL, 
                         source    = 'data', 
                         simtab    = FALSE,
                         filter    = NULL,
                         tidy      = FALSE,
                         index_col = NULL) {
  list(problem = problem, subprob = subprob,
       source = source, simtab = simtab,
       filter = filter, tidy = tidy, 
       index_col = index_col)
}

# Create shortcut functions on the fly to filter observations
only_obs <- function(xpdb, problem) {
  mdv_var <- xp_var(xpdb, problem, type = c('evid', 'mdv'))$col[1]
  fun <- function(x) {}
  body(fun) <- bquote(x[x[, .(mdv_var)] == 0, ])
  fun
}

# Main function to get the data from different source and prepare it for plotting
fetch_data <- function(xpdb, 
                       problem   = NULL, 
                       subprob   = NULL,
                       source    = 'data', 
                       simtab    = FALSE,
                       filter    = NULL,
                       tidy      = FALSE, 
                       index_col = 'ID',
                       quiet     = FALSE) {
  
  if (source == 'data') {
    if (is.null(problem)) problem <- last_data_problem(xpdb, simtab)
    if (is.na(problem)) {
      msg(c('No data associated with $prob no.', problem, ' could be found.'), quiet)
      return()
    }
    msg(c('Using data from $prob no.', problem), quiet)
    data <- get_data(xpdb, problem = problem)
  } else {
    if (!source %in% xpdb$files$name) {
      msg(c('File ', source, ' not found in the xpdb.'), quiet)
      return()
    }
    if (is.null(problem)) problem <- last_file_problem(xpdb, source)
    if (is.null(subprob)) subprob <- last_file_subprob(xpdb, source, problem)
    msg(c('Using ', source , ' $prob no.', problem, ' subprob no.', subprob, '.'), quiet)
    data <- get_file(xpdb, source, problem, subprob)
  }
  
  if (is.function(filter)) data <- filter(data)
  
  if (tidy) {
    msg(c('Tidying data by ', stringr::str_c(index_col, collapse = ', ')), quiet)
    data <- tidyr::gather_(data = data, key_col = 'variable', value_col = 'value',
                           gather_cols = colnames(data)[!colnames(data) %in% index_col])
  }
  
  # Attach metadata to output
  attributes(data) <- c(attributes(data), 
                        list(problem = problem, simtab = simtab,
                             subprob = subprob, source = source))
  data
}