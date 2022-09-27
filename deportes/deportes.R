# 0 Vamos a usar datos del INEGI
# https://www.inegi.org.mx/programas/mopradef/
# El Módulo de Práctica Deportiva y Ejercicio Físico
# (MOPRADEF) se levantaba cada tres meses, desde noviembre de 2013; 
# y a partir de 2015, una vez al año, en el mes de noviembre. El MOPRADEF 
# tiene el propósito de generar información estadística sobre la 
#participación de hombres y mujeres de 18 años y más en la práctica de 
# algún deporte o la realización 
# de ejercicio físico en su tiempo libre; así como otras características 
# de interés sobre estas actividades físicas, para la formulación de 
#políticas públicas encaminadas a mejorar  la salud y la calidad de
# ida de los mexicanos.


# 1. Cambiar directorio
getwd()
setwd("~/nelly/r-ladies/deportes/mopradef")
getwd()

library(ggplot2)
library(dplyr)

mopradef.df <- read.csv(file = 'conjunto_de_datos/conjunto_de_datos_mopradef_2021_11.csv')

colnames(mopradef.df)

# Me interasn año, período, entidad, sexo edad
unique(mopradef.df$anio)
unique(mopradef.df$periodo)
unique(mopradef.df$entidad)
unique(mopradef.df$sexo)
unique(mopradef.df$edad)
# Vamos a hacer x entidad, dos barras por sexo y counts
#depor_histo<-geom_histogram(mopradef.df )

# entidad, cuenta, edad
mopra_entidad<-mopradef.df %>%
  dplyr::group_by(entidad,sexo) %>%
  dplyr::count(entidad, sort = TRUE)


theme_set(theme_classic())

depor_histo<-ggplot(mopra_entidad, aes(fill=as.factor(sexo),y=n,x=entidad)) +
  geom_bar(position="stack", stat="identity")+  # change binwidth
  labs(title="Histograma de deportistas por estado", 
       subtitle="Clasificación según género")  


ggsave(file="depor_histo.png",depor_histo)

depor_histo<-ggplot(mopra_entidad, aes(fill=as.factor(sexo),y=n,x=entidad)) +
  geom_bar(position="dodge", stat="identity")+  # change binwidth
  labs(title="Histograma de deportistas por estado", 
       subtitle="Clasificación según género")  

ggsave(file="depor_histo.png",depor_histo)

# Ejemplo de Reporte https://www.inegi.org.mx/contenidos/programas/mopradef/doc/resultados_mopradef_nov_2021.pdf

# entidad, cuenta, edad
mopra_edad<-mopradef.df %>%
  dplyr::group_by(sexo,edad) %>%
  dplyr::count(edad, sort = TRUE)


theme_set(theme_classic())
depor_edad_histo<-ggplot(mopra_edad, aes(fill=as.factor(sexo),y=n,x=edad)) +
  geom_bar(position="stack", stat="identity")+  # change binwidth
  labs(title="Histograma de deportistas por edad", 
       subtitle="Clasificación según género")  


ggsave(file="depor_edad_histo.png",depor_edad_histo)

