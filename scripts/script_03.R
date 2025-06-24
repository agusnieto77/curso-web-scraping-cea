# =====================================================
# -WEB SCRAPING MASIVO - MÚLTIPLES PÁGINAS DE NOTICIAS-
# =====================================================

# Cargar librería para web scraping

library(rvest)

# PASO 1: GENERAR URLs DE MÚLTIPLES PÁGINAS
# -----------------------------------------
# Crear un vector con URLs de las páginas 1 a 318 del sitio de noticias
# paste0() concatena strings sin espacios
# 1:318 genera una secuencia de números del 1 al 318

urls_noticias <- paste0("https://www.rivasciudad.es/noticias/?fwp_paged=", 1:318)

# PASO 2: SELECCIONAR UN SUBCONJUNTO PARA PRUEBAS
# -----------------------------------------------
# Para evitar sobrecargar el servidor y hacer pruebas, tomamos solo las primeras 5 páginas
# BUENA PRÁCTICA: Siempre probar con pocas páginas antes de hacer scraping masivo

sub_urls <- urls_noticias[1:5]

# PASO 3: INICIALIZAR VECTOR PARA ALMACENAR ENLACES
# -------------------------------------------------
# Crear un vector vacío que contendrá todos los enlaces a noticias individuales

links_noticias <- c()

# PASO 4: BUCLE PARA EXTRAER ENLACES DE CADA PÁGINA
# -------------------------------------------------
# Iterar sobre cada URL de página para extraer enlaces a noticias individuales

for (url in sub_urls) {
  
  # Leer el HTML de la página actual
  html <- read_html(url)
  
  # Imprimir la URL actual (útil para monitorear progreso y debugging)
  print(url)
  
  # Extraer enlaces de noticias de la página actual y agregarlos al vector principal
  # html_elements() encuentra todos los elementos que coinciden con el selector
  # html_attr() extrae el atributo "href" de cada elemento
  # append() agrega los nuevos enlaces al vector existente
  links_noticias <- append(
    links_noticias, 
    html_attr(html_elements(html, "div.m4p__img-buscador > a"), "href")
  )
  
  # Imprimir el número total de enlaces acumulados (útil para monitorear progreso)
  print(length(links_noticias))
}

# PASO 5: INICIALIZAR DATAFRAME PARA ALMACENAR DATOS DE NOTICIAS
# --------------------------------------------------------------
# Crear un tibble vacío que contendrá toda la información extraída de las noticias

notas_df <- tibble::tibble()

# PASO 6: BUCLE PARA EXTRAER CONTENIDO DE CADA NOTICIA INDIVIDUAL
# ---------------------------------------------------------------
# Iterar sobre cada enlace de noticia para extraer su contenido completo

for (link in links_noticias) {
  
  # Leer el HTML de la noticia individual
  html <- read_html(link)
  
  # Imprimir la URL actual (monitoreo de progreso)
  print(link)
  
  # Extraer información específica de la noticia y crear una fila nueva
  # rbind() combina el dataframe existente con la nueva fila
  notas_df <- rbind(notas_df, tibble::tibble(
    
    # Extraer título principal
    titulo = html_text(html_element(html, ".m4p-header-detail h1")),
    
    # Extraer subtítulo
    subtitulo = html_text(html_element(html, ".m4p-header-detail p")),
    
    # Extraer fecha en formato datetime (estructurada)
    fecha = html_attr(html_element(html, ".m4p-author_time > time"), "datetime"),
    
    # Extraer URL de la imagen principal
    url_imagen = html_attr(html_element(html, "figure > img"), "src"), 
    
    # Extraer contenido completo de la noticia
    nota = html_text(html_element(html, ".m4p-post-content")),
    
    # Guardar URL de la noticia original
    url = link
  ))
  
  # Imprimir el dataframe actual (útil para ver progreso, pero puede ser verboso)
  print(notas_df)
}

# PASO 7: DESCARGAR TODAS LAS IMÁGENES
# ------------------------------------
# Iterar sobre cada URL de imagen para descargarla localmente

for (img in notas_df$url_imagen) {
  
  # Descargar cada imagen
  # basename() extrae solo el nombre del archivo de la URL completa
  # mode="wb" especifica modo binario (necesario para archivos multimedia)
  download.file(
    url = img,
    destfile = paste0("inotas/", basename(img)),
    mode = "wb"
  )
}

# ==========================================
# -----------CONCEPTOS AVANZADOS------------
# ==========================================

# 1. SCRAPING A ESCALA:
#    - Generación automática de URLs con secuencias numéricas
#    - Uso de bucles para procesar múltiples páginas
#    - Acumulación progresiva de datos

# 2. ESTRUCTURAS DE CONTROL:
#    - for loops para iteración
#    - Uso de print() para monitoreo de progreso
#    - Construcción incremental de vectores y dataframes

# 3. FUNCIONES CLAVE:
#    - paste0(): concatenación de strings
#    - append(): agregar elementos a vectores
#    - rbind(): combinar dataframes por filas
#    - length(): obtener tamaño de vectores

# 4. MONITOREO Y DEBUGGING:
#    - print() para mostrar progreso
#    - Verificación de tamaños con length()
#    - Estrategia de "probar primero con pocos datos"

# ===============================================
# NOTA: Comentarios escritos por Claude Sonnet 4
# Modelo de IA desarrollado por Anthropic
# Fecha: Junio 2025
# ===============================================
