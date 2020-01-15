# PRACTICA: LIMPIEZA DE DATOS

# lectura de dataset
datos <- read.table(file="datos.csv")
datos <- read.table(file="datos.csv", sep = ",")
datos <- read.table(file="datos.csv", sep = ",", header = TRUE)

# resumen del dataframe cargado
summary(datos)
# estructura del dataframe cargado
str(datos)

# visualizacion del dataframe
datos.limpios
head(datos.limpios)

# eliminacion/descarte de una columna
datos.limpios <- subset(datos, select = -ID)

# filtrado
filter(datos.limpios, lugar == "")
datos.limpios <- filter(datos.limpios, lugar != "")

# limpieza
datos.limpios$edad <- abs(datos.limpios$edad)

# agregando variables
datos.limpios$edad.intervalo <- cut(datos.limpios$edad, breaks = c(0,20,30), include.lowest = T)

# filtrado
datos.limpios$reincidente %in% c("si","no")
datos.limpios$reincidente.fix <- datos.limpios$reincidente
datos.limpios$reincidente.fix[!datos.limpios$reincidente %in% c("si","no")] <- NA
summary(datos.limpios)

# limpieza
datos.limpios.2 <- datos.limpios[-c(11,12),]
datos.limpios.2 <- droplevels(datos.limpios.2)
str(datos.limpios.2)

# visualizacion basica
plot(datos.limpios.2$edad,datos.limpios.2$monto)

# correlacion entre columnas del dataset
cor(datos.limpios.2$edad, datos.limpios.2$monto)

# visualizacion usando diagramas de cajas
plot(datos.limpios.2$reincidente.fix, datos.limpios.2$monto)
points(as.numeric(datos.limpios.2$reincidente.fix),
       jitter(x = datos.limpios.2$monto), col="red", pch=16)

# histogramas y graficas de densidad
hist(datos.limpios.2$edad)
hist(datos.limpios.2$monto)
plot(density(datos.limpios.2$edad))
plot(density(datos.limpios.2$monto))


