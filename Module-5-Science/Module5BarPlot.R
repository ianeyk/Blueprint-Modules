#Plot of OR and AQI

#install.packages("ggplot2")


#Load libraries for our plot/map

library(ggplot2)


#load AQI data
countyAQI <- readr::read_csv("C:/dev/maps/daily_aqi_by_county_2021.csv")

#Rename county and state name columns 
countyAQI$County <- countyAQI$`county Name`
countyAQI$State <- countyAQI$`State Name`
head(countyAQI)

#select from table only Oregon counties
OR_AQI <- subset(countyAQI, State == "Oregon")

#group by county and average AQI values for all those that share county name
AQI1 <- OR_AQI %>% 
  group_by(County) %>% 
  summarise(AQIAvg = mean(AQI))

#Check AQI1 (average AQI for Counties)
head(AQI1)

#lot AQI average against county
ggplot(AQI1, aes(x = County, y = AQIAvg), fill=County) + #define x and y axis values
    geom_bar(stat="identity") +
    coord_flip() + #flips coordinates so labels work better. Delete this line if you wish to have the plot vertical
    ggtitle("AQI Average for Oregon Counties 2021") + #title of plot
    xlab("County") + #label x axis
    ylab("AQI")   #label y axis
       
