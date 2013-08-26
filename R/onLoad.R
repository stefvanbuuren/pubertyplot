#The default
plotdumpdir = "";

#Override during load?
.onLoad <- function(...){
	plotdumpdir <<- "/tmp/plotfiles"
	dir.create(plotdumpdir, showWarnings=F);
}
