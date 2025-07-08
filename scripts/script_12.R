library(rvest)
library(leaflet)
library(tidyverse)
library(tidygeocoder)

url <- "https://www.google.com/maps/search/escuelas+sevilla+espana"

html_gmap <- read_html_live(url)

html_gmap$view()

# Para ordenadores con IP de España
html_gmap$click("div.CxJub > div.VtwTSb > form:nth-child(2) > div > div > button") 

n_prev <- 0
max_intentos <- 20
intento <- 1

repeat {
  nodos_gmap <- html_gmap$html_elements(".Nv2PK.tH5CWc.THOPZb")
  n_actual <- length(nodos_gmap)
  
  if (n_actual == n_prev || intento > max_intentos) break
  
  try({
    html_gmap$scroll_into_view(css = ".qjESne.veYFef")
  }, silent = TRUE)
  
  Sys.sleep(5)
  n_prev <- n_actual
  intento <- intento + 1
  message("Cantidad de nodos encontrado: ", length(nodos_gmap),"\n")
}

cat("\014")

cat(as.character(nodos_gmap[1]))

nombres <- html_attr(html_elements(nodos_gmap, ".hfpxzc"), "aria-label")

links <- html_attr(html_elements(nodos_gmap, ".hfpxzc"), "href")

valoraciones <- c()
for (nodo in nodos_gmap) { valoraciones <- c(valoraciones, html_attr(html_element(nodo, ".ZkP5Je"), "aria-label")) } 

tipo_direcciones <- c()
for (nodo in nodos_gmap) { tipo_direcciones <- c(tipo_direcciones, html_text(html_element(nodo, "div.UaQhfb.fontBodyMedium > div:nth-child(4) > div:nth-child(1)"))) }

tipo <- c()
for (nodo in nodos_gmap) { tipo <- c(tipo, html_text(html_element(nodo, ".W4Efsd > span > span"))) }

direcciones <- c()
for (nodo in nodos_gmap) { direcciones <- c(direcciones, sub(".*·\\s*", "", html_text(html_element(nodo, "div.UaQhfb.fontBodyMedium > div:nth-child(4) > div:nth-child(1)")))) }

webs <- html_attr(html_elements(nodos_gmap, ".lcr4fd.S9kvJb"), "href")

html_gmap$session$close()

tabla_gmap <- tibble(
  nombres = nombres,
  links = links,
  valoraciones = valoraciones,
  direcciones = direcciones,
  webs = webs
)

tabla_gmap$latitud <- as.numeric(gsub(".*!3d([-0-9\\.]+)!4d.*", "\\1", tabla_gmap$links))
tabla_gmap$longitud <- as.numeric(gsub(".*!4d([-0-9\\.]+)!.*", "\\1", tabla_gmap$links))

tabla_gmap

leaflet(tabla_gmap)  |> 
  addTiles()  |> 
  setView(lng = mean(tabla_gmap$longitud, na.rm = TRUE),
          lat = mean(tabla_gmap$latitud, na.rm = TRUE),
          zoom = 13) |> 
  addMarkers(
    ~longitud, ~latitud,
    label = ~nombres,
    popup = ~paste0("<b>", nombres, "</b><br>",
                    "Dirección: ", direcciones, "<br>",
                    "Valoración: ", valoraciones, "<br>",
                    ifelse(is.na(webs), "", paste0("Web: <a href='", webs, "' target='_blank'>", webs, "</a><br>")),
                    "<a href='", links, "' target='_blank'>Ver en Google Maps</a>")
  )
