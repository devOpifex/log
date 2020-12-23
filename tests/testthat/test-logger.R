test_that("Logger", {
  bare <- Logger$new()
  expect_null(bare$log())

  expect_output(bare$log("hello"), "hello")

  prefix <- Logger$new("INFO")
  expect_output(prefix$log("hello"), "INFO\\t hello")

  flags <- Logger$new("ERROR")$date()
  str <- sprintf("ERROR\\t %s hello", format(Sys.Date(), "%d-%m-%Y"))
  expect_output(flags$log("hello"), str)

  flags$flag(function(){
    return("AAA")
  })

  str <- sprintf("ERROR\\t %s AAA world", format(Sys.Date(), "%d-%m-%Y"))
  expect_output(flags$log("world"), str)

  hook <- Logger$
    new()$
    hook(function(x){
      return("HOOK")
    })

  expect_output(hook$log("hello"), "HOOK hello")

  pred <- function(){
    return(FALSE)
  }

  bare$predicate <- pred

  expect_null(bare$log("nothing"))
})
