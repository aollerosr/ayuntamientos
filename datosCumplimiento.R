#############################################################################
#### Datos de id-NIF ayuntamientos + cumplimiento
#### Los datos se obtienen a partir de pythong

a1 <- read.csv("/home/antonio/Python/resultados2013", header = FALSE)
a2 <- read.csv("/home/antonio/Python/resultadosaaa2013", header = FALSE)

a1 <- a1[!is.na(a1$V2),]
a2 <- a2[!is.na(a2$V2),]

df_cumplimiento2013 <- rbind(a1,a2)

remove(a1)
remove(a2)

colnames(df_cumplimiento2013) <- c("rendicionCuentasID", "NIF", "tipoYNombre")

df_cumplimiento2014 <- read.csv("/home/antonio/ayuntamientos/datos/NIFs_2014.csv")
colnames(df_cumplimiento2014) <- c("rendicionCuentasID", "NIF")
df_cumplimiento2014$tipoYNombre <- ""

df_cumplimiento2015 <- read.csv("/home/antonio/ayuntamientos/datos/NIFs_2015.csv")
colnames(df_cumplimiento2015) <- c("rendicionCuentasID", "NIF")
df_cumplimiento2015$tipoYNombre <- ""

df_cumplimiento <- rbind(df_cumplimiento2013, df_cumplimiento2014, df_cumplimiento2015)

df_cumplimiento <- unique(df_cumplimiento[,c("NIF", "rendicionCuentasID")])


df_cumplimiento2013$cumple2013 <- "TRUE"
df_cumplimiento2014$cumple2014 <- "TRUE"
df_cumplimiento2015$cumple2015 <- "TRUE"

df_cumplimiento <- merge.data.frame(df_cumplimiento,
                                    df_cumplimiento2013[, c("NIF", "tipoYNombre" ,"cumple2013")],
                                    by = "NIF",
                                    all.x = TRUE)



df_cumplimiento <- merge.data.frame(df_cumplimiento,
                                    df_cumplimiento2014[, c("NIF", "cumple2014")],
                                    by = "NIF",
                                    all.x = TRUE)

df_cumplimiento <- merge.data.frame(df_cumplimiento,
                                    df_cumplimiento2015[, c("NIF", "cumple2015")],
                                    by = "NIF",
                                    all.x = TRUE)



write.csv(df_cumplimiento, file = paste0(path, "/", "cumplimiento.csv"), fileEncoding = "UTF-8")

setdiff(df_cumplimiento2014$NIF, df_cumplimiento$NIF)
setdiff(df_cumplimiento2015$NIF, df_cumplimiento$NIF)


remove(df_cumplimiento2013)
remove(df_cumplimiento2014)
remove(df_cumplimiento2015)

###################################################
#Parser para separar nombre y tipo de entidad
#Por terminar

df_cumplimiento <- read.csv("/home/antonio/ayuntamientos/datos/datosFinales/cumplimiento.csv")

df_cumplimiento$tipo <- 1
df_cumplimiento$nombre <- 1

for(i in 1:length(df_cumplimiento$tipoYNombre)){
  if(!is.na(df_cumplimiento[i,"tipoYNombre"])){
  df_cumplimiento[i,"tipo"] <- parseTipo(df_cumplimiento[i,"tipoYNombre"])
  df_cumplimiento[i,"nombre"] <- parseNombre(df_cumplimiento[i,"tipoYNombre"])
  }
}


parseTipo <- function(strng){
  switch(substr(strng,1,3),
         "Ayu" = substr(strng,1,12),
         "Dip" = substr(strng,1,10),
         "Con" = substr(strng,1,15),
         "Man" = substr(strng,1,12),
         "Cab" = substr(strng,1,15),
         "Com" = substr(strng,1,7), 
         "Agr" = substr(strng,1,10),    
         "Áre" = substr(strng,1,18)    
  )
}

parseNombre <- function(strng){
  strng <- as.character(strng)
  switch(substr(strng,1,3),
         "Ayu" = substr(strng,14,nchar(strng)),
         "Dip" = substr(strng,12,nchar(strng)),
         "Con" = substr(strng,17,nchar(strng)),
         "Man" = substr(strng,14,nchar(strng)),
         "Cab" = substr(strng,17,nchar(strng)),
         "Com" = substr(strng,9,nchar(strng)), 
         "Agr" = substr(strng,12,nchar(strng)),    
         "Áre" = substr(strng,20,nchar(strng))    
  )
}





