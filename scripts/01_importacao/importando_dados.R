#pacotes necessarios para as analises#

library(terra)
library(dplyr)
library(tidyr)
library(ggplot2)
library(sf)


#ler área de estudo#

area <- vect("dados/raw/area_bio.shp")

#ler rasters do mapbiomas#

uso2017 <- rast("dados/raw/mapbiomas_2017.tif")
uso2020 <- rast("dados/raw/mapbiomas_2020.tif")
uso2023 <- rast("dados/raw/mapbiomas_2023.tif")

#recortar o raster fora do limite da area e mascarar para que os valores fora do poligono sejam NA pela area#

uso2017 <- mask(crop(uso2017, area), area)
uso2020 <- mask(crop(uso2020, area), area)
uso2023 <- mask(crop(uso2023, area), area)
