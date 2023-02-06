## Practica 2 - Empleo de datos reales de *Arabidopsis thaliana*

- Les mostrare como importar diferentes archivos a R.
- Trabajaremos con el archivos TSV (Araport11_gene_type.txt) y emplearemos algunos comandos de la clase previa.
- Emplearemos el archivo BED 12 (Araport11_pcoding_transcripts.bed) para modificarlo y agregar nuevas columnas de informacio.


### Como se ven los archivos al inicio:

Primeras filas del archivo *Araport11_gene_type.txt*:

```
!Gene list based on the Araport11 genome release
!Release date of annotation: June 2016
!Annotated by: Araport at J. Craig Ventner Institute
name    gene_model_type
AT1G01010       protein_coding
AT1G01020       protein_coding
AT1G01030       protein_coding
AT1G01040       protein_coding
AT1G01046       miRNA_primary_transcript
AT1G01050       protein_coding
```

Archivo *Araport11_GTF_genes_transposons.current.gtf*:

```
Chr1    Araport11       gene    3631    5899    .       +       .       transcript_id "AT1G01010"; gene_id "AT1G01010";
Chr1    Araport11       mRNA    3631    5899    .       +       .       transcript_id "AT1G01010.1"; gene_id "AT1G01010";
Chr1    Araport11       CDS     3760    3913    .       +       0       transcript_id "AT1G01010.1"; gene_id "AT1G01010";
Chr1    Araport11       CDS     3996    4276    .       +       2       transcript_id "AT1G01010.1"; gene_id "AT1G01010";
Chr1    Araport11       CDS     4486    4605    .       +       0       transcript_id "AT1G01010.1"; gene_id "AT1G01010";
Chr1    Araport11       CDS     4706    5095    .       +       0       transcript_id "AT1G01010.1"; gene_id "AT1G01010";
Chr1    Araport11       CDS     5174    5326    .       +       0       transcript_id "AT1G01010.1"; gene_id "AT1G01010";
Chr1    Araport11       CDS     5439    5630    .       +       0       transcript_id "AT1G01010.1"; gene_id "AT1G01010";
Chr1    Araport11       exon    3631    3913    .       +       .       transcript_id "AT1G01010.1"; gene_id "AT1G01010";
Chr1    Araport11       exon    3996    4276    .       +       .       transcript_id "AT1G01010.1"; gene_id "AT1G01010";
```

Archivo *Araport11_GTF_genes_transposons.current.gff*:

```
#chromosome assembly: TAIR10.1
#genome annotation (gene structure): Araport11
#symbol and full name data generated: 2023-01-02 by TAIR
##gff-3
Chr1    Araport11       gene    3631    5899    .       +       .       ID=AT1G01010;Name=AT1G01010;Note=NAC domain containing protein 1;symbol=NAC001;full_name=NAC domain containing protein 1;computational_description=NAC domain containing protein 1;locus=2200935;locus_type=protein_coding
Chr1    Araport11       mRNA    3631    5899    .       +       .       ID=AT1G01010.1;Parent=AT1G01010;Name=AT1G01010.1;Note=NAC domain containing protein 1;conf_class=2;symbol=NAC001;full_name=NAC domain containing protein 1;computational_description=NAC domain containing protein 1;conf_rating=****;gene=2200934,UniProt=Q0WV96;curator_summary=Member of the NAC domain containing family of plant specific transcriptional regulators.
Chr1    Araport11       CDS     3760    3913    .       +       0       ID=AT1G01010:CDS:1;Parent=AT1G01010.1;Name=NAC001:CDS:1;Note=NAC domain containing protein 1;curator_summary=Member of the NAC domain containing family of plant specific transcriptional regulators.;computational_description=NAC domain containing protein 1;
Chr1    Araport11       CDS     3996    4276    .       +       2       ID=AT1G01010:CDS:2;Parent=AT1G01010.1;Name=NAC001:CDS:2;Note=NAC domain containing protein 1;curator_summary=Member of the NAC domain containing family of plant specific transcriptional regulators.;computational_description=NAC domain containing protein 1;
Chr1    Araport11       CDS     4486    4605    .       +       0       ID=AT1G01010:CDS:3;Parent=AT1G01010.1;Name=NAC001:CDS:3;Note=NAC domain containing protein 1;curator_summary=Member of the NAC domain containing family of plant specific transcriptional regulators.;computational_description=NAC domain containing protein 1;
Chr1    Araport11       CDS     4706    5095    .       +       0       ID=AT1G01010:CDS:4;Parent=AT1G01010.1;Name=NAC001:CDS:4;Note=NAC domain containing protein 1;curator_summary=Member of the NAC domain containing family of plant specific transcriptional regulators.;computational_description=NAC domain containing protein 1;
```

