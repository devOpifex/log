#' Default Logger for Shiny.
#' 
#' Serve a shiny application with default loggers,
#' useful for debugging.
#' 
#' @param ui,server UI definition and server function
#' as passed to [shiny::shinyApp()].
#' @param ... Any other arguments passed to [shiny::shinyApp()].
#' @param inputs Logger to log inputs, set to `NULL` to not log.
#' @param app Shiny application as returned by [shiny::shinyApp()].
#' 
#' @name shiny
#' @export 
logApp <- function(ui, server, ..., inputs = inputLogger){
  checkInstalled("shiny")

  app <- shiny::shinyApp(ui, server, ...)

  shinyWithLog(app, inputs)

}

#' @rdname shiny
#' @export
shinyWithLog <- function(app, inputs = inputLogger){

  if(!is.log(inputs) && !is.null(inputs))
    stop("`inputs` must be a logger", call. = FALSE)

  serverFnSource <- app$serverFuncSource()

  app$serverFuncSource <- function(){
    function(input, output, session){

      # track inputs
      if(!is.null(inputs)){
        session$onInputReceived(function(val){

          for(i in 1:length(val)){
            values <- paste0(val[[i]], collapse = " - ")
            inputs$log(names(val)[i], ": ", values, sep = "")
          }

          return(val)
        })
      }

      # fails if user only uses input and output
      # if fails try without session
      app <- tryCatch(
        serverFnSource(input, output, session), 
        error = function(e) e
      )
      
      if(inherits(app, "error"))
        app <- serverFnSource(input, output)

      app
    }
  }

  app
}

#' Input logger
#' 
#' Default logger used to log inputs in [logApp()].
#' 
#' @export 
inputLogger <- Logger$new("INPUT")$date()$time()