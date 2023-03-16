# Parte 1

### Datos Marvel vs DC comics

library(reshape2) # install.packages("reshape2")
library(dplyr) # install.packages("dplyr")


infoCharacters <- read.csv("data/heroesInformation.csv", na.strings = c("-", "-99")) # sustituir valores - y -99  por NA
infoPowers <- read.csv("data/superHeroPowers.csv")
infoStats <- read.csv("data/charactersStats.csv", na.strings = "")

head(infoCharacters)
head(infoPowers)
head(infoStats)

#Renombrar la columna "name" por "Name" en infoCharacters

colnames(infoCharacters)
colnames(infoCharacters)[2]

#opcionA
#olnames(infoCharacters)[2] <- "Name"
# opcion B
colnames(infoCharacters)[colnames(infoCharacters) == "name"] <- "Name"

colnames(infoPowers)[colnames(infoPowers) == "hero_names"] <- "Name"


head(infoCharacters)
head(infoPowers)
head(infoStats)

# Separar por empresas

#  Empresas comprendidas en esta base de datos
unique(infoCharacters$Publisher)

# Solo Marvel Comics y DC Comics
#infoCharacters[fila,columna]
#infoCharacters[1,]
#infoCharacters[,1]

# opcion A
marvelDcInfo <- infoCharacters[(infoCharacters$Publisher == "Marvel Comics" | infoCharacters$Publisher == "DC Comics"), ]
head(marvelDcInfo)

unique(marvelDcInfo$Publisher)

# opcion B
marvelDcInfo <- infoCharacters %>% filter(Publisher %in% c("Marvel Comics", "DC Comics"))
head(marvelDcInfo)

unique(marvelDcInfo$Publisher)

# Eliminar personajes duplicados

duplicated(marvelDcInfo$Name) # duplicaciones
dim(marvelDcInfo)

#marvelDcInfo[fila,columna]

# opcion A
marvelDcInfo <- marvelDcInfo[!duplicated(marvelDcInfo$Name), ] # dame los nombres de los heroes (fila) que no esten duplicados
head(marvelDcInfo)

dim(marvelDcInfo)

# opcion B
marvelDcInfo <- marvelDcInfo %>% filter(!(duplicated(Name)))
dim(marvelDcInfo)

# Seleccionar columnas de interes

# opcion A
marvelDcInfo <- marvelDcInfo %>%
  dplyr::select(Name, Gender, Race, Publisher)

# opcion B
#arvelDcInfo <-  
# select(marvelDcInfo, Name, Gender, Race, Publisher)

#select(dataframe, columna1, columna2, columna3)

head(marvelDcInfo)


## Unir tablas de estadisticas
head(infoStats)
head(infoPowers)

# union 1
marvelDcStatsInfo <- left_join(marvelDcInfo, infoStats, by = "Name")
head(marvelDcStatsInfo)

# union 2
fullMarvelDc <- left_join(marvelDcStatsInfo, infoPowers, by = "Name")
head(fullMarvelDc)

## Algunas preguntas

#Cantidad de personajes:

str(fullMarvelDc)

# Cambiar formatos
fullMarvelDc$Name <- as.factor(fullMarvelDc$Name)
fullMarvelDc$Gender <- as.factor(fullMarvelDc$Gender)
fullMarvelDc$Race <- as.factor(fullMarvelDc$Race)
fullMarvelDc$Publisher <- as.factor(fullMarvelDc$Publisher)
fullMarvelDc$Alignment <- as.factor(fullMarvelDc$Alignment)

str(fullMarvelDc) 

# Cuantos personajes hay en cada compania?
# Opcion A
summary(fullMarvelDc$Publisher)

# Opcion B
fullMarvelDc %>% filter(Publisher == "DC Comics") %>% n_distinct()
fullMarvelDc %>% filter(Publisher == "Marvel Comics") %>% n_distinct()

# Cuantos de cada genero en cada empresa?

# Opcion A

