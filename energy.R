library(stringr)
library(tidyverse)

setwd("~/Documentos/carpentries/R_ladies/energy_gapminder/per_person/")

for ( i in list.files(".",pattern = ".csv")){
  nombre <- str_sub(i, end = -5)
  tabla <- read.csv(i, 
                    na.strings=c("","NA"))
  assign(nombre, tabla)
  rm(tabla, nombre,i)}

## Intentar quitar caracteres y convertir en numericos ####
#for (i in c(2:length(electricity_generation_per_person))){
#    electricity_generation_per_person[,i]<- gsub("\\.", "", electricity_generation_per_person[,i])
#    electricity_generation_per_person[,i]<- gsub("k", "000", electricity_generation_per_person[,i])
#}
# Necesito quitar la K, converitr a numerico y multiplicar por mil sólo las celdas que tenían k



## Seguir con Gas natural y oil que sí están bien ####
paices <- read.csv("../countries_info/Data Geographies - v2 - by Gapminder - list-of-countries-etc.csv",
                   na.strings=c("","NA"),
                   stringsAsFactors = TRUE)

gas_long <- pivot_longer(natural_gas_production_per_person, cols = starts_with("X"), names_to = "Year", values_to = "NGpC")
gas_long <- as.data.frame(gas_long)
gas_long[,"Year"] <- sub(".", "", gas_long[,"Year"])
gas_long[,"Year"] <- as.integer(gas_long[,"Year"])

oil_long <- pivot_longer(oil_production_per_person, cols = starts_with("X"), names_to = "Year", values_to = "OpC")
oil_long <- as.data.frame(oil_long)
oil_long[,"Year"] <- sub(".", "", oil_long[,"Year"])
oil_long[,"Year"] <- as.integer(oil_long[,"Year"])

continent <- select(paices, country= name, eight_regions)


gas_oil <- full_join(x = gas_long, y= oil_long, by= c("country", "Year"))
gas_oil <- left_join(x=gas_oil, y= continent, by="country")
gas_oil <- gas_oil %>%
  select(Country = country,
         Continent = eight_regions,
         Year,
         NGpC,
         OpC)
levels(gas_oil$Continent) <- c("North Africa", "Sub Saharan Africa", "North America", "South America" ,"West Asia", "East Asia Pacific", "East Europe", "West Europe")

ggplot(data = gas_oil,
       mapping = aes(x=Year, y = NGpC, color = Continent, by= Country),)+
  geom_col()+
  geom_line(mapping = aes(x= Year, y= OpC))+
  scale_y_continuous(("NGpC", sec.axis = sec_axis(name = OpC)))
