## Local mock server for the pubertyplot "puberty" and "pubertypro" webapps.
##
## Lets you try out the web frontends in inst/webapps without setting up
## Apache + rApache. Serves the static HTML/JS/CSS and answers the AJAX
## endpoints by calling pubertyplot's exported handlers directly, faking
## the GET/POST/FILES/setContentType globals that rApache normally injects.
##
## Usage (from anywhere):
##   Rscript tools/run_mock_webapp.R
## or, from an R session with the repo as the working directory:
##   source("tools/run_mock_webapp.R")
##
## Requires: R, the httpuv package, and either devtools (to load the
## package from source) or pubertyplot already installed.

if (!requireNamespace("httpuv", quietly = TRUE)) {
  stop(
    "The 'httpuv' package is required to run this mock server.\n",
    "Install it with: install.packages(\"httpuv\")"
  )
}
library(httpuv)

## Resolve the repo root relative to this script, so it works regardless
## of the user's working directory or where they cloned the repo.
this_file <- function() {
  args <- commandArgs(trailingOnly = FALSE)
  file_arg <- sub("^--file=", "", grep("^--file=", args, value = TRUE))
  if (length(file_arg) > 0) {
    return(normalizePath(file_arg))
  }
  # Fallback for source()'d execution inside an R session.
  normalizePath(sys.frame(1)$ofile)
}

pkgroot <- tryCatch(
  dirname(dirname(this_file())),
  error = function(e) normalizePath(".")
)

if (file.exists(file.path(pkgroot, "DESCRIPTION"))) {
  if (requireNamespace("devtools", quietly = TRUE)) {
    devtools::load_all(pkgroot, quiet = TRUE)
  } else {
    stop(
      "Found the package source at ", pkgroot, " but the 'devtools' ",
      "package is not installed.\n",
      "Install it with: install.packages(\"devtools\")"
    )
  }
} else if (requireNamespace("pubertyplot", quietly = TRUE)) {
  library(pubertyplot)
} else {
  stop(
    "Could not find the pubertyplot package source, and it is not ",
    "installed.\nRun this script from inside a clone of the repo, or ",
    "install the package first."
  )
}

webappsroot <- file.path(pkgroot, "inst", "webapps")
webroots <- list(
  puberty    = file.path(webappsroot, "puberty"),
  pubertypro = file.path(webappsroot, "pubertypro")
)

## plotter() and plotterpro() read the package's own `plotdumpdir`
## binding (set by .onLoad() to the hardcoded "/tmp/plotfiles"), not a
## global variable of the same name -- so it must be overridden inside
## the package namespace to actually take effect, and to work on
## platforms without a writable "/tmp" (e.g. Windows).
plotdumpdir <- file.path(tempdir(), "plotfiles")
dir.create(plotdumpdir, showWarnings = FALSE, recursive = TRUE)
assignInNamespace("plotdumpdir", plotdumpdir, ns = "pubertyplot")

setContentType <<- function(type) invisible(NULL)

mime_for <- function(path) {
  ext <- tolower(tools::file_ext(path))
  switch(ext,
    html = "text/html",
    css  = "text/css",
    js   = "application/javascript",
    png  = "image/png",
    jpg  = "image/jpeg",
    jpeg = "image/jpeg",
    pdf  = "application/pdf",
    gif  = "image/gif",
    csv  = "text/csv",
    txt  = "text/plain",
    sav  = "application/octet-stream",
    "application/octet-stream"
  )
}

parse_query <- function(qs) {
  if (is.null(qs) || qs == "") {
    return(list())
  }
  qs <- sub("^\\?", "", qs)
  pairs <- strsplit(qs, "&")[[1]]
  out <- list()
  for (p in pairs) {
    kv <- strsplit(p, "=", fixed = TRUE)[[1]]
    key <- utils::URLdecode(kv[1])
    val <- if (length(kv) > 1) utils::URLdecode(kv[2]) else ""
    out[[key]] <- val
  }
  out
}

read_body_raw <- function(req) {
  if (is.null(req$rook.input)) return(raw(0))
  req$rook.input$read()
}

