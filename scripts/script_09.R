library(rvest)
library(tidyverse)

url_base <- "https://news.google.com/search?q="

consulta <- URLencode("corrupción")

before <- "+before:"

hasta <- "2010-12-31"

site <- "%20site%3A"

periodico <- "elpais.com"

hl  <- "&hl="

vhl <- "es"

gl <- "&gl="

vgl <- "ES"

ceid <- "&ceid="

vceid <- "ES%3Aes"

url <- paste0(url_base, consulta, before, hasta, site, periodico, hl, vhl, gl, vgl, ceid, vceid)

html <- read_html(url, encoding = "UTF-8")

articulos <- html_elements(html, "article")

df_filter <- tibble(
  fecha   = as_datetime(map_chr(articulos, ~ html_attr(html_element(.x, ".hvbAAd"), "datetime"))),
  titulo  = map_chr(articulos, ~ html_text(html_element(.x, ".JtKRv"))),
  autoria = map_chr(articulos, ~ html_text(html_element(.x, ".bInasb"))),
  imagen  = map_chr(articulos, ~ html_attr(html_element(.x, ".Quavad.vwBmvb"), "src")),
  link    = map_chr(articulos, ~ url_absolute(html_attr(html_element(.x, ".WwrzSb"), "href"), "https://news.google.com")),
  fuente  = map_chr(articulos, ~ html_text(html_element(.x, ".vr1PYe")))
)

df_filter
