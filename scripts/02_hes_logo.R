#install.packages("SpatialKDE")

library(sf)
library(SpatialKDE)
library(ggplot2)
library(wesanderson)
library(hexSticker)
# load data

st_layers("data/data.gpkg")

sites_point = st_read("data/data.gpkg", layer = "sites_point")

# create grid

cell_size = 2000

band_width = 1000

grid = create_grid_hexagonal(sites_point, cell_size = cell_size, only_inside = TRUE )

# calculate KDE

kde = sites_point %>% 
  kde(band_width = band_width, kernel = "quartic", grid = grid)

# palette
pal <- wes_palette("Zissou1", 10, type = "continuous")

# plot
p = ggplot(data = kde) +
  geom_sf(aes(fill = kde_value), color = "#C0BCB5", show.legend = FALSE) +
  scale_fill_gradientn(colours = pal) + 
 theme_void()

#

sysfonts::font_add_google("Lato", "sans-serif")
a = sysfonts::font_info_google()
a = sysfonts::font_families_google()


sticker(p,
        package="asar",
        s_x=1, s_y= 1, s_width= 1.75, s_height= 1.75,
        p_family = "sans-serif",
        p_size= 6, 
        p_y = 0.45,
        p_x = 0.65,
        p_color = "#828585",
        h_fill =  "#C0BCB5",
        h_color = "#828585",
        url = "https://topographos.github.io/asar/",
        u_color	= "#828585",
        u_size = 1.5,
        filename="assets/hex_logo.png")
