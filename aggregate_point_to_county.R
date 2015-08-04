library("sp")
library("rgdal")

pt = read.csv("illinois_case1.csv") # replace input data here
pt.geo = pt

# read illinois county geojson
il = readOGR("il.geojson", "OGRGeoJSON")
coordinates(pt.geo) <- c("lon", "lat")
proj4string(pt.geo) <- proj4string(il)

# overlay operation
county.label <- over(pt.geo, il)

# assign Name(county name) attribute from polygon to point
pt$county <- county.label$County

# aggregate by a combined key set
out <- aggregate(yield ~ run + year + county, FUN = mean, data=pt, na.rm=T)

write.csv(out,"yield_by_county.csv",row.names = F) # replace output directory here

# average the overall yield by runs and sort
ave <- aggregate(yield ~ run, FUN = mean, data=pt, na.rm=T)
attach(ave)
sortyield <-ave[order(yield),]

# add a new column to check the order
ss <-cbind(sortyield,"order"=1:nrow(sortyield))

# create an ordered sequence to select 20 scenarios from 500 runs
sss <-subset(ss, order %in% c(seq(5,500,25)))

# subsetting the original file by 20 runs
spt <-subset(pt, run %in% c(sss$run))

# output the selected county yield data
write.csv(spt,"yield_by_county_selected.csv",row.names = F) 
