########################################################################
#Script para crear un dataset con datos de referencia de ayuntamientos
#incluyendo las listas que los gobiernan

#Manejamos tres inputs:
#   1.- listas => Datos con las listas que gobiernan la entidad local
#       Obtenido del portal de entidades locales (Ministerio de Hacienda y AAPP)
#       https://ssweb.seap.minhap.es/portalEELL/consulta_alcaldes/alcaldes?id_provincia=  (hay que añadir el código de provincia)
#   2.- refMunicipios => Reference data de los municipios
#       Obtenido del portal de entidades locales
#       https://ssweb.seap.minhap.es/REL/frontend/export_data/file_export/export_excel/municipios/all/all
#   3.- Usamos un fichero con reference data de provincias para añadir un identificador de provincias a 2 y así poder comparar 1 y 2
#       Obtenido de: https://raw.githubusercontent.com/codeforspain/ds-organizacion-administrativa/master/data/provincias.csv


path <- paste0("/home/antonio/ayuntamientos/datos/datosFuente") #path genérico para los datos. Todos los ficheros tienen que estar descargados aquí


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

files <- list.files(path, pattern = "xlsx") #vector con todos los ficheros xls en el directorio
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

df_alcaldes <- df_alcaldes[!is.na(df_alcaldes$Municipio),] #Hay que borrar algunos registros que se crean con nulls, supongo que por cómo están hecho los Excels...

remove(df_alcaldes_pre)
remove(files)
remove(i)

#Creamos una nueva variable con los nombres que podemos comparar con el fichero de reference data
df_alcaldes$NomMun2 <- as.character(df_alcaldes$Municipio)


# Cambiamos algunos nombres para poder hacer un merge de los dos datasets principales
# Código en excel para crear el texto desde una tabla: =CONCATENATE("df_alcaldes[df_alcaldes$Municipio == '",A1583,"', 'nombre'] <-  '",B1583,"'")

