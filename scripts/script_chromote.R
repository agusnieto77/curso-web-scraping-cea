# ==========================================
# WEB SCRAPING CON CHROMOTE - AUTOMATIZACIÓN DE NAVEGADOR
# ==========================================

# Cargar librerías necesarias

library(chromote)  # Para automatización de navegador (Chrome/Chromium)
library(rvest)     # Para parsing de HTML

# ==========================================
# PARTE 1: NAVEGACIÓN Y CAPTURA DE PANTALLA
# ==========================================

# PASO 1: CREAR UNA NUEVA SESIÓN DE NAVEGADOR
# -------------------------------------------
# ChromoteSession$new() inicia una nueva instancia de Chrome/Chromium
# Esto abre un navegador real que puede ejecutar JavaScript

b <- ChromoteSession$new()

# PASO 2: ABRIR LA INTERFAZ VISUAL (OPCIONAL)
# -------------------------------------------
# b$view() abre una ventana donde puedes ver el navegador en acción
# Útil para debugging y desarrollo, pero no necesario para scraping automatizado

b$view()

# PASO 3: NAVEGAR A DIFERENTES PÁGINAS WEB
# ----------------------------------------
# Navegar a la primera página usando el método directo

b$go_to("https://testthat.r-lib.org/")

# Navegar usando el protocolo Chrome DevTools (método alternativo)
# $Page$navigate() es más específico y permite más control

b$Page$navigate("https://rstudio.github.io/chromote/index.html")

# Navegar a otra página

b$Page$navigate("https://rstudio.github.io/shinytest2/index.html")

# PASO 4: RECARGAR LA PÁGINA ACTUAL
# ---------------------------------
# Equivalente a presionar F5 o el botón de recarga

b$Page$reload()

# PASO 5: CAPTURAR PANTALLAS
# --------------------------
# Tomar screenshot en formato PNG
# Útil para documentación, debugging o análisis visual

b$screenshot("page1.png")

# Tomar screenshot en formato PDF
# Captura toda la página, incluso lo que no es visible en pantalla

b$screenshot_pdf("page1.pdf")

# PASO 6: CERRAR LA SESIÓN DEL NAVEGADOR
# --------------------------------------
# Importante para liberar recursos del sistema

b$close()

# ==========================================
# PARTE 2: EXTRACCIÓN DE CONTENIDO HTML
# ==========================================

# PASO 7: CREAR NUEVA SESIÓN PARA SCRAPING
# ----------------------------------------

b <- ChromoteSession$new()

# PASO 8: NAVEGAR A LA PÁGINA OBJETIVO
# ------------------------------------

b$go_to(url = "https://rstudio.github.io/chromote/index.html")

# PASO 9: OBTENER EL DOCUMENTO HTML COMPLETO
# ------------------------------------------
# $DOM$getDocument() obtiene la representación del DOM (Document Object Model)
# Esto incluye todo el HTML después de que JavaScript se haya ejecutado

html <- b$DOM$getDocument()

# PASO 10: EXTRAER EL HTML COMO STRING
# ------------------------------------
# $DOM$getOuterHTML() convierte el DOM a texto HTML
# nodeId = html$root$nodeId especifica que queremos todo el documento (desde la raíz)
# $outerHTML accede al contenido HTML como string

html_content <- b$DOM$getOuterHTML(nodeId = html$root$nodeId)$outerHTML

# PASO 11: CERRAR LA SESIÓN
# -------------------------

b$close()

# PASO 12: PROCESAR EL HTML CON RVEST
# -----------------------------------
# Ahora que tenemos el HTML como string, podemos usar rvest normalmente
# read_html() parsea el string HTML a un objeto xml_document

pagina <- read_html(html_content)

# PASO 13: EXTRAER CONTENIDO ESPECÍFICO
# -------------------------------------
# html_element() encuentra el primer elemento <p>
# html_text() extrae el texto sin etiquetas HTML

pagina %>% html_element("p") %>% html_text()

# ==========================================
# CONCEPTOS TÉCNICOS FUNDAMENTALES:
# ==========================================

# 1. DIFERENCIAS CON read_html() TRADICIONAL:
#    - read_html(): obtiene HTML estático, sin ejecutar JavaScript
#    - chromote: ejecuta JavaScript, obtiene HTML dinámico (DOM final)
#    - chromote puede interactuar con elementos (clicks, formularios, etc.)

# 2. CHROME DEVTOOLS PROTOCOL:
#    - chromote usa el protocolo de Chrome DevTools
#    - Permite control completo del navegador
#    - Acceso a funciones avanzadas: DOM, Network, Performance, etc.

# 3. MÉTODOS DE NAVEGACIÓN:
#    - $go_to(): método directo y simple
#    - $Page$navigate(): más control, parte del protocolo DevTools
#    - $Page$reload(): recarga la página actual

# 4. GESTIÓN DE SESIONES:
#    - Cada ChromoteSession es una instancia independiente del navegador
#    - Importante cerrar sesiones para liberar memoria
#    - Puede mantener cookies, localStorage, etc. durante la sesión

# ===============================================
# NOTA: Comentarios escritos por Claude Sonnet 4
# Modelo de IA desarrollado por Anthropic
# Fecha: Junio 2025
# ===============================================

