#' Dutch 1997 pubertal stage references
#'
#' Reference percentiles for pubertal stage variables by age, based on the
#' Dutch 1997 growth study (Fredriks et al., 2000). Used by
#' \code{\link{calculateSDS}} to convert an observed age/stage combination
#' into a standard deviation score.
#'
#' @format A list with six components, one per pubertal stage variable:
#'   \code{gen}, \code{phb}, \code{tv}, \code{bre}, \code{phg} and
#'   \code{men}. Each component is a data frame whose first column is
#'   \code{age} and whose remaining columns hold the age at which 50% of
#'   the reference population reaches each stage.
#' @source Fredriks AM, van Buuren S, Burgmeijer RJ, et al. (2000).
#'   Continuing positive secular growth change in The Netherlands 1955-1997.
#'   \emph{Pediatric Research}, 47(3), 316-323.
"pub.ref"

#' Dutch 1997 pubertal stage reference lines
#'
#' Reference curves, expressed as standard deviation scores (SDS) by age,
#' derived from \code{\link{pub.ref}}. Used by \code{\link{plot_stadia}} to
#' draw the percentile lines on a puberty stadia plot.
#'
#' @format A list with six components, one per pubertal stage variable:
#'   \code{gen}, \code{phb}, \code{tv}, \code{bre}, \code{phg} and
#'   \code{men}. Each component is a matrix whose first column is
#'   \code{age} and whose remaining columns hold the SDS curve for each
#'   stage.
#' @source Derived from \code{\link{pub.ref}}; see
#'   \code{data-raw/R/create_references.R}.
"pub.ref.lines"