fullMarvelDc %>% select(Gender, Publisher) %>% filter(Publisher == "DC Comics" & Gender == "Male") %>% nrow()
fullMarvelDc %>% select(Gender, Publisher) %>% filter(Publisher == "DC Comics" & Gender == "Female") %>% nrow()

fullMarvelDc %>% select(Gender, Publisher) %>% filter(Publisher == "Marvel Comics" & Gender == "Male") %>% nrow()
fullMarvelDc %>% select(Gender, Publisher) %>% filter(Publisher == "Marvel Comics" & Gender == "Female") %>% nrow()

# Opcion B
marvelDcGender <- fullMarvelDc %>% filter(!is.na(Gender)) %>%
  dplyr::group_by(Gender) %>%
  dplyr::count(Publisher) %>%
  dplyr::select(Gender, Publisher, Count = n)

# dplyr:: significa que estas tomando la funcion de esta paqueteria

head(marvelDcGender)

# Cual es la raza predominante por compania?

marvelDcRace <- fullMarvelDc %>% filter(!is.na(Race)) %>%
  group_by(Publisher) %>%
  dplyr::count(Race) %>%
  select(Publisher,Race,  Count = n) %>%
  arrange(-Count) # ordenar de max a min

head(marvelDcRace)

# Y si le agregamos sexo?
fullMarvelDc %>% filter(!is.na(Race)) %>%
  group_by(Publisher, Gender) %>%
  dplyr::count(Race) %>%
  select(Publisher, Gender, Race,  Count = n) %>%
  arrange(-Count) # ordenar de max a min

# Cuantos son villanos, cuantos son heroes?

marvelDcAlignment <- fullMarvelDc %>%  filter(!is.na(Alignment)) %>%
  group_by(Publisher) %>%
  dplyr::count(Alignment) %>%
  select(Publisher, Alignment,  Count = n) %>%
  arrange(-Count) # ordenar de max a min

marvelDcAlignment

# Y si le agregamos sexo?
fullMarvelDc %>% filter(!is.na(Alignment) & !is.na(Gender)) %>%
  group_by(Publisher, Gender) %>%
  dplyr::count(Alignment) %>%
  select(Publisher, Gender, Alignment,  Count = n) %>%
  arrange(-Count) # ordenar de max a min

## Habilidades

head(fullMarvelDc)

# Acomodo de tablas y asignacion de habilidades
marvelDc <- melt(fullMarvelDc, id = c("Name", "Gender", "Race", "Publisher", "Alignment", "Intelligence.x", 
                                      "Strength", "Speed", "Durability.x", "Power", "Combat", "Total"))


str(marvelDc)
dim(marvelDc)
head(marvelDc)

# Cambiar formatos
marvelDc$Name <- as.factor(marvelDc$Name)
marvelDc$Gender <- as.factor(marvelDc$Gender)
marvelDc$Race <- as.factor(marvelDc$Race)
marvelDc$Publisher <- as.factor(marvelDc$Publisher)
marvelDc$Alignment <- as.factor(marvelDc$Alignment)

# renombrar columna
colnames(marvelDc)[colnames(marvelDc) == "variable"] <- "SuperPower"
marvelDc$SuperPower <- as.factor(marvelDc$SuperPower)

# Corregir nombres de columnas
colnames(marvelDc)[colnames(marvelDc) == "Intelligence.x"] <- "Intelligence"
colnames(marvelDc)[colnames(marvelDc) == "Durability.x"] <- "Durability"


# Seleccion de habilidades con TRUE
marvelDc <- marvelDc %>%
  filter(value == "True") %>%
  select(-value) #eliminar columna

head(marvelDc)

# superman
marvelDc %>% filter(Name == "Superman")

# Quien es el mas fuerte?
  
marvelDc %>% filter(!is.na(Strength)) %>%  # filtrar NA
  group_by(Name, Publisher) %>%  # Agrupar por nombre del heroe y empresa
  distinct(Strength) %>% # Eliminar duplicados en la columna, para tener solo un valor por personaje
  select(Name, Publisher, Strength) %>% # seleccionar columnas
  arrange(-Strength) # Ordenar de mayor a menor


