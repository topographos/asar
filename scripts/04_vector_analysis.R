library(sf)
library(tmap)
# DATA ----

# read layers in db
st_layers("data.gpkg")

# read sites
sites = st_read("data.gpkg", layer = "tbs_sites_point")

# select only first column
sites = sites[,c(1,9)]

# read survey boundaries
survey = st_read("data.gpkg", layer = "tbs_survey_extent")

survey = st_as_sfc(survey)
# plot in interactive mode
tmap_mode("view")

tm_shape(sites_point) +
  tm_symbols(col = "red")

# switch back to static view
tmap_mode("plot")


# GRID ----

# tessellation is create using st_make_grid funtion
tbs_grid = st_make_grid(sites_point, cellsize = 2500)

plot(tbs_grid)
plot(sites_point, add = TRUE)

# this makes a sfc_POLYGON so we are going to convert it to sf 
tbs_grid_sf = st_sf(tbs_grid)


# add unique id to grid
tbs_grid_sf$grid_id = 1:nrow(tbs_grid_sf)

# plot
tm_shape(tbs_grid_sf) +
  tm_borders() +
  tm_text("grid_id") +
tm_shape(sites_point) +
  tm_symbols(col="blue")


# count number of sites in each grid square
?st_intersects
st_intersects(tbs_grid_sf, sites_point)

# lengths will return the number of each element of the list.
lengths(st_intersects(tbs_grid_sf, sites_point))

plot(st_filter(tbs_grid_sf, sites, .predicate = st_intersects))

# we can assign this list of count of points back to our grid 
tbs_grid_sf$sites_count = lengths(st_intersects(tbs_grid_sf, sites_point))

# plot
tm_shape(tbs_grid_sf) +
  tm_polygons("sites_count")

# filter out grids without sites 
tm_shape(tbs_grid_sf[tbs_grid_sf$sites_count > 0,]) +
  tm_polygons("sites_count")



# KDE ----

# load packge
library(SpatialKDE)

# wrapper for st_make_grid function
grid = create_grid_rectangular(sites, cell_size = 500,  only_inside = FALSE)

#plot grid
tm_shape(grid) +
  tm_polygons()

# calculate KDE
kde = sites_point %>% 
  kde(band_width = 2000, kernel = "quartic", grid = grid)

# calculate grid
tm_shape(kde) +
  tm_polygons("kde_value")

# more code: https://topographos.github.io/kdepop/

# BUFFER ----

# filter sites

sites_ltm = sites[sites$period == "Late Third Millennium",]

sites_buff_2km = st_buffer(sites_ltm, dist = 2000)

plot(sites_buff_2km)

sites_buff_2km_union = st_union(sites_buff_2km)

# plot
tm_shape(sites_buff_2km_union) +
  tm_borders()

# VORONOI ----

# method 1
voronoi <- sites_ltm %>%  # consider the master points
  st_geometry() %>% # ... as geometry only (= throw away the data items)
  st_union() %>% # unite them ...
  st_voronoi() %>% # ... and perform the voronoi tessellation
  st_collection_extract() %>% # select the polygons
  st_sf(crs = 32637) %>% # set metric crs
  st_join(sites) %>% # & re-connect the data items
  st_intersection(survey) # limit to boundaries

# plot
tm_shape(voronoi) +
  tm_borders() +
tm_shape(sites_ltm) +
  tm_symbols()

# method 2
# install.packages("dismo")
library(dismo)

voronoi_int = voronoi(st_coordinates(sites_ltm),ext = st_bbox(survey))

voronoi_int = st_as_sf(voronoi_int) %>% st_set_crs(st_crs(sites_ltm))

voronoi_int = voronoi_int %>%  st_intersection(survey)

# plot
tm_shape(voronoi_int) +
  tm_borders() +
  tm_shape(sites_ltm) +
  tm_symbols()
