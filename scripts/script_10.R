# ==========================================
# ------WEB SCRAPING DE GOOGLE NEWS------
# ==========================================

# Cargar librerías necesarias para web scraping directo de Google News

library(httr2)      # Para realizar peticiones HTTP modernas y configurar headers
library(rvest)      # Para web scraping y manipulación de HTML/CSS selectors
library(tidyverse)  # Suite completa para manipulación de datos

# PASO 1: CONFIGURAR URL DE BÚSQUEDA DE GOOGLE NEWS
# ------------------------------------------------
# Google News permite búsquedas directas con parámetros GET específicos

url <- "https://www.google.com/search?q=Milei&gl=es&tbm=nws&num=100"

# DESGLOSE DE PARÁMETROS URL:
# - q=Milei: término de búsqueda (acepta cualquier palabra/frase)
# - gl=es: geolocalización en español (afecta fuentes priorizadas)
# - tbm=nws: tipo de búsqueda = noticias (news)
# - num=100: número máximo de resultados a obtener

# PASO 2: CONFIGURAR HEADERS HTTP PARA SIMULAR NAVEGADOR REAL
# ----------------------------------------------------------
# TÉCNICA CRÍTICA: Anti-detección de bots mediante User-Agent spoofing
# Google puede bloquear peticiones que no parezcan de navegadores reales

encabezados <- list(
  "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.54 Safari/537.36",
  "Accept-Language" = "es-AR"  # Preferencia de idioma argentino
)

# PASO 3: REALIZAR PETICIÓN HTTP CON HEADERS PERSONALIZADOS
# --------------------------------------------------------
# httr2 ofrece sintaxis moderna para peticiones HTTP complejas
# TÉCNICA AVANZADA: Pipeline de petición en múltiples etapas

respuesta <- req_perform(req_headers(request(url), !!!encabezados))

# DESGLOSE DETALLADO DE LA PETICIÓN HTTP:
# =====================================

# ETAPA 1: request(url) - CREAR OBJETO DE PETICIÓN BASE
# ----------------------------------------------------
# request() NO ejecuta la petición, solo crea un "molde" o "plantilla"
# 
# ANALOGÍA: Es como preparar un sobre para enviar una carta:
# - Escribes la dirección de destino (URL)
# - Pero aún NO lo envías al correo
# 
# TÉCNICAMENTE:
# - Crea un objeto S3 de clase "httr2_request"
# - Almacena la URL de destino
# - Establece método HTTP por defecto (GET)
# - Prepara estructura para agregar más configuraciones
# 
# EJEMPLO EQUIVALENTE PASO A PASO:
# peticion_base <- request(url)
# class(peticion_base)  # "httr2_request"

# ETAPA 2: req_headers(..., !!!encabezados) - APLICAR HEADERS HTTP
# ---------------------------------------------------------------
# CONCEPTO DE HEADERS HTTP:
# Los headers son metadatos que acompañan la petición HTTP
# Le dicen al servidor web información adicional sobre:
# - Qué navegador estamos usando (User-Agent)
# - Qué idiomas aceptamos (Accept-Language)
# - Cómo queremos recibir la respuesta (Accept)
# - Cookies de autenticación, etc.
# 
# OPERADOR SPLATTING (!!! - Triple Bang):
# ======================================
# El operador !!! es una característica avanzada de R (tidyverse)
# que "desempaca" o "expande" una lista en argumentos individuales
# 
# SIN splatting operator (NO funciona):
# req_headers(peticion_base, encabezados)
# # Esto pasaría UNA lista como UN solo argumento
# 
# CON splatting operator (CORRECTO):
# req_headers(peticion_base, !!!encabezados)
# # Esto expande la lista en argumentos separados
# 
# EQUIVALENCIA MANUAL:
# Lo que hace internamente !!!encabezados es convertir esto:
# encabezados <- list("User-Agent" = "Mozilla/5.0...", "Accept-Language" = "es-AR")
# 
# En esto:
# req_headers(peticion_base, 
#            "User-Agent" = "Mozilla/5.0...", 
#            "Accept-Language" = "es-AR")
# 
# EJEMPLO VISUAL DEL SPLATTING:
# lista <- list(a = 1, b = 2, c = 3)
# funcion(lista)       # Pasa 1 argumento (la lista completa)
# funcion(!!!lista)    # Pasa 3 argumentos separados (a=1, b=2, c=3)

