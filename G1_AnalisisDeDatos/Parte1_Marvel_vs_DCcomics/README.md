## Parte 1.- Ejercicio con la base de datos Marvel vs DC Comics (29/01/23)

Datos en formato CSV  - Archivos separados por comas
-------------------------------------------

* [Marvel vs DC Comics](https://github.com/cosmoduende/r-marvel-vs-dc/tree/main/dataset_shdb)

Descarga los **Datos en formato CSV** de la parte superior, los datos fueron tomados del [Github de Cosmoduende](https://github.com/cosmoduende).

Paquetes que necesitas

```
# En caso de que los tengas instalados emplea estos codigos:
install.packages("dplyr")
install.packages("reshape2")

# Si ya los tienes solo llamalos en el ambiente:
library(reshape2)
library(dplyr)
```

Las funciones que usaremos seran del paquete `dplyr`:

```
select() : Seleccionar nombres de las columnas. --> select(dataframe, columna1, columna2, ... columnax)
filter() : Filtrar filas por una condicion especifica, apartir de la columna.
mutate() : Modificar o agregar columnas.
group_by() : Agrupar informacion de acuerdo a un(as) columna(s) seleccionada(s). 
if_else() : Condicional.
arrange() : Acomodar los resultados, default de menor a mayor.
count(): Cuenta los valores de acuerdo a una variable.
left_join() : Unir dos dataframe con base en una misma columna en comun.
n_distinct() : Cuenta las filas unicas.
distinct() : Muestra las filas duplicadas.
```

Si quieres ver mas funciones de 'dplyr' puedes visitar su [Github](https://github.com/cran/dplyr). En la seccion *Cheat Sheet* se encuentra la informacion resumida.

La funcion empleada del paquete `reshape2`:

```
melt(): Modificacion el formato de un dataframe.
```
i quieres ver mas funciones de 'reshape2' puedes visitar su [Github](https://github.com/cran/reshape2). 

A) Importar informacion en R

```
infoCharacters <- read.csv("data/heroesInformation.csv", na.strings = c("-", "-99")) # La opcion na.string nos permite sustituir valores - y -99 por NA
infoPowers <- read.csv("data/superHeroPowers.csv")
infoStats <- read.csv("data/charactersStats.csv", na.strings = "")

# Observar el contenido de los dataframe
head(infoCharacters)
head(infoPowers)
head(infoStats)
```

B) Renombrar columnas

```
# Cambiar la columna "name" por "Name"
colnames(infoCharacters)[colnames(infoCharacters) == "name"] <- "Name"
colnames(infoPowers)[colnames(infoPowers) == "hero_names"] <- "Name"
```

C) Dividir/filtrar informacion de acuerdo a la empresa

```
# Empresas comprendidas en esta base de datos
unique(infoCharacters$Publisher)

# Solo Marvel Comics y DC Comics
marvelDcInfo <- infoCharacters[(infoCharacters$Publisher == "Marvel Comics" | infoCharacters$Publisher == "DC Comics"), ]

head(marvelDcInfo)
```

D) Eliminar personajes duplicados (filas duplicadas)

```
# Observar cuales se duplican mediante la funcion "duplicated"
duplicated(marvelDcInfo$name) 

dim(marvelDcInfo) # Tamano del dataframe

# Eliminar filas duplicadas
marvelDcInfo <- marvelDcInfo[!duplicated(marvelDcInfo$Name), ]

head(marvelDcInfo)
```

E) Seleccionar columnas de interes

```
marvelDcInfo <- marvelDcInfo %>%
  select(Name, Gender, Race, Publisher) # Columnas Name (nombre del personaje), Gender (genero), Race (raza), Publisher (empresa)

head(marvelDcInfo)
```

F) Unir tablas con base en una columna en comun

```
# Primera union, empleando la columna Name
# Se unio las columnas seleccionadas con la informacion basica de cada personaje con los stats de cada uno.
marvelDcStatsInfo <- left_join(marvelDcInfo, infoStats, by = "Name")
head(marvelDcStatsInfo)

# Segunda union, empleando la columna Name
# Se el dataframe generado co la informacion de los poderes por cada personaje.
fullMarvelDc <- left_join(marvelDcStatsInfo, infoPowers, by = "Name")
head(fullMarvelDc)
```

### Preguntas

Cuantos personajes hay por cada empresa?

```
# Cambiar formatos
fullMarvelDc$Name <- as.factor(fullMarvelDc$Name)
fullMarvelDc$Gender <- as.factor(fullMarvelDc$Gender)
fullMarvelDc$Race <- as.factor(fullMarvelDc$Race)
fullMarvelDc$Publisher <- as.factor(fullMarvelDc$Publisher)
fullMarvelDc$Alignment <- as.factor(fullMarvelDc$Alignment)

# Opcion A
summary(fullMarvelDc$Publisher)

# Opcion B
fullMarvelDc %>% filter(Publisher == "DC Comics") %>% n_distinct()
fullMarvelDc %>% filter(Publisher == "Marvel Comics") %>% n_distinct()
```

Cuantos personajes son mujeres y hombres hay por cada empresa?

