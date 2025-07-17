library(rvest)
library(tidyverse)

urls <- paste0("https://www.sevillaactualidad.com/sevilla/page/", 2646:3645, "/")
dt_sevilla <- tibble()
url_fallidas <- c()

for (u in urls) {
  exito <- FALSE
  intentos <- 0
  
  while (!exito && intentos < 3) {
    intentos <- intentos + 1
    tryCatch({
      htmls <- html_elements(read_html(u), "main.site-main article")
      for (h in htmls) {
        dt_sevilla <- bind_rows(
          dt_sevilla,
          tibble(
            fecha = html_attr(html_element(h, 'time'), "datetime"),
            titulo = html_text2(html_element(h, 'h2')), 
            autoria = html_text2(html_element(h, 'span.author.vcard')),
            url_autoria = html_attr(html_element(h, 'span.author.vcard a'), "href"),
            url_img = html_attr(html_element(h, 'figure > a > img'), "data-orig-file"),
            link_nota = html_attr(html_element(h, 'h2 a'), "href"),
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

saveRDS(dt_sevilla, "data/dt_sevilla.rds")