# Quien es el mas inteligente?
marvelDc %>% filter(!is.na(Intelligence)) %>%  # filtrar NA
  group_by(Name, Publisher) %>%
  distinct(Intelligence) %>% # eliminar duplicados
  select(Name, Publisher, Intelligence) %>%
  arrange(-Intelligence)

# Quien tiene mas poderes?
marvelDc %>% group_by(Name, Publisher) %>%
  distinct(SuperPower) %>%
  dplyr::count(Publisher) %>% # dplyr::count(Name) %>%
  select(Name, Publisher,  Count = n) %>%
  arrange(-Count) # ordenar de max a min

# Es el personaje con mas habilidades, pero tiene sus stats muy bajos
marvelDc %>% filter(Name == "Spectre")

# Quien tiene los stats mas altos?

# Es el personaje con mas habilidades, pero tiene sus stats muy bajos

# Opcion A
marvelDc %>% arrange(-Intelligence, -Strength, -Speed, -Durability, -Power, -Combat ) %>%
  select(-SuperPower) %>%
  distinct()

# Opcion B
# Hay 6 columnas de stats, osea que los valores maximos se encuentran cercanos a 600 [6-11]
marvelDc %>% select(-SuperPower) %>% distinct() %>% # eliminas duplicados
  filter(Intelligence >= 100 & Strength >= 100 & Speed >= 100 & Durability >= 100 & Power >= 100 & Combat >= 100)
# Ninguno

# Personaje con stats superiores a 90 en cada uno
marvelDc %>% select(-SuperPower) %>% distinct() %>% # eliminas duplicados
  filter(Intelligence >= 90 & Strength >= 90 & Speed >= 90 & Durability >= 90 & Power >= 90 & Combat >= 90)


# Personas con valores totales superiores a 570
marvelDc %>% select(-SuperPower) %>% distinct() %>% # eliminas duplicados
  filter(Total >= 570)

# Quien es la mujer mas poderosa y malvada?
# con filtro
marvelDc %>% select(-SuperPower) %>% distinct() %>% # eliminas duplicados
  filter(Total >= 500  & Gender == "Female" & Alignment == "bad") 

# sin filtro
marvelDc %>% select(-SuperPower) %>% distinct() %>% # eliminas duplicados
  filter(Gender == "Female" & Alignment == "bad") %>%
  arrange(-Total)


# Quien es el hombre mas poderosa y malvada?

# sin filtro
marvelDc %>% select(-SuperPower) %>% distinct() %>% # eliminas duplicados
  filter(Gender == "Male" & Alignment == "bad") %>%
  arrange(-Total)

# Y bueno ?
marvelDc %>% select(-SuperPower) %>% distinct() %>% # eliminas duplicados
  filter(Gender == "Male" & Alignment == "good") %>%
  arrange(-Total)


# Ambos ?
marvelDc %>% select(-SuperPower) %>% distinct() %>% # eliminas duplicados
  filter(Gender == "Male" & Alignment == c("good", "bad")) %>%
  arrange(-Total)

# Agregar etiqueta "Heroe (hero)", "villano (villain)" o "Neutral (neutral)"
# Agregar nueva columna con etiqueta
marvelDc_edited <- marvelDc %>% mutate(Group = if_else(Alignment == "good","hero", 
                                                       if_else(Alignment == "bad","villain", "neutral")))

head(marvelDc_edited)


#if_else(condicion, si pasa esto, si no pasa esto)

marvelDc_edited %>% select(-SuperPower) %>% distinct() %>% # eliminas duplicados
  filter(Gender == "Male" & Group == c("hero","villain")) %>%
  arrange(-Total)


# Eliminar variables
rm(infoCharacters, infoPowers, infoStats, marvelDc_edited, marvelDc, marvelDcAlignment, 
   fullMarvelDc, marvelDcGender, marvelDcStatsInfo, marvelDcInfo)