```
# Opcion A
fullMarvelDc %>% select(Gender, Publisher) %>% filter(Publisher == "DC Comics" & Gender == "Male") %>% nrow()
fullMarvelDc %>% select(Gender, Publisher) %>% filter(Publisher == "DC Comics" & Gender == "Female") %>% nrow()

fullMarvelDc %>% select(Gender, Publisher) %>% filter(Publisher == "Marvel Comics" & Gender == "Male") %>% nrow()
fullMarvelDc %>% select(Gender, Publisher) %>% filter(Publisher == "Marvel Comics" & Gender == "Female") %>% nrow()

# Opcion B
marvelDcGender <- fullMarvelDc %>% filter(!is.na(Gender)) %>%
  group_by(Gender) %>%
  dplyr::count(Publisher) %>%
  select(Gender, Publisher, Count = n)

head(marvelDcGender)
```

Cuales son las razas predominantes de cada empresa?

```
marvelDcRace<- fullMarvelDc %>% filter(!is.na(Race)) %>%
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
```

Cuantos personajes villanos y heroes por cada empresa?

```
marvelDcAlignment <- fullMarvelDc %>%   filter(!is.na(Alignment)) %>%
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
```

## Continuamos con la parte 1

G) Reacomodar la tabla de acuerdo a las habilidades o poderes

```
# La funcion "melt" te permite acomodar la tablas, cambiando el formato de la misma de acuerdo a las habilidades o poderes
marvelDc <- melt(fullMarvelDc, id = c("Name", "Gender", "Race", "Publisher", "Alignment", "Intelligence.x", 
                                         "Strength", "Speed", "Durability.x", "Power", "Combat", "Total"))

# Cambiar formatos
marvelDc$Name <- as.factor(marvelDc$Name)
marvelDc$Gender <- as.factor(marvelDc$Gender)
marvelDc$Race <- as.factor(marvelDc$Race)
marvelDc$Publisher <- as.factor(marvelDc$Publisher)
marvelDc$Alignment <- as.factor(marvelDc$Alignment)
colnames(marvelDc)[colnames(marvelDc) == "variable"] <- "SuperPower" # Renombrar columna
marvelDc$SuperPower <- as.factor(marvelDc$SuperPower)

# Corregir nombres de columnas
colnames(marvelDc)[colnames(marvelDc) == "Intelligence.x"] <- "Intelligence"  # Renombrar columna
colnames(marvelDc)[colnames(marvelDc) == "Durability.x"] <- "Durability"  # Renombrar columna


# Seleccion de habilidades con TRUE
marvelDc <- marvelDc %>%
  filter(value == "True") %>%
  select(-value) #eliminar columna

head(marvelDc)

# Observar la informacion de Superman
marvelDc %>% filter(Name == "Superman")
```

### Preguntas

Quienes son los personajes mas fuerte de cada empresa?

```
marvelDc %>% filter(!is.na(Strength)) %>%  # filtrar NA
  group_by(Name, Publisher) %>%  # Agrupar por nombre del heroe y empresa
  distinct(Strength) %>% # Eliminar duplicados en la columna, para tener solo un valor por personaje
  select(Name, Publisher, Strength) %>% # seleccionar columnas
  arrange(-Strength) # Ordenar de mayor a menor
```

Quienes son los personajes mas inteligentes de cada empresa?

```
marvelDc %>% filter(!is.na(Intelligence)) %>%  # filtrar NA
  group_by(Name, Publisher) %>%
  distinct(Intelligence) %>% # eliminar duplicados
  select(Name, Publisher, Intelligence) %>%
  arrange(-Intelligence)
```

Quienes son los personajes con mas habilidades/poderes por cada empresa?

```
marvelDc %>% group_by(Name, Publisher) %>%
  distinct(SuperPower) %>%
  dplyr::count(Publisher) %>%
  select(Name, Publisher,  Count = n) %>%
  arrange(-Count) # ordenar de max a min
```

Sin embargo, ser el mas habilidoso no implica el mas poderoso...Si observamos sus stats todos son de 1 o menos

```
# Es el personaje con mas habilidades, pero tiene sus stats muy bajos
marvelDc %>% filter(Name == "Spectre")
```

Quienes son los personajes con los stats mas altos por cada empresa?

```
 Opcion A
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
  
# Y si filtramos 
# Personas con valores totales superiores a 570
marvelDc %>% select(-SuperPower) %>% distinct() %>% # eliminas duplicados
  filter(Total >= 570)
```

Quienes son las mujeres mas poderosas y malvadas?

```
# con filtro
marvelDc %>% select(-SuperPower) %>% distinct() %>% # eliminas duplicados
  filter(Total >= 500  & Gender == "Female" & Alignment == "bad") 

# sin filtro
marvelDc %>% select(-SuperPower) %>% distinct() %>% # eliminas duplicados
  filter(Gender == "Female" & Alignment == "bad") %>%
  arrange(-Total)
```

Quienes son los hombres mas poderosos y malvados?

```
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
```

## Continuamos con la parte 1

H) Renombrar a villanos y a heroes empleando condicionales

```
# Agregar nueva columna con etiqueta
marvelDc_edited <- marvelDc %>% mutate(Group = if_else(Alignment == "good","hero", if_else(Alignment == "bad","villain", "neutral")))
```

Contestamos la pregunta anterior ahora con cambios, Quienes son los hombres mas poderosos y malvados?

```
marvelDc_edited %>% select(-SuperPower) %>% distinct() %>% # eliminas duplicados
  filter(Gender == "Male" & Group == c("hero","villain")) %>%
  arrange(-Total)
```
