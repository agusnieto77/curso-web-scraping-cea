library(googleway)
library(dplyr)

school01 <- google_places(search_string = "school", radius = 1, location = c(37.38283, -5.97317),  key = Sys.getenv("GOOGLE_MAPS_KEY"), language = "es")

school02 <- google_places(search_string = "school", radius = 1, location = c(37.38283, -5.97317),  key = Sys.getenv("GOOGLE_MAPS_KEY"), language = "es",
                                page_token = school01$next_page_token)

school03 <- google_places(search_string = "school", radius = 1, location = c(37.38283, -5.97317),  key = Sys.getenv("GOOGLE_MAPS_KEY"), language = "es",
                                page_token = school02$next_page_token)

t_school <- bind_rows(list(school01$results, school02$results, school03$results)) |> distinct(place_id, .keep_all = T)

glimpse(t_school)

t_school

tabla_escuelas$name

# https://developers.google.com/maps/documentation/places/web-service/legacy/supported_types?hl=es-419