Archivo *Araport11_pcoding_transcripts.bed*:

```
Chr1    61904   63811   AT1G01130.1     0       -       63811   63811   0       3       45,75,255,      0,145,1652,
Chr1    69910   72138   AT1G01150.1     0       -       72138   72138   0       4       375,129,681,197,        0,929,1130,2031,
Chr1    70034   72138   AT1G01150.2     0       -       72138   72138   0       4       199,73,681,197, 0,861,1006,1907,
Chr1    70618   72138   AT1G01150.3     0       -       72138   72138   0       3       350,681,197,    0,422,1323,
Chr1    112262  113947  AT1G01280.1     0       +       113947  113947  0       2       933,669,        0,1016,
Chr1    119380  119997  AT1G01305.1     0       +       119997  119997  0       1       617,    0,
Chr1    130735  130858  AT1G01335.1     0       +       130858  130858  0       1       123,    0,
Chr1    138488  139671  AT1G01355.2     0       +       139671  139671  0       5       290,40,126,143,184,     0,386,500,714,999,
Chr1    138512  139651  AT1G01355.3     0       +       139651  139651  0       5       29,182,240,143,164,     0,84,362,690,975,
Chr1    138512  139680  AT1G01355.1     0       +       139680  139680  0       5       29,182,252,143,193,     0,84,350,690,975,
```

Archivo *Araport11_lncRNAs_genes_biotypes_label.bed*:

```
Chr1 11100 11372 AT1G03987.1 0 + 11372 11372 0 1 272, 0, Araport11_lncRNA
Chr1 43086 43295 AT1G04003.1 0 - 43295 43295 0 1 209, 0, Araport11_lncRNA
Chr1 255021 255384 AT1G04033.1 0 + 255384 255384 0 1 363, 0, Araport11_lncRNA
Chr1 258716 258963 AT1G04037.1 0 - 258963 258963 0 1 247, 0, Araport11_lncRNA
Chr1 291593 292061 AT1G04063.1 0 - 292061 292061 0 1 468, 0, Araport11_lncRNA
Chr1 402085 402294 AT1G04087.1 0 + 402294 402294 0 1 209, 0, Araport11_lncRNA
Chr1 424665 425164 AT1G04093.1 0 + 425164 425164 0 1 499, 0, Araport11_lncRNA
Chr1 551288 551529 AT1G04127.1 0 - 551529 551529 0 1 241, 0, Araport11_lncRNA
Chr1 558070 558492 AT1G04133.1 0 - 558492 558492 0 1 422, 0, Araport11_lncRNA
Chr1 559734 560251 AT1G04137.1 0 + 560251 560251 0 1 517, 0, Araport11_lncRNA
```
### Paquetes requeridos

```
# REQUIRED LIBRARIES
library(reshape2) # install.packages("reshape2")
library(dplyr) # install.packages("dplyr")
library(stringr) # install.packages("stringr")
library(tidyverse) # install.packages("tidyverse")
```

### Importar archivo TSV

```
# Cargar tabla separada por tabuladores (TSV) 
At_Araport_gene_type_db <- read.table("data/Araport11_gene_type.txt", header=TRUE, skip =3) # saltar las primeras tres lineas
# renombrar columnas
colnames(At_Araport_gene_type_db) <- c("GeneID", "Info")
head(At_Araport_gene_type_db)
```

### Importar archivo GTF

```
At_Araport_GTF_db <- read.table("data/Araport11_GTF_genes_transposons.current.gtf", header=FALSE, sep = "\t") 
# renombrar
colnames(At_Araport_GTF_db) <- c("chrom", "source", "feature", "start", "end", "score", "strand", "frame", "attribute")
head(At_Araport_GTF_db)
```

### Importar archivo Gff3

