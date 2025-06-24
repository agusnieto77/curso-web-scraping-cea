# =====================================
# --------WEB SCRAPING DE 4CHAN--------
# =====================================

# Cargar la librería necesaria para web scraping
library(rvest)

# PASO 1: DEFINIR LA URL BASE
# ---------------------------
# Definir la URL del catálogo de la sección /pol/ de 4chan

url_base <- "https://boards.4chan.org/pol/catalog"

# PASO 2: LEER EL HTML DE LA PÁGINA
# ---------------------------------
# read_html_live() se usa para páginas que cargan contenido dinámicamente con JavaScript
# Es más robusto que read_html() para sitios modernos

html_boards_pol <- read_html_live(url_base)

# PASO 3: DEFINIR EL SELECTOR CSS
# -------------------------------
# Este selector busca:
# - div.thread: divs con clase "thread" 
# - > a:first-child: el primer enlace (a) hijo directo de cada div

tag_html_href <- "div.thread > a:first-child"

# PASO 4: EXTRAER LOS ELEMENTOS QUE COINCIDEN
# -------------------------------------------
# html_elements() busca todos los elementos que coinciden con el selector

elements_boards_pol <- html_elements(html_boards_pol, tag_html_href)

# PASO 5: EXTRAER LOS ATRIBUTOS HREF
# ----------------------------------
# html_attr() extrae el valor del atributo "href" de cada elemento
# Estos href contienen los enlaces relativos a cada hilo

links_boards_pol <- html_attr(elements_boards_pol, "href")

# Mostrar los enlaces extraídos

links_boards_pol

# VERSIÓN COMPACTA DEL CÓDIGO ANTERIOR
# ------------------------------------
# Todo el proceso anterior se puede hacer en una sola línea:

links_boards_pol <- html_attr(html_elements(read_html_live("https://boards.4chan.org/pol/catalog"), "div.thread > a:first-child"), "href")

# Mostrar los enlaces nuevamente

links_boards_pol

# PASO 6: CONSTRUIR URL COMPLETA Y ACCEDER A UN HILO ESPECÍFICO
# -------------------------------------------------------------
# Los enlaces extraídos son relativos (ej: /pol/thread/12345)
# Necesitamos agregar "https:" al inicio para formar la URL completa

link_4 <- paste0("https:", links_boards_pol[4])  # Seleccionar la 4ta url de hilos

# PASO 7: LEER EL HTML DEL HILO ESPECÍFICO
# ----------------------------------------

html_boards_pol_hilo <- read_html_live(link_4)

# PASO 8: EXTRAER EL CONTENIDO DE LOS MENSAJES
# --------------------------------------------
# Selector para los mensajes: blockquote con clase "postMessage"

tag_message <- "blockquote.postMessage"

# Extraer todos los elementos que contienen mensajes

element_post <- html_elements(html_boards_pol_hilo, tag_message)

# Convertir el HTML a texto plano

text_post <- html_text(element_post)

# Mostrar el texto extraído

text_post

# VERSIÓN COMPACTA PARA EXTRAER MENSAJES
# --------------------------------------
# Ejemplo usando una URL específica de hilo
text_post <- html_text(html_elements(read_html_live("https://boards.4chan.org/pol/thread/508525729"), "blockquote.postMessage"))

# =====================================
# -----------CONCEPTOS CLAVE-----------
# =====================================

# 1. SELECTORES CSS:
#    - "div.thread" = div con clase "thread"
#    - ">" = hijo directo
#    - ":first-child" = primer elemento hijo
#    - "blockquote.postMessage" = blockquote con clase "postMessage"

# 2. FUNCIONES PRINCIPALES:
#    - read_html_live(): Lee HTML de páginas dinámicas
#    - html_elements(): Busca elementos usando selectores CSS
#    - html_attr(): Extrae atributos de elementos HTML
#    - html_text(): Convierte contenido HTML a texto plano

# 3. FLUJO DE TRABAJO:
#    a) Definir URL objetivo
#    b) Leer el HTML de la página
#    c) Identificar selectores CSS apropiados
#    d) Extraer elementos
#    e) Extraer datos específicos (atributos, texto, etc.)

# 4. BUENAS PRÁCTICAS:
#    - Inspeccionar la página web para identificar selectores
#    - Usar read_html_live() para sitios con JavaScript
#    - Manejar URLs relativas vs absolutas
#    - Considerar términos de uso y robots.txt del sitio

# =====================================
# -----------ROBOTS.TXT DE 4CHAN--------
# =====================================

# El archivo robots.txt de 4chan (https://boards.4chan.org/robots.txt) contiene lo siguiente:

# User-agent: *
# Disallow: /*?mode=*$
# 
# Sitemap: https://boards.4chan.org/sitemap.xml

# ¿Qué significa esto?
# - User-agent: * indica que la regla aplica a todos los bots.
# - Disallow: /*?mode=* bloquea a los bots de rastrear cualquier URL que contenga "?mode=" 
# (por ejemplo, https://boards.4chan.org/pol/thread/12345?mode=archive).
# - Sitemap: especifica la ubicación del sitemap para facilitar la indexación de las URLs permitidas.

# En resumen: El robots.txt de 4chan permite el acceso general a los hilos y catálogos, pero restringe 
# URLs con el parámetro "?mode=". Siempre es recomendable revisar este archivo antes de realizar scraping 
# para respetar las restricciones del sitio.
