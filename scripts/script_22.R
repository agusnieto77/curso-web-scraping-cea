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

Límite: 1000 tokens.
'
  
url <- "https://www.lacapitalmdp.com/categorias/la-ciudad"

body_html <- as.character(html_element(read_html(url), "article"))

cat(body_html)

prompt_completo <- paste0(instruccion, "\n```html\n", body_html, "\n```")

cat(prompt_completo)

chat <- chat_ollama(model = "gpt-oss") # gpt-oss

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

# 2. Leer la página web
url <- "https://www.lacapitalmdp.com/categorias/la-ciudad"
webpage <- read_html(url)

# 3. Extraer elementos con selectores
titulos_selector <- '.font-24 a'
enlaces_selector <- '.font-24 a'

titulos <- html_nodes(webpage, titulos_selector) %>%
  html_text(trim = TRUE)

enlaces <- html_nodes(webpage, enlaces_selector) %>%
  html_attr("href")


# Verificar que ambos vectores tengan la misma longitud
if (length(titulos) != length(enlaces)) {
  stop("La cantidad de títulos y enlaces no coincide.")
}

# Limpiar espacios en blanco extra (ya se hace con trim=TRUE en html_text)
# No es necesario usar trimws() porque html_text deja los espacios en blanco ya limpios.

# 4. Crear y retornar tibble
resultado <- tibble(
  titulo = titulos,
  enlace = enlaces
)

print(resultado)

#################################################

shell("taskkill /IM ollama.exe /F")
