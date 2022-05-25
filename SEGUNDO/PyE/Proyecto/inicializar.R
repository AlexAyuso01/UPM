#script para inicializar los datos 

#set seed y creación de Data, S y Data 200
set.seed(2021)
#setwd("Path")
Data = read.csv( file=paste("PYE2DataSet","29",".csv",sep=""), header=TRUE)
S <- sample(1:dim(Data)[1],200); Data200 <- Data[S,]

#importación de librerías
librerias <- c("tidyverse", "broom", "plyr", 
        "ggplot2", "lattice", "Rmisc", "DescTools", "MASS", "car", "EstimationTools", "ISwR", "IMTest", "boot", "vcd", "rcompanion", "FSA", "psych", "e1071");
#require(librerias)
lapply(librerias, require, character.only = TRUE)
#do.call("require", x)
