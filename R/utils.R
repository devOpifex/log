#' Check Installed
#' 
#' Check that package is installed.
#' 
#' @param pkg Package name. 
#' 
#' @keywords internal
checkInstalled <- function(pkg){
  has_it <- base::requireNamespace(pkg, quietly = TRUE)

  if(!has_it)
    stop(sprintf("This function requires the package {%s}", pkg), call. = FALSE)
}
