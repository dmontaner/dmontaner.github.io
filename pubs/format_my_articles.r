##format_my_articles.r
##2016-04-23 david.montaner@gmail.com
##Format my articles from PubMed XML file

## Download the file collection.xml
## from pubmed.dmontaner.com as:
## Send to > File > Format = XML

options (width = 130)

date ()
Sys.info ()[c("nodename", "user")]
commandArgs ()
rm (list = ls ())
R.version.string ##"R version 3.2.5 (2016-04-14)"
library (xml2); packageDescription ("xml2", fields = "Version") #"0.1.2"
##help (package = xml2)


### DATOS
datos <- read_xml ("collection.xml")
datos <- as_list (datos)

table (sapply (datos, length))
datos <- lapply (datos, unlist, recursive = FALSE) ## eliminate first list layer
table (sapply (datos, length))
unique (t (sapply (datos, names))) ## OK same order

lon <- t (sapply (datos, sapply, length))
head (lon)  ## Identifiers may have different lengths; this will break as.data.frame

fuera <- which (colnames (lon) == "Identifiers")
fuera
datos <- lapply (datos, "[", - fuera) ## now all elements of datos should have the same structure

datos <- t (sapply (datos, unlist)) ## matrix
datos <- as.data.frame (datos, stringsAsFactors = FALSE)

head (datos)

datos[,'auth.md'] <- sub ('Montaner D', '**Montaner D**', datos[,'Description'])  ## bold
datos[,'auth.tw'] <- sub ('Montaner D', "''Montaner D''", datos[,'Description'])  ## bold

### MARKDOWN
datos[,'md'] <- paste0 ('1. _', datos[,'Title'], '_ ', datos[,'auth.md'],
                        " [", datos[,'Details'], "](http://www.ncbi.nlm.nih.gov/", datos[,'URL'], ')')

### TiddlyWiki
datos[,'tw'] <- paste0 ('# //', datos[,'Title'], '// ', datos[,'auth.tw'],
                        " [[", datos[,'Details'], "|http://www.ncbi.nlm.nih.gov/", datos[,'URL'], ']]')


## many et. al
table (grepl ('Montaner D', datos[,'Description']))
grep ('Montaner D', datos[,'Description'], invert = TRUE, value = TRUE)

## order

### SAVE
## markdown
writeLines (datos[,'md'], con = "dmontaner_pubications.md")
##writeLines (datos[,'md'], con = "dmontaner_pubications.md", sep = "  \n\n")
## tiddlywiki
writeLines (datos[,'tw'], con = "dmontaner_pubications.tw")
##writeLines (datos[,'md'], con = "dmontaner_pubications.md", sep = "  \n\n")

################################################################################

###PANDOC

system ("pandoc -S -f markdown -t docx  -o dmontaner_pubications.docx dmontaner_pubications.md")
#system ("pandoc    -f markdown -t docx  -o dmontaner_pubications.docx dmontaner_pubications.md")

system ("pandoc -S -f markdown -t latex -o dmontaner_pubications.pdf dmontaner_pubications.md")
#system ("pandoc    -f markdown -t latex -o dmontaner_pubications.pdf dmontaner_pubications.md")

system ("pandoc -S -H html.sty -f markdown -t html -o dmontaner_pubications.html dmontaner_pubications.md")
#system ("pandoc    -H html.sty -f markdown -t html -o dmontaner_pubications.html dmontaner_pubications.md")

system ("pandoc -S -f markdown -t plain -o dmontaner_pubications.txt dmontaner_pubications.md") ## does not remove __ and **
#system ("pandoc    -f markdown -t plain -o dmontaner_pubications.txt dmontaner_pubications.md")

system ("pandoc -S -f markdown -t latex -o dmontaner_pubications.tex dmontaner_pubications.md")
#system ("pandoc    -f markdown -t latex -o dmontaner_pubications.tex dmontaner_pubications.md")

#system ("pandoc -S --self-contained  -f markdown -t latex -o dmontaner_pubications_self.tex dmontaner_pubications.md")


###EXIT
warnings ()
sessionInfo ()
q ("no")
