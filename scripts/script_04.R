# ===========================================================
# WEB SCRAPING DE BOOKING.COM - ANÁLISIS DE PRECIOS HOTELEROS
# ===========================================================

# Cargar librerías necesarias

library(rvest)     # Para web scraping
library(dplyr)     # Para manipulación de datos
library(stringr)   # Para manipulación de strings/texto

# PASO 1: DEFINIR PARÁMETROS DE BÚSQUEDA
# --------------------------------------
# Definir las variables de búsqueda como si fuera un formulario web

ingreso <- "2025-08-28"    # Fecha de check-in (formato YYYY-MM-DD)
egreso <- "2025-08-30"     # Fecha de check-out (formato YYYY-MM-DD)
adultos <- 1               # Número de adultos
ninos <- 0                 # Número de niños
moneda <- "EUR"            # Moneda para mostrar precios
hotel <- "hostal-central-palace-madrid.es"  # Identificador específico del hotel en Booking

# PASO 2: CONSTRUIR LA URL COMPLEJA DE BOOKING.COM
# ------------------------------------------------
# Booking.com utiliza URLs muy largas con múltiples parámetros
# paste0() concatena todos los elementos sin espacios para formar la URL completa

url <- paste0("https://www.booking.com/hotel/es/", 
              hotel, 
              ".html?aid=2369661&label=msn-yfgP0XnN9y0nVn6Sx32PmQ-79989658705812%3Atikwd-79989834229482%3Aaud-811122080%3Aloc-170%3Aneo%3Amte%3Alp164493%3Adec%3Aqsbooking&sid=73fa6d0e4c0a34b807e0ad08132c404e&all_sr_blocks=36374811_371091600_0_2_0&checkin=", 
              ingreso, 
              "&checkout=", 
              egreso, 
              "&dest_id=363748&dest_type=hotel&dist=0&group_adults=",
              adultos,
              "&group_children=0&hapos=1&highlighted_blocks=36374811_371091600_0_2_0&hpos=1&matching_block_id=36374811_371091600_0_2_0&no_rooms=1&req_adults=", 
              adultos, 
              "&req_children=",
              ninos, 
              "&room1=A%2CA&sb_price_type=total&sr_order=popularity&sr_pri_blocks=36374811_371091600_0_2_0__70030&srepoch=1747701518&srpvid=7b4f0472f1090600&type=total&ucfs=1&selected_currency=", 
              moneda)

# PASO 3: LEER EL HTML DE LA PÁGINA
# ---------------------------------
# Obtener el contenido HTML de la página con todos los parámetros especificados

html <- read_html(url)

# PASO 4: EXTRAER DATOS Y CREAR TABLA ESTRUCTURADA
# ------------------------------------------------
# Crear un tibble con información específica de la oferta hotelera
# Cada campo utiliza selectores CSS específicos para extraer información precisa

tabla_hoteles <- tibble(
  # Información de contexto y metadatos
  fecha_captura = Sys.time(),        # Timestamp de cuando se capturó la data
  establecimiento = hotel,           # Nombre del hotel
  fecha_in = ingreso,               # Fecha de entrada
  fecha_out = egreso,               # Fecha de salida
  adultos = adultos,                # Número de adultos
  ninos = ninos,                    # Número de niños
  
  # Información específica extraída del HTML
  # html_text2() es más robusto que html_text() para manejar espacios y formato
  tipologia = html_text2(html_elements(html, "span.hprt-roomtype-icon-link")),
  
  moneda = moneda,                  # Moneda de referencia
  
  # Precios (antes y después de descuentos)
  precio_base = html_text2(html_elements(html, "div.bui-f-color-destructive.js-strikethrough-price.prco-inline-block-maker-helper.bui-price-display__original")),
  precio_final = html_text2(html_elements(html, "span.prco-valign-middle-helper")),
  
  # Información de ofertas especiales
  oferta = html_text2(html_elements(html, "div.c-deals-container > div > div:nth-child(2) > span > span > span")),
  
  # Información de disponibilidad/urgencia
  disponibilidad = html_text2(html_elements(html, "li.bui-list_item.bui-text--color-destructive-dark div.bui-list_description, li.bui-list__item.bui-text--color-destructive-dark > div.bui-list__body > div.bui-list__description"))
)

# PASO 5: LIMPIAR Y TRANSFORMAR LOS DATOS EXTRAÍDOS
# -------------------------------------------------
# Los datos extraídos del HTML necesitan limpieza para ser utilizables

tabla_hoteles <- mutate(
  tabla_hoteles, 
  
  # Limpiar precio base:
  # 1. str_remove_all(precio_base, "€\\s?"): elimina el símbolo € seguido de espacio opcional
  # 2. str_replace_all(..., "\\.", ""): elimina puntos (separadores de miles en Europa)
  # 3. as.numeric(): convierte a número
  precio_base = as.numeric(str_replace_all(str_remove_all(precio_base, "€\\s?"), "\\.", "")), 
  
  # Limpiar precio final con el mismo proceso
  precio_final = as.numeric(str_replace_all(str_remove_all(precio_final, "€\\s?"), "\\.", "")),
  
  fecha_in = as.Date(fecha_in), 
  
  fecha_out = as.Date(fecha_out),
  
  # Extraer solo el número de la información de disponibilidad
  # str_extract(disponibilidad, "\\d+"): extrae el primer número encontrado
  disponibilidad = as.numeric(str_extract(disponibilidad, "\\d+"))
)

# Mostrar la tabla final con datos limpios
tabla_hoteles

# ==========================================
# -------CONCEPTOS TÉCNICOS AVANZADOS-------
# ==========================================

# 1. CONSTRUCCIÓN DE URLs COMPLEJAS:
#    - Booking.com usa URLs muy largas con múltiples parámetros
#    - Cada parámetro tiene un propósito específico (fechas, huéspedes, moneda, etc.)
#    - paste0() permite construir URLs dinámicamente

# 2. SELECTORES CSS COMPLEJOS:
#    - Clases CSS específicas de Booking: "hprt-roomtype-icon-link", "bui-f-color-destructive"
#    - Selectores anidados: "div > div:nth-child(2) > span > span > span"
#    - Múltiples selectores separados por coma para mayor robustez

# 3. LIMPIEZA DE DATOS CON REGEX:
#    - "€\\s?": símbolo euro seguido de espacio opcional
#    - "\\.": punto literal (escapado porque . tiene significado especial en regex)
#    - "\\d+": uno o más dígitos consecutivos

# 4. TRANSFORMACIÓN DE TIPOS DE DATOS:
#    - Conversión de strings a números con as.numeric()
#    - Extracción de números específicos de texto mixto
#    - Preservación de metadatos (fechas, timestamps)

# ===============================================
# NOTA: Comentarios escritos por Claude Sonnet 4
# Modelo de IA desarrollado por Anthropic
# Fecha: Junio 2025
# ===============================================
