# Erratum

The package supports [erratum](https://erratum.opifex.org) so one can easily log errors and warnings.

```r
library(erratum)

err <- e("This is an error")

l <- Logger$new("ERROR")

l$log(err)
```