# ETAPA 3: req_perform() - EJECUTAR LA PETICIÓN HTTP
# ------------------------------------------------
# req_perform() es donde REALMENTE ocurre la magia:
# 
# PROCESO INTERNO:
# 1. Toma el objeto de petición configurado
# 2. Abre conexión TCP/IP con el servidor (www.google.com)
# 3. Envía petición HTTP GET con headers incluidos
# 4. Espera respuesta del servidor
# 5. Recibe respuesta completa (headers + body HTML)
# 6. Cierra conexión
# 7. Devuelve objeto "httr2_response" con toda la información
# 
# ANALOGÍA COMPLETA DEL CORREO:
# - request(url): Preparar sobre con dirección
# - req_headers(): Agregar sellos y etiquetas especiales
# - req_perform(): ENVIAR la carta y esperar respuesta
# 
# ESTRUCTURA DE LA RESPUESTA:
# El objeto "respuesta" contiene:
# - Status code (200 = OK, 404 = No encontrado, etc.)
# - Headers de respuesta del servidor
# - Body HTML completo de la página
# - Metadatos de timing, cookies, etc.

# VERSIÓN EXPANDIDA PARA APRENDIZAJE:
# ==================================
# Si quisieras ver cada paso por separado:
# 
# paso1 <- request(url)                    # Crear petición base
# paso2 <- req_headers(paso1, !!!encabezados)  # Agregar headers
# paso3 <- req_perform(paso2)              # Ejecutar petición
# 
# # El resultado final es idéntico a:
# # respuesta <- req_perform(req_headers(request(url), !!!encabezados))

# VENTAJAS DEL PIPELINE httr2:
# ===========================
# 1. LEGIBILIDAD: Se lee de izquierda a derecha como una receta
# 2. MODULARIDAD: Cada función tiene una responsabilidad específica
# 3. REUTILIZACIÓN: Puedes guardar peticiones parcialmente configuradas
# 4. DEBUGGING: Fácil aislar problemas en cada etapa
# 5. EXTENSIBILIDAD: Fácil agregar autenticación, timeouts, etc.

# PASO 4: PARSEAR RESPUESTA HTML
# ------------------------------
# Convertir respuesta HTTP cruda a estructura HTML navegable

html <- read_html(resp_body_string(respuesta))

# resp_body_string() extrae el contenido HTML como texto plano
# read_html() parsea el HTML a estructura DOM manipulable

# PASO 5: EXTRAER ELEMENTOS DE NOTICIAS CON SELECTOR CSS
# -----------------------------------------------------
# TÉCNICA ESPECÍFICA: Ingeniería inversa de selectores CSS de Google
# ".SoaBEf" es la clase CSS que Google usa para contenedores de noticias

noticias <- html_elements(html, ".SoaBEf")

# PASO 6: CREAR DATAFRAME CON EXTRACCIÓN MASIVA DE METADATOS
# ---------------------------------------------------------
# tibble() con extracción simultánea de múltiples campos por noticia

df_google <- tibble(
  
  # FECHA DE PUBLICACIÓN CON CONVERSIÓN DE TIMESTAMP
  # TÉCNICA COMPLEJA: Extracción de atributos de datos embebidos
  # 1. map_chr() vectoriza operación sobre cada elemento noticia
  # 2. html_element(.x, "span[data-ts]") encuentra span con atributo data-ts
  # 3. html_attr(..., "data-ts") extrae valor del atributo (timestamp Unix)
  # 4. as.numeric() convierte string a número
  # 5. as_datetime() convierte timestamp Unix a fecha legible
  
  fecha = as_datetime(as.numeric(map_chr(noticias, ~ html_attr(html_element(.x, "span[data-ts]"), "data-ts")))),
  
  # EDITORIAL/TIEMPO RELATIVO DE PUBLICACIÓN
  # Texto visible que muestra "hace X horas" o nombre del medio
  
  edit = map_chr(noticias, ~ html_text(html_element(.x, "span[data-ts]"))),
  
  # TÍTULO DE LA NOTICIA
  # ".MBeuO" es la clase CSS específica de Google para títulos de noticias
  
  titulo = map_chr(noticias, ~ html_text(html_element(.x, ".MBeuO"))),
  
  # FRAGMENTO/RESUMEN DE LA NOTICIA
  # ".GI74Re" contiene el snippet o descripción breve de la noticia
  
  frag = map_chr(noticias, ~ html_text(html_element(.x, ".GI74Re"))),
  
  # IMAGEN ASOCIADA A LA NOTICIA
  # TÉCNICA: Extracción de atributos de elementos multimedia
  # html_attr(..., "src") obtiene la URL de la imagen
  
  imagen = map_chr(noticias, ~ html_attr(html_element(.x, "img"), "src")),
  
  # ENLACE DIRECTO A LA NOTICIA ORIGINAL
  # Extrae href del primer enlace en cada contenedor de noticia
  
  link = map_chr(noticias, ~ html_attr(html_element(.x, "a"), "href")),
  
  # NOMBRE DE LA FUENTE/MEDIO DE COMUNICACIÓN
  # ".NUnG9d span" es selector anidado específico para fuentes
  
  fuente = map_chr(noticias, ~ html_text(html_element(.x, ".NUnG9d span"))),
  
  # METADATOS DE SCRAPING
  # Campos adicionales para auditoría y control de calidad
  
  url = url,           # URL original de la búsqueda
  captura = Sys.time() # Timestamp de cuándo se realizó el scraping
)

