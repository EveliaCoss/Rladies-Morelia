# Introduccion a Rmarkdown

Autora: Evelia Coss
-----------------------

En este apartado estaremos siguiendo el material de Carpentry, capitulo 15 [Producing Reports With knitr](https://swcarpentry.github.io/r-novice-gapminder/15-knitr-markdown/index.html).
Ademas aprenderemos a crear indices en nuestros reportes y agregar notas de ayuda de diferentes colores.

## Instalacion de Rmarkdown en Rstudio

En la linea de comandos colocar el siguiente codigo:
```
install.packages("rmarkdown")
```

## Archivo inicial

Para crear un archivo dar click en `File/New file/R markdown`. El archivo generado tiene en la parte superior las siguientes instrucciones:

```
---
title: "Sesion de Rmarkdown"
author: "Evelia Coss"
date: "4/9/2022"
output: html_document 
---
```

En donde se indica el nombre del archivo que le dimos al crearlo, el nombre del autor, la fecha y el tipo de archivo de salida. En este caso es un archivo tipo html.

Ademas, se incluyen una serie de instrucciones entre la linea de comandos para obtener el resumen (summary) de la variable cars. Las instrucciones pueden contener un titulo, en este caso "cars".

```{r cars}
summary(cars)
```

## Division de titulos

Los titulos se dividen por el simbolo `#`, de la siguiente manera:

```
# Genero Plantae (titulo principal)
## Plantas Verdes (sub1)
### Streptophyta (sub2)
#### Plantas terrestres (sub3)
##### Plantas vaculares (sub4)
```

## Letras negritas e italicas

Puedes resaltar tu informacion colocando el simbolo `*` antes y despues del texto: Ejemplo: *italica* y **negritas**.

```
*italica*
**negritas**
```

Ademas tambien podemos usar este mismo simbolo para comodar la informacion (vinetas):

```
Nombre de las participantes

* Johana 
* Elisa
* Fer
* Claudia
* Nelly
```

Nombre de las participantes

* Johana 
* Elisa
* Fer
* Claudia
* Nelly

## Visualizacion grafica

Rmarkdown es ideal para crear reportes con codigo, notas y graficas.

Tomando el ejemplo del [capitulo 8](https://swcarpentry.github.io/r-novice-gapminder/08-plot-ggplot2/index.html).









