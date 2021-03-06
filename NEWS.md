# xpose 0.2
### General
* Renamed package `xpose`
* Added example dataset `xpdb_ex_pk`
* New internal data structure using nested tibbles
* Improvement of documentation, and testing

### Data import 
#### `read_nm_tables()`
* Handles NONMEM tables in .csv, .zip format
* Handles multiple $PROB and tables with FIRSTONLY option
* Added option to import data manually as in xpose4 with `manual_nm_import()`
* Added indexing of variable and convenience functions to edit it: `set_vars_type()`, `set_vars_label()`, `set_vars_units()`

#### `read_nm_files()`
* Now imports multiple $PROB and subproblems

### Summary
* Added `print()` and `summary()` methods for xpdb
* Added `list_vars()` function to list available variables
* Added many new keywords to `template_titles`

### Access xpdb
* Added convenience functions to access data from xpdb `get_code()`, `get_data()`, `get_file()`, `get_summary()`.
* Added a method for xpdb to `dplyr::filter()`

### Plots
* Changed `cwres_vs_idv`, type residual functions to more general `res_vs_idv(res = 'CWRES')` functions
* Implemented/improved general plotting functions: `xplot_distrib()`, `xplot_qq()`, `xplot_scatter()`, with convenience function to fetch data in xpdb `data_opt_set()`.
* Implemented: `dv_vs_idv()`, `ipred_vs_idv()`, `pred_vs_idv()`, `dv_preds_vs_idv()`, `ind_plots()`, `vpc()`, `prm_distrib()`, `eta_distrib()`,
`res_distrib()`, `cov_distrib()`, `prm_qq()`, `eta_qq()`,
`res_qq()`, `cov_qq()`, `prm_vs_iteration()`, `grd_vs_iteration()`.
* Updated/renamed: `theme_bw2()`, `theme_readable()`, `theme_xp_default()`, `theme_xp_xpose4()`.

### VPC
* Added wrapper around [`ronkeizer/vpc`](https://github.com/ronkeizer/vpc) inside `vpc_data()`.


# ggxpose 0.1
### First commit
* Proof of concept pre-release around simple goodness-of-fit functions like `dv_vs_ipred()`

### Definition of core functions and workflow
* Defined the `xpose_geom()` core function to specifically direct arguments to [`ggplot2`](http://ggplot2.tidyverse.org) layers
* Defined the concept of template titles
* Define the templates for `xpose_theme()`
* Makes use of the [`tidyverse`](http://tidyverse.org) and pipes `%>%`
