#1. plot

#install and load library rgdal
install.packages("rgdal")
library(rgdal)

#read Palo Alto shapefile
palo_alto <- readOGR("C:\\Users\\ahohl\\Google Drive\\Classes\\Fall2017\\GEOG6030\\Ex3\\RGIS3_Data\\palo_alto", "palo_alto")

#plot Palo Alto shapefile
plot(palo_alto)

#red lines and title
plot(palo_alto, border = "red")
title(main = "Palo Alto", sub = "By Census Tracts")

#read freeways  
freeways <- readOGR("C:\\Users\\ahohl\\Google Drive\\Classes\\Fall2017\\GEOG6030\\Ex3\\RGIS3_Data\\palo_alto", "palo_alto_freeways")

#plot freeways side by side
par(mfrow = c(1, 2))      # split plotting canvas into two columns
plot(freeways, col = "red", bg = "blue")  #red and blue
plot(freeways, lwd = 10, col = "green")   #green


#1.1 Multiple layers with plot
#stop if shapefiles are not in same projection
dev.off()
stopifnot(proj4string(palo_alto) == proj4string(freeways))  # Check in same projection before combining!

#plot palo alto and freeways
plot(palo_alto)
plot(freeways, col = "blue", add = T)


#2. spplot
#choropleth map
spplot(palo_alto, "PrCpInc", main = "Palo Alto Demographics", sub = "Average Per Capita Income", col = "transparent")


#2.1 Controlling colors

#install and load library RColorbrewer
install.packages("RColorBrewer")
library(RColorBrewer)

#display color palette
display.brewer.all()

#create custom color palette, specify number of colors
my.palette <- brewer.pal(n = 7, name = "OrRd")

#pass palette to spplot, make sure the number of cuts is the number of colors minus one
spplot(palo_alto, "PrCpInc", col.regions = my.palette, cuts = 6, col = "transparent")


#2.2 controlling color breaks
#install and load library classInt
install.packages("classInt")
library(classInt)

#create custom cuts and plot
breaks.qt <- classIntervals(palo_alto$PrCpInc, n = 6, style = "quantile", intervalClosure = "right")
spplot(palo_alto, "PrCpInc", col = "transparent", col.regions = my.palette, at = breaks.qt$brks)


#3. Basemaps
#install and load libraries dismo and raster
install.packages("dismo")
install.packages("raster")
library(dismo)
library(raster)

# Pass object whose extent you plan to plot as first argument and map-type
# as second.
base.map <- gmap(palo_alto, type = "terrain")

reprojected.palo_alto <- spTransform(palo_alto, base.map@crs)

plot(base.map)
plot(reprojected.palo_alto, add = T, border = "red", col = "transparent")

#overlay choropleth map with basemap (not working)
# install.packages("broom")
# library(broom)
# 
# pa_WGS84 <- spTransform(palo_alto, CRS("+init=epsg:4326"))
# pa_df_WGS84 <- tidy(pa_WGS84)
# 
# palo_alto$tractID <- sapply(slot(pa_WGS84, "polygons"), function(x) slot(x, "ID"))
# pa_df_WGS84 <- merge(pa_df_WGS84, pa_WGS84, by.x = "id", by.y="tractID")
# 
# install.packages("ggmap")
# library(ggmap)
# 
# sj_basemap <- get_map(location="San Jose, Ca", zoom=11, maptype = 'satellite')
# 
# ggmap(sj_basemap)
# 
# ggmap(sj_basemap) +
#   geom_polygon(data = pa_df_WGS84 , aes(x=long, lat, group = group, fill = cut_number(palo_alto$PrCpInc, 5)), alpha = 0.8) +
#   scale_fill_brewer("whatever", palette = "OrRd")
# ggmap(sj_basemap) +
#   geom_polygon(data = pa_df_WGS84, aes(x=long, lat, group = group), alpha = 0.8) +
#   scale_fill_brewer("whatever", palette = "OrRd")
















