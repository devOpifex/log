# Plumber

Use `prLog` to run a plumber API that logs requests, their paths, latency, and more.

Create a standard plumber API file.

```r
#* Increment a counter
#* @get /
function() {
  return("Hello titan!")
}

#* Plot a histogram
#* @serializer png
#* @get /plot
function() {
  rand <- rnorm(100)
  hist(rand)
}
```

Use `prLog`.

```r
library(plumber) 
     
log::prLog("test.R") %>%  
  pr_run() 
```


If you are using a package that already modifies the plumber object (e.g.: [titan](https://titan.opifex.org)) and cannot use `prLog`, you can use `prWithLog` instead.

```r
titan::prTitan("test.R") %>%  
  prWithLog() %>% 
  pr_run() 
```
