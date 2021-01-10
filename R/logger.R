#' Logger
#' 
#' Create a logger.
#' 
#' @importFrom crayon blurred
#' 
#' @examples 
#' info <- Logger$new("INFO")$
#'  date()$
#'  time()$
#'  hook(crayon::blue)
#' 
#' info$log("Hello")
#' Sys.sleep(.7)
#' info$log("World")
#' 
#' @export 
Logger <- R6::R6Class(
  "Logger",
  public = list(
#' @field printer A callback function to write the message
#' to the console, must accept a single argument, 
#' defaults to `cat`.
    printer = NA,
#' @field predicate A predicate function that determines whether
#' to actually run the log, useful if you want to switch the 
#' logger on and off for debugging. 
#' 
#' If the function returns `TRUE` the logger runs as normal, 
#' if `FALSE` the logger does not actually print, write or 
#' dump the messages.
    predicate = NA,
#' @details Initialise
#' 
#' @param prefix String to prefix all log messages.
#' @param file Name of the file to dump the logs to, 
#' only used if `write` is `TRUE`.
#' @param write Whether to write the log to the `file`.
#' @param sep Separator between `prefix` and other flags 
#' and messages.
#' 
#' @examples 
#' info <- Logger$new("INFO")
#' info$log("hello")
    initialize = function(prefix = NULL, write = FALSE, file = "log.log", sep = "\t"){
      
      callback <- function(prefix, sep){
        if(is.null(prefix))
          sep <- ""

        if(is.null(prefix))
          prefix <- ""

        pref <- sprintf("%s%s", prefix, sep)
        function(){
          private$.prefixHook(pref)
        }
      }

      private$.callbacks <- list(callback(prefix, sep))

      private$.file <- file
      private$.write <- write
      self$printer <- cli::cat_line
      self$predicate <- function(){
        TRUE
      }
      private$.prefixHook <- function(prefix){
        return(prefix)
      }
    },
#' @details Include the date in the log
#' @param format Formatter for the item, passed
#' to [format()].
#' @examples 
#' info <- Logger$new("INFO")$date()
#' info$log("today")
    date = function(format = "%d-%m-%Y"){
      callback <- function(){
        blurred(format(Sys.Date(), format = format))
      }

      private$.callbacks <- append(private$.callbacks, callback)
      invisible(self)
    },
#' @details Include the time in the log
#' @param format Formatter for the item, passed
#' to [format()].
#' @examples 
#' info <- Logger$new("INFO")$time()
#' info$log("now")
    time = function(format = "%H:%M:%S"){
      callback <- function(){
        blurred(format(Sys.time(), format = format))
      }

      private$.callbacks <- append(private$.callbacks, callback)
      invisible(self)
    },
#' @details Include the time in the log
#' @examples 
#' info <- Logger$new("INFO")$unix()
#' info$log("timestamp")
    unix = function(){
      callback <- function(){
        blurred(as.numeric(Sys.time()))
      }

      private$.callbacks <- append(private$.callbacks, callback)
      invisible(self)
    },
#' @details Preprocess the prefix with a custom function
#' 
#' @param fn A function that accepts one argument (string)
#' and returns a modified version of that string.
#' @examples 
#' err <- Logger$new("INFO")$hook(crayon::red)
#' err$log("hello")
    hook = function(fn){
      private$.prefixHook <- fn
      invisible(self)
    },
#' @details Include the directory in the log
#' @examples 
#' info <- Logger$new("INFO")$dir()
#' info$log("directory")
    dir = function(){
      callback <- function(){
        blurred(getwd())
      }

      private$.callbacks <- append(private$.callbacks, callback)
      invisible(self)
    },
#' @details Pass a custom flag
#' @param what Function to run for every message logged
#' or string to include in log message.
#' @examples 
#' fl <- function(){
#'  paste0(sample(letters, 4), collapse = "")
#' }
#' 
#' info <- Logger$new("INFO")$flag(fl)
#' info$log("random")
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
#' @examples 
#' info <- Logger$new("INFO")
#' info$log("Logger")
    log = function(..., sep = " ", collapse = " "){

      if(!self$predicate())
        return(invisible())

      if(length(list(...)) == 0)
        return(invisible())

      # support erratum
      if(inherits(list(...)[[1]], "Issue"))
        msg <- list(...)[[1]]$message
      else
        msg <- paste(..., sep = sep, collapse = collapse)

      # run callbacks
      cbs <- sapply(private$.callbacks, function(fn) fn())
      cbs <- paste(cbs, collapse = " ")
      
      # prefix
      msg_return <- paste(cbs, msg, collapse = " ")
      msg_return <- trimws(msg_return)
      msg_print <- msg_return
      
      self$printer(msg_print)

      if(private$.write)
        write(clean_msg(msg_return), private$.file, append = TRUE)
      else 
        private$.log <- c(private$.log, msg_return)

      invisible(msg_return)
    },
#' @details Dump the log to a file
#' @param file Name of the file to dump the logs to.
#' @examples 
#' info <- Logger$new("INFO")
#' info$log("hello")
#' \dontrun{info$dump()}
    dump = function(file = "dump.log"){
      if(!self$predicate())
        return(invisible())
      
      log <- sapply(private$.log, clean_msg)
      writeLines(log, file)
    }
  ),
  private = list(
    .prefixHook = NULL,
    .callbacks = list(),
    .log = c(),
    .file = "log.log",
    .write = FALSE
  )
)

#' Clean Message
#' 
#' Clean message for writing to file.
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
#' @examples 
#' info <- Logger$new("INFO")
#' is.log(info)
#' 
#' @export 
is.log <- function(obj){
  if(inherits(obj, "Logger"))
    return(TRUE)

  FALSE
}
