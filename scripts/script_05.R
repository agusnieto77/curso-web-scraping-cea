# ==========================================
# ----------WEB SCRAPING DE AIRBNB----------
# ==========================================

# Cargar librería para web scraping

library(rvest)

# PASO 1: DEFINIR PARÁMETROS DE BÚSQUEDA
# --------------------------------------
# Configurar los criterios de búsqueda como variables

lugar <- "Punta-Umbr%C3%ADa--Huelva--Espa%C3%B1a"  # Lugar codificado en URL (con %C3%AD = í, %C3%B1 = ñ)
checkin <- "2025-07-21"      # Fecha de entrada (formato YYYY-MM-DD)
checkout <- "2025-07-26"     # Fecha de salida (formato YYYY-MM-DD)
adultos <- 1                 # Número de adultos

# PASO 2: CONSTRUIR LA URL COMPLEJA DE AIRBNB
# -------------------------------------------
# Airbnb utiliza URLs muy específicas con múltiples parámetros de filtro

url <- paste0("https://www.airbnb.com.ar/s/", 
              lugar, 
              "/homes?refinement_paths%5B%5D=%2Fhomes&place_id=ChIJ3SC2WNXQEQ0RpTb9gnjUwnk&location_bb=QhUInMDeUFJCFKfhwOKUpQ%3D%3D&acp_id=98d025a8-89ca-4653-8036-692edf9d11e0&date_picker_type=calendar&checkin=",
              checkin,
              "&checkout=",
              checkout,
              "&flexible_date_search_filter_type=0&adults=",
              adultos,
              "&source=structured_search_input_header&search_type=autocomplete_click") 

# PASO 3: DEFINIR SELECTORES XPATH Y CSS
# --------------------------------------
# XPath para el contenedor principal que incluye todos los listados
# Este XPath apunta al contenedor general donde están todos los alojamientos

todo <- '//*[@id="site-content"]/div/div[2]/div/div/div/div/div/div/div/div[2]/div/div/div/div/div'

# Leer HTML usando read_html_live() para sitios con JavaScript dinámico
# Airbnb carga contenido dinámicamente, por lo que necesitamos la versión "live"

html <- read_html_live(url)

# PASO 4: DEFINIR SELECTORES CSS ESPECÍFICOS PARA CADA ELEMENTO
# -------------------------------------------------------------
# Airbnb usa clases CSS extremadamente específicas y largas
# Estos selectores pueden cambiar frecuentemente

# Selector para precios (incluye múltiples variantes por si cambian las clases)

precio <- "span.umg93v9.atm_7l_rb934l.atm_cs_1peztlj.atm_rd_14k51in.atm_cs_kyjlp1__1v156lz.dir.dir-ltr, span.umuerxh.atm_7l_dezgoh.atm_rd_us8791.atm_cs_1529pqs__oggzyc.atm_cs_kyjlp1__1v156lz.dir.dir-ltr"

# Selector para imágenes principales

img <- "img.i1ezuexe.atm_e2_idpfg4.atm_vy_idpfg4.atm_mk_stnw88.atm_e2_1osqo2v__1lzdix4.atm_vy_1osqo2v__1lzdix4.i1wndum8.atm_jp_pyzg9w.atm_jr_nyqth1.i16t4q3z.atm_vh_yfq0k3.dir.dir-ltr"

# Selector para tipo de alojamiento (casa completa, habitación privada, etc.)

tipo <- "div.t1jojoys.atm_g3_1kw7nm4.atm_ks_15vqwwr.atm_sq_1l2sidv.atm_9s_cj1kg8.atm_6w_1e54zos.atm_fy_1vgr820.atm_7l_jt7fhx.atm_cs_10d11i2.atm_ks_zryt35__1rgatj2.dir.dir-ltr"

# Selector para valoraciones/puntuación

valoracion <- "div.t1a9j9y7.atm_da_1ko3t4y.atm_dm_kb7nvz.atm_fg_h9n0ih.dir.dir-ltr > span > span:nth-child(3)"

