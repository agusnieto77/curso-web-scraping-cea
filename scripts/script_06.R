# ==========================================
# WEB SCRAPING DE PRECIOS DE ACEITE DE OLIVA
# Consejo Oleícola Internacional (IOC)
# ==========================================

# Cargar librería para web scraping

library(rvest)

# PASO 1: DEFINIR LA URL DE LA PÁGINA PRINCIPAL
# ---------------------------------------------
# URL del Consejo Oleícola Internacional que contiene enlaces a datos de precios
# El fragmento "#prices" indica que queremos ir directamente a la sección de precios

url <- "https://www.internationaloliveoil.org/que-hacemos/unidad-de-asuntos-econonicos-y-promocion/?lang=es#prices"

# PASO 2: LEER EL HTML DE LA PÁGINA PRINCIPAL
# -------------------------------------------
# Obtener el contenido HTML de la página principal

html <- read_html(url)

# PASO 3: EXTRAER ENLACES USANDO XPATH
# ------------------------------------
# XPATH vs CSS Selectors:
# - XPATH: lenguaje de consulta XML más potente y específico
# - CSS Selectors: más simple pero menos preciso en algunos casos
# 
# Este XPATH específico navega por:
# - //*[@id="et_builder_outer_content"]: elemento con ID específico
# - /div/div/div/div/div[2]: navegación por estructura de divs anidados
# - /div[9]/div[2]/div/div/div/a: llegar hasta los enlaces (a) finales

links <- html_attr(
  html_elements(html, xpath = '//*[@id="et_builder_outer_content"]/div/div/div/div/div[2]/div[9]/div[2]/div/div/div/a'), 
  "href"
)

# PASO 4: ACCEDER A UN ENLACE ESPECÍFICO CON CONTENIDO DINÁMICO
# -------------------------------------------------------------
# Seleccionar el 5º enlace de la lista (links[5])
# read_html_live() se usa porque la página puede tener contenido generado por JavaScript
# Es más lento que read_html() pero más confiable para sitios modernos

html_tablas <- read_html_live(links[5])

# PASO 5: EXTRAER TODAS LAS TABLAS DE LA PÁGINA
# ---------------------------------------------
# html_table() es una función especializada que:
# 1. Busca elementos <table> en el HTML
# 2. Convierte automáticamente el HTML de tabla a data.frame/tibble
# 3. Maneja headers, filas y columnas automáticamente
# 
# html_elements(html_tablas, "table") encuentra todos los elementos <table>
# html_table() convierte cada tabla a un data.frame
# El resultado es una lista de data.frames (una por cada tabla encontrada)

tablas <- html_table(html_elements(html_tablas, "table"))

# Mostrar las tablas extraídas

tablas

# ==========================================
# ---------CONCEPTOS TÉCNICOS CLAVE---------
# ==========================================

# 1. XPATH vs CSS SELECTORS:
#    CSS Selector equivalente (aproximado):
#    "#et_builder_outer_content > div > div > div > div > div:nth-child(2) > div:nth-child(9) > div:nth-child(2) > div > div > div > a"
#    
#    Ventajas de XPath:
#    - Más expresivo para navegación compleja
#    - Permite condiciones más específicas
#    - Mejor para elementos con atributos específicos
#    
#    Desventajas de XPath:
#    - Más frágil ante cambios en la estructura
#    - Sintaxis más compleja
#    - Menos intuitivo para principiantes

# 2. EXTRACCIÓN DE TABLAS HTML:
#    html_table() automáticamente:
#    - Identifica headers (<th>) y los usa como nombres de columnas
#    - Convierte filas (<tr>) en observaciones
#    - Maneja colspan y rowspan básicos
#    - Devuelve data.frames listos para análisis

# ===============================================
# NOTA: Comentarios escritos por Claude Sonnet 4
# Modelo de IA desarrollado por Anthropic
# Fecha: Junio 2025
# ===============================================