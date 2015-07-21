library("sp")
library("rgdal")

pt = read.csv("illinois_case1.csv") # replace input data here
pt.geo = pt

# read illinois county geojson
il = readOGR("il_counties.geojson", "OGRGeoJSON")
coordinates(pt.geo) <- c("lon", "lat")
proj4string(pt.geo) <- proj4string(il)

# overlay operation
county.label <- over(pt.geo, il)

# assign Name(county name) attribute from polygon to point
pt$county <- county.label$Name

# aggregate by a combined key set
out <- aggregate(yield ~ run + year + county, FUN = mean, data=pt, na.rm=T)

write.csv(out,"yield_by_county.csv",row.names = F) # replace output directory here