# PASO 5: CREAR TABLA BASE CON INFORMACIÓN GENERAL
# ------------------------------------------------
# Crear un tibble inicial con los parámetros de búsqueda y campos vacíos para los datos específicos

tabla_airbnb_huelva <- tibble::tibble(
  
  # Metadatos de la búsqueda
  
  lugar = lugar,
  checkin = checkin,
  checkout = checkout,
  adultos = adultos,
  
  # Campos que se llenarán posteriormente
  
  precio = NA,
  tipo = NA,
  valoracion = NA,
  imagen = NA,
  
  # Extraer texto completo de cada listado para debugging/referencia
  
  texto = html_text(html_elements(html, xpath = todo)),
  
  # TÉCNICA AVANZADA: Guardar el HTML de cada listado individual como string
  # as.character() convierte los elementos HTML a texto para procesamiento posterior
  
  xlm = as.character(html_elements(html, xpath = todo))
)

# PASO 6: BUCLE PARA EXTRAER INFORMACIÓN ESPECÍFICA DE CADA LISTADO
# -----------------------------------------------------------------
# Iterar sobre cada elemento HTML guardado para extraer datos específicos

for (i in 1:length(tabla_airbnb_huelva$xlm)) {
  
  # TÉCNICA CLAVE: Parsear cada fragmento HTML individual
  # read_html() puede procesar strings HTML directamente
  
  html_individual <- read_html(tabla_airbnb_huelva$xlm[i])
  
  # Extraer precio del listado individual
  
  tabla_airbnb_huelva$precio[i] <- html_text(html_elements(html_individual, precio))
  
  # Extraer tipo de alojamiento
  
  tabla_airbnb_huelva$tipo[i] <- html_text(html_elements(html_individual, tipo))
  
  # Extraer valoración con manejo de casos donde no existe
  # ifelse() maneja el caso donde algunos listados no tienen valoración
  # length() == 0 verifica si el selector no encontró ningún elemento
  
  valoracion_extraida <- html_text(html_elements(html_individual, valoracion))
  tabla_airbnb_huelva$valoracion[i] <- ifelse(
    length(valoracion_extraida) == 0, 
    NA, 
    valoracion_extraida
  )
  
  # Extraer URL de imagen usando el atributo "data-original-uri"
  # Airbnb usa lazy loading, por lo que la imagen real está en este atributo específico
  
  tabla_airbnb_huelva$imagen[i] <- html_attr(html_elements(html_individual, img), "data-original-uri")
}

# Mostrar la tabla final con todos los datos extraídos

tabla_airbnb_huelva

# ==========================================
# -------CONCEPTOS TÉCNICOS AVANZADOS-------
# ==========================================

# 1. XPATH VS CSS SELECTORS:
#    - XPath: '//*[@id="site-content"]/div/div[2]/...' (ruta absoluta en DOM)
#    - CSS: 'span.clase1.clase2' (selección por clases)
#    - XPath es más preciso pero más frágil a cambios

# 2. PROCESAMIENTO DE HTML EN DOS ETAPAS:
#    - Primera etapa: extraer contenedores principales con XPath
#    - Segunda etapa: procesar cada contenedor individualmente con CSS
#    - Permite mayor precisión y control de errores

# 3. MANEJO DE CONTENIDO DINÁMICO:
#    - read_html_live() para JavaScript
#    - read_html() para fragmentos HTML estáticos
#    - Combinación de ambas técnicas según necesidad

# 4. CLASES CSS GENERADAS AUTOMÁTICAMENTE:
#    - "atm_7l_rb934l": clases generadas por sistemas de CSS-in-JS
#    - Muy específicas pero propensas a cambiar
#    - Usar múltiples selectores separados por coma para robustez

# ===============================================
# NOTA: Comentarios escritos por Claude Sonnet 4
# Modelo de IA desarrollado por Anthropic
# Fecha: Junio 2025
# ===============================================
