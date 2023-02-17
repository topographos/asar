# This script reads and plots survey data
# Author: Michal Michalski
# Date: 03-11-2023
# input: 

# install packages
install.packages("sf")

# load sf package
library(sf)

# check content of geopackage
st_layers("data.gpkg")

# load survey extent
survey = st_read("data/data.gpkg", layer = "tbs_survey_extent")

head(survey)

# read sites
sites = st_read("data/data.gpkg", layer = "tbs_sites_point")

sites = st_read("data/data.gpkg", query = "select id, size_ha, period, geom from tbs_sites_point")

class(sites)

head(sites) 

#  geometry is a list columns
df  = data.frame(id = 1:2)

list = list(1:2, 1:3)

df$list = list

str(df)

# geometry is a special type of list
class(sites$geom)

# filter only Iron Age sites
sites_ia = sites[sites$period == "Iron Age",]

# histogram
hist(sites_ia$size_ha, main = "Iron Age Sites", xlab = "Size in Hectares")

# plot basic
plot(st_geometry(survey), border = 'black', lwd = 2, lty = 21)
plot(sites_ia$geom, add = TRUE)

# add population column
sites_ia$pop = size_ha * 100

# save Iron Age sites to shapefile
st_write(sites_ia, "./data/tbs_sites_ia.shp")


# MAPS ----
# install.packages("mapsf")
library(mapsf)

# MAP 1
# theme from arguments
mf_init(x = survey, theme = "default")
# Plot the base map
mf_map(x = survey, theme = "default", lwd = 2, lty = 21)
# Plot proportional symbols
mf_map(x = sites_ia, var = "size_ha", type = "prop")

# MAP 2
# Initiate a base map
mf_init(x = survey, theme = "darkula")
# plot municipalities 
mf_map(survey, add = TRUE)
# plot population
mf_map(
  x = sites_ia, 
  var = "size_ha",
  type = "prop",
  inches = 0.25, 
  col = "brown4",
  leg_pos = "bottomleft2",  
  leg_title = "Area in Hectares"
)
# annotation
mf_annotation(
  x = c(641692.6, 4066955),
  txt = "Tell Beydar",
  pos = "topleft", cex = 1.2, font = 2,
  halo = TRUE, s = 1.5
)
# layout
mf_layout(title = "TBS Survey - Sites distribution in Iron Age", 
          credits = paste0("Sources: Ur and Wilkinson 2008\n",
                           "mapsf ", 
                           packageVersion("mapsf")))




