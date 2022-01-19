#Map of OR and AQI

#install packages if you haven't done so already
#install.packages("maps")
#install.packages("mapproj")
#install.packages("ggmap")
#install.packages("mapdata")
#install.packages("ggplot2")
#install.packaged("tidyverse")

#Load libraries for our plot/map
library(magrittr)
library(tidyverse) 
library(maps)
library(ggplot2)
library(ggmap)
library(mapdata)


#set theme of plot
theme_set(theme_bw(base_size=16)) 

#import and load state/county data

data(county.fips)
states <- map_data("state")
counties <- map_data("county")

#Check state data
head(states)

#check county data and as you can see, the region and subregions are your state and county names
head(counties)

#this will define the borders for the county map 
ggplot(data = states) + 
  geom_polygon(aes(x = long, y = lat, fill = region, group = group), color = "white") + 
  coord_fixed(1.3) +
  guides(fill="none")  # do this to leave off the color legend

#select only west coast states

west_coast <- subset(states, region %in% c("california", "oregon", "washington"))

ggplot(data = west_coast) + 
  geom_polygon(aes(x = long, y = lat), fill = "palegreen", color = "black") 

#fix coordinates so it displays better
ggplot(data = west_coast) + 
  geom_polygon(aes(x = long, y = lat, group = group), fill = "palegreen", color = "black") + 
  coord_fixed(1.3)


#select only oregon data
or_df <- subset(states, region == "oregon")
or_county <- subset(counties, region == "oregon")

#Oregon state border
or_base <- ggplot(data = or_df, mapping = aes(x = long, y = lat, group = group)) + 
  coord_fixed(1.3) + 
  geom_polygon(color = "black", fill = "gray")
or_base + theme_nothing()

#Oregon counties border
or_base + theme_nothing() + 
  geom_polygon(data = or_county, fill = NA, color = "white") +
  geom_polygon(color = "black", fill = NA)  # get the state border back on top

#load AQI data
countyAQI <- readr::read_csv("C:/dev/maps/daily_aqi_by_county_2021.csv")
head(countyAQI)

#transforms your county names to all lowercase so that you can join it to the preset county file we called forth earlier
countyAQI$subregion <- tolower(countyAQI$`county Name`)
countyAQI$region <- tolower(countyAQI$`State Name`)
head(countyAQI)

OR_AQI <- subset(countyAQI, region == "oregon")

AQI1 <- OR_AQI %>% 
  group_by(subregion) %>% 
  summarise(AQIAvg = mean(AQI))

#join county and AQI data
datacheck <- inner_join(or_county, AQI1, by = "subregion")
head(datacheck)

#format plot
ditch_the_axes <- theme(
  axis.text = element_blank(),
  axis.line = element_blank(),
  axis.ticks = element_blank(),
  panel.border = element_blank(),
  panel.grid = element_blank(),
  axis.title = element_blank()
)

AQI <- or_base + 
  geom_polygon(data = datacheck, aes(fill = AQIAvg), color = "white") +
  geom_polygon(color = "black", fill = NA) +
  theme_bw() +
  ditch_the_axes

AQI 
