########################################################################
#Script para crear un dataset con datos de referencia de ayuntamientos
#y las listas que gobiernan los ayuntamientos


path <- paste0(getwd(),"/datos") #path genérico para los datos. Todos los ficheros tienen que estar descargados aquí


########################################################################################
##Descarga de los datos de listas gobernando en cada ayuntamiento

for(i in 1:52){
  download.file(paste0("https://ssweb.seap.minhap.es/portalEELL/consulta_alcaldes/alcaldes?id_provincia=",i),
                destfile=paste0(path, "/prov", i, ".xls"),
                mode='wb')
}

########################################################################################
##### Hay que convertir los ficheros a xlsx para poder usar la librería xlsx
##### Se puede convertir con una macro en Excel o con el siguiente bash script de linux:
#!/bin/bash
#for file in /home/antonio/datosAlcaldes/datos/*.xls
#do
#libreoffice --convert-to xlsx $file --headless 
#done

library(xlsx)

#files <- list.files(path, pattern = "xlsx") #vector con todos los ficheros xls en el directorio
#En vez de hacer una enumeración, hago un bucle con el id de provincia, porque ahora es relevante

#El primer fichero inicializa el dataframe
df_alcaldes_pre <- read.xlsx(paste0(path,"/prov",1,".xlsx"), sheetIndex = 1, startRow = 6) 
df_alcaldes_pre$idProv <- 1 #Añadimos una columna con el código de provincia, porque hay nombres que se repiten
df_alcaldes <- df_alcaldes_pre

#Bucle para añadir el resto de ficheros
for (i in 2:length(files)){
  print(paste("Cargando:", paste0(path,"/prov",i,".xlsx")))   
  df_alcaldes_pre <- read.xlsx(paste0(path,"/prov",i,".xlsx"), sheetIndex = 1, startRow = 6)
  df_alcaldes_pre$idProv <- i
  df_alcaldes <- rbind(df_alcaldes, df_alcaldes_pre)
}

df_alcaldes <- df_alcaldes[!is.na(df_alcaldes$Municipio),]

#Cambiamos algunos nombres después de haber matcheados las diferencias....
#Código para matchear en Python 
# Código en excel para crear el texto desde una tabla: =CONCATENATE("df_alcaldes[df_alcaldes$Municipio == '",A1583,"', 'nombre'] <-  '",B1583,"'")

df_alcaldes[df_alcaldes$Municipio == 'Lucena del Cid', 'nombre'] <-  'Llucena/Lucena del Cid'
df_alcaldes[df_alcaldes$Municipio == 'Vistabella del Maestrazgo', 'nombre'] <-  'Vistabella del Maestrat'
df_alcaldes[df_alcaldes$Municipio == 'Illora', 'nombre'] <-  'Íllora'
df_alcaldes[df_alcaldes$Municipio == 'Itrabo', 'nombre'] <-  'Ítrabo'
df_alcaldes[df_alcaldes$Municipio == 'Arrazua-Ubarrundia', 'nombre'] <-  'Arratzua-Ubarrundia'
df_alcaldes[df_alcaldes$Municipio == 'Donostia-San Sebastián', 'nombre'] <-  'Donostia/San Sebastián'
df_alcaldes[df_alcaldes$Municipio == 'Espelúy', 'nombre'] <-  'Espeluy'
df_alcaldes[df_alcaldes$Municipio == 'Torre del Campo', 'nombre'] <-  'Torredelcampo'
df_alcaldes[df_alcaldes$Municipio == 'Estella/Lizarra', 'nombre'] <-  'Estella-Lizarra'
df_alcaldes[df_alcaldes$Municipio == 'Etxarri-Aranatz', 'nombre'] <-  'Etxarri Aranatz'
df_alcaldes[df_alcaldes$Municipio == 'Oitz', 'nombre'] <-  'Oiz'
df_alcaldes[df_alcaldes$Municipio == 'Uharte-Arakil', 'nombre'] <-  'Uharte Arakil'
df_alcaldes[df_alcaldes$Municipio == 'Urrotz', 'nombre'] <-  'Urroz'
df_alcaldes[df_alcaldes$Municipio == "Callosa d'En Sarrià", 'nombre'] <-  "Callosa d'en Sarrià"
df_alcaldes[df_alcaldes$Municipio == 'Roda de Barà', 'nombre'] <-  'Roda de Berà'
df_alcaldes[df_alcaldes$Municipio == 'Benigánim', 'nombre'] <-  'Benigànim'
df_alcaldes[df_alcaldes$Municipio == 'Benisanó', 'nombre'] <-  'Benissanó'
df_alcaldes[df_alcaldes$Municipio == 'Benisuera', 'nombre'] <-  'Benissuera'
df_alcaldes[df_alcaldes$Municipio == 'Potríes', 'nombre'] <-  'Potries'
df_alcaldes[df_alcaldes$Municipio == 'Sopelana', 'nombre'] <-  'Sopela'
        

