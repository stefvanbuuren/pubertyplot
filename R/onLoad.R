#' Directory where generated plot and data files are written
#'
#' Set on package load to \code{/tmp/plotfiles}. Used by the rApache
#' handlers \code{\link{plotter}} and \code{\link{plotterpro}} as the
#' destination directory for generated PDF, PNG, CSV and TXT files.
#'
#' @export
#The default
plotdumpdir = "";

# GET, POST and FILES are injected into the global environment by rApache
# at request time; setContentType() is an rApache built-in. Neither exists
# outside that runtime, so they are declared here to satisfy R CMD check.
utils::globalVariables(c("GET", "POST", "FILES", "setContentType", "pub.data"))

#Override during load?
.onLoad <- function(...){
	plotdumpdir <<- "/tmp/plotfiles"
	dir.create(plotdumpdir, showWarnings=F);
}