```
At_Araport_GFF3_db <-read.delim("data/Araport11_GFF3_genes_transposons.current.gff", header=F, comment.char="#")
# character: a character vector of length one containing a single character or an empty string. Use "" to turn off the interpretation of comments altogether.
# renombrar
colnames(At_Araport_GFF3_db) <- c("chrom", "source", "feature", "start", "end", "score", "strand", "frame", "attribute")
head(At_Araport_GFF3_db)
```

### Importar archivo Gff3

```
At_Araport_GFF3_db <-read.delim("data/Araport11_GFF3_genes_transposons.current.gff", header=F, comment.char="#")
# character: a character vector of length one containing a single character or an empty string. Use "" to turn off the interpretation of comments altogether.
# renombrar
colnames(At_Araport_GFF3_db) <- c("chrom", "source", "feature", "start", "end", "score", "strand", "frame", "attribute")
head(At_Araport_GFF3_db)
```

### Importar archivo BED (BED12)

```
At_Araport11_pcodinggene_BED_db <- read.table("data/Araport11_pcoding_transcripts.bed", header=FALSE) 
# character: a character vector of length one containing a single character or an empty string. Use "" to turn off the interpretation of comments altogether.
# Renombrar
colnames(At_Araport11_pcodinggene_BED_db) <- c("chrom", "chromStart", "chromEnd", "TranscriptID", "score", "strand", "thickStart", "thickEnd", "itemRgb", "blockCount", "blockSizes", "blockStarts")
head(At_Araport11_pcodinggene_BED_db)
```

### Importar archivo BED (BED13)

```
At_Araport11_lncRNAsgene_BED_db <- read.table("data/Araport11_lncRNAs_genes_biotypes_label.bed", header=FALSE) 
# character: a character vector of length one containing a single character or an empty string. Use "" to turn off the interpretation of comments altogether.
# Renombrar
colnames(At_Araport11_lncRNAsgene_BED_db) <- c("chrom", "chromStart", "chromEnd", "TranscriptID", "score", "strand", "thickStart", "thickEnd", "itemRgb", "blockCount", "blockSizes", "blockStarts", "Type")
head(At_Araport11_lncRNAsgene_BED_db)
```

### Empezemos el ejercicio

#### Cuantos genes tenemos anotados en la base de datos de Araport11?

```
# Opcion A
dim(At_Araport_gene_type_db)

# Opcion B
n_distinct(At_Araport_gene_type_db$GeneID)
```

#### Cuales son los biotipos anotados en Araport11?

```
unique(At_Araport_gene_type_db$Info)
```

#### Cuantos genes hay en cada biotipo?

```
table(At_Araport_gene_type_db$Info)
```

### Modificando el archivo BED

#### Agregar nueva columna de GeneID

```
# Agregar columna de GeneID y eliminar de TranscriptID los ultimos dos caracteres
At_Araport11_pcodinggene_db <- At_Araport11_pcodinggene_BED_db %>% 
mutate(GeneID = gsub('.{2}$',"", At_Araport11_pcodinggene_BED_db[,4]))  # eliminar los ultimos dos caracteres
# ordenar
At_Araport11_pcodinggene_db <- At_Araport11_pcodinggene_db[,c(1:4,13,5:12)]
head(At_Araport11_pcodinggene_db)
```

### Agregar Biotipo

```
At_Araport11_pcodinggene_db <- left_join(At_Araport11_pcodinggene_db, At_Araport_gene_type_db, by ="GeneID")
head(At_Araport11_pcodinggene_db)

# cuales son los biotipo?
unique(At_Araport11_pcodinggene_db$Info)

Cuantos genes hay?
At_Araport11_pcodinggene_db %>% select(GeneID) %>% n_distinct()

# Cuantos transcritos hay?
At_Araport11_pcodinggene_db %>% select(TranscriptID) %>% n_distinct()

```

### Agregar el tamano del transcrito

```
At_Araport11_pcodinggene_db$MatureLength <- sapply(strsplit(At_Araport11_pcodinggene_db$blockSizes, ","), function(x) sum(as.numeric(x)))

head(At_Araport11_pcodinggene_db)

# Cuales es el tamano mas grandes y pequeno?
summary(At_Araport11_pcodinggene_db$MatureLength)
```


