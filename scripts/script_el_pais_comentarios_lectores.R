library(httr)
library(rvest)
library(jsonlite)
library(tidyverse)

urls <- paste0("https://elpais.com/buscador/corrupcion/", 1:1000, "/")

links_recolectados <- "links_recolectados.csv"

if (!file.exists(links_recolectados)) { file.create(links_recolectados) }

for (u in urls[1:10]) {
  html <- read_html(u)
  Sys.sleep(0.5)
  links <- html_attr(html_elements(html, "h2.c_t > a"), "href")
  if (length(links) > 0) { write(links, file = links_recolectados, append = TRUE) }
  message("URL: ", u, " | Links recolectados: ", length(links))
}

links_recolectados <- readLines("links_recolectados.csv")

notas_el_pais <- "notas_el_pais.csv"

if (!file.exists(notas_el_pais)) { write_csv(tibble(notas = character(),num_com = integer(),url_com = character(),link = character()), notas_el_pais) }

boton1 <- "#didomi-notice-agree-button"
boton2 <- "span.a_com_c.disqus-comment-count"

links_fallidos <- c()

for (l in links_recolectados[1:10]) {
  message("\nObteniendo el contenido de la URL: ", str_trunc(l, 55))
  intentos <- 1
  exito <- FALSE
  while (intentos <= 5 && !exito) {
    tryCatch({
      nota <- read_html_live(l)
      Sys.sleep(1.5)
      if (length(nota$html_elements(boton1)) > 0) {
        nota$click(boton1)
        Sys.sleep(1.5)
      }
      nota$scroll_by(9000)
      Sys.sleep(1.5)
      if (length(nota$html_elements(boton2)) > 0) {
        nota$click(boton2)
        Sys.sleep(1.5)
      }
      fila <- tibble(
        notas   = html_text(html_element(nota, "#main-content")),
        num_com = as.integer(html_text(html_element(nota, ".disqus-comment-count"))),
        url_com = html_attr(html_element(nota, xpath = "/html/body/article/div[4]/div/div/div[4]/iframe[1]"), "src"),
        link    = l
      )
      nota$session$close()
      rm(nota)
      write_csv(fila, notas_el_pais, append = TRUE)
      exito <- TRUE
    }, error = function(e) {
      message(sprintf("%d intento fallido con URL: %s", intentos, stringr::str_trunc(l, 50)))
      intentos <<- intentos + 1
      Sys.sleep(3)
    })
  }
  if (!exito) {
    message(sprintf("Falló el scraping del link tras 5 intentos: %s", stringr::str_trunc(l, 50)))
    links_fallidos <- c(links_fallidos, l)
  }
}

# nota <- read_html_live(links_recolectados[1])
# nota$view()
# nota$session$close()
# rm(nota)

df_notas_el_pais <- read_csv("notas_el_pais.csv")

comentarios <- df_notas_el_pais |> filter(num_com > 0)

comentarios <- comentarios |> filter(!is.na(url_com))

urls <- comentarios$url_com

urls[2]

page <- read_html(GET(urls[5], add_headers("User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36")))

json_data <-  fromJSON(html_text(html_element(page, "script[id='disqus-threadData']")))

json_data

str(json_data, max.level = 4)

df_com <- as_tibble(json_data$response$posts)

df_com

lista_comentarios <-  list()
vector_comentarios <- c()

for (url in urls) {
  page <- read_html(GET(url, add_headers("User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36")))
  json_comentarios <- fromJSON(html_text(html_element(page, "script[id='disqus-threadData']")))$response$posts
  lista_comentarios <- append(lista_comentarios, json_comentarios)
  vector_comentarios <- append(vector_comentarios, json_comentarios$raw_message)
}

lista_comentarios

vector_comentarios