remove(df_alcaldes_pre)

######################################################################################
####### Descarga de identificadores de municipios y provincias

#Esto era una descarga desde github
#df_municipios <- as.data.frame(read.csv("https://raw.githubusercontent.com/codeforspain/ds-organizacion-administrativa/master/data/municipios.csv"))
#df_provincias <- as.data.frame(read.csv("https://raw.githubusercontent.com/codeforspain/ds-organizacion-administrativa/master/data/provincias.csv"))
#df_munYProv <- merge.data.frame(df_municipios, df_provincias, by  = "provincia_id", all = TRUE)

#Descarga desde el portal de entidades locales 

download.file("https://ssweb.seap.minhap.es/REL/frontend/export_data/file_export/export_excel/municipios/all/all",
              destfile=paste0(path, "/datosalcaldes.csv"),
              mode='wb')
df_munYProv <- read.csv(paste0(path, "/datosAlcaldes.csv"))


###################
#########Crear fichero con todos los identificadores de las provincias
df_provincias1 <- as.data.frame(read.csv("https://raw.githubusercontent.com/codeforspain/ds-organizacion-administrativa/master/data/provincias.csv"))
df_provincias2 <- unique(df_munYProv[,c("Codigo.Provincia", "PROVINCIA")])
####Hay que cambiar algunos nombres...
df_provincias1$nombre <- as.character(df_provincias1$nombre)
df_provincias1[df_provincias1$nombre == "Alicante/Alacant", "nombre"] <- "Alacant/Alicante"
df_provincias1[df_provincias1$nombre == "Balears, Illes", c("nombre")] <- "Illes Balears"
df_provincias1[df_provincias1$nombre == "Castellón/Castelló", c("nombre")] <- "Castelló/Castellón"
df_provincias1[df_provincias1$nombre == "Valencia/València", c("nombre")] <- "València/Valencia"

df_provinciasID <- merge.data.frame(df_provincias1, 
                                    df_provincias2,
                                    by.x = "nombre",
                                    by.y = "PROVINCIA",
                                    all = TRUE)
remove(df_provincias1)
remove(df_provincias2)


write.csv(df_provinciasID, file = paste0(path, "/", "idProvincias.csv"), fileEncoding = "UTF-8")



#################
###### Fusionar con los alcaldes
####### El dataset final es un full outer join
##### OJO!!!!! Algunos nombres de localidades se repiten... Por eso concateno el id de provincial al nombre

df_alcaldes <- df_alcaldes[,c("Municipio", "Lista", "idProv")]
df_alcaldes$ID <- paste0(df_alcaldes$idProv,"-",df_alcaldes$Municipio)

df_munYProv <- merge.data.frame(df_munYProv,
                                df_provinciasID[,c("Codigo.Provincia", "provincia_id")],
                                by = "Codigo.Provincia" 
                                )
df_munYProv$ID <- paste0(df_munYProv$provincia_id,"-",df_munYProv$DENOMINACION)

df_final <- merge.data.frame(df_alcaldes, 
                             df_munYProv, 
                             by = "ID", 
                             all.y = TRUE)


remove(df_alcaldes)
remove(df_munYProv)


#######Preparar ficheros para matchear opciones
a <- df_final[is.na(df_final$Lista), c("ID","DENOMINACION")]

b <- merge.data.frame(df_alcaldes, 
                      df_munYProv, 
                      by = "ID", 
                      all.x = TRUE)
b <- b[is.na(b$DENOMINACION), c("ID","Municipio")]
b <- b[!is.na(b$Municipio),]

write.csv(a, file = paste0(path, "/", "orphanReference.csv"), fileEncoding = "UTF-8")
write.csv(b, file = paste0(path, "/", "orphanListas.csv"), fileEncoding = "UTF-8")


remove(a)
remove(b)


######### Salvamos el dataset
write.csv(df_final, file = paste0(path, "/", "munProvAlc.csv"), fileEncoding = "UTF-8")
