#' Default Logger for Shiny.
#' 
#' Serve a shiny application with default loggers,
#' useful for debugging.
#' 
#' @param ui,server UI definition and server function
#' as passed to [shiny::shinyApp()].
#' @param ... Any other arguments passed to [shiny::shinyApp()].
#' @param inputs Logger to log inputs, set to `NULL` to not log.
#' 
#' @export 
logApp <- function(ui, server, ..., inputs = logInputs){
  checkInstalled("shiny")

  app <- shiny::shinyApp(ui, server, ...)

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
logInputs <- Logger$new("INPUT")$date()$time()
