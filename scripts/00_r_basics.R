# INFO ----
# A short description of your script
# Purpose: 
# Author:
# Date:

# CALCULATOR ----

2 + 2 # addition

4 - 2 # minus

2* 2  # multiplication

4^2   # 4 * 4 power function

# calculate absolute population of a site with area of 4.815 hectares ; 1 hectare equal 100 people 

4.815 * 100

# OBJECTS ----
# create objects with assign operator <- 

area <-  4.815

per_per_hectar <-  100

area * per_hectar

site_pop <-  area * per_hectar

# FUNCTIONS ----

# set of numbers
size_ha = c(7.56, 4.80, 10.5, 20, 7.67)

# function signature
mean()

# arguments by position
mean(size_ha, trim = 0.1, TRUE)

# arguments by name 
mean(na.rm = TRUE, trim = 0.1, x = size)

# arguments by position,rare arguments by name

mean(size_ha, trim = 0.1, na.rm = TRUE)


# PACKAGES ----

install.packages("stringr") # only once

library(stringr) # in every R session

str_sub("THS_48_0_0", start = 1, end = 3)

stringr::str_sub("THS_48_0_0", start = 1, end = 3)


# WORKSPACE ----

getwd()

objects()

ls()

rm(x)

rm(list = ls())

# HELP ----

help.start()

help()

# STYLE ----

# Object Names

# https://en.wikipedia.org/wiki/Snake_case

size_ha

# don't:  start with number, use special signs, copy exisiting function names

# File Names

# GOOD
# 01_data_cleaning.R
# 02_population_calculation.R
# ths_sites.csv

# BAD
# code.R
# data!.csv

# Comments
# comments can be put everywhere hash mark '#'

# EXERCISE ----

# a mini analysis
# start with clean slate

rm(list=ls())

# data
site_id <- "THS_48_0_0"

area <-  4.815

period <- "Iron Age"

# analysis

# theory supported estimation 
peson_per_hectar <-  100

# calculation
site_pop <-  round(area * peson_per_hectar)

#result ready for a newspaper headline
paste("Archaeologists estimate the population of", site_id,  "may have hit", site_pop, "in", period)

?round()
?paste()



# DATA TYPES ----
# simple vectors, matrix
# complex lists, data frames

rm(list = ls())

## Vector ----

# character vector
site_id = c("THS_1_0_0", "THS_2_0_0", "THS_3_0_0")

# numeric vector
size_ha = c(18.0, 5.6, 7.2)

# logical vector
tell = c(TRUE, FALSE, FALSE)

site_id # see data

is.vector(site_id)

str(site_id)

str(size_ha)

# arithmetic expresion; operation are performed element by element

size_ha * 100

pop = size_ha * 100

is.vector(pop)

# accessing vector elements

site_id[2]

## Factor ----

period <-  c("Iron Age", "Iron Age", "Bronze Age")

period <- factor(period)

str(period)

period

summary(period)

## List ----
# R list is an object consisting of an ordered collection of objects called components
# a list can contain variety of objects: vectors, function and so on

THS_24_0_0 = list(name = "THS_24_0_0", size = c(16.06,10.41, 1.76), 
                  periods = c("Late Bronze Age", "Khabur", "Iron Age"), 
                  category = factor(c("small town", "small town", "village")) )

# access list

THS_24_0_0[[1]]

THS_24_0_0$name

THS_24_0_0[[2]]

THS_24_0_0$size

THS_24_0_0$periods

THS_24_0_0$category

## Data frames ----

# construct df
sites <- data.frame(site_id, size_ha, period)

# add new variable
sites$tell <- tell

# DATA INDEXING ----

# rows - single
sites[1,]

# rows - range
sites[1:2, ]

# column - single
sites[,1]        # as vector

sites["site_id"] # as data frame

sites$site_id     # $ sign

sites[sites$site_id == "THS_1_0_0",]  # note the coma, filter on rows extract all columns

sites[sites$size_ha > 10,]

subset(sites, site_id == "THS_1_0_0")

