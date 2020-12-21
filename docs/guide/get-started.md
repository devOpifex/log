# Get Started

This documents the core functionalities of the log package.

## Setup

A logger is created from the `Logger` class. Setting `write` to `TRUE` will write every message logged to the `file`. The `prefix` is a string that will precede every message. The `sep` argument is the separator between the `prefix` and the rest of the message to the right, it defaults to a tab (`t`).

```r
library(log)

# defaults
log <- Logger$new(
  prefix = "",
  write = FALSE,
  file = "log.log",
  sep = "\t"
)
```

_Different loggers can write to the same file._

One can leave `write` as the default `FALSE` and later use the `dump` method to save it to a file.

## Basic

After the logger has been instantiated one can use the `log` method to log a message to the console (and the file depending on whether that was set).

```r
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

## Flags

When setting up the logger one can customise it with "flags" so it includes a bit more information that might be useful to debug, e.g.: the time and date at which the message was logged. These will be written after the `prefix` and are placed in the order they are used (e.g.: date then time as shown below).

The date and time format can be customised with the `format` argument.

```r
errorLog <- Logger$new("ERROR")$
  date()$
  time()

fnc <- function() {
  errorLog$log("Oh no")
  Sys.sleep(.7)
  errorLog$log("Snap!")
}

fnc()
#> ERROR     19-12-2020 17:29:02 Oh no 
#> ERROR     19-12-2020 17:29:03 Snap!
```

Flags available:

- `date` - current date
- `time` - current time
- `unix` - unix timestamp
- `wd` - working directory

!!! tip 
    You can also customise the look of the prefix with `hook`, pass it a function that will take the prefix and return a modified version of it.

While the package comes with basic flags you can add your own with the `flag` method. This method accepts either a function that will be run every time a message is logged or a string that will simply be included in the message.

```r
random_flag <- function(){
  paste0(sample(letters, 3), collapse = "|")
}

l <- Logger$new("ERROR")$
  time()$
  flag("[README.md]")$
  flag(random_flag)

fnc <- function() {
  l$log("Oh no")
  Sys.sleep(.7)
  l$log("Snap!")
}

fnc()
#> ERROR     17:29:03 [README.md] w|e|g Oh no 
#> ERROR     17:29:04 [README.md] u|p|n Snap!
```

## Hook

There is also the possibility to pass a "hook;" a function that will preprocess the prefix and return a modified version of it.

```r
# using crayon to write the entire line red
errorLog <- errorLog$hook(crayon::red)

# fancier
hook <- function(x) {
  paste(crayon::blue(cli::symbol$info, x))
}

log <- Logger$new("INFO")$hook(hook)
log$log("Fancy this!?")
#> ℹ INFO     Fancy this!?
```

!!! tip
    The package comes with default loggers, see [templates](/guide/templates)

## Dump

Finally you can dump the log to a file with `dump`.

```r
log$dump("stuff.log")
```

## Printer

By default log uses `cli::cat_cli` to print the messages, this can be changed via the `printer` field. It accepts a function that will be used to print messages, this function must accept a single argument: the message.

```r
log <- Logger$new("PRINTER")
log$printer <- cli::cli_li

log$log("{.val something}")
#> ● PRINTER something
```
