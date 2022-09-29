## -------- Marvel vs DC Comics ---------------

# Los datos provienen de : https://github.com/cosmoduende/r-marvel-vs-dc
# Si quieres navegar en los datos de acuerdo al autor, visita la pagina : https://cosmoduende.medium.com/dc-comics-vs-marvel-comics-an%C3%A1lisis-exploratorio-y-visualizaci%C3%B3n-de-datos-con-r-b0cf565e44e2

# INSTALAR PAQUETES FALTANTES
install.packages("wesanderson")
install.packages("pander")

library(pacman)

# ACTIVAR PAQUETES EN EL AMBIENTE DE R
p_load("vroom", 
       "reshape2", 
       "wesanderson",
       "cowplot",
       "pander",
       "dplyr", 
       "gridExtra",
       "ggplot2", 
       "RColorBrewer",
       "ggplot2",
       "dplyr",
       "magick",
       "ggrepel",
       "tidyverse",
       "lessR")

# LEER DATASETS 
infoCharacters <- read.csv("data/heroesInformation.csv", na.strings = c("-", "-99"))
infoPowers <- read.csv("data/superHeroPowers.csv")
infoStats <- read.csv("data/charactersStats.csv", na.strings = "")

# SUBSET PARA MARVEL Y DC
colnames(infoCharacters)[colnames(infoCharacters) == "name"] <- "Name"
marvelDcInfo <- infoCharacters[(infoCharacters$Publisher == "Marvel Comics" | infoCharacters$Publisher == "DC Comics"), ]

# REMOVER NOMBRES DUPLICADOS Y SELECCIONAR COLUMNAS
marvelDcInfo <- marvelDcInfo[!duplicated(marvelDcInfo$Name), ]
marvelDcInfo <- marvelDcInfo %>%
  select(Name, Gender, Race, Publisher)

# JOIN DATASETS
marvelDcStatsInfo <- join(marvelDcInfo, infoStats, by = "Name", type = "inner")
colnames(infoPowers)[colnames(infoPowers) == "hero_names"] <- "Name"
fullMarvelDc <- join(marvelDcStatsInfo, infoPowers, by = "Name", type = "inner")

# TRANSFORMAR EN UNA SOLA COLUMNA SUPERPODERES
marvelDc <- melt(fullMarvelDc, id = c("Name", "Gender", "Race", "Publisher", "Alignment", "Intelligence", 
                                         "Strength", "Speed", "Durability", "Power", "Combat", "Total"))
colnames(marvelDc)[colnames(marvelDc) == "variable"] <- "SuperPower"
marvelDc <- marvelDc %>%
  filter(value == "True") %>%
  select(-value)
  
# CONVERTIR COLUMNAS CATEGÓRICAS A FACTORES
marvelDc$Name <- as.factor(marvelDc$Name)
marvelDc$Gender <- as.factor(marvelDc$Gender)
marvelDc$Race <- as.factor(marvelDc$Race)
marvelDc$Publisher <- as.factor(marvelDc$Publisher)
marvelDc$Alignment <- as.factor(marvelDc$Alignment)
marvelDc$SuperPower <- as.factor(marvelDc$SuperPower)

# PALETAS DE COLOR PERSONALIZADAS DE ACUERDO A LOS COLORES DE LAS EMPRESAS
dcMarvelPalette <- c("#0476F2", "#EC1E24")
goodBadPalette <- c("#A71D20", "#0DA751", "#818385")

# CARGAR LOGOS DE LAS EMPRESAS (SE EMPLEA CON EL PAQUETE magick)
Marvel_logo <-image_read("./logos/Marvel_Logo.png")
DC_logo <-image_read("./logos/DC-comic-1.png") 

## NOTA: SI QUIERES SABER MAS DEL PAQUETE magick, VISITA : https://cran.r-project.org/web/packages/magick/vignettes/intro.html#Cut_and_edit

# ----------- FIGURA 1 PANEL A (GRAFICA DE BARRAS CON EL TOTAL DE PERSONAJES POR EMPRESA CON LOGOS) ---------------

# > COMPARACIÓN GENERAL EN EL NUMERO DE PERSONAJES POR EMPRESA  
marvelDc_gg <- marvelDc %>% mutate(Publisher = factor(Publisher, levels =c("Marvel Comics", "DC Comics"))) %>% ggplot(aes(x = Publisher, fill = Publisher)) +
  geom_bar(stat = "count", aes(fill = Publisher)) + # Para que cuente el numero de datos
  geom_text(stat = "count", aes(label = ..count..), vjust=-0.5, family="sans", size =6)+
  scale_y_continuous(expand = c(0, 0), limits = c(0, 3000))+ # cero en la linea
  labs(x = "", y = "No. de Personajes", title = "") +
  scale_fill_manual(values= c("#EC1E24", "#0476F2")) + # colores
  guides(fill = FALSE) +
  theme_classic() +
  theme(text=element_text(size=13, family="sans"), #cambiar letra y posicion de los labels
        title =element_text(size=16, family="sans"), #tamano del titulo
        axis.text = element_text(size = 15), # tamanos de las letras en eje X y Y
        axis.text.x = element_blank(), # tamanos de las letras en eje X y Y
        plot.title = element_text(hjust = 0.5, vjust=1)) # posicion del titulo
   
