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

get_file <- function(){
  for (i in -(1:sys.nframe())) {
    if (identical(args(sys.function(i)), args(base::source))) {
      return(normalizePath(sys.frame(i)$ofile,winslash = '/'))
    }
  }
}
