test_that("Templates", {
  info <- infoLog()
  error <- errorLog()
  warn <- warningLog()
  success <- successLog()

  expect_output(info$log("hello"))
  expect_output(error$log("hello"))
  expect_output(warn$log("hello"))
  expect_output(success$log("hello"))
})
