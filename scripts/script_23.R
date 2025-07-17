# https://platform.openai.com/docs/models/compare

library(rvest)
library(ellmer)
library(stringr)

instruccion <- 'Analiza el HTML y extrae selectores CSS para:
1. **Título de noticia**: Selector del elemento que contiene el título principal
2. **Enlace de noticia**: Selector del elemento <a> que dirige al artículo completo

**INPUT**: Contenido HTML de página de noticias
**OUTPUT**: Solo JSON en este formato JSON:

{
  "tag_titulo": "selector_css_titulo",
  "tag_link": "selector_css_enlace"
}

'

url <- "https://www.lacapitalmdp.com/categorias/la-ciudad"

body_html <- as.character(html_element(read_html(url), "section"))

cat(body_html)

prompt_completo <- paste0(instruccion, "\n```html\n", body_html, "\n```")

cat(prompt_completo)

chat_openai <- chat_openai(
  model = "gpt-4.1-nano",
  params = list(
    temperature = 0.1,
    top_p = 0.1,
    max_completion_tokens = 1000
  )
)

resultado_json <- chat_openai$chat_structured(prompt_completo, type = type_object(
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

codigo <- chat_openai$chat(instruccion_codigo)

cat(str_extract(codigo, "(?s)```r\\n(.*?)\\n```")[[1]])

#####################################################################

# Cargar librería
library(rvest)
library(tibble)

# URL de la página
url <- 'https://www.lacapitalmdp.com/categorias/la-ciudad'

# Leer la página
pagina <- read_html(url)

# Extraer todos los elementos <a> dentro de <article h2>
nodos_titulos <- html_nodes(pagina, 'article h2 a')

# Extraer los textos de los títulos
titulos <- html_text(nodos_titulos, trim = TRUE)

# Extraer los enlaces (href)
enlaces <- html_attr(nodos_titulos, 'href')

# Verificar que tengan la misma longitud
if(length(titulos) != length(enlaces)){
  stop("Los vectores de títulos y enlaces no tienen la misma longitud.")
}

# Crear tibble con los resultados
resultados <- tibble(
  titulo = titulos,
  enlace = enlaces
)

# Mostrar resultados
print(resultados)

#####################################################################
