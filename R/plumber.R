#' Plumber
#' 
#' Serve a plumber API with metrics, use this function
#' like you would use [plumber::pr()].
#' 
#' @param file Plumber file as passed to [plumber::pr()].
#' @param ... Any other argument to pass to [plumber::pr()].
#' @param requests Logger to log requests, set to `NULL` to not log.
#' @param pr Plumber API as returned by [plumber::pr()].
#' 
#' @name plumber
#' 
#' @export 
prLog <- function(file = NULL, ..., requests = requestLogger){
  checkInstalled("plumber")

  if(!is.log(requests) && !is.null(requests))
    stop("`requests` must be a logger", call. = FALSE)

  pr <- plumber::pr(file, ...)

  prWithLog(pr, requests)
}

#' @rdname plumber
#' @export
prWithLog <- function(pr, requests = requestLogger){

  checkInstalled("plumber")

  if(!is.null(requests))
    pr <- plumber::pr_hook(pr, "preroute", function(req){
      req$LOG_START <- Sys.time()
    })
  
  pr <- plumber::pr_hook(pr, "postroute", function(req, res){

    if(!is.null(requests)){

      diff <- Sys.time() - req$LOG_START

      requests$log(
        req$REQUEST_METHOD,
        " [", res$status, "] ",
        req$PATH_INFO,
        round(diff * 1000), "ms",
        sep = ""
      )

    }

  })

  pr
}

requestLogger <- Logger$new("REQUEST")$date()$time()
