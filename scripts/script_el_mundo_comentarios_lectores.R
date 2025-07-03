library(rvest)
library(jsonlite)
library(tidyverse)
library(reticulate)

n <- seq(1, 1000, by = 50)

urls <- paste0("https://ariadna.elmundo.es/buscador/archivo.html?q=corrupcion&t=1&i=", n,"&n=50&fd=0&td=0&w=60&s=0&no_acd=1")

links_recolectados <- "links_el mundo.csv"

if (!file.exists(links_recolectados)) { file.create(links_recolectados) }

urls_fallidas <- c()

for (u in urls[1:3]) {
  intentos <- 1
  exito <- FALSE
  while (intentos <= 5 && !exito) {
    tryCatch({
      html <- read_html_live(u)
      Sys.sleep(0.5)
      links <- html_attr(html_elements(html, "h3 a"), "href")
      html$session$close()
      rm(html)
      if (length(links) > 0) {
        write(links, file = links_recolectados, append = TRUE)
      }
      message("URL: ", str_trunc(u, 60), " | Links recolectados: ", length(links))
      exito <- TRUE
    }, error = function(e) {
      message("Error en intento ", intentos, " con la URL ", str_trunc(u, 60))
      intentos <- intentos + 1
      Sys.sleep(1.5)
    })
  }
  if (!exito) {
    urls_fallidas <- c(urls_fallidas, u)
    message("Falló la URL tras 5 intentos: ", u)
  }
}

links_recolectados <- readLines("links_el mundo.csv")

links_recolectados <- gsub("^//www", "https://www", links_recolectados)

boton1 <- "#ue-accept-notice-button" 
boton2 <- paste(
  "div.ue-l-article__main-column.ue-l-article--minimum-content-from-tablet > article > div.ue-l-article__header.ue-c-article__header > div.ue-c-article__bar.ue-l-article--leftcol-width-from-desktop.ue-l-article--float-left-from-desktop.ue-l-article--move-to-leftcol-from-desktop.ue-l-article--order-1-from-mobile > div.ue-c-article__bar-footer > button,",
  "div.ue-l-article__header.ue-c-article__header > div > ul > li:nth-child(2) > button,",
  "div.ue-l-article__header-content > ul > li:nth-child(2) > button,", 
  "article > div.ue-l-article__body > ul > li:nth-child(2) > button,",
  "div.ue-c-article__bar-footer > button",
  collapse = " ")                                                                                                  

boton3 <- "ul#subNavComentarios li a.boton.mas, #ancla_comentarios > div.comments-tool > a.boton.mas"                                                                                                                                                                                                        
                                                                                                                                                                                                              
links_fallidos_notas <- c()                                                                                                                                                                       

# nota <- read_html_live(links_recolectados[1])
# nota$view()
# nota$html_elements(boton1)
# nota$html_elements(boton2)
# nota$html_elements(boton3)
# nota$session$close()
# rm(nota)

for (l in links_recolectados[1:12]) {
  message("\nObteniendo información de la URL: ", str_trunc(l, 50))
  intentos <- 1
  exito <- FALSE
  while (intentos <= 5 && !exito) {
    tryCatch({
      nota <- read_html_live(l)
      Sys.sleep(1.5)
      if (length(nota$html_elements(boton1)) > 0) { nota$click(boton1) }
      Sys.sleep(1.5)
      nota$scroll_by(200)
      Sys.sleep(1.5)
      if (length(nota$html_elements(boton2)) > 0) { nota$click(boton2) }
      Sys.sleep(1.5)
      n_com <- html_text(html_element(nota, ".ue-c-article__button-text, .ue-c-article__button, .js-ueCommentsCounter"))
      n_com <- as.integer(gsub("\\D", "", n_com))
      if (!is.na(n_com) && is.numeric(n_com) && n_com > 10) {
        max_clics <- 150
        clics <- 0
        repeat {
          if (length(nota$html_elements(boton3)) == 0) {
            message("No hay comentarios.")
            break
          }
          resultado_clic <- tryCatch({
            nota$click(boton3)
            TRUE  
          }, error = function(e) {
            message("Ya no hay más comentarios.")
            FALSE 
          })
          if (!resultado_clic) {
            break
          }
          clics <- clics + 1
          message("Clic número ", clics)
          Sys.sleep(1.5)
          if (clics >= max_clics) {
            message("Se alcanzó el máximo de clics permitidos.")
            break
          }
        }
      }
      Sys.sleep(1.5)
      fila <- list(
        notas   = html_text(html_element(nota, "article")),
        num_com = html_text(html_element(nota, ".ue-c-article__button-text, .js-ueCommentsCounter")),
        coment  = html_text(html_elements(nota, '.texto-comentario')),
        link    = l,
        timestamp = Sys.time()
      )
      json_line <- toJSON(fila, auto_unbox = TRUE)
      cat(json_line, "\n", file = "notas_el_mundo.jsonl", append = TRUE)
      nota$session$close()
      exito <- TRUE
    }, error = function(e) {
      message(sprintf("%d intento fallido con la URL: %s", intentos, str_trunc(l, 50)))
      intentos <<- intentos + 1
      Sys.sleep(3)
    })
  }
  if (!exito) {
    message("Tras 5 intentos fallidos pasamos al siguiente link.")
    links_fallidos_notas <- c(links_fallidos_notas, l)
  }
}

lineas <- readLines("notas_el_mundo.jsonl", warn = FALSE)
datos <- lapply(lineas, fromJSON)

datos[[1]]$coment

comentarios_el_mundo <- str_trim(unlist(lapply(datos, function(x) x$coment)))

cat("\nRecolectamos", length(comentarios_el_mundo), "comentarios.\n")

# py_install("pysentimiento")

pysentimiento <- import("pysentimiento")

analyzer <- pysentimiento$create_analyzer(task="sentiment", lang="es")

comentario <- comentarios_el_mundo[3]

comentario

resultado <- analyzer$predict(comentario)$output

resultado$output

df_com_sent <- tibble(sentimiento = NA, comentario = comentarios_el_mundo)

for (i in seq_along(df_com_sent$sentimiento)) { df_com_sent$sentimiento[i] <- analyzer$predict(df_com_sent$comentario[i] )$output }

df_com_sent

count(df_com_sent, sentimiento)
