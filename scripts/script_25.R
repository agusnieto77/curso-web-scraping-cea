library(rvest)
library(tidyverse)

urls_sevilla <- paste0("https://andaluciainformacion.es/?hemeroteca-articulo=1&q=&c=118&f=2021-01-28&pagina=", 1:1000)
dt_infosevilla <- tibble()
url_fallidas <- c()

for (u in urls_sevilla) {
  exito <- FALSE
  intentos <- 0
  
  while (!exito && intentos < 3) {
    intentos <- intentos + 1
    tryCatch({
      htmls <- html_elements(read_html(u), "div.CONTENIDO-IZQ.LISTADO_BUSQUEDA.LISTADO_NORMAL > div.MODULO")
      for (h in htmls) {
        dt_infosevilla <- bind_rows(
          dt_infosevilla,
          tibble(
            titulo = html_attr(html_element(h, 'h3 a'), "title"), 
            bajada = html_text2(html_element(h, 'div.entradilla')),
            url_img = html_attr(html_element(h, 'div.img-wrap img'), "src"),
            link_nota = url_absolute(html_attr(html_element(h, 'h3 a'), "href"), "https://andaluciainformacion.es/"),
            url = u
          )
        )
      }
      cat("URL scrapeada:", u, "\n")
      exito <- TRUE
    }, error = function(e) {
      if (intentos < 3) {
        cat("Error en la URL:", u, ". Reintentando en 5 segundos...\n")
        Sys.sleep(5)
      } else {
        cat("URL fallida tras 3 intentos:", u, "\n")
        url_fallidas <<- c(url_fallidas, u)
      }
    })
  }
}

saveRDS(dt_infosevilla, "data/dt_infosevilla.rds")
