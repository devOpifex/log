#' Logger
#' 
#' Create a logger
#' 
#' @examples 
#' infoLog <- Logger$new("INFO")$
#'  date()$
#'  time()$
#'  hook(crayon::blue)
#' 
#' infoLog$log("Hello")
#' Sys.sleep(.7)
#' infoLog$log("World")
#' 
#' @export 
Logger <- R6::R6Class(
  "Logger",
  public = list(
#' @details Initialise
#' 
#' @param prefix String to prefix all log messages.
    initialize = function(prefix = ""){
      private$.prefix <- prefix
    },
#' @details Include the date in the log
#' @param format Formatter for the item, passed
#' to [format()].
    date = function(format = "%d-%m-%Y"){
      callback <- function(){
        format(Sys.Date(), format = format)
      }

      private$.callbacks <- append(private$.callbacks, callback)
      invisible(self)
    },
#' @details Include the time in the log
#' @param format Formatter for the item, passed
#' to [format()].
    time = function(format = "%H:%M:%S"){
      callback <- function(){
        format(Sys.time(), format = format)
      }

      private$.callbacks <- append(private$.callbacks, callback)
      invisible(self)
    },
#' @details Include the time in the log
    unix = function(){
      callback <- function(){
        as.numeric(Sys.time())
      }

      private$.callbacks <- append(private$.callbacks, callback)
      invisible(self)
    },
#' @details Preprocess the prefix with a custom function
#' 
#' @param fn A function that accepts one argument (string)
#' and returns a modified version of that string.
    hook = function(fn){
      private$.prefixHook <- fn(private$.prefix)
      invisible(self)
    },
#' @details Include the directory in the log
    dir = function(){
      callback <- function(){
        getwd()
      }

      private$.callbacks <- append(private$.callbacks, callback)
      invisible(self)
    },
#' @details Log messages
#' @param msg Message to log
    log = function(msg = ""){
      # run callbacks
      cbs <- lapply(private$.callbacks, function(cb){
        cb()
      })

      cbs <- unlist(cbs)
      cbs <- paste(cbs, collapse = " ")

      # prefix
      msg_return <- paste(private$.prefix, "\t", cbs, msg, "\n")
      msg_print <- msg_return
      if(!is.null(private$.prefixHook))
        msg_print <- paste(private$.prefixHook, "\t", cbs, msg, "\n")

      cat(msg_print)
      private$.log <- c(private$.log, msg_return)

      invisible(msg_return)
    },
#' @details Dump the log to a file
#' @param file Name of the file to dump the logs to.
    dump = function(file = "log.txt"){
      log <- sapply(private$.log, function(l){
        gsub("\\n", "", l)
      })
      writeLines(log, file)
    }
  ),
  private = list(
    .prefix = "",
    .prefixHook = NULL,
    .callbacks = list(),
    .log = c()
  )
)