df_alcaldes[df_alcaldes$NomMun2 == 'Lucena del Cid', 'NomMun2'] <-  'Llucena/Lucena del Cid'
df_alcaldes[df_alcaldes$NomMun2 == 'Vistabella del Maestrazgo', 'NomMun2'] <-  'Vistabella del Maestrat'
df_alcaldes[df_alcaldes$NomMun2 == 'Illora', 'NomMun2'] <-  'Íllora'
df_alcaldes[df_alcaldes$NomMun2 == 'Itrabo', 'NomMun2'] <-  'Ítrabo'
df_alcaldes[df_alcaldes$NomMun2 == 'Arrazua-Ubarrundia', 'NomMun2'] <-  'Arratzua-Ubarrundia'
df_alcaldes[df_alcaldes$NomMun2 == 'Donostia-San Sebastián', 'NomMun2'] <-  'Donostia/San Sebastián'
df_alcaldes[df_alcaldes$NomMun2 == 'Espelúy', 'NomMun2'] <-  'Espeluy'
df_alcaldes[df_alcaldes$NomMun2 == 'Torre del Campo', 'NomMun2'] <-  'Torredelcampo'
df_alcaldes[df_alcaldes$NomMun2 == 'Estella/Lizarra', 'NomMun2'] <-  'Estella-Lizarra'
df_alcaldes[df_alcaldes$NomMun2 == 'Etxarri-Aranatz', 'NomMun2'] <-  'Etxarri Aranatz'
df_alcaldes[df_alcaldes$NomMun2 == 'Oitz', 'NomMun2'] <-  'Oiz'
df_alcaldes[df_alcaldes$NomMun2 == 'Uharte-Arakil', 'NomMun2'] <-  'Uharte Arakil'
df_alcaldes[df_alcaldes$NomMun2 == 'Urrotz', 'NomMun2'] <-  'Urroz'
df_alcaldes[df_alcaldes$NomMun2 == "Callosa d'En Sarrià", 'NomMun2'] <-  "Callosa d'en Sarrià"
df_alcaldes[df_alcaldes$NomMun2 == 'Roda de Barà', 'NomMun2'] <-  'Roda de Berà'
df_alcaldes[df_alcaldes$NomMun2 == 'Benigánim', 'NomMun2'] <-  'Benigànim'
df_alcaldes[df_alcaldes$NomMun2 == 'Benisanó', 'NomMun2'] <-  'Benissanó'
df_alcaldes[df_alcaldes$NomMun2 == 'Benisuera', 'NomMun2'] <-  'Benissuera'
df_alcaldes[df_alcaldes$NomMun2 == 'Potríes', 'NomMun2'] <-  'Potries'
df_alcaldes[df_alcaldes$NomMun2 == 'Sopelana', 'NomMun2'] <-  'Sopela'
df_alcaldes[df_alcaldes$NomMun2 == 'Salvatierra/Agurain', 'NomMun2'] <-  'Agurain/Salvatierra'
df_alcaldes[df_alcaldes$NomMun2 == 'Adsubia', 'NomMun2'] <- "Atzúbia, l"  
df_alcaldes[df_alcaldes$NomMun2 == "Callosa d'en Sarrià", 'NomMun2'] <- "Callosa d'En Sarrià"  
df_alcaldes[df_alcaldes$NomMun2 == 'Arratzua-Ubarrundia', 'NomMun2'] <- 'Arrazua-Ubarrundia' 
df_alcaldes[df_alcaldes$NomMun2 == 'Illar', 'NomMun2'] <-  'Íllar'
df_alcaldes[df_alcaldes$NomMun2 == 'Manjabálago', 'NomMun2'] <-  'Manjabálago y Ortigosa de Rioalmar'
df_alcaldes[df_alcaldes$NomMun2 == 'Deyá', 'NomMun2'] <-  'Deià'
df_alcaldes[df_alcaldes$NomMun2 == 'Maó', 'NomMun2'] <-  'Maó-Mahón'
df_alcaldes[df_alcaldes$NomMun2 == 'Palma', 'NomMun2'] <-  'Palma de Mallorca'
df_alcaldes[df_alcaldes$NomMun2 == 'Santa Eulalia del Río', 'NomMun2'] <-  'Santa Eulària des Riu'
df_alcaldes[df_alcaldes$NomMun2 == 'Castrillo Matajudíos', 'NomMun2'] <-  'Castrillo Mota de Judíos'
df_alcaldes[df_alcaldes$NomMun2 == 'Collado', 'NomMun2'] <-  'Collado de la Vera'
df_alcaldes[df_alcaldes$NomMun2 == 'Alquerías del Niño Perdido', 'NomMun2'] <-  'Alqueries, les/Alquerías del Niño Perdido'
df_alcaldes[df_alcaldes$NomMun2 == 'Sarratella', 'NomMun2'] <-  'Serratella, la'
df_alcaldes[df_alcaldes$NomMun2 == 'Benasal', 'NomMun2'] <-  'Benassal'
df_alcaldes[df_alcaldes$NomMun2 == 'Chert/Xert', 'NomMun2'] <-  'Xert'
df_alcaldes[df_alcaldes$NomMun2 == 'Arcas del Villar', 'NomMun2'] <-  'Arcas'
df_alcaldes[df_alcaldes$NomMun2 == 'Pozorrubio', 'NomMun2'] <-  'Pozorrubio de Santiago'
df_alcaldes[df_alcaldes$NomMun2 == 'Guajares, Los', 'NomMun2'] <-  'Guájares, Los'
df_alcaldes[df_alcaldes$NomMun2 == 'Güejar Sierra', 'NomMun2'] <-  'Güéjar Sierra'
df_alcaldes[df_alcaldes$NomMun2 == 'Otura', 'NomMun2'] <-  'Villa de Otura'
df_alcaldes[df_alcaldes$NomMun2 == 'Bidegoian', 'NomMun2'] <-  'Bidania-Goiatz'  #Confirmar!!!!
df_alcaldes[df_alcaldes$NomMun2 == 'Torla', 'NomMun2'] <-  'Torla-Ordesa'
df_alcaldes[df_alcaldes$NomMun2 == 'Atez', 'NomMun2'] <-  'Atez/Atetz'
df_alcaldes[df_alcaldes$NomMun2 == 'Barañain', 'NomMun2'] <-  'Barañáin/Barañain'
df_alcaldes[df_alcaldes$NomMun2 == 'Echarri', 'NomMun2'] <-  'Echarri/Etxarri'
df_alcaldes[df_alcaldes$NomMun2 == 'Leache', 'NomMun2'] <-  'Leache/Leatxe'
df_alcaldes[df_alcaldes$NomMun2 == 'Ollo', 'NomMun2'] <-  'Valle de Ollo/Ollaran'
df_alcaldes[df_alcaldes$NomMun2 == 'Vilaflor', 'NomMun2'] <-  'Vilaflor de Chasna'
df_alcaldes[df_alcaldes$NomMun2 == 'Lantejuela, La', 'NomMun2'] <-  'Lantejuela'
df_alcaldes[df_alcaldes$NomMun2 == 'Alboraya', 'NomMun2'] <-  'Alboraia/Alboraya'
df_alcaldes[df_alcaldes$NomMun2 == 'El Puig de Santa María', 'NomMun2'] <-  'Puig de Santa Maria, el'
df_alcaldes[df_alcaldes$NomMun2 == 'Montroy', 'NomMun2'] <-  'Montroi/Montroy'
df_alcaldes[df_alcaldes$NomMun2 == 'Real de Gandía', 'NomMun2'] <-  'Real de Gandia, el'
df_alcaldes[df_alcaldes$NomMun2 == 'Villalonga', 'NomMun2'] <-  'Vilallonga/Villalonga'


######################################################################################
####### Descarga de identificadores de municipios y provincias

