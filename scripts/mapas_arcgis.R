library(sf)

# El TOKEN es temporal, dura solo unos pocos minutos, hay que renovarlo desde 
# https://mapadocomercio.dgae.gov.pt/mapa -> inspeccionar -> Network -> query file
# Ejemplo: https://servergeo.sgeconomia.gov.pt/arcgis/rest/services/DGAE/Estabelecimentos/FeatureServer/0/query?f=(...)token=(...)

token = "qTVuGscZ1Xrgc-EdsFYznhjOAbjShgqt8l8kp7CQHLmgam2KukH2NUpxHGCCpRZ43Jwl11agKj3YOwAIR1lGD6Z810V2e6ddtwVcLh4uE49j1XPbfLd4CeBbONHTiQZipEXpAX5EJWUFLmkGOREWZdUuiwnCvToVtlPmULI08MfiHfdLBsx37V926u-ttkhS"

xmax <- "1060000"  
ymin <- "4400000"  
xmin <- "690000"   
ymax <- "5200000"  

url <- paste0("https://servergeo.sgeconomia.gov.pt/arcgis/rest/services/DGAE/Estabelecimentos/FeatureServer/0/query?f=geojson&geometry=%7B%22xmin%22%3A-", xmin, ".0979068615%2C%22ymin%22%3A", ymin, ".951845113%2C%22xmax%22%3A-", xmax, ".113001734%2C%22ymax%22%3A", ymax, ".934750238%7D&orderByFields=OBJECTID&outFields=*&outSR=102100&quantizationParameters=%7B%22extent%22%3A%7B%22spatialReference%22%3A%7B%22latestWkid%22%3A3857%2C%22wkid%22%3A102100%7D%2C%22xmin%22%3A-956380.0979068615%2C%22ymin%22%3A5031390.949845113%2C%22xmax%22%3A-953934.113001734%2C%22ymax%22%3A5033836.934750238%7D%2C%22mode%22%3A%22view%22%2C%22originPosition%22%3A%22upperLeft%22%2C%22tolerance%22%3A4.77731426782227%7D&resultType=tile&returnExceededLimitFeatures=true&spatialRel=esriSpatialRelIntersects&where=1%3D1&geometryType=esriGeometryEnvelope&inSR=102100&token=", token)

data_geojson <- st_read(url)

st_write(data_geojson, "datos_estabelecimentos.geojson", driver = "GeoJSON")
saveRDS(data_geojson, file = "datos_estabelecimentos.rds")


library(httr)
library(jsonlite)

json_cae <- fromJSON(content(GET("https://cadastro.dgae.gov.pt/api/domain-values/cae?page=0&size=2000"), "text", encoding = "UTF-8"))

saveRDS(json_cae, file = "datos_cae.rds")

