# PRACTICA: Dataframes

# creacion de un data frame
semestre <- c(3,7,7,3,3,4,8)
edad <- c(18,22,21,19,18,18,20)
carrera <- c("economia","contaduria","contaduria","economia","economia","economia","contaduria")
repitente <- c("no","si","no","no","si","no","si")
estudiantes.df <- data.frame(edad,carrera,semestre,repitente)
estudiantes.df
str(estudiantes.df)
summary(estudiantes.df)

# lectura y escritura en el dataframe
estudiantes.df[1,]
estudiantes.df[,2]
estudiantes.df["edad"]
estudiantes.df[,"edad"]
estudiantes.df$edad
estudiantes.df$semestre[1:4]
estudiantes.df$carrera == "economia"
from.economy <- estudiantes.df$carrera == "economia"
estudiantes.df[from.economy,]
estudiantes.df[from.economy,"semestre"]

# sub-seleccion del dataframe
subset(estudiantes.df, subset = repitente == "no")
subset(estudiantes.df, subset = repitente == "no", select = -repitente)
subset(estudiantes.df, subset = repitente == "no", select = -c(edad,carrera))
subset(estudiantes.df, subset = repitente == "no", select = c(edad,semestre))
subset(estudiantes.df, subset = edad >= 18)

# agregar y descartar columnas
estudiantes.df$becado <- rep("si",7) 
estudiantes.df$becado <- NULL
estudiantes.df <- cbind(estudiantes.df, becado = rep("si",7))
estudiantes.df <- estudiantes.df[,-5]

# agregar y descartar observaciones
extra.df <- data.frame(edad=c(18,19), carrera=c("ingenieria","ingenieria"), semestre=c(4,4), repitente=c("no","no"))
estudiantes.df <- rbind(estudiantes.df, extra.df)
