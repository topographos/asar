####################
#Purpose: this is a script to read a csv file with archaeological settlements, create sf class, export to GIS file
#Author: Michal Michalski
#Date: 05/10/2021
#Revised:
#Import format: csv
#Output format: sf and geopackage

# install packages

install.packages("sf")

# load packages

library(sf) # representation for spatial vector data

# import the csv

tbs_sites = read.csv("data/tbs_sites.csv")

# check structure

str(tbs_sites)

# check first entries

head(tbs_sites, n = 1)

# check external software used by sf

sf::sf_extSoftVersion()

# provide the EPSG code using st_crs()

crs_wgs84 = st_crs(4326) # WGS84 has EPSG code 4326

# it is a so colled crs object

class(crs_wgs84)

str(crs_wgs84)

# access the wkt element

cat(crs_wgs84$wkt)

# return user input as a number

crs_wgs84$epsg

# PROJ string - old way

crs_wgs84$proj4string

# create a sf object - no crs yet

tbs_sites_sf = st_as_sf(tbs_sites, coords = c("longitude", "latitude"))

plot(tbs_sites_sf$geometry)

# you can see NA value in CRS

# assign now crs code

# 1 - use EPSG number code, or

st_crs(tbs_sites_sf) = 4326

# 2 - use the crs_wgs84 object

st_crs(tbs_sites_sf) = crs_wgs84

# return the crs of sf object

st_crs(tbs_sites_sf)

# get the WKT2 string

cat(st_crs(tbs_sites_sf)$wkt)

# transform from geodetic to projected

# create

# provide the EPSG code using st_crs() - https://epsg.io/32637

UTM_Zone_37N = st_crs(32637) # IGRS_UTM_Zone_38N EPSG: 3891

# transform sites from 

tbs_sites_sf = st_transform(tbs_sites_sf, UTM_Zone_37N)

# look at crs

st_crs(tbs_sites_sf)

# look at sf class

tbs_sites_sf

# plot the geometry

plot(tbs_sites_sf$geometry)

# save to geopackage

st_write(tbs_sites_sf, "data/tbs_data.gpkg", layer = "tbs_sites", delete_layer = TRUE)

# have a look at content

st_layers("data/tbs_data.gpkg",do_count = TRUE)
