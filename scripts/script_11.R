library(httr2)
library(jsonlite)

# usethis::edit_r_environ()

url <- "https://opendata.aemet.es/opendata/api/valores/climatologicos/inventarioestaciones/todasestaciones/"

url_datos <- resp_body_json(req_perform(req_url_query(request(url),api_key = Sys.getenv("OPEN_DATA"))))

datos <-  resp_body_string(req_perform(request(url_datos$datos)))

cat(datos)

cat(datos, file = "estaciones_aemet.json")

fromJSON("estaciones_aemet.json", simplifyVector = TRUE)

urls <- c("https://opendata.aemet.es/opendata/api/mapasygraficos/analisis/",
          "https://opendata.aemet.es/opendata/api/mapasygraficos/previstos/h24/",
          "https://opendata.aemet.es/opendata/api/mapasygraficos/mapassignificativos/fecha/2019-12-02/esp/f/")

urls_mapas <- c()

for (u in urls) {
  urls_mapas <- append(urls_mapas, resp_body_json(req_perform(req_url_query(request(u),api_key = Sys.getenv("OPEN_DATA"))))$datos)
}

for (u in urls) {
  m <- resp_body_json(req_perform(req_url_query(request(u),api_key = Sys.getenv("OPEN_DATA"))))$datos
  download.file(m, paste0("mapa_", basename(m),".png"), mode = "wb")
}
