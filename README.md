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

## Get yout current location (lat/lng)

```
library(shiny)

shinyApp(
  ui = fluidPage(
    checkboxInput("input_1", label = "Get directions", value = FALSE),
    uiOutput("actual_dir"),
    verbatimTextOutput("direction")
  ),
  server = function(input, output, session) {
    output$actual_dir <- renderUI({
      if (input$input_1) {
        get_location()
      } else {
        NULL
      }
    })
    observeEvent(input$input_1,{
      lat <- input$lat
      lng <- input$long

      output$direction <- renderText(paste0("lat: ", lat, ", lng: ", lng ))
    })
  }
)
```
![loc](https://github.com/Jorge-hercas/GoogleTooltip/assets/70007745/d6ec42df-6b95-46dd-9e6c-8ea78c3211b2)










