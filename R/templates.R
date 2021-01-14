#' Template Loggers
#' 
#' Template loggers for convenience.
#' 
#' @param prefix The prefix to use, this is passed to [Logger].
#' 
#' @importFrom crayon blue red green yellow
#' @importFrom cli symbol
#' 
#' @examples 
#' info <- infoLog()
#' info$log("Information")
#' 
#' @name templates
#' @export 
infoLog <- function(prefix = "INFO"){
  prefix <- blue(symbol$info, prefix)

  Logger$new(prefix, sep = "\t\t")$date()$time()
}

#' @rdname templates
#' @export 
errorLog <- function(prefix = "ERROR"){
  prefix <- red(symbol$cross, prefix)

  Logger$new(prefix, sep = "\t\t")$date()$time()
}

#' @rdname templates
#' @export 
warningLog <- function(prefix = "WARNING"){
  prefix <- yellow(symbol$warning, prefix)

  Logger$new(prefix)$date()$time()
}

#' @rdname templates
#' @export 
successLog <- function(prefix = "SUCCESS"){
  prefix <- green(symbol$tick, prefix)

  Logger$new(prefix)$date()$time()
}
