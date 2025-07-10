library(rvest)
library(jsonlite)
library(tidyverse)

url_momo <- "https://momo.isciii.es/panel_momo/"

html_momo <- read_html_live(url_momo)

script_json <- html_text(html_elements(html_momo, xpath = '//script[starts-with(@data-for, "htmlwidget-")]'))

json_data1 <- fromJSON(script_json[1], simplifyVector = TRUE)
glimpse(json_data1)
glimpse(json_data1$x$data)
data1 <- tibble(fechas = unlist(json_data1$x$data$x), datos = unlist(json_data1$x$data$y))
View(data1)

json_data2 <- fromJSON(script_json[2], simplifyVector = TRUE)
glimpse(json_data2)
glimpse(json_data2$x$data)
data2 <- tibble(fechas = unlist(json_data2$x$data$x)[1:1283], dato1 = unlist(json_data2$x$data$y)[1:1283], dato2 = unlist(json_data2$x$data$y)[1284:2566])
View(data2)

json_data3 <- fromJSON(script_json[3], simplifyVector = TRUE)
glimpse(json_data3)
glimpse(json_data3$x$data)
data3 <- tibble(provincia = unlist(json_data3$x$data$y), dato = unlist(json_data3$x$data$x))
View(data3)

json_data4 <- fromJSON(script_json[4], simplifyVector = TRUE)
glimpse(json_data4)
glimpse(json_data4$x$data)
data4 <- tibble(provincia = unlist(json_data4$x$data$y)[1:19], dato1 = unlist(json_data4$x$data$x)[1:19], dato2 = unlist(json_data4$x$data$x)[20:38])
View(data4)

# html_momo$view()

datos <- str_match_all(html_text(html_element(html_momo, ".section.level2.dashboard-row")), "(\\d+[\\.\\d]*)\\s*([A-Za-zÁÉÍÓÚáéíóúñÑ ]+)")[[1]]

datos_espana <- pivot_wider(tibble(nombre = gsub(" ", "_", datos[,3]), valor = as.integer(gsub("\\.", "", datos[,2]))), names_from = nombre, values_from = valor)

tabla_momo <- tibble(
  fecha_mes       = as_date(paste0(html_text2(html_elements(html_momo, xpath = '//*[@id="tabla_detalle"]/div/div[1]/div[2]/div/div/div[1]/div')), "-01")),
  notificadas     = as.integer(gsub("\\.", "", html_text2(html_elements(html_momo, xpath = '//*[@id="tabla_detalle"]/div/div[1]/div[2]/div/div/div[2]/div')))),
  observadas      = as.integer(gsub("\\.", "", html_text2(html_elements(html_momo, xpath = '//*[@id="tabla_detalle"]/div/div[1]/div[2]/div/div/div[3]/div')))),
  estimada_base   = as.integer(gsub("\\.", "", html_text2(html_elements(html_momo, xpath = '//*[@id="tabla_detalle"]/div/div[1]/div[2]/div/div/div[4]/div')))),
  exceso_t_causas = as.integer(gsub("\\.", "", html_text2(html_elements(html_momo, xpath = '//*[@id="tabla_detalle"]/div/div[1]/div[2]/div/div/div[5]/div')))),
  atribuibles_tem = as.integer(gsub("\\.", "", html_text2(html_elements(html_momo, xpath = '//*[@id="tabla_detalle"]/div/div[1]/div[2]/div/div/div[6]/div')))) 
)

source("./scripts/funciones/fun_momo.R")    

(tabla_prueba <- paginacion(html_live = html_momo))

html_momo$view()

html_elements(html_momo, "#section-filtros > form > div:nth-child(2) > div > div > div.selectize-input.items.full.has-options.has-items")

html_momo$click("#section-filtros > form > div:nth-child(2) > div > div > div.selectize-input.items.full.has-options.has-items")

html_momo$click("#kuu19n4pgh > div:nth-child(2) > div.option.active")

region <- html_text2(html_element(html_momo, "#kuu19n4pgh > div:nth-child(2) > div.option.active"))

html_momo$click("#section-filtros > form > div:nth-child(3) > div > div > div.selectize-input.items.full.has-options.has-items")

html_momo$click("#fzb0xh5r2g")

sexo <- html_text2(html_element(html_momo, "#fzb0xh5r2g"))

html_momo$click("#agrupacion_tabla > div > label:nth-child(1) > input[type=radio]")

grupo_fecha <- html_text2(html_element(html_momo, "#agrupacion_tabla > div > label:nth-child(1)"))

tabla_dia_mujeres_andalucia <- paginacion(html_live = html_momo)

glimpse(tabla_dia_mujeres_andalucia)

html_momo$session$close()
