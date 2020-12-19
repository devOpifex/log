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
#' @param file Name of the file to dump the logs to, 
#' only used if `write` is `TRUE`.
#' @param write Whether to write the log to the `file`.
#' @param sep Separator between `prefix` and other flags 
#' and messages.
    initialize = function(prefix = "", write = FALSE, file = "log.log", sep = "\t"){
      private$.prefix <- prefix
      private$.file <- file
      private$.write <- write
      private$.sep <- sep
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
#' @details Include the working directory
    wd = function(){
      callback <- function(){
        getwd()
      }

      private$.callbacks <- append(private$.callbacks, callback)
      invisible(self)
    },
#' @details Preprocess the prefix with a custom function
#' 
#' @param fn A function that accepts one argument (string)
#' and returns a modified version of that string.
    hook = function(fn){
      private$.prefixHook <- fn
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
#' @details Pass a custom flag
#' @param what Function to run for every message logged
#' or string to include in log message.
    flag = function(what){

      if(!is.function(what))
        fn <- function(){
          return(what)
        }
      else 
        fn <- what

      private$.callbacks <- append(private$.callbacks, fn)
      invisible(self)
    },
#' @details Log messages
#' @param ... Elements to compose message.
#' @param sep,collapse Separators passed to [paste()].
    log = function(..., sep = " ", collapse = " "){

      # support erratum
      if(inherits(list(...)[[1]], "Issue"))
        msg <- list(...)[[1]]$message
      else
        msg <- paste(..., sep = sep, collapse = collapse)

      # run callbacks
      cbs <- lapply(private$.callbacks, function(cb){
        cb()
      })

      cbs <- unlist(cbs)
      cbs <- paste(cbs, collapse = " ")
      
      # prefix
      msg_return <- paste(private$.prefix, private$.sep, cbs, msg, "\n")
      msg_print <- msg_return
      if(!is.null(private$.prefixHook))
        msg_print <- paste(private$.prefixHook(private$.prefix), private$.sep, cbs, msg, "\n")

      cat(msg_print)

      if(private$.write)
        write(clean_msg(msg_return), private$.file, append = TRUE)
      else 
        private$.log <- c(private$.log, msg_return)

      invisible(msg_return)
    },
#' @details Dump the log to a file
#' @param file Name of the file to dump the logs to.
    dump = function(file = "dump.log"){
      log <- sapply(private$.log, clean_msg)
      writeLines(log, file)
    }
  ),
  private = list(
    .prefix = "",
    .prefixHook = NULL,
    .callbacks = list(),
    .log = c(),
    .file = "log.txt",
    .write = FALSE,
    .sep = "\t"
  )
)

#' Cleans Message for print
#' 
#' @param msg Message string.
#' 
#' @noRd 
#' @keywords internal
clean_msg <- function(msg){
  gsub("\\n", "", msg)
}

#' Log Check
#' 
#' @param obj Object to check.
#' 
#' @return `TRUE` if object is a logger,
#' and `FALSE` otherwise.
#' 
#' @export 
is.log <- function(obj){
  if(inherits(obj, "Logger"))
    return(TRUE)

  FALSE
}