#Esto era una descarga desde github
#df_municipios <- as.data.frame(read.csv("https://raw.githubusercontent.com/codeforspain/ds-organizacion-administrativa/master/data/municipios.csv"))
#df_provincias <- as.data.frame(read.csv("https://raw.githubusercontent.com/codeforspain/ds-organizacion-administrativa/master/data/provincias.csv"))
#df_munYProv <- merge.data.frame(df_municipios, df_provincias, by  = "provincia_id", all = TRUE)

#Descarga desde el portal de entidades locales 

download.file("https://ssweb.seap.minhap.es/REL/frontend/export_data/file_export/export_excel/municipios/all/all",
              destfile=paste0(path, "/IDsMunProv.csv"),
              mode='wb')
df_munYProv <- read.csv(paste0(path, "/IDsMunProv.csv"))


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
#df_provinciasID <- read.csv("/home/antonio/ayuntamientos/datos/datosFinales/idProvincias.csv")



#################
###### Fusionar con los alcaldes
####### El dataset final es un full outer join
##### OJO!!!!! Algunos nombres de localidades se repiten... Por eso concateno el id de provincial al nombre

#df_alcaldes <- df_alcaldes[,c("Municipio", "Lista", "idProv", "NomMun2")]
df_alcaldes$ID <- paste0(df_alcaldes$idProv,"-",df_alcaldes$NomMun2)

df_munYProv <- merge.data.frame(df_munYProv,
                                df_provinciasID[,c("Codigo.Provincia", "provincia_id")],
                                by = "Codigo.Provincia" 
                                )
df_munYProv$ID <- paste0(df_munYProv$provincia_id,"-",df_munYProv$DENOMINACION)

df_final <- merge.data.frame(df_alcaldes, 
                             df_munYProv, 
                             by = "ID", 
                             all.y = TRUE)


df_final$alcalde <- paste0(df_final$Nombre, "_", df_final$Apellido, "_", df_final$Apellido.1)
df_final <- df_final[ , c("ID", "Municipio", "fecha_posesion", "Lista", "idProv", "Codigo.Provincia", 
                          "CODIGO_CA", "COMUNIDAD_AUTONOMA", "PROVINCIA", "NUMERO_INSCRIPCION", "Codigo.Municipio", 
                          "DENOMINACION", "FECHA_INSCRIPCION", "SUPERFICIE", "HABITANTES", 
                          "DENSIDAD", "CAPITALIDAD", "alcalde")]

colnames(df_final) <- c("ID", "municipioNombreListas", "alcaldeFechaPosesion", "municipioLista", "provinciaCodigoAlfabetico", "ProvinciaCodigo", 
                        "CAcodigo", "CANombre", "provinciaNombre", "municipioNumeroInscripcion", "municipioCodigo", 
                        "municipioNombreReferece", "municipioFechaInscripcion", "municipioSuperficie", "municipioHabitantes",
                        "municipioDensidad", "municipioCapitalidad", "municipioAlcalde")



#######Preparar ficheros para matchear opciones
a <- df_final[is.na(df_final$Lista), c("ID","DENOMINACION", "provincia_id")] #Este df contiene los municipios que no tienen lista asignada

b <- merge.data.frame(df_alcaldes, 
                      df_munYProv, 
                      by = "ID", 
                      all.x = TRUE)
b <- b[is.na(b$DENOMINACION), c("ID","Municipio", "idProv")]
b <- b[!is.na(b$Municipio),] #Este df contiene los municipios que tienen lista pero no tienen reference data con la misma denominación

colnames(a) <- c("ID", "Nombre", "idProv")
colnames(b) <- c("ID", "Nombre", "idProv")

######Importante!!!!
#Cambiamos del b al a (es decir, el de b en la primera celda, y el de a en la segunda)
#=CONCATENATE("df_alcaldes[df_alcaldes$NomMun2 == '",B11,"', 'NomMun2'] <-  '",C11,"'")

for(i in 1:52){
  df_aIntProv <- a[a$idProv == i, ] 
  df_bIntProv <- b[b$idProv == i, ]
  if(is.na(df_bIntProv[1,1]) == FALSE && is.na(df_aIntProv[1,1]) == FALSE){
    df_aIntProv$Origen <- 'a'
    df_bIntProv$Origen <- 'b'
    df_intProv <- rbind(df_aIntProv, df_bIntProv)
    write.csv(df_intProv, file = paste0(path, "/", "matchPorProvincias", i ,".csv"), fileEncoding = "UTF-8")
    
  }
}


write.csv(a, file = paste0(path, "/", "orphanReference.csv"), fileEncoding = "UTF-8")
write.csv(b, file = paste0(path, "/", "orphanListas.csv"), fileEncoding = "UTF-8")


remove(a)
remove(b)
remove(df_alcaldes)
remove(df_munYProv)


######### Salvamos el dataset
write.csv(df_final, file = paste0(path, "/", "munProvAlc.csv"), fileEncoding = "UTF-8")
