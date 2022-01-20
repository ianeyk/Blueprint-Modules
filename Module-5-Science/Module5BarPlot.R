# Plot of OR and AQI

# install.packages("tidyverse")


# Load libraries for our plot/map

library(tidyverse)


# load AQI data
countyAQI <- read_csv("C:/dev/maps/daily_aqi_by_county_2021.csv")

# Rename county and state name columns
countyAQI <- countyAQI %>% 
  rename(
    county = "county Name", 
    state = "State Name"
  )
head(countyAQI)

#select from table only Oregon counties
OR_AQI <- countyAQI %>% 
  filter(state == "Oregon") %>% 
  group_by(county) %>% 
  summarize(AQIavg = mean(AQI))
head(OR_AQI)

#lot AQI average against county
OR_AQI %>% 
ggplot(mapping = aes(x = county, y = AQIavg), fill = "khaki3") + 
  geom_bar(stat = "identity") + 
  ylim(0, 100) + 
  labs(
    x = "County", 
    y = "AQI", 
    title = "AQI Average for Oregon Counties 2021"
  ) + 
  coord_flip() + # flips coordinates so labels work better. 
                 # Delete this line if you wish to have the plot vertical
  theme(
    axis.ticks.y = element_blank(),
    panel.grid.major.y = element_blank()
  )