#' Compartment kinetics
#'
#' @description Plot of the change in compartment amounts over the independent variable
#'
#' @inheritParams dv_vs_pred
#' @param drop_static Should columns that only have a single unique value 
#' (i.e. static) be dropped.
#' 
#' @inheritSection xplot_scatter Layers mapping
#' @inheritSection xplot_scatter Faceting
#' @inheritSection xplot_scatter Template titles
#' @seealso \code{\link{xplot_scatter}}
#' @examples
#' amt_vs_idv(xpdb_ex_pk)
#' 
#' @export
amt_vs_idv <- function(xpdb,
                       mapping  = NULL,
                       group    = 'ID',
                       drop_static = TRUE,
                       type     = 'l',
                       title    = 'Compartments amount vs. @x | @run',
                       subtitle = 'Ofv: @ofv',
                       caption  = '@dir',
                       log      = NULL,
                       facets,
                       problem,
                       quiet,
                       ...) {
  # Check input
  check_xpdb(xpdb, check = 'data')
  if (missing(problem)) problem <- default_plot_problem(xpdb)
  if (missing(quiet)) quiet <- xpdb$options$quiet
  if (missing(facets)) facets <- add_facet_var(facets = xpdb$xp_theme$facets, 
                                               variable = 'variable')
  
  extra_args <- list(...)
  if (!any(names(extra_args) == 'nrow')) extra_args$nrow <- 3
  if (!any(names(extra_args) == 'ncol')) extra_args$ncol <- 3
  
  amt_col <- xp_var(xpdb, problem, type = 'a')$col
  if (drop_static) {
    amt_col <- drop_static_cols(xpdb, problem, cols = amt_col, quiet = quiet)
  }
  if (is.null(amt_col)) {
    stop('No compartment amount column found in the xpdb data index.', call. = FALSE)
  }
  
  do.call('xplot_scatter', 
          c(extra_args, 
            list(xpdb = xpdb, group = group, quiet = quiet,
                 opt = data_opt(problem = problem, 
                                filter = function(x) {
                                  dplyr::select_if(.tbl = x, .predicate = function(x) dplyr::n_distinct(x) > 1)
                                }, tidy = TRUE, value_col = amt_col,
                                post_processing = reorder_factors(prefix = 'Comp. ')),
                 mapping = aes_c(aes_string(x = xp_var(xpdb, problem, type = 'idv')$col, 
                                            y = 'value'), mapping),
                 type = type, facets = facets, 
                 xscale = check_scales('x', log), 
                 yscale = check_scales('y', log), 
                 title = title, subtitle = subtitle, caption = caption,
                 plot_name = as.character(match.call()[[1]]))))
}
