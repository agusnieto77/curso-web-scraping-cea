library(httr2)
library(jsonlite)
library(tidyverse)

request <- request("https://maps.googleapis.com/maps/api/place/textsearch/json") |>
  req_url_query(query = "escuelas sevilla",  key = Sys.getenv("GOOGLE_MAPS_KEY"))

response <- req_perform(request)

data <- fromJSON(resp_body_string(response))

restaurantes <- data$results

restaurantes$name[1]               # Nombre del primer restaurante
restaurantes$rating[1]             # Calificación
restaurantes$user_ratings_total[1] # Número de reseñas

glimpse(restaurantes)
