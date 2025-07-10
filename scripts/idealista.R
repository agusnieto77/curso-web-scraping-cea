library(rvest)
library(httr2)
library(jsonlite)
library(tidyverse)

urls_idealista <- paste0("https://www.idealista.com/venta-terrenos/huelva-provincia/pagina-", 1:40, ".htm")

espera <- sort(c(0.5:19.5, 1:20))
sample(espera, 1, replace = TRUE)
dir.create("idealista", showWarnings = FALSE, recursive = TRUE)

for (p in seq_along(urls_idealista)) {
  tiempo <- sample(espera, 1, replace = TRUE)
  response <-  req_perform(req_headers(request(urls_idealista[p]),
                                       "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36",
                                       "Accept" = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
                                       "Accept-Language" = "es-ES,es;q=0.9"))
  nombre_archivo <- sprintf("idealista/pagina%d.html", p)
  if (resp_status(response) == 200) { writeLines(resp_body_string(response), nombre_archivo) }
  message("Status: ", response$status_code)
  message("Tiempo de espera: ", tiempo, " segundos.")
  Sys.sleep(tiempo)
}

archivos_html <- list.files("idealista", pattern = "\\.html$", full.names = TRUE)

read_html(archivos_html[1]) |> html_elements("div.item-info-container > a") |> html_attr("title")
read_html(archivos_html[1]) |> html_elements("div.item-info-container > div.price-row") |> html_text2() |> str_trim()

precios_terrenos <- tibble()

for (pw in archivos_html) {
  html <- read_html(pw)
  precios_terrenos <- bind_rows(precios_terrenos, tibble(
    terreno = html_attr(html_elements(html, "div.item-info-container > a"), "title"),
    precio = str_trim(html_text2(html_elements(html, "div.item-info-container > div.price-row")))
  ))
}

precios_terrenos

# https://medium.com/@guilhermedatt/calling-the-idealista-api-using-python-a39a843cf5cc