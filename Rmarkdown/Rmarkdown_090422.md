# Introduccion a Rmarkdown

Autora: Evelia Coss

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



## Division de titulos

Los titulos se dividen por el simbolo `#`, de la siguiente manera:

```
# Genero Plantae (titulo principal)
## Plantas Verdes (sub1)
### Streptophyta (sub2)
#### Plantas terrestres (sub3)
##### Plantas vaculares (sub4)
```

