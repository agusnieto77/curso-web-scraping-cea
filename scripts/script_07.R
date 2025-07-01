# ==========================================
# ------WEB SCRAPING DE GOOGLE NEWS RSS------
# ==========================================

# Cargar librerías necesarias para web scraping de feeds RSS

library(xml2)       # Para trabajar con archivos XML/RSS
library(rvest)      # Para web scraping y manipulación de HTML
library(tidyverse)  # Suite completa para manipulación de datos

# PASO 1: CONFIGURAR PARÁMETROS DE BÚSQUEDA RSS
# ---------------------------------------------
# Google News RSS permite búsquedas específicas por términos

url_rss_base <- "https://news.google.com/rss/search?q="  # URL base del feed RSS de Google News
consulta <- "corrupción"                                 # Término de búsqueda (acepta cualquier palabra/frase)

# PASO 2: CONSTRUIR URL COMPLETA CON CODIFICACIÓN SEGURA
# ------------------------------------------------------
# URLencode() es CRÍTICO para manejar caracteres especiales en URLs
# Convierte espacios, acentos, ñ, etc. al formato web estándar

url <- URLencode(paste0(url_rss_base, consulta))

# TÉCNICA CLAVE: Doble codificación para máxima compatibilidad
# Primera codificación: al construir la URL
# Segunda codificación: al hacer la petición HTTP

# PASO 3: DESCARGAR Y PARSEAR EL FEED RSS XML
# -------------------------------------------
# read_xml() descarga el contenido RSS desde Google y lo convierte a estructura XML navegable

xlm <- read_xml(url)

# PASO 4: EXTRAER TODOS LOS ELEMENTOS DE NOTICIAS
# -----------------------------------------------
# xml_find_all() busca TODOS los elementos <item> en el feed RSS
# Cada <item> representa una noticia individual con sus metadatos
# ".//item" es XPath que significa: "buscar en cualquier nivel del documento"

items <- xml_find_all(xlm, ".//item")

# PASO 5: CREAR TABLA ESTRUCTURADA CON EXTRACCIÓN MASIVA DE DATOS
# ---------------------------------------------------------------
# tibble() crea un dataframe moderno con extracción simultánea de múltiples campos

df_xml <- tibble(
  
  # FECHA DE PUBLICACIÓN CON SELECTOR MÚLTIPLE
  # "pubDate|pubdate" usa operador OR en XPath
  # Algunos feeds RSS usan "pubDate", otros "pubdate" (variaciones estándar)
  
  fecha = xml_text(xml_find_first(items, "pubDate|pubdate")),
  
  # TÍTULO DE LA NOTICIA
  # xml_find_first() encuentra el PRIMER elemento <title> de cada item
  # xml_text() convierte el contenido XML a texto plano
  
  titulo = xml_text(xml_find_first(items, "title")),
  
  # DESCRIPCIÓN/RESUMEN CON PROCESAMIENTO COMPLEJO HTML→TEXTO
  # TÉCNICA AVANZADA: Extracción en múltiples etapas
  # 1. map_chr() aplica función a cada item individualmente (vectorización)
  # 2. ~ crea función anónima donde .x representa cada item
  # 3. xml_find_first(.x, "description") encuentra elemento <description>
  # 4. xml_text() extrae contenido (que viene como HTML embebido)
  # 5. read_html() parsea ese HTML a estructura navegable
  # 6. html_text() convierte HTML a texto plano limpio (elimina tags)
  
  descri = map_chr(items, ~ html_text(read_html(xml_text(xml_find_first(.x, "description"))))),
  
  # ENLACE DIRECTO A LA NOTICIA ORIGINAL
  # Google News RSS proporciona enlaces directos al artículo fuente
  
  link = xml_text(xml_find_first(items, "link")),
  
  # IDENTIFICADOR ÚNICO GLOBAL (GUID)
  # Cada noticia tiene un identificador único que persiste en el tiempo
  # Útil para evitar duplicados en scraping recurrente
  
  guid = xml_text(xml_find_first(items, "guid")),
  
  # NOMBRE DEL MEDIO DE COMUNICACIÓN FUENTE
  # Identifica qué periódico/portal publicó originalmente la noticia
  
  fuente = xml_text(xml_find_first(items, "source")),
  
  # URL DEL SITIO WEB DEL MEDIO
  # TÉCNICA ESPECÍFICA: Extracción de atributos XML
  # "source/@url" significa: "el atributo 'url' del elemento 'source'"
  # @ en XPath indica acceso a atributos en lugar de contenido de texto
  
  link_fuente = xml_text(xml_find_first(items, "source/@url"))
)

# PASO 6: MOSTRAR RESULTADO FINAL
# -------------------------------
# Visualizar el dataframe completo con todas las noticias estructuradas

df_xml

# ===============================================
# NOTA: Comentarios escritos por Claude Sonnet 4
# Modelo de IA desarrollado por Anthropic
# Fecha: Junio 2025 - Curso Web Scraping con R
# ===============================================
