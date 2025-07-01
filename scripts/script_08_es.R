library(rvest)
library(tidyverse)

httr::content(httr::GET("http://ipapi.co/country_name/"), "text", encoding = "UTF-8")

url_base <- "https://news.google.com/search?q="

consulta <- "corrupción"

url <- URLencode(paste0(url_base, consulta))

html <- read_html_live(url)

boton <- "#yDmH0d > c-wiz > div > div > div > div.NIoIEf > div.G4njw > div.AIC7ge > div.CxJub > div.VtwTSb > form:nth-child(2) > div > div > button"

if (length(html$html_elements(boton)) > 0) { html$click(boton) }

Sys.sleep(3)

html <- read_html_live(url)

articulos <- html_elements(html, "article")

html$session$close()

df_html <- tibble(
  fecha   = map_chr(articulos, ~ html_attr(html_element(.x, ".hvbAAd"), "datetime")),
  titulo  = map_chr(articulos, ~ html_text(html_element(.x, ".JtKRv"))),
  autoria = map_chr(articulos, ~ html_text(html_element(.x, ".bInasb"))),
  imagen  = map_chr(articulos, ~ html_attr(html_element(.x, ".Quavad.vwBmvb"), "src")),
  link    = map_chr(articulos, ~ html_attr(html_element(.x, ".WwrzSb"), "href")),
  fuente  = map_chr(articulos, ~ html_text(html_element(.x, ".vr1PYe")))
)

df_html
