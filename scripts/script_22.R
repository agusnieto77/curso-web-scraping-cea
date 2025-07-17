library(jsonlite)
library(stringr)
library(ollamar)
library(ellmer)
library(rvest)

shell("start /b ollama serve")

test_connection()

instruccion <- 'Analiza el HTML y extrae selectores CSS para:
1. **Título de noticia**: Selector del elemento que contiene el título principal
2. **Enlace de noticia**: Selector del elemento <a> que dirige al artículo completo

**INPUT**: Contenido HTML de página de noticias
**OUTPUT**: Solo JSON en este formato:

```json
{
  "tag_titulo": "selector_css_titulo",
  "tag_link": "selector_css_enlace"
}
```

Límite: 1000 tokens.'
  
url <- "https://www.lacapitalmdp.com/categorias/la-ciudad"

body_html <- as.character(html_element(read_html(url), "article"))

cat(body_html)

prompt_completo <- paste0(instruccion, "\n```html\n", body_html, "\n```")

cat(prompt_completo)

chat <- chat_ollama(model = "gemma3:12b")

resultado_json <- chat$chat_structured(prompt_completo, type = type_object(
  tag_titulo = type_string("Selector CSS para el título de la noticia"),
  tag_link = type_string("Selector CSS para el enlace de la noticia")
))

resultado_json

instruccion_codigo <- paste0("Desarrollar un código completo en R para web scraping que extraiga títulos y enlaces de noticias desde:
'https://www.lacapitalmdp.com/categorias/la-ciudad'

REQUISITOS:
- Usar librería rvest (cargar con library(rvest))
- Usar html_nodes() para extraer todos los elementos encontrados

SELECTORES:
- Título: '", resultado_json[[1]], "' → extraer texto con html_text()
- Enlace: '", resultado_json[[2]], "' → extraer href con html_attr('href')

OUTPUT:
- Tibble con columnas: 'titulo' y 'enlace'
- Verificar que ambos vectores tengan la misma longitud
- Limpiar espacios en blanco extra

ESTRUCTURA:
1. Cargar librerías necesarias
2. Leer la página web
3. Extraer elementos con selectores
4. Crear y retornar tibble")

cat(instruccion_codigo)

codigo <- chat$chat(instruccion_codigo)

cat(str_extract(codigo, "(?s)```R\\n(.*?)\\n```")[[1]])

#################################################

# 1. Cargar librerías necesarias
library(rvest)
library(dplyr)
library(tibble)

# 2. Leer la página web
url <- "https://www.lacapitalmdp.com/categorias/la-ciudad"
page <- read_html(url)

# 3. Extraer elementos con selectores
titulo_selectores <- 'h2.font-24 > a'
enlace_selectores <- 'h2.font-24 > a'

titulos <- html_nodes(page, titulo_selectores) %>%
  html_text() %>%
  trimws() # Eliminar espacios en blanco al principio y al final

enlaces <- html_nodes(page, enlace_selectores) %>%
  html_attr("href") %>%
  trimws() # Eliminar espacios en blanco al principio y al final


# Verificar que ambos vectores tengan la misma longitud
if (length(titulos) != length(enlaces)) {
  stop("Los vectores de títulos y enlaces no tienen la misma longitud.")
}

# 4. Crear y retornar tibble
noticias <- tibble(
  titulo = titulos,
  enlace = enlaces
)

print(noticias)

#################################################

shell("taskkill /IM ollama.exe /F")
