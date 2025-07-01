library(tidygeocoder)
library(tidyverse)
library(ggrepel)
library(maps)

geo("Tokio")

(capitales <- tibble(
  pais = c("Argentina", "Brasil", "Chile", "España", "Francia", 
           "Alemania", "Italia", "Reino Unido", "Estados Unidos", 
           "Canadá", "México", "Japón", "China", "India", "Australia"),
  capital = c("Buenos Aires", "Brasilia", "Santiago", "Madrid", "París",
              "Berlín", "Roma", "Londres", "Washington D.C.", 
              "Ottawa", "Ciudad de México", "Tokio", "Pekín", "Nueva Delhi", "Canberra"),
  cap_pais = paste(capital, pais, sep =  ", ")
))

cap_coor <- capitales |> geocode(address = cap_pais, method = "osm", lat = "lat", long = "lon")

ggplot(map_data("world")) + geom_map(map = map_data("world"), aes(map_id = region), color = "white", fill = "gray90") +
  geom_text_repel(data = cap_coor, aes(x = lon, y = lat, label = capital), size = 3.5) + theme_void()

geo(c("C. San Fernando, 4, 41004 Sevilla, España",
      "Diag. Alberdi Sur 2695, B7600 Mar del Plata, Provincia de Buenos Aires", 
      "Av. Universidad 3004, Copilco Universidad, Coyoacán, 04510 Ciudad de México, CDMX, México"))
