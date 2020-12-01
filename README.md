
<!-- README.md is generated from README.Rmd. Please edit that file -->

<!-- badges: start -->

<!-- badges: end -->

# log

A logger for R.

## Installation

Get it from github.

``` r
# install.packages("remotes")
remotes::install_github("devOpifex/log")
```

## Example

The package comes with a single reference class to create logs.

``` r
library(log)

log <- Logger$new(prefix = "INFO")

fnc <- function() {
  log$log("Something")
  Sys.sleep(.7)
  log$log("Something else")
}

fnc()
#> INFO       Something 
#> INFO       Something else
```

You can easily add timestamps and more.

``` r
errorLog <- Logger$new("ERROR")$
  date()$
  time()

fnc <- function() {
  errorLog$log("Oh no")
  Sys.sleep(.7)
  errorLog$log("Snap!")
}

fnc()
#> ERROR     01-12-2020 17:56:23 Oh no 
#> ERROR     01-12-2020 17:56:23 Snap!
```

You can also customise the look of the prefix with `hook`, pass it a
function that will take the prefix and return a modified version of it.

``` r
# using crayon
errorLog <- errorLog$hook(crayon::red)

# fancier
hook <- function(x) {
  paste(crayon::blue(cli::symbol$info, x))
}

log <- Logger$new("INFO")$hook(hook)
log$log("Fancy this!?")
#> ℹ INFO     Fancy this!?
```

Finally you can dump the log to a file with `dump`.

``` r
log$dump("file.txt")
```
