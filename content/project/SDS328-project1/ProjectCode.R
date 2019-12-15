library(tidyverse)
library(dplyr)
library(ggplot2)

emissions_wide <- read.csv("emissions.csv")
cars <- read.csv("cars.csv")

emissions <- emissions_wide %>%
  pivot_longer(-Country, names_to = "Year", names_prefix = "X", values_to = "Yearly.Emissions") %>%
  filter(Country == "United States") %>%
  mutate(Year = as.numeric(Year)) %>%
  select(-Country)
  
carsTidy <- cars %>%
  rename(City.MPG = Unrounded.City.MPG..FT1., Highway.MPG = Unrounded.Highway.MPG..FT1.,
         Combined.MPG = Unrounded.Combined.MPG..FT1.) %>%
  select(Vehicle.ID, Year, Make, Fuel.Type, City.MPG, Highway.MPG, Combined.MPG)

carsEmissions <- carsTidy %>%
  inner_join(emissions, by = c("Year", "Year"))

carsEmissions %>% 
  group_by(Make, Fuel.Type) %>%
  summarise(mean(City.MPG))




