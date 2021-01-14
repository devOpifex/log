# Log

[![R-CMD-check](https://github.com/devOpifex/log/workflows/R-CMD-check/badge.svg)](https://github.com/devOpifex/log/actions)

A convenient logger for R, shiny, and plumber.

[Get Started](/guide/get-started){: .md-button .md-button--primary }
[Install](/installation){: .md-button }

## Example

```r
log <- Logger$new(prefix = "INFO")

log$log("Something")
#> INFO       Something 

log$log("Something else")
#> INFO       Something else
```
