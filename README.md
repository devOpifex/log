
<!-- README.md is generated from README.Rmd. Please edit that file -->

<div align="center">

<img src="docs/log.png" height="200px" />

<!-- badges: start -->

[![R-CMD-check](https://github.com/devOpifex/log/workflows/R-CMD-check/badge.svg)](https://github.com/devOpifex/log/actions)
[![Coveralls test coverage](https://coveralls.io/repos/github/devOpifex/log/badge.svg)](https://coveralls.io/r/devOpifex/log?branch=master)
[![Travis build status](https://travis-ci.com/devOpifex/log.svg?branch=master)](https://travis-ci.com/devOpifex/log)
<!-- badges: end -->

[Docs](https://log.opifex.org)

A logger for R inspired by go’s standard library log package.

</div>

## Example

```r
log <- Logger$new(prefix = "INFO")

log$log("Something")
#> INFO       Something 

log$log("Something else")
#> INFO       Something else
```

## Code of Conduct

Please note that the log project is released with a [Contributor Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
