# Ambiorix

Under the hood the [ambiorix](https://ambiorix.john-coene.com/) package uses this package for logging.

The default logger can be combined with any other logger.

```r
library(ambiorix)

app <- Ambiorix$new()

# create logger with the log package
logger <- log::Logger$new()

app$get("/", function(req, res){
  log$log("Home", "was visited")
  res$send("hello!")
})

app$get("/about", function(req, res){
  log$log("About page", "was just viewed")
  res$send("Me me me")
})

app$start()
```