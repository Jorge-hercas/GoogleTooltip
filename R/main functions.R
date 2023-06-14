


#' Set google key
#'
#' @param key Key for google maps to use API data
#'
#' @return
#' @export
#'
#' @examples
set_key <- function(key){
  Sys.setenv(google_key = key)
}


#' Text input with tooltip's from Google
#'
#' @param key Key for google maps to use API data (string)
#' @param label Text input label (string)
#' @param inputId Input ID (string)
#' @param width Horizontal size of widget. Value from 1 to 12
#' @param placeholder text inside widget (string)
#' @param use_shinywidgets Boolean. If it is TRUE, it will return the widget from the shinyWidgets library
#' @param icon Fontawesome icon
#' @param size Icon size
#'
#' @return
#' @export
#'
#' @examples
#' if (interactive()) {
#' library(shiny)
#' library(ggmap)
#'
#' key <- "YOUR_API_KEY"
#'
#' shinyApp(
#'   ui = fluidPage(
#'     autocomplete_textOutput(label = "Set a direction", inputId = "direction", key = key),
#'     verbatimTextOutput("text")
#'   ),
#'   server = function(input, output){
#'     observeEvent(input$direction,{
#'       output$text <- renderText({
#'         register_google(key)
#'         dir <- geocode(location = input$direction)
#'         if (is.na(dir$lat[1]) == T){
#'           "No address found"
#'         }else{
#'           paste0("lat: ",dir$lat, ", lng: ", dir$lon)
#'         }
#'       })
#'     })
#'   }
#' )
#'
#' }
autocomplete_textOutput <- function(key = Sys.getenv("google_key"), label = "Set a direction",inputId, width = NULL, placeholder = NULL, use_shinywidgets = FALSE, icon = NULL, size = NULL){

  if (!require(shiny)) {install.packages("shiny")}
  library(shiny)

  text_input <- if (use_shinywidgets == F){
    textInput(inputId = inputId, label = label, width = width, placeholder = placeholder)
  }else{
    shinyWidgets::textInputIcon(inputId = inputId, label = label, width = width, placeholder = placeholder, icon = icon, size = size)
  }

    div(
      text_input,
      textOutput(outputId = "address"),
      HTML(paste0(" <script>
                function initAutocomplete() {

                 var autocomplete =   new google.maps.places.Autocomplete(document.getElementById('",inputId,"'),{types: ['geocode']});
                 autocomplete.setFields(['address_components', 'formatted_address',  'geometry', 'icon', 'name']);
                 autocomplete.addListener('place_changed', function() {
                 var place = autocomplete.getPlace();
                 if (!place.geometry) {
                 return;
                 }

                 var addressPretty = place.formatted_address;
                 var address = '';
                 if (place.address_components) {
                 address = [
                 (place.address_components[0] && place.address_components[0].short_name || ''),
                 (place.address_components[1] && place.address_components[1].short_name || ''),
                 (place.address_components[2] && place.address_components[2].short_name || ''),
                 (place.address_components[3] && place.address_components[3].short_name || ''),
                 (place.address_components[4] && place.address_components[4].short_name || ''),
                 (place.address_components[5] && place.address_components[5].short_name || ''),
                 (place.address_components[6] && place.address_components[6].short_name || ''),
                 (place.address_components[7] && place.address_components[7].short_name || '')
                 ].join(' ');
                 }
                 var address_number =''
                 address_number = [(place.address_components[0] && place.address_components[0].short_name || '')]
                 var coords = place.geometry.location;
                 //console.log(address);
                 Shiny.onInputChange('jsValue', address);
                 Shiny.onInputChange('jsValueAddressNumber', address_number);
                 Shiny.onInputChange('jsValuePretty', addressPretty);
                 Shiny.onInputChange('jsValueCoords', coords);});}
                 </script>
                 <script src='https://maps.googleapis.com/maps/api/js?key=", key,"&libraries=places&callback=initAutocomplete' async defer></script>")
      )
    )
}


#' Get current location using a JavaScript function
#'
#' @description This function allows you to obtain your exact location through a javascript request, returning lat/long as inputs. To use it correctly, it is necessary to include it in a renderUI() within the server of a shiny app. See the example below on its use.
#' @return
#' @export
#'
#' @examples
#' library(shiny)
#'
#' shinyApp(
#'   ui = fluidPage(
#'     checkboxInput("input_1", label = "Get directions", value = FALSE),
#'     uiOutput("actual_dir"),
#'     verbatimTextOutput("direction")
#'   ),
#'   server = function(input, output, session) {
#'     output$actual_dir <- renderUI({
#'       if (input$input_1) {
#'         get_location()
#'       } else {
#'         NULL
#'       }
#'     })
#'     observeEvent(input$input_1,{
#'       lat <- input$lat
#'       lng <- input$long
#'
#'       output$direction <- renderText(paste0("lat: ", lat, ", lng: ", lng ))
#'     })
#'   }
#' )
get_location <- function() {
  tags$script(
    '$(document).ready(function () {
        navigator.geolocation.getCurrentPosition(onSuccess, onError);

        function onError (err) {
          Shiny.onInputChange("geolocation", false);
        }

        function onSuccess (position) {
          setTimeout(function () {
            var coords = position.coords;
            console.log(coords.latitude + ", " + coords.longitude);
            Shiny.onInputChange("geolocation", true);
            Shiny.onInputChange("lat", coords.latitude);
            Shiny.onInputChange("long", coords.longitude);
          }, 1100)
        }
      });'
  )
}





