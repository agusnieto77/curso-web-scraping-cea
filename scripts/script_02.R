# ==========================================
# ---WEB SCRAPING DE NOTICIAS - TUTORIAL----
# ==========================================

# Cargar la librería necesaria para web scraping
library(rvest)

# PASO 1: DEFINIR LA URL DE LA PÁGINA DE NOTICIAS
# -----------------------------------------------
# URL del sitio de noticias de Rivas Ciudad con paginación
# El parámetro "fwp_paged=1" indica que estamos en la primera página

url_noticias <- "https://www.rivasciudad.es/noticias/?fwp_paged=1"

# PASO 2: LEER EL HTML DE LA PÁGINA PRINCIPAL
# -------------------------------------------
# read_html() es suficiente para páginas estáticas
# Es más eficiente que read_html_live() cuando no se necesita ejecutar JS

html_noticias <- read_html(url_noticias)

# Mostrar el objeto HTML (opcional, para verificar que se cargó correctamente)

html_noticias

# PASO 3: DEFINIR EL SELECTOR PARA EXTRAER ENLACES
# ------------------------------------------------
# Selector CSS que busca:
# - div.m4p__img-buscador: div con clase específica que contiene la imagen de la noticia
# - > a: enlace (a) hijo directo de ese div

tag_html_href <- "div.m4p__img-buscador > a"

# PASO 4: EXTRAER ELEMENTOS QUE CONTIENEN LOS ENLACES
# ---------------------------------------------------

elements_noticias <- html_elements(html_noticias, tag_html_href)

# PASO 5: EXTRAER LOS ATRIBUTOS HREF (ENLACES)
# --------------------------------------------
# Obtener las URLs de cada noticia individual

links_noticias <- html_attr(elements_noticias, "href")

links_noticias

# PASO 6: SELECCIONAR UNA NOTICIA ESPECÍFICA
# ------------------------------------------
# Seleccionar la noticia número 30 de la lista

link_noticia <- links_noticias[30]

# PASO 7: LEER EL HTML DE LA NOTICIA INDIVIDUAL
# ---------------------------------------------

html_noticia <- read_html(link_noticia)

# PASO 8: DEFINIR SELECTORES PARA EXTRAER INFORMACIÓN ESPECÍFICA
# --------------------------------------------------------------
# Cada selector apunta a un elemento específico de la página de la noticia:

tag_titulo <- ".m4p-header-detail h1"        # Título principal (h1 dentro de div con clase específica)
tag_subtitulo <- ".m4p-header-detail p"      # Subtítulo (párrafo dentro del mismo div)
tag_fecha <- ".m4p-author_time > time"       # Fecha (elemento time dentro de div de autor/tiempo)
tag_imagen <- "figure > img"                 # Imagen principal (img dentro de figure)
tag_nota <- ".m4p-post-content"              # Contenido completo de la noticia

# PASO 9: CREAR UN TIBBLE CON TODA LA INFORMACIÓN EXTRAÍDA
# --------------------------------------------------------
# tibble es una versión moderna y mejorada de data.frame
# html_element() extrae SOLO el primer elemento que coincide (vs html_elements() que extrae todos)

nota <- tibble::tibble(
  # Extraer el texto del título
  titulo = html_text(html_element(html_noticia, tag_titulo)),
  
  # Extraer el texto del subtítulo
  subtitulo = html_text(html_element(html_noticia, tag_subtitulo)),
  
  # Extraer el atributo "datetime" del elemento time (fecha estructurada)
  fecha = html_attr(html_element(html_noticia, tag_fecha), "datetime"),
  
  # Extraer la URL de la imagen (atributo "src")
  url_imagen = html_attr(html_element(html_noticia, tag_imagen), "src"), 
  
  # Extraer todo el contenido de texto de la noticia
  nota = html_text(html_element(html_noticia, tag_nota)),
  
  # Guardar también la URL de la noticia para referencia
  url = link_noticia
)

# Mostrar el tibble con toda la información extraída

nota

# PASO 10: CREAR DIRECTORIO PARA GUARDAR IMÁGENES
# -----------------------------------------------
# dir.create() crea un directorio llamado "inotas" 
# Si ya existe, R mostrará una advertencia pero continuará

dir.create("inotas")

# PASO 11: DESCARGAR LA IMAGEN DE LA NOTICIA
# ------------------------------------------
# download.file() descarga un archivo desde una URL
# - url: la URL de la imagen extraída anteriormente
# - destfile: ruta donde guardar el archivo
# - basename() extrae solo el nombre del archivo de la URL completa
# - mode = "wb": modo binario (importante para imágenes)

download.file(
  url = nota$url_imagen, 
  destfile = paste0("inotas/", basename(nota$url_imagen)), 
  mode = "wb"
)

# ==========================================
# ------------CONCEPTOS CLAVE---------------
# ==========================================

# 1. DIFERENCIAS ENTRE FUNCIONES:
#    - html_element() vs html_elements():
#      * html_element(): extrae SOLO el primer elemento encontrado
#      * html_elements(): extrae TODOS los elementos que coinciden
#    - read_html() vs read_html_live():
#      * read_html(): para páginas estáticas, más rápido
#      * read_html_live(): para páginas de carga dinámica con JavaScript

# 2. TIPOS DE DATOS EXTRAÍDOS:
#    - html_text(): extrae el texto visible del elemento
#    - html_attr(): extrae atributos específicos (href, src, datetime, etc.)

# 3. SELECTORES CSS UTILIZADOS:
#    - ".clase": selecciona por clase CSS
#    - "elemento": selecciona por tipo de elemento HTML
#    - ">": selector de hijo directo
#    - Combinaciones: ".clase elemento", ".clase > elemento"

# 4. MANEJO DE ARCHIVOS:
#    - dir.create(): crear directorios
#    - download.file(): descargar archivos desde URLs
#    - basename(): extraer nombre de archivo de una ruta
#    - paste0(): concatenar strings sin separador

# 5. ESTRUCTURA DE DATOS:
#    - tibble: versión moderna de data.frame
#    - Permite organizar datos estructurados
#    - Cada columna puede ser de diferente tipo (texto, fecha, URL, etc.)

# 6. BUENAS PRÁCTICAS:
#    - Verificar que los elementos existen antes de acceder a índices específicos
#    - Usar mode="wb" para descargar archivos binarios (imágenes, PDFs, etc.)
#    - Organizar datos en estructuras coherentes
#    - Guardar URLs de referencia para trazabilidad
