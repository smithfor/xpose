% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/xplot_helpers.R
\name{drop_static_cols}
\alias{drop_static_cols}
\title{Return names of columns having several unique values}
\usage{
drop_static_cols(xpdb, problem, cols, quiet)
}
\arguments{
\item{xpdb}{An xpose database object.}

\item{problem}{The $problem number to be used.}

\item{cols}{A vector of column names to be checked.}

\item{quiet}{Should messages be displayed to the console.}
}
\value{
A subset of `col` for which more than one single 
value was found in the data.
}
\description{
Return names of columns having several unique values
}
\keyword{internal}
