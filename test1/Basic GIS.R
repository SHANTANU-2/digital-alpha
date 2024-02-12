#basic GIS operations using R
#POints
library(ithir)

data(HV100)
str(HV100)

# load the necessary R packages
library(sp)
library(raster)
#install.packages("rgdal") # no longer available
library(rgdal) # no longer available
library (terra) #new change instead of RGDAL
install.packages("sf")

#assigning spatial coordinates
coordinates(HV100) <- ~x + y
coordinates(HV100)
str(HV100)


#Plot
spplot(HV100, "OC", scales = list(draw = T), cuts = 5,
       col.regions = bpy.colors(cutoff.tails = 0.1,
                                alpha = 1), cex = 1)

#Define CRS (In this case WGS1984 UTM Zone 56)
# Use EPSG code (European Petroleum Survey Group) code 
# Consult consult http://spatialreference.org/ for assistance

library (sf)
library(terra)
proj4string(HV100) <- CRS("+init=epsg:32756")
HV100@proj4string

# To export the data set as a shapefile (set working directory)

st_write(HV100, "HV_dat_shape.shp")

## "C:\Users\user\OneDrive - iitkgp.ac.in\Documents\DSM_2024\HV_dat_shape.shp"
HV100 <- st_read("C:\Users\user\OneDrive - iitkgp.ac.in\Documents\DSM_2024\HV_dat_shape.shp")


# Check yor working directory for presence of this file

#To see in Google Earth (WGS1984)
# Needs coordinate transformation to WGS1984
library (sf)
library(terra)
HV100_ll <- st_transform(HV100, crs = 4326) #epsg: 4326 for WGS1984
st_write(HV100_ll, "HV100.kml", driver = "kml", delete_dsn = TRUE)
# Check yor working directory for presence of this file


#read in shape file

imp_HV_dat <- st_read("HV_dat_shape.shp")
crs_info <- st_crs(imp_HV_dat) # Retrieve the coordinate reference system information
print(crs_info) # Print the coordinate reference system information

#The imported shapefile is now a SpatialPointsDataFrame, just like the HV100




#rasters
library(ithir)
data(HV_dem)
str(HV_dem)

#table to raster
#Define CRS

r.DEM <- rasterFromXYZ(HV_dem)
proj4string(r.DEM) <- CRS("+init=epsg:32756")

#Plots raster and overlay HV100 points
plot(r.DEM)
points(HV100, pch = 20)

#Export in ESRI ASCII (common universal raster format)
writeRaster(r.DEM, filename = "HV_dem100.asc",
            format = "ascii", overwrite = TRUE)