# AGREGAR LOGOS EN CADA EMPRESA
marvelDc_gg <- ggdraw(marvelDc_gg) +
  draw_image(Marvel_logo, x = 0.42, y = 0.7, hjust = 1, vjust = 1, width = 0.13, height = 0.2) +
  draw_image(DC_logo, x = 0.82, y = 0.45, hjust = 1, vjust = 1, width = 0.13, height = 0.2) 

marvelDc_gg

# ----------- FIGURA 1 PANEL B (GRAFICA DE BARRAS CON EL TOTAL DE PERSONAJES POR CADA GENERO Y EMPRESA) ---------------

# > COMPARACIÓN DE GÉNEROS EN PERONAJES DE DC Y MARVEL
marvelDcGender <- marvelDc %>%
  filter(!is.na(Gender)) %>%
  group_by(Gender) %>%
  dplyr::count(Publisher) %>%
  select(Gender, Publisher, Count = n)
  
marvelDcGender_gg <- marvelDcGender %>% 
  mutate(Publisher = factor(Publisher, levels =c("Marvel Comics", "DC Comics"))) %>%
  ggplot(aes(x = Gender, y = Count)) +
  geom_bar(stat = "identity", aes(fill = Publisher)) +
  geom_text(stat = "identity", aes(label = Count), vjust=-0.5, family="sans", size =6)+
  scale_y_continuous(expand = c(0, 0), limits = c(0, 2000))+ # cero en la linea
  labs(x = "", y = "No. de Personajes", title = "") +
  scale_fill_manual(values= c("#EC1E24", "#0476F2")) + # colores
  facet_wrap(~Publisher) +
  theme_classic() +
  theme(text=element_text(size=15, family="sans"), #cambiar letra y posicion de los labels
        title =element_text(size=18, family="sans"), #tamano del titulo
        axis.text = element_text(size = 15), # tamanos de las letras en eje X y Y
        legend.position = "none",
        strip.background = element_blank(),  # sin relleno
        strip.text =element_blank(), # sin texto en face_wrap
        plot.title = element_text(hjust = 0.5, vjust=1)) # posicion del titulo
   
marvelDcGender_gg

# ----------- FIGURA 1 PANEL C (GRAFICA DE LOLLIPOP CON EL TOTAL DE PERSONAJES POR RAZA Y EMPRESA) ---------------

# > COMPARACIÓN DE RAZAS EN PERSONAJES DE MARVEL Y DC 
counts_per_Race_DCcomics <- marvelDc %>% 
  filter(!is.na(Race)) %>% # Eliminar valores con NA
  filter(Publisher == "DC Comics") %>% # Seleccionar solo a la empresa DC
  group_by(Race) %>% # Agrupar dde acuerdo con la especie
  tally() %>% # tally cuenta cuantos elementos hay en cada grupo
  mutate(Publisher = "DC Comics") # Agregar una ultima columna con el nombre de la empresa

counts_per_Race_Mcomics <- marvelDc %>% 
  filter(!is.na(Race)) %>% # Eliminar valores con NA
  filter(Publisher == "Marvel Comics") %>% # Seleccionar solo a la empresa Marvel
  group_by(Race) %>% # Agrupar dde acuerdo con la especie
  tally() %>% # tally cuenta cuantos elementos hay en cada grupo
  mutate(Publisher = "Marvel Comics") # Agregar una ultima columna con el nombre de la empresa

counts_per_Race_allComics <- rbind(counts_per_Race_DCcomics, counts_per_Race_Mcomics) # Unir la informacion de las empresas

