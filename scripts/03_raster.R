# load packages
library(terra) # raster 
library(tmap) # mapping
library(sf) # vector

# Raster Basics ----
# create matrix - two dimensional data structure
m = matrix(1:9, nrow = 3, ncol = 3)

# check for attributes
attributes(m)

# check for dimension
dim(m)

# create spatial raster 
r <- rast(ncol=3, nrow=3, xmin=-150, xmax=-120, ymin=20, ymax=50, vals = 1:9)

# plot
plot(r)

# read in raster - EPSG 32637
dem = rast("data/dem.tif")

#have a look - only one single layer look for nlyr and name
dem

# plot
plot(dem , main = "Digital Elevation Model")


# calculate terrain characteristics - creates multiple layers
terrain_char <- terra::terrain(dem, c('slope', 'aspect', 'TPI', 'TRI'))

# plot
plot(terrain_char)

# raster model

class(dem) # class

dim(dem) # dimensions

ncell(dem) # number of cells

nrow(dem) # number of rows

ncol(dem) # number of columns

ext(dem) # spatial extension

res(dem) # raster resolution

crs(dem) # raster coordinate system

nlyr(dem) # number of raster layers

# re-project raster ----

dem_WGS84 = project(dem, "EPSG:4326" )

# you can save your raster
terra::writeRaster(dem,"dem_WGS84.tif")

# TMAP ----

library(tmap)

# map raster
tm_shape(dem) + 
  tm_raster(style = "quantile", n = 12, title = "Elevation (m)",
            palette = colorRampPalette( c("#a7b898","#ffeee5"))(25),
            alpha = 0.7,
            legend.hist = TRUE) +
  tm_legend(outside = TRUE, hist.width = 2)

# lets improve our map by adding our survey data

# clear environment and load all data again
rm(list = ls())
# check layers

st_layers("data/data.gpkg")

# survey extent
survey = st_read("data/data.gpkg", layer = "tbs_survey_extent")

# sites
sites = st_read("data/data.gpkg", layer = "tbs_sites_point")

# raster
dem = rast("data/dem.tif")

# create map with tmap

tm_shape(dem) +
  tm_raster(style = "quantile", n = 12, title = "Elevation (m)",
            palette = colorRampPalette( c("#a7b898","#ffeee5"))(25),
            legend.hist = TRUE) +
tm_shape(survey) +
  tm_borders(col = "black", lty = "dashed" ) +
tm_shape(sites) +
  tm_symbols(alpha = 0.6) +
  tm_legend(outside = TRUE, hist.width = 2) +
  tm_layout(title = "TBS Survey") +
  tm_compass() +
  tm_scale_bar() +
  tm_grid()





