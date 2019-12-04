#https://www.r-bloggers.com/easy-us-maps-in-r-thanksgiving-edition/
#https://mgimond.github.io/Spatial/reading-and-writing-spatial-data-in-r.html
#https://community.rstudio.com/t/saving-shapefiles-with-r-that-can-be-re-read-as-a-shapefile/32644/4
#https://www.natedayta.com/2018/08/04/maps-with-the-new-ggplot2-v3-0-0/
#https://datacarpentry.org/r-raster-vector-geospatial/06-vector-open-shapefile-in-r/
#https://www.r-graph-gallery.com/168-load-a-shape-file-into-r.html

# installing libraries ########################################################
install.packages(c("gtrendsR","sf","ggplot2"))


# loading libraries
library(gtrendsR)
library(sf)
library(ggplot2)
library(dplyr)
library(tidyr)

#
#https://geomedellin-m-medellin.opendata.arcgis.com/datasets/barrio-vereda

# Get Google trends
keyword.trend <- gtrends(keyword = "marcha", geo = "CO",
                        time = "now 1-d", gprop = "web", hl = "en-US")
keyword.trend.depto <- keyword.trend$interest_by_region
keyword.trend.depto$location <- iconv(keyword.trend.depto$location, from="UTF-8", to="ASCII//TRANSLIT")


# reading shapefile
#https://sites.google.com/site/seriescol/shapes
#http://datosabiertos.esri.co/datasets/subregiones-provincias-de-colombia
#https://opendata.arcgis.com/datasets/aca23d80f0ea4280beb3274a04e7f312_0.zip
download.file("https://sites.google.com/site/seriescol/shapes/depto.zip",
               destfile="~/col_deptos.zip")
system("unzip col_deptos.zip")
col.deptos <- st_read("depto.shp")
col.deptos$NOMBRE_DPT <- as.character(col.deptos$NOMBRE_DPT)
col.deptos$NOMBRE_DPT <- c("Antioquia","Atlantico","Bogota","Bolivar","Boyaca","Caldas",
                            "Caqueta","Cauca Department","Cesar","Cordoba","Cundinamarca",
                            "Choco","Huila","La Guajira","Magdalena","Meta","Narino",
                            "North Santander","Quindio","Risaralda","Santander Department",
                            "Sucre","Tolima","Valle del Cauca","Arauca","Casanare",
                            "Putumayo","Amazonas Department","Guainia","Guaviare","Vaupes",
                            "Vichada","San Andres and Providencia")
#st_write(col.deptos, "col.deptos_.shp", driver="ESRI Shapefile")

# reading shapefile
col.deptos <- st_read("col.deptos.shp")
col.deptos$NOMBRE_DPT <- as.character(col.deptos$NOMBRE_DPT)

# plotting a map
ggplot(data = col.deptos, aes(fill = AREA)) +
  geom_sf(color = "white") +
  scale_fill_viridis_c("Area", option = "plasma") + # magma,inferno,plasma,viridis,cividis
  theme(legend.position = "right") + 
  theme(panel.background = element_rect(colour = "black")) +
  ggtitle("Area de los departamentos de Colombia")


# adding trend information to the shapefile
col.deptos$trend.hits <- rep(NA,nrow(col.deptos))
for (i in 1:33){
  id <- which(col.deptos$NOMBRE_DPT[i] == keyword.trend.depto$location)
  col.deptos$trend.hits[i] <- keyword.trend.depto$hits[id]
}

# plotting a map
ggplot(data = col.deptos, aes(fill = trend.hits)) +
  geom_sf(color = "white") +
  scale_fill_viridis_c("Popularidad", option = "viridis") + # magma,inferno,plasma,viridis,cividis
  theme(legend.position = "right") + 
  theme(panel.background = element_rect(colour = "black")) +
  ggtitle("Popularidad de las marchas\nsegún Google por departamento")

#
col.deptos %>% 
  mutate(Area.p = AREA/sum(AREA), trend.hits.p = trend.hits/sum(trend.hits, na.rm = TRUE)) %>%
  gather(key = "Indicador", value = "Valor", c(Area.p,trend.hits.p)) %>%
  ggplot(aes(fill = Valor)) +
  geom_sf(color = "white") +
  scale_fill_viridis_c(option = "viridis") + # magma,inferno,plasma,viridis,cividis
  theme(legend.position = "right") + 
  theme(panel.background = element_rect(colour = "black")) +
  facet_wrap(~ Indicador)

# writing the modified shapefile on disk
#st_write(col.deptos, "col.deptos.mod.shp", driver="ESRI Shapefile")