marvelDcRace_gg <- counts_per_Race_allComics %>% 
mutate(Publisher = factor(Publisher, levels =c("Marvel Comics", "DC Comics"))) %>% # Orden de las empresas
ggplot(aes(x = reorder(Race,n), # Ordenar por el numero de personajes por raza
                        y = n, fill= Publisher)) +
  geom_segment(aes(x = reorder(Race,n), xend = reorder(Race,n), y = 0, yend = n), # Graficar lineas
               color = "black", lwd = 1) +
  geom_point(aes(colour = factor(Publisher)), size = 4) + # Graficar puntos
  scale_color_manual(values=c("#EC1E24", "#0476F2")) + # Colores de relleno de acuerdo a la empresa
  #geom_text(aes(label = n), color = "black", size = 3) + # Si quieren agregar los numeros por cada punto
  labs(y="", x="Especies") + 
  facet_wrap(~Publisher) + # Graficar por empresas
  coord_flip() + # Voltear la grafica
  theme_light() + 
    theme(text=element_text(size=15, family="sans"), # Cambiar el tamano de la letra y seleccionar el formato Arial [family="sans"]
        title =element_text(size=18, family="sans"), # Formato del titulo
        axis.text = element_text(size = 15), # Tamanos de las letras en eje X y Y
        legend.position = "none", # Que no agregue la leyenda
        strip.background = element_blank(),  # sin relleno
        strip.text =element_blank(), # Sin texto en face_wrap, es decir que no diga las empresas para guiarnos solo por los colores
        plot.title = element_text(hjust = 0.5, vjust=1)) # Posicion del titulo

marvelDcRace_gg

# ----------- FIGURA 1 COMPLETA ---------------

# PANEL A Y B
marvelDc_cowAB <- plot_grid(marvelDc_gg, marvelDcGender_gg, # GRAFICA A Y GRAFICA B
                            rel_widths = c(2, 0.3), # Escalas de las figuras, panel A va a ser dos veces mas grande que la B, y la B disminuye en su tamano
                            ncol=1, # Figura en una sola columna
                            labels = "AUTO", label_size = 20)  # Agregar label A y B de forma automatica, tamano de la letra

marvelDc_cowAB

# PANEL C
marvelDc_cowC <- plot_grid(NA, marvelDcRace_gg, # Al poner NA se agrega una figura vacia, sirve para dar espacios
                            rel_widths = c(0.3, 2), # Reducir el tamano del espacio y ampliar el panel C
                            nrow=1, # Figura en una sola fila
                            labels = "C", label_size = 20)  # Agregar label C, tamano de la letra

marvelDc_cowC

# UNIR FIGURA
# plot_grid proviene del paquete cowplot
tiff(file="Figura1_Informaciongeneral.tiff", width = 12, height = 8, units = 'in', res = 300)
plot_grid(marvelDc_cowAB, marvelDc_cowC) 
dev.off()

# ----------- FIGURA 2 PANEL A (GRAFICA DE BARRAS CON EL TOTAL DE PERSONAJES EN CADA BANDO Y EMPRESA) ---------------

# > COMPARACIÓN DE HEROES Y VILLANOS EN MARVEL Y DC
marvelDcAlignment <- marvelDc %>%
  filter(!is.na(Alignment)) %>%
  group_by(Alignment) %>%
  dplyr::count(Publisher) %>%
  dplyr::select(Alignment, Publisher, Count = n)

marvelDcAlignment_gg <- marvelDcAlignment %>% 
  mutate(Publisher = factor(Publisher, levels =c("Marvel Comics", "DC Comics"))) %>%
  ggplot(aes(x = Alignment, y = Count)) +
  geom_bar(stat = "identity", aes(fill = Alignment)) +
  geom_text(stat = "identity", aes(label = Count), vjust=-0.5, family="sans", size =6)+
  scale_y_continuous(expand = c(0, 0), limits = c(0, 1800))+ # cero en la linea
  labs(x = "", y = "No. de Personajes", title = "") +
  scale_fill_manual(values= c("#7D3C98", "#8c8c8c", "black")) + # colores
  facet_wrap(~Publisher, strip.position= "bottom") +
  theme_classic() +
  theme(text=element_text(size=15, family="sans"), #cambiar letra y posicion de los labels
        title =element_text(size=18, family="sans"), #tamano del titulo
        axis.text = element_text(size = 15), # tamanos de las letras en eje X y Y
        legend.position = "none",
        strip.background = element_blank(),  # sin relleno
        strip.text =element_text(face = "bold", size =15), # sin texto en face_wrap
        strip.placement = "outside",
        plot.title = element_text(hjust = 0.5, vjust=1)) # posicion del titulo

marvelDcAlignment_gg

# ----------- FIGURA 2 PANEL B (GRAFICA DE PIE/PASTEL CON EL TOTAL DE PERSONAJES EN CADA BANDO Y EMPRESA, PERSONAJES FEMENINOS) ---------------

# > DISTRIBUCION DE VILLANAS Y HEROES EN PERSONAJES FEMENINOS
marvelDcAlignment_Female <- marvelDc %>% filter(Gender == "Female") %>%
  filter(!is.na(Alignment)) %>%
  group_by(Alignment) %>%
  dplyr::count(Publisher) %>%
  dplyr::select(Alignment, Publisher, Count = n)

