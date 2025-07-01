library(rvest)
library(tidyverse)

url_base <- "https://news.google.com/search?q="

consulta <- "corrupción"

url <- URLencode(paste0(url_base, consulta))

html <- read_html(url, encoding = "UTF-8")

articulos <- html_elements(html, "article")

df_html <- tibble(
  fecha   = map_chr(articulos, ~ html_attr(html_element(.x, ".hvbAAd"), "datetime")),
  titulo  = map_chr(articulos, ~ html_text(html_element(.x, ".JtKRv"))),
  autoria = map_chr(articulos, ~ html_text(html_element(.x, ".bInasb"))),
  imagen  = map_chr(articulos, ~ html_attr(html_element(.x, ".Quavad.vwBmvb"), "src")),
  link    = map_chr(articulos, ~ html_attr(html_element(.x, ".WwrzSb"), "href")),
  fuente  = map_chr(articulos, ~ html_text(html_element(.x, ".vr1PYe")))
)

df_html