## Minimal multipart/form-data parser sufficient for a single <input
## type="file"> field, as used by inst/webapps/pubertypro/index.html.
parse_multipart <- function(body_raw, content_type) {
  boundary <- sub(".*boundary=", "", content_type)
  boundary <- sub('^"', "", boundary)
  boundary <- sub('[";].*$', "", boundary)
  boundary_raw <- charToRaw(paste0("--", boundary))
  crlf <- charToRaw("\r\n")

  find_all <- function(haystack, needle) {
    n <- length(needle)
    h <- length(haystack)
    if (h < n) return(integer(0))
    positions <- integer(0)
    i <- 1
    while (i <= h - n + 1) {
      if (identical(haystack[i:(i + n - 1)], needle)) {
        positions <- c(positions, i)
        i <- i + n
      } else {
        i <- i + 1
      }
    }
    positions
  }

  marks <- find_all(body_raw, boundary_raw)
  parts <- list()
  for (k in seq_len(length(marks) - 1)) {
    part_start <- marks[k] + length(boundary_raw)
    part_end <- marks[k + 1] - 1
    if (part_end < part_start) next
    part <- body_raw[part_start:part_end]
    # strip leading CRLF left over from the boundary line
    if (length(part) >= 2 && identical(part[1:2], crlf)) {
      part <- part[-(1:2)]
    }
    # header/body split on the first blank line (\r\n\r\n)
    sep <- charToRaw("\r\n\r\n")
    pos <- find_all(part, sep)
    if (length(pos) == 0) next
    header_raw <- part[1:(pos[1] - 1)]
    content <- part[(pos[1] + length(sep)):length(part)]
    # strip trailing CRLF before the next boundary
    if (
      length(content) >= 2 &&
        identical(content[(length(content) - 1):length(content)], crlf)
    ) {
      content <- content[1:(length(content) - 2)]
    }
    headers <- rawToChar(header_raw)
    name_match <- regmatches(
      headers,
      regexpr('(?<!file)name="[^"]*"', headers, perl = TRUE)
    )
    name <- sub('name="([^"]*)"', "\\1", name_match)
    filename_match <- regmatches(
      headers,
      regexpr('filename="[^"]*"', headers, perl = TRUE)
    )
    filename <- if (length(filename_match) > 0) {
      sub('filename="([^"]*)"', "\\1", filename_match)
    } else {
      NULL
    }
    parts[[name]] <- list(filename = filename, content = content)
  }
  parts
}

handle_pubertyupload <- function(req) {
  body_raw <- read_body_raw(req)
  content_type <- req$CONTENT_TYPE
  parts <- parse_multipart(body_raw, content_type)
  part <- parts[["datafile"]]
  if (is.null(part)) {
    return(list(
      status = 400L,
      headers = list("Content-Type" = "text/plain"),
      body = "missing file"
    ))
  }
  tmp <- tempfile()
  writeBin(part$content, tmp)
  FILES <<- list(datafile = list(name = part$filename, tmp_name = tmp))
  out <- capture.output(pubertyplot::upload_tryCatch_pro())
  list(
    status = 200L,
    headers = list("Content-Type" = "text/html"),
    body = paste(out, collapse = "\n")
  )
}

handle_pubertyproplot <- function(req) {
  body_raw <- read_body_raw(req)
  body_str <- rawToChar(body_raw)
  params <- parse_query(body_str)
  POST <<- params
  out <- capture.output(pubertyplot::plotterpro())
  list(
    status = 200L,
    headers = list("Content-Type" = "text/html"),
    body = paste(out, collapse = "\n")
  )
}

handle_pubertyplot <- function(req) {
  params <- parse_query(req$QUERY_STRING)
  # GET$gender etc. are indexed with [1] in plotter(), so wrap each
  # value in a one-element vector to mimic rApache's GET list.
  GET <<- lapply(params, function(v) v)
  out <- capture.output(pubertyplot::plotter())
  list(
    status = 200L,
    headers = list("Content-Type" = "text/plain"),
    body = paste(out, collapse = "")
  )
}

serve_static <- function(path) {
  if (path == "/" || path == "/puberty" || path == "/puberty/") {
    path <- "/puberty/index.html"
  }
  if (path == "/pubertypro" || path == "/pubertypro/") {
    path <- "/pubertypro/index.html"
  }

  if (startsWith(path, "/plotdumpdir/")) {
    file <- file.path(plotdumpdir, sub("^/plotdumpdir/", "", path))
  } else if (startsWith(path, "/puberty/")) {
    file <- file.path(webroots$puberty, sub("^/puberty/", "", path))
  } else if (startsWith(path, "/pubertypro/")) {
    file <- file.path(webroots$pubertypro, sub("^/pubertypro/", "", path))
  } else {
    file <- file.path(webroots$puberty, sub("^/", "", path))
  }

  if (file.exists(file) && !dir.exists(file)) {
    return(list(
      status = 200L,
      headers = list("Content-Type" = mime_for(file)),
      body = readBin(file, "raw", n = file.info(file)$size)
    ))
  }
  list(status = 404L, headers = list("Content-Type" = "text/plain"), body = "Not found")
}

app <- list(
  call = function(req) {
    path <- req$PATH_INFO
    tryCatch(
      {
        if (path == "/pubertyplot") {
          handle_pubertyplot(req)
        } else if (path == "/pubertyupload") {
          handle_pubertyupload(req)
        } else if (path == "/pubertyproplot") {
          handle_pubertyproplot(req)
        } else {
          serve_static(path)
        }
      },
      error = function(e) {
        list(
          status = 500L,
          headers = list("Content-Type" = "text/plain"),
          body = paste("Server error:", conditionMessage(e))
        )
      }
    )
  }
)

host <- "127.0.0.1"
port <- 7654
server <- httpuv::startServer(host, port, app)
puberty_url <- sprintf("http://%s:%d/puberty/", host, port)
pubertypro_url <- sprintf("http://%s:%d/pubertypro/", host, port)
cat("Mock webapps running at:\n")
cat(" ", puberty_url, "\n")
cat(" ", pubertypro_url, "\n")
cat("Press Ctrl+C to stop.\n")

## IDE consoles (e.g. Positron, RStudio) don't always know how to open a
## bare local server URL when its link is clicked ("No application found
## to load URL"). Open it directly in the system browser instead.
utils::browseURL(puberty_url)

repeat {
  httpuv::service()
  Sys.sleep(0.01)
}
