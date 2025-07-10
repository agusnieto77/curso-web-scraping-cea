library(tidyverse)

tablas_momo <- function(html_live) {
  tags <- paste0('#tabla_detalle .rt-td:nth-child(', 1:6, ')')
  tabla <- tibble(
    fecha           =                 as_factor(html_text2(html_elements(html_live, tags[1]))),
    notificadas     = as.integer(str_remove_all(html_text2(html_elements(html_live, tags[2])), "\\.")),
    observadas      = as.integer(str_remove_all(html_text2(html_elements(html_live, tags[3])), "\\.")),
    estimada_base   = as.integer(str_remove_all(html_text2(html_elements(html_live, tags[4])), "\\.")),
    exceso_t_causas = as.integer(str_remove_all(html_text2(html_elements(html_live, tags[5])), "\\.")),
    atribuibles_tem = as.integer(str_remove_all(html_text2(html_elements(html_live, tags[6])), "\\."))
  )
  return(tabla)
}

paginacion <- function(html_live) {
  n_pag <- max(as.numeric(unlist(str_extract_all(html_text2(html_elements(html_live, css = '.rt-page-button')), "\\d+"))))-1
  tabla1 <- tablas_momo(html_live)
  if(n_pag == 0) return(tabla1)
  tablan <- tabla1
  Sys.sleep(1)
  walk(seq_len(n_pag), ~{
    message("Vuelta: ", .x)
    html_live$click("div > div.rt-pagination > div.rt-pagination-nav > button.rt-next-button.rt-page-button")
    Sys.sleep(3)
    tablan <<- bind_rows(tablan, tablas_momo(html_live))
  })
  return(tablan)
}
