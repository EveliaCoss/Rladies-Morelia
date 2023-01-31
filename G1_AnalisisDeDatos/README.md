# Grupo 1:  Analisis de Datos en R

## Repaso de conocimientos

Si quieres repasar tu conocimiento antes de adentrarte en esta actividad te propongo revisar los siguientes apartados, generados por [Software Carpentry](https://swcarpentry.github.io/r-novice-gapminder/):

* [Data Structures](https://swcarpentry.github.io/r-novice-gapminder/04-data-structures-part1/index.html)
* [Exploring Data frames](https://swcarpentry.github.io/r-novice-gapminder/05-data-structures-part2/index.html)
* [Subsetting Data](https://swcarpentry.github.io/r-novice-gapminder/06-data-subsetting/index.html)
* [Control Flow](https://swcarpentry.github.io/r-novice-gapminder/07-control-flow/index.html)

Ademas si quieres checar que mas puedes hacer con tus dataframe puedes revisar esta pagina: https://sparkbyexamples.com/r-programming/add-row-to-dataframe-in-r/

## Datasets propuestos

### Datos en formato CSV  - Archivos separados por comas

* [Marvel vs DC Comics](https://github.com/cosmoduende/r-marvel-vs-dc/tree/main/dataset_shdb)

###  Datos en formato TSV (Informacion de *Arabidopsis thaliana*) - Archivos separados por tabuladores

Obtenidos de la Base de datos de [Arabidopsis thaliana](https://www.arabidopsis.org/download/index-auto.jsp?dir=%2Fdownload_files%2FGenes%2FAraport11_genome_release)

* [Araport11 Gene Type.txt](https://www.arabidopsis.org/download_files/Genes/Araport11_genome_release/Araport11_gene_type) 
* [Araport11_GFF3_genes_transposons.current.gff](https://drive.google.com/file/d/1EBl07-o6Ai2QvOzDwjbFmazipWK1Jgj2/view?usp=share_link) - [Formato GFF](https://genome.ucsc.edu/FAQ/FAQformat.html#format3)
* [Araport11_GTF_genes_transposons.current.gtf](https://drive.google.com/file/d/1XdQqVeaeB6Uz2AGFWRrUmKJ_9z2goYZX/view?usp=share_link) - [Formato GTF](https://genome.ucsc.edu/FAQ/FAQformat.html#format4)
* [Araport11_pcoding_transcripts.bed](https://drive.google.com/file/d/1a3UzS6X_rQ8eyw0WllM8vR8DK4Aq3dR6/view?usp=share_link) - [Formato BED12](https://genome.ucsc.edu/FAQ/FAQformat.html)
* [Araport11_lncRNAs_genes_biotypes_label.bed](https://drive.google.com/file/d/1I5mLJMPbJj3mcRd8WUWNGhpXrMWDioyn/view?usp=share_link) - Formato BED13 (BED12 + columna con informacion)

## Parte 1.- Ejercicio con la base de datos Marvel vs DC Comics (29/01/23)

Descarga los Datos en formato CSV de la parte superior, los datos fueron tomados del [Github de Cosmoduende](https://github.com/cosmoduende).

Objetivos de esta seccion:

* Importar datos CSV a R.
* Empleo de comandos basicos en R.
* Manipulacion de datos (limpieza, filtrado, adicion, eliminacion, ordenar, etc).
* Uso de condicionales (if_else).

## Parte 2.- Ejercicio con datos reales de especies (PROXIMAMENTE)

Descarga los **Datos en formato TSV** de la parte superior, los archivos provienen de la base de datos TAIR10/Araport11 de *Arabidopsis thaliana*. 

Objetivos de esta seccion: 

* Importar datos de diversos formatos en R (GTF, GFF, BED, TXT).
* Clasificar los genes en monoexonicos y multiexonicos con base en la informacion contenida en el BED.
* Obtener el tamano del transcrito maduro a partir de la informacion contenida en el BED.
* Agrupar por los biotipos encontrados en los archivos.
* Filtrar datos...


