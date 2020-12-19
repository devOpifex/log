# Shiny

You can log shiny-related events with `logApp`, by default it will log inputs and their values, this can be changed, customised or turned off.

```r
library(log)
library(shiny)

ui <- fluidPage(
  h1("hello"),
  actionButton("hello", "world"),
  dateRangeInput("date", "Date"),
  selectInput("sel", "Select", choice = letters)
)

server <- function(input, output, session){
}

logApp(ui, server)
```

If you are using a package that already modifies the application (e.g.: [titan](https://titan.opifex.org)) and cannot use `logApp`, you can use `shinyWithLog` instead.

```r
shinyWithLog(
  titan::titanApp(ui, server)
)
```