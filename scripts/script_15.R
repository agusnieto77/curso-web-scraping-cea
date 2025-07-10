library(sf)
library(osmdata)
library(osmextract)

bb_sevilla <- getbb("Sevilla, Spain")

q <- opq(bbox = bb_sevilla) |> add_osm_feature(key = "amenity", value = "school")

osm_result <- osmdata_sf(q)

escuelas_sf <- osm_result$osm_points

escuelas_sf <- escuelas_sf |> select(osm_id, name, geometry) |> st_transform(4326)

par(mar = rep(0.1, 4))
plot(st_geometry(escuelas_sf), main = "Escuelas según OSM")

cycleways_spanish = oe_get(
  "Spain",
  quiet = FALSE,
  query = "SELECT * FROM 'lines' WHERE highway = 'cycleway'",
  download_directory = "./osm_data/"
)

par(mar = rep(0.1, 4))
plot(st_geometry(cycleways_spanish))

# REFERENCIAS: 
# https://docs.ropensci.org/osmdata/
# https://docs.ropensci.org/osmextract/
# https://docs.ropensci.org/osmapiR/
# https://docs.ropensci.org/osmplotr/