# GRAFICA DE PASTEL
marvelDcAlignment_Female_gg <- marvelDcAlignment_Female %>% 
  mutate(Publisher = factor(Publisher, levels =c("Marvel Comics", "DC Comics"))) %>% #Orden de las empresas
  ggplot(aes(x=factor(1), y=Count, fill=factor(Alignment))) +
  geom_bar(stat="identity", position="fill", width=1) + # Rellenar por el contenido, para que las escalas no sean iguales
  coord_polar("y") + # Para hacerlo circular
  facet_wrap(~Publisher) + # Graficar por empresa
  scale_fill_manual(values= c("#7D3C98", "#8c8c8c", "black")) + # Colores
  labs(title = "Bandos en personajes femeninos") +
  theme_void() + # Remover el background, grid y numeric labels
  theme(text= element_text(size=12, family="sans"), # Cambiar el tamano de la letra y seleccionar letra Arial
        legend.position = "none", # Quitar la leyenda
        legend.title = element_blank(), # Titulos de la leyenda vacios
        strip.text = element_blank()) # Quitar los titulos generados por facet_wrap

marvelDcAlignment_Female_gg

# ----------- FIGURA 2 COMPLETA ---------------

# PANEL A
Fig2marvelDc_cowAB <- plot_grid(marvelDcAlignment_gg, marvelDcAlignment_Female_gg, 
                            rel_widths = c(2, 0.3), 
                            ncol=1, 
                            labels = "AUTO", label_size = 20)

tiff(file="Figura2_Malosbuenos.tiff", width = 6, height = 8, units = 'in', res = 300)
Fig2marvelDc_cowAB
dev.off()

# ----------- FIGURA 3  COMPLETA ---------------

# > TOP SUPERPODERES EN MARVEL Y DC
dcSuperP <- marvelDc %>%
  filter(Publisher == "DC Comics" & Gender == "Female") %>% # Seleccionar solo empresa DC comics y personajes femeninos
  group_by(SuperPower) %>% # Agrupar por sus poderes
  dplyr::count(SuperPower) %>% # Conteo
  dplyr::select(SuperPower, Count = n) %>% # Seleccionar solo las columnas de poderes y cambiar el nombre de n por Count
  arrange(-Count) %>% # Acomodar tabla de mayor a menor
  mutate(Publisher = "DC Comics") # Nueva columna con el nombre de la empresa
dcSuperP <- dcSuperP[1:20,] # Seleccionar los primeros 20 poderes con mayor numero de personajes

marvelSuperP <- marvelDc %>%
  filter(Publisher == "Marvel Comics" & Gender == "Female") %>% # Seleccionar solo empresa Marvel y personajes femeninos
  group_by(SuperPower) %>% # Agrupar por sus poderes
  dplyr::count(SuperPower) %>% # Conteo
  dplyr::select(SuperPower, Count = n) %>% # Seleccionar solo las columnas de poderes y cambiar el nombre de n por Count
  arrange(-Count) %>% # Acomodar tabla de mayor a menor
  mutate(Publisher = "Marvel Comics") # Nueva columna con el nombre de la empresa
marvelSuperP <-marvelSuperP[1:20,] # Seleccionar los primeros 20 poderes con mayor numero de personajes

marvelDcPower_db <- rbind(dcSuperP,marvelSuperP) # Unir ambas tablas de las Empresas

marvelDcPower_gg <- marvelDcPower_db %>% 
  mutate(Publisher = factor(Publisher, levels =c("Marvel Comics", "DC Comics"))) %>% # Ordenar
  ggplot(aes(x=Count, y=reorder(SuperPower, Count))) +
  geom_bar(stat = "identity", aes(fill = Publisher)) +
  #scale_y_continuous(expand = c(0, 0), limits = c(0, 1800))+ # cero en la linea
  labs(x = "No. de Personajes", y = "Poderes", title = "") +
  scale_fill_manual(values= c("#EC1E24", "#0476F2")) + # colores
  facet_wrap(~Publisher, scales="free") +
  theme_classic() +
  theme(text=element_text(size=15, family="sans"), #cambiar letra y posicion de los labels
        title =element_text(size=18, family="sans"), #tamano del titulo
        axis.text = element_text(size = 15), # tamanos de las letras en eje X y Y
        legend.position = "none",
        strip.background = element_blank(),  # sin relleno
        strip.text =element_text(face = "bold", size =15), # sin texto en face_wrap
        plot.title = element_text(hjust = 0.5, vjust=1)) # posicion del titulo

marvelDcPower_gg






