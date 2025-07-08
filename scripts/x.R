require(rvest)
require(dplyr)

url <- "https://x.com/fpandaluza?lang=es"

html <- read_html_live(url)

html$view()

nombre <- html_text(html$html_elements("div > div > div > main > div > div > div > div > div > div > div:nth-child(1) > div > div > div > div > div > div > div > h2 > div > div > div > div > span > span > span:nth-child(1)"))

n_post <- html_text(html$html_elements("div > div > div > main > div > div > div > div > div > div > div:nth-child(1) > div > div > div > div > div > div > div > div"))[1]

user_name <- html_text(html$html_elements("div > div > div > main > div > div > div > div > div > div:nth-child(3) > div > div > div:nth-child(1) > div > div > div > div > div > div > div > div > div > span"))

imagen_perfil_1 <- html_attr(html$html_elements("div > div > div > main > div > div > div > div > div > div:nth-child(3) > div > div > div:nth-child(1) > a > div > div > div > img"), "src")

imagen_perfil_2 <- html_attr(html$html_elements("div > div > div > main > div > div > div > div > div > div:nth-child(3) > div > div > div:nth-child(1) > div > div > div > div > div > div > div > a > div:nth-child(3) > div > div > div > img"), "src")

descrip_perfil <- html_text(html$html_elements("div > div > div > main > div > div > div > div > div > div:nth-child(3) > div > div > div:nth-child(1) > div > div:nth-child(3) > div"))

mas_datos_perfil <- html_text(html$html_elements("div > div > div > main > div > div > div > div > div > div:nth-child(3) > div > div > div:nth-child(1) > div > div:nth-child(4)"))

loc_perfil <- html_text(html$html_elements("div > div > div > main > div > div > div > div > div > div:nth-child(3) > div > div > div:nth-child(1) > div > div:nth-child(4) > div > span:nth-child(1) > span > span"))

link_perfil <-  html_attr(html$html_elements("div > div > div > main > div > div > div > div > div > div:nth-child(3) > div > div > div:nth-child(1) > div > div:nth-child(4) > div > a"), "href")

inicio_cuenta <- html_text(html$html_elements("div > div > div > main > div > div > div > div > div > div:nth-child(3) > div > div > div:nth-child(1) > div > div:nth-child(4) > div > span:nth-child(3) > span"))

siguiendo <- html_text(html$html_elements("div > div > div > main > div > div > div > div > div > div:nth-child(3) > div > div > div:nth-child(1) > div > div > div > a > span > span"))[1]

seguidores <- html_text(html$html_elements("div > div > div > main > div > div > div > div > div > div:nth-child(3) > div > div > div:nth-child(1) > div > div > div > a > span > span"))[3]

post_1 <- html_text(html$html_elements("article"))[1]

post_1_texto <- html_text(html$html_elements("div > div > div.css-175oi2r.r-1f2l425.r-13qz1uu.r-417010.r-18u37iz > main > div > div > div > div > div > div:nth-child(3) > div > div > section > div > div > div:nth-child(1) > div > div > article > div > div > div.css-175oi2r.r-18u37iz > div.css-175oi2r.r-1iusvr4.r-16y2uox.r-1777fci.r-kzbkwu > div:nth-child(2)"))[1]

post_1_fecha <- html_attr(html$html_elements("article time"), "datetime")[1]

post_1_n_com <- html_text(html$html_elements("div:nth-child(1) > button > div > div > span > span > span"))[1]

post_1_n_rt <- html_text(html$html_elements("div:nth-child(2) > button > div > div > span > span > span"))[1]

post_1_n_mg <- html_text(html$html_elements("div:nth-child(3) > button > div > div > span > span > span"))[1]

x_cea <- tibble(
  nombre = nombre,
  n_post = n_post,
  usuario = user_name,
  img_p_1 = imagen_perfil_1,
  img_p_2 = imagen_perfil_2,
  descrip_p = descrip_perfil,
  descrip_p2 = mas_datos_perfil,
  localizacion = loc_perfil,
  link_p = link_perfil,
  inicio = inicio_cuenta,
  siguiendo = siguiendo,
  seguidores = seguidores,
  post_1_to = post_1,
  post_1_te = post_1_texto,
  post_1_fe = post_1_fecha,
  post_1_n_co = post_1_n_com,
  post_1_n_rt = post_1_n_rt,
  post_1_n_mg = post_1_n_mg,
  url = url
  )

glimpse(x_cea)

html$session$close()
