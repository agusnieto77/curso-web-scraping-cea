library(googleway)
library(dplyr)
library(purrr)
library(sf)

datos_coor <- "https://www.juntadeandalucia.es/institutodeestadisticaycartografia/dega/sites/default/files/datos/094-dera-13-limites-administrativos-gpkg.zip"
"https://www.juntadeandalucia.es/institutodeestadisticaycartografia/dega/sites/default/files/datos/094-dera-13-limites-administrativos.zip"

options(timeout = 6000)
download.file(datos_coor, destfile = "./coordanadas.zip", mode = "wb" )

unzip("coordanadas.zip", exdir = "./coordenadas")

st_layers("./coordenadas/094-dera-13-limites-administrativos-gpkg.gpkg", )

dir <- "./coordenadas/094-dera-13-limites-administrativos-gpkg.gpkg"

layer <- "T13_24_BarrioUrbano"

coor <- st_coordinates(st_centroid(st_transform(filter(read_sf(dir, layer), municipio == "Sevilla"), crs = 4326)))

school <- list()
df_school <- tibble()

for (i in seq_along(coor[, 1])) {
  location_results <- list()
  next_token <- NULL
  for (page in 1:3) {
    if (page == 1) { 
      response <- google_places(search_string = "school", radius = 500, location = coor[i, 2:1], key = Sys.getenv("GOOGLE_MAPS_KEY"), language = "es")
    } else {
      if (is.null(next_token)) break 
      response <- google_places(search_string = "school", radius = 500, location = coor[i, 2:1],  key = Sys.getenv("GOOGLE_MAPS_KEY"), language = "es", page_token = next_token)
    }
    location_results[[page]] <- response
    next_token <- response$next_page_token
    if (is.null(next_token)) break
    if (page < 3) Sys.sleep(2)
  }
  school <- append(school, location_results)
  results_data <- bind_rows(map( location_results, "results"))
  df_school <- bind_rows(df_school, results_data)
  message("Obteniendo localizaciones de las coordenadas: ", coor[i, 2:1])
}

df_school <- df_school |> distinct(place_id, .keep_all = TRUE)

glimpse(df_school)

saveRDS(df_school, "df_school.rds")
