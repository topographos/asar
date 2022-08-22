#install.packages("hexSticker")
#install.packages("wesanderson")

library(ggplot2)
library(hexSticker)
library(wesanderson)
library(sf)

st_layers("data/data.gpkg")

h_ways = st_read("data/data.gpkg", layer = "hollow_ways")

sites  = st_read("data/data.gpkg", layer = "sites_point")

sites$size_ha = sites$size_ha * 1.5

survey = st_read("data/data.gpkg", layer = "survey_extent")

# plot

p = ggplot() +
  geom_sf(data = sites, 
          aes(size = size_ha),
          color = "#645f55", 
          fill = "#645f55",
          alpha = .1) +
  geom_sf(data = sites, color = "#A84268", size = 0.1) +
  theme_minimal() +
  theme(legend.position="none") +
  theme(axis.text.x=element_blank(),
        axis.text.y=element_blank(),
        panel.grid.major = element_line(colour = "transparent")) +
  theme_transparent()


p


sysfonts::font_add_google("Lato", "sans-serif")
a = sysfonts::font_info_google()

a = sysfonts::font.families.google()
royal = wes_palette("Royal1")


sticker(p,
        package="ASAR",
        s_x=1, s_y= 1, s_width= 1.75, s_height= 1.75,
        p_family = "sans-serif",
        p_size= 5, 
        p_y = 0.6,
        p_x = 0.5,
        p_color = "#828585",
        h_fill =  "#C0BCB5",
        h_color = "#828585",
        url = "https://topographos.github.io/asar/",
        u_color	= "#828585",
        u_size = 1.2,
        filename="assets/hex_logo.png")


