# GoogleTooltip
Package to generate suggested results of addresses in a textoutput from the google maps API

Note that for this package it is necessary to obtain an API Key from google maps, which can be obtained in [the following link](https://developers.google.com/maps/documentation/javascript/get-api-key?hl=es-419).

You can download the package with the following command:

```
devtools::install_github("Jorge-hercas/GoogleTooltip")
```

## Basic example

```
if (interactive()) {
library(shiny)
library(ggmap)

key <- "YOUR_API_KEY"

shinyApp(
  ui = fluidPage(
    autocomplete_textOutput(label = "Set a direction", inputId = "direction", key = key),
    verbatimTextOutput("text")
  ),
  server = function(input, output){
    observeEvent(input$direction,{
      output$text <- renderText({
        register_google(key)
        dir <- geocode(location = input$direction)
        if (is.na(dir$lat[1]) == T){
          "No address found"
        }else{
          paste0("lat: ",dir$lat, ", lng: ", dir$lon)
        }
      })
    })
  }
)

}
```

![Grabación de pantalla 2023-06-12 a la(s) 11 01 51](https://github.com/Jorge-hercas/GoogleTooltip/assets/70007745/57a57ef2-66c9-430a-aeab-615a7a3bbc6a)













