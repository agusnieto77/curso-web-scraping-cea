library(DBI)
library(rvest)
library(RMariaDB)
library(tidyverse)

html <- html_elements(read_html("https://elpais.com/noticias/espana/#?rel=arch"), "#main-content > div > div > article")

con <- tryCatch(
  {
    dbConnect(MariaDB(),
              host = Sys.getenv('HOSTDB'),
              user = Sys.getenv('USERDB'),
              password = Sys.getenv('PASSDB'),
              dbname = Sys.getenv('NAMEDB'),
              client.flag = RMariaDB::CLIENT_LOCAL_FILES)
  },
  error = function(e) {
    cat("Error en la conexión:\n")
    print(e)
    NULL
  }
)

dbReadTable(con, "curso_ws")

for (i in html) {
  tryCatch({
    dbWriteTable(con, 
                 value = tibble(
                   fecha = html_attr(html_element(i, "#sc_date"), "data-date"), 
                   titulo = html_text2(html_element(i, "header > h2")), 
                   bajada = html_text2(html_element(i, "p")), 
                   link = html_attr(html_element(i, "header > h2 > a"), "href")
                 ), 
                 name = "el_pais_es", 
                 row.names = FALSE, 
                 append = TRUE)
  }, error = function(e) {
    cat("URL duplicada, se omite\n")
  })
}

as_tibble(dbReadTable(con, "el_pais_es"))

RMariaDB::dbDisconnect(con)

# RECURSO: https://heliohost.org/signup/