# PASO 7: INSPECCIONAR RESULTADO INICIAL
# --------------------------------------
# glimpse() muestra estructura compacta del dataframe

glimpse(df_google)

# PASO 8: VERIFICAR CALIDAD DE EXTRACCIÓN
# ---------------------------------------
# Mostrar primera imagen para validar extracción correcta

df_google$imagen[1]

# ==========================================
# ------MÉTODO ALTERNATIVO: SCRAPING LIVE------
# ==========================================

# PASO 9: SCRAPING DINÁMICO CON RENDERIZADO JAVASCRIPT
# ---------------------------------------------------
# TÉCNICA AVANZADA: Para contenido generado dinámicamente por JavaScript
# read_html_live() simula navegador completo con motor JavaScript

html_live <- read_html_live(url)

# PASO 10: EXTRACCIÓN IDÉNTICA CON OBJETO LIVE
# -------------------------------------------
# Misma lógica de extracción pero sobre contenido renderizado dinámicamente

noticias_live <- html_elements(html_live, ".SoaBEf")

# PASO 11: CREAR SEGUNDO DATAFRAME PARA COMPARACIÓN
# ------------------------------------------------
# Estructura idéntica para comparar resultados entre métodos

df_google_live <- tibble(
  fecha   = as_datetime(as.numeric(map_chr(noticias_live, ~ html_attr(html_element(.x, "span[data-ts]"), "data-ts")))),
  edit    = map_chr(noticias_live, ~ html_text(html_element(.x, "span[data-ts]"))),
  titulo  = map_chr(noticias_live, ~ html_text(html_element(.x, ".MBeuO"))),
  frag    = map_chr(noticias_live, ~ html_text(html_element(.x, ".GI74Re"))),
  imagen  = map_chr(noticias_live, ~ html_attr(html_element(.x, "img"), "src")),
  link    = map_chr(noticias_live, ~ html_attr(html_element(.x, "a"), "href")),
  fuente  = map_chr(noticias_live, ~ html_text(html_element(.x, ".NUnG9d span"))),
  url = url,
  captura = Sys.time()
)

# PASO 12: COMPARAR RESULTADOS ENTRE MÉTODOS
# -----------------------------------------
# Verificar diferencias entre scraping estático vs dinámico

glimpse(df_google_live)

# PASO 13: VALIDACIÓN FINAL DE EXTRACCIÓN
# ---------------------------------------
# Comparar calidad de imágenes entre ambos métodos

df_google_live$imagen[1]

# ===============================================
# DIFERENCIAS CLAVE ENTRE MÉTODOS:
# 
# MÉTODO ESTÁTICO (httr2 + rvest):
# - Más rápido y eficiente en recursos
# - Funciona con contenido HTML estático
# - Requiere headers anti-detección
# - Ideal para sitios con contenido pre-renderizado
# 
# MÉTODO DINÁMICO (read_html_live):
# - Más lento pero más completo
# - Ejecuta JavaScript y carga contenido dinámico
# - Simula navegador real completo
# - Ideal para SPAs y contenido generado por JS
# 
# RECOMENDACIÓN: Usar método estático primero,
# método dinámico como fallback si falla extracción
# ===============================================

# ===============================================
# NOTA: Comentarios escritos por Claude Sonnet 4
# Modelo de IA desarrollado por Anthropic
# Fecha: Julio 2025 - Curso Web Scraping con R
# ===============================================
