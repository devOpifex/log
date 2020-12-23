# Templates

The packages comes with four template loggers to log different types of information:

- Info
- Error
- Warning
- Success

```r
foo <- function(){
  info <- infoLog()
  error <- errorLog()
  warn <- warningLog()
  success <- successLog()

  info$log("Some information")
  error$log("An error occurred")
  warn$log("A warning was raised")
  success$log("It went well!")
}

foo()
#> ℹ INFO           21-12-2020 20:10:52 Some information
#> ✖ ERROR          21-12-2020 20:10:52 An error occurred
#> ⚠ WARNING        21-12-2020 20:10:52 A warning was raised
#> ✔ SUCCESS        21-12-2020 20:10:52 It went well!
```

!!! Note
    The above prints with colors via `cli`.
