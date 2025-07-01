library(httr)
library(rvest)

httr::content(httr::GET("http://ipapi.co/country_name/"), "text", encoding = "UTF-8")

url <- "https://news.google.com/search?q=corrupcion"

html <- read_html(url, encoding = "UTF-8")

html_elements(html, "article")

# listado de proxy: https://www.proxynova.com/proxy-server-list/

res <- GET(
  url,
  use_proxy("72.10.164.178", 23805),
  user_agent("Mozilla/5.0")
)

html_text <- content(res, as = "text", encoding = "UTF-8")

html <- read_html(html_text, encoding = "UTF-8")

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
