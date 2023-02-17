# Packages ----
install.packages("")
library(sf)
library(terra)
library(RStoolbox)
library(tidyverse)
library(tmap)
library(exactextractr)

# DATA ----

# vector

st_layers("data/data.gpkg")

# archaeological sites
sites = st_read("data/data.gpkg", layer = "tbs_sites_point")

# survey extent
survey = st_read("data/data.gpkg", layer = "tbs_survey_extent")

# landsat bands

# Blue
blue <- rast("data/landsat_tbs/band_2.tif")
# Green
green <- rast("data/landsat_tbs/band_3.tif")
# Red
red <- rast("data/landsat_tbs/band_4.tif")
# Near Infrared (NIR)
near.infrared <- rast("data/landsat_tbs/band_5.tif")

# LANDSAT ----

# stack RGB
landsat.rgb = c(red,green,blue)

landsat = c(blue,green,red,near.infrared)

# 16-bit values that range from 0 to 65535
plotRGB(landsat.rgb , scale=65535)

# stretch min to max - linear stretching
plotRGB(landsat.rgb , scale=65535, stretch = "lin")

# stretch min to max - histogram stretching
plotRGB(landsat.rgb , scale=65535, stretch = "hist")

# RStoolbox
RStoolbox::ggRGB(landsat.rgb, r = "band_4", g = "band_3", b = "band_2")

# NDVI ----

# Normalized Difference Vegetation Index (NDVI) 
# NDVI = (infrared - red) / (infrared + red)
ndvi = (near.infrared - red) / (near.infrared + red)

plot(ndvi)

# RStoolbox
indices = spectralIndices(landsat, red = "band_4", nir = "band_5", indices = c("NDVI","MSAVI"))

indices = rast(indices)

plot(indices)

# RASTER - VECTOR ----

# prep sites - select tells from LBA and buffer
tells_lba = sites %>% 
  filter(tell == TRUE & period == "Late Bronze Age") %>% 
  select(name) 

buffer= st_buffer(tells_lba, dist = 1000)

# map 
tm_shape(ndvi) +
  tm_raster(palette = "YlGn") +
tm_shape(tells_lba_buf) +
  tm_polygons(alpha = 0.1) +
tm_shape(tells_lba) +
  tm_dots() +
  tm_text("name",size = 0.6) +
tm_shape(survey) +
  tm_borders()

# extract ndvi value - method 1

sites_ndvi_raw = terra::extract(ndvi, vect(buffer))

# tidy up 
sites_ndvi = sites_ndvi_raw %>% 
  mutate(
    ndvi = round(band_5, 3)
  ) %>% 
  select(-band_5) %>% 
  drop_na()

# add unique ID
buffer$ID = 1:nrow(buffer)

# do stats filter out bottom 5% and top 5%
sites_ndvi_stats = sites_ndvi %>% 
  group_by(ID) %>% 
  filter(between(ndvi, quantile(ndvi, 0.05), quantile(ndvi, 0.95))) %>% 
  summarise(min = min(ndvi),
            mean = mean(ndvi),
            max = max(ndvi))

# join to buffers
buffer_ndvi =left_join(buffer,sites_ndvi_stats)

# extract ndvi value - method 2
buffer$ndvi_sum = exact_extract(ndvi, buffer, 'sum', progress = TRUE)

buffer$ndvi_mean = exact_extract(ndvi, buffer, 'mean', progress = TRUE)

# MAP ---- 
tm_shape(survey) +
  tm_borders() +
tm_shape(buffer) +
  tm_polygons(col = "ndvi_mean", palette = "YlGn") +
tm_shape(tells_lba) +
  tm_dots() +
  tm_text("name",size = 0.6)

