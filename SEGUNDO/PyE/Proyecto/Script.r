# Dataset
auto <- read.csv("PYE2DataSet29.csv", header = T, sep =",")

# Librerias
library(base)
library(tidyverse)
library(broom)
library(plyr)
library(ggplot2)
library(lattice)
library(Rmisc)
library(DescTools)
library(MASS)
library(car)
library(EstimationTools)
library(ISwR)
library(IndependenceTests)
library(Imtest)
library(boot)
library(vcd)
library(rcompanion)
library(FSA)
library(psych)
library(e1071)
library(rriskDistributions)
library(stats)
library(dplyr)
library(TeachingDemos)

# Ajustes de sleeptime
set.seed(2022)
valores <- auto$sleeptime
fit.cont(valores)
hist(valores, freq = F, main = "Distribución de 30 medias de 200 elementos")

# Medias muestrales: histograma, boxplot y ajuste
set.seed(2022)
valores <- auto$Age
medias <- replicate(30, mean(sample(valores, size = 200)))
hist(medias, main = "Distribución de 30 medias de 200 elementos")
boxplot(medias, main = "Distribución de 30 medias de 200 elementos")
fit.cont(medias)
medias <- replicate(50, mean(sample(valores, size = 200)))
hist(medias, main = "Distribución de 50 medias de 200 elementos")
boxplot(medias, main = "Distribución de 50 medias de 200 elementos")
fit.cont(medias)
medias <- replicate(100, mean(sample(valores, size = 200)))
hist(medias, main = "Distribución de 100 medias de 200 elementos")
boxplot(medias, main = "Distribución de 100 medias de 200 elementos")
fit.cont(medias)

# Varianzas muestrales: histograma, boxplot y ajuste
set.seed(2022)
varianzas <- replicate(30, var(sample(valores, size = 200)))
hist(varianzas, main = "Distribución de 30 varianzas de 200 elementos")
boxplot(varianzas, main = "Distribución de 30 varianzas de 200 elementos")
fit.cont(varianzas)
varianzas <- replicate(50, var(sample(valores, size = 200)))
hist(varianzas, main = "Distribución de 50 varianzas de 200 elementos")
boxplot(varianzas, main = "Distribución de 50 varianzas de 200 elementos")
fit.cont(varianzas)
varianzas <- replicate(100, var(sample(valores, size = 200)))
hist(varianzas, main = "Distribución de 100 varianzas de 200 elementos")
boxplot(varianzas, main = "Distribución de 100 varianzas de 200 elementos")
fit.cont(varianzas)

# falta apartado 3 de proporciones
set.seed(2022)
valores <- auto$Sex
var <- sample(valores, size = 200)
muestra <- as.data.frame(var)
hombres <- filter(muestra, muestra == "M")
proporcion <- length(hombres$var) / length(muestra)

# Estimación de media y varianza de sleeptime
set.seed(2022)
valores <- auto$sleeptime
cat("La media poblacional de sleeptime es", mean(valores))
cat("La varianza poblacional de sleeptime es", var(valores))
valores <- sample(valores, size = 200)
cat("La media muestral de 200 datos de sleeptime es", mean(valores))
cat("La varianza muestral de 200 datos de sleeptime es", var(valores))

# Estimación de media y varianza de steps
set.seed(2022)
valores <- auto$steps
cat("La media poblacional de steps es", mean(valores))
cat("La varianza poblacional de steps es", var(valores))
valores <- sample(valores, size = 200)
cat("La media muestral de 200 datos de steps es", mean(valores))
cat("La varianza muestral de 200 datos de steps es", var(valores))

# Estimación de media y varianza de sleeptime entre mujeres
set.seed(2022)
valores <- filter(auto, auto$Sex == "M")
valores <- valores[,5]
cat("La media poblacional entre mujeres de sleeptime es", mean(valores))
cat("La varianza poblacional entre mujeres de sleeptime es", var(valores))
valores <- sample(valores, size = 200)
cat("La media muestral de 200 mujeres de sleeptime es", mean(valores))
cat("La varianza muestral de 200 mujeres de sleeptime es", var(valores))

# Estimación de media y varianza de steps entre mujeres
set.seed(2022)
valores <- filter(auto, auto$Sex == "M")
valores <- valores[,6]
cat("La media poblacional entre mujeres de steps es", mean(valores))
cat("La varianza poblacional entre mujeres de steps es", var(valores))
valores <- sample(valores, size = 200)
cat("La media muestral de 200 mujeres de steps es", mean(valores))
cat("La varianza muestral de 200 mujeres de steps es", var(valores))

# Estimación de media y varianza de sleeptime entre hombres
set.seed(2022)
valores <- filter(auto, auto$Sex == "V")
valores <- valores[,5]
cat("La media poblacional entre hombres de sleeptime es", mean(valores))
cat("La varianza poblacional entre hombres de sleeptime es", var(valores))
valores <- sample(valores, size = 200)
cat("La media muestral de 200 hombres de sleeptime es", mean(valores))
cat("La varianza muestral de 200 hombres de sleeptime es", var(valores))

# Estimación de media y varianza de steps entre hombres
set.seed(2022)
valores <- filter(auto, auto$Sex == "M")
valores <- valores[,6]
cat("La media poblacional entre hombres de steps es", mean(valores))
cat("La varianza poblacional entre hombres de steps es", var(valores))
valores <- sample(valores, size = 200)
cat("La media muestral de 200 hombres de steps es", mean(valores))
cat("La varianza muestral de 200 hombres de steps es", var(valores))

# Estimacion del intervalo de media, varianza y proporcion de M y V en sleeptime
set.seed(2022)
valorM <- filter(auto, auto$Sex == "M")
valorV <- filter(auto, auto$Sex == "V")
valorM <- valorM[,5]
valorV <- valorV[,5]
valoresM <- sample(valorM, size = 200)
valoresV <- sample(valorV, size = 200) 

zsum.test(mean.x = mean(valoresM), sigma.x = var(valorM), n.x=200, conf.level = 0.90)
zsum.test(mean.x = mean(valoresM), sigma.x = var(valorM), n.x=200, conf.level = 0.95)
zsum.test(mean.x = mean(valoresM), sigma.x = var(valorM), n.x=200, conf.level = 0.99)
zsum.test(mean.x = mean(valoresV), sigma.x = var(valorV), n.x=200, conf.level = 0.90)
zsum.test(mean.x = mean(valoresV), sigma.x = var(valorV), n.x=200, conf.level = 0.95)
zsum.test(mean.x = mean(valoresV), sigma.x = var(valorV), n.x=200, conf.level = 0.99)

t.test(valoresM, var.equal = FALSE, conf.level = 0.90)$conf.int
t.test(valoresM, var.equal = FALSE, conf.level = 0.95)$conf.int
t.test(valoresM, var.equal = FALSE, conf.level = 0.99)$conf.int
t.test(valoresV, var.equal = FALSE, conf.level = 0.90)$conf.int
t.test(valoresV, var.equal = FALSE, conf.level = 0.95)$conf.int
t.test(valoresV, var.equal = FALSE, conf.level = 0.99)$conf.int

var.test(valoresM, conf.level = 0.90)$conf.int
var.test(valoresM, conf.level = 0.95)$conf.int
var.test(valoresM, conf.level = 0.99)$conf.int
var.test(valoresV, conf.level = 0.90)$conf.int
var.test(valoresV, conf.level = 0.95)$conf.int
var.test(valoresV, conf.level = 0.99)$conf.int

prop.test(valoresM, valoresV, conf.level = 0.90)$conf.int
prop.test(valoresM, valoresV, conf.level = 0.95)$conf.int
prop.test(valoresM, valoresV, conf.level = 0.99)$conf.int


# Estimacion del intervalo de media, varianza y proporcion de M y V en step
set.seed(2022)
valoresM <- filter(auto, auto$Sex == "M")
valoresV <- filter(auto, auto$Sex == "V")
valoresM <- valoresM[,6]
valoresV <- valoresV[,6]
valoresM <- sample(valoresM, size = 200)
valoresV <- sample(valoresV, size = 200)

zsum.test(mean.x = mean(valoresM), sigma.x = var(valorM), n.x=200, conf.level = 0.90)
zsum.test(mean.x = mean(valoresM), sigma.x = var(valorM), n.x=200, conf.level = 0.95)
zsum.test(mean.x = mean(valoresM), sigma.x = var(valorM), n.x=200, conf.level = 0.99)
zsum.test(mean.x = mean(valoresV), sigma.x = var(valorV), n.x=200, conf.level = 0.90)
zsum.test(mean.x = mean(valoresV), sigma.x = var(valorV), n.x=200, conf.level = 0.95)
zsum.test(mean.x = mean(valoresV), sigma.x = var(valorV), n.x=200, conf.level = 0.99)

t.test(valoresM, var.equal = FALSE, conf.level = 0.90)$conf.int
t.test(valoresM, var.equal = FALSE, conf.level = 0.95)$conf.int
t.test(valoresM, var.equal = FALSE, conf.level = 0.99)$conf.int
t.test(valoresV, var.equal = FALSE, conf.level = 0.90)$conf.int
t.test(valoresV, var.equal = FALSE, conf.level = 0.95)$conf.int
t.test(valoresV, var.equal = FALSE, conf.level = 0.99)$conf.int

var.test(valoresM, conf.level = 0.90)$conf.int
var.test(valoresM, conf.level = 0.95)$conf.int
var.test(valoresM, conf.level = 0.99)$conf.int
var.test(valoresV, conf.level = 0.90)$conf.int
var.test(valoresV, conf.level = 0.95)$conf.int
var.test(valoresV, conf.level = 0.99)$conf.int

prop.test(valoresM, valoresV, conf.level = 0.90)$conf.int
prop.test(valoresM, valoresV, conf.level = 0.95)$conf.int
prop.test(valoresM, valoresV, conf.level = 0.99)$conf.int


# Estimacion del intervalo para la diferencia de media, varianza y proporcion de M y V en sleeptime
valoresM <- filter(auto, auto$Sex == "M")
valoresV <- filter(auto, auto$Sex == "V")
valoresM <- valoresM[,5]
valoresV <- valoresV[,5]
valoresM1 <- sample(valoresM, size = 200)
valoresM2 <- sample(valoresM, size = 200)
valoresV1 <- sample(valoresV, size = 200)
valoresV2 <- sample(valoresV, size = 200)

zsum.test(mean.x = mean(valoresM1), sigma.x = var(valorM), n.x=200, mean.y = mean(valoresM2), sigma.y = var(valorM2), n.y = 200, conf.level = 0.90)
zsum.test(mean.x = mean(valoresM1), sigma.x = var(valorM), n.x=200, mean.y = mean(valoresM2), sigma.y = var(valorM2), n.y = 200, conf.level = 0.95)
zsum.test(mean.x = mean(valoresM1), sigma.x = var(valorM), n.x=200, mean.y = mean(valoresM2), sigma.y = var(valorM2), n.y = 200, conf.level = 0.99)
zsum.test(mean.x = mean(valoresV1), sigma.x = var(valorV), n.x=200, mean.y = mean(valoresV2), sigma.y = var(valorV2), n.y = 200, conf.level = 0.90)
zsum.test(mean.x = mean(valoresV1), sigma.x = var(valorV), n.x=200, mean.y = mean(valoresV2), sigma.y = var(valorV2), n.y = 200, conf.level = 0.95)
zsum.test(mean.x = mean(valoresV1), sigma.x = var(valorV), n.x=200, mean.y = mean(valoresV2), sigma.y = var(valorV2), n.y = 200, conf.level = 0.99)

t.test(valoresM1, valoresM2, var.equal = TRUE, conf.level = 0.90)$conf.int
t.test(valoresM1, valoresM2, var.equal = TRUE, conf.level = 0.95)$conf.int
t.test(valoresM1, valoresM2, var.equal = TRUE, conf.level = 0.99)$conf.int
t.test(valoresV1, valoresV2, var.equal = TRUE, conf.level = 0.99)$conf.int
t.test(valoresV1, valoresV2, var.equal = TRUE, conf.level = 0.99)$conf.int
t.test(valoresV1, valoresV2, var.equal = TRUE, conf.level = 0.99)$conf.int

var.test(valoresM1, valoresM2 conf.level = 0.90)$conf.int
var.test(valoresM1, valoresM2 conf.level = 0.95)$conf.int
var.test(valoresM1, valoresM2 conf.level = 0.99)$conf.int
var.test(valoresV1, valoresV2 conf.level = 0.90)$conf.int
var.test(valoresV1, valoresV2 conf.level = 0.95)$conf.int
var.test(valoresV1, valoresV2 conf.level = 0.99)$conf.int

prop.test(c(valoresM1, ValoresM2), c(valoresV1, valoresV2), conf.level = 0.90)$conf.int
prop.test(c(valoresM1, ValoresM2), c(valoresV1, valoresV2), conf.level = 0.95)$conf.int
prop.test(c(valoresM1, ValoresM2), c(valoresV1, valoresV2), conf.level = 0.99)$conf.int

# Estimacion del intervalo para la diferencia de media, varianza y proporcion de M y V en step
valoresM <- filter(auto, auto$Sex == "M")
valoresV <- filter(auto, auto$Sex == "V")
valoresM <- valoresM[,5]
valoresV <- valoresV[,5]
valoresM1 <- sample(valoresM, size = 200)
valoresM2 <- sample(valoresM, size = 200)
valoresV1 <- sample(valoresV, size = 200)
valoresV2 <- sample(valoresV, size = 200)

zsum.test(mean.x = mean(valoresM1), sigma.x = var(valorM), n.x=200, mean.y = mean(valoresM2), sigma.y = var(valorM2), n.y = 200, conf.level = 0.90)
zsum.test(mean.x = mean(valoresM1), sigma.x = var(valorM), n.x=200, mean.y = mean(valoresM2), sigma.y = var(valorM2), n.y = 200, conf.level = 0.95)
zsum.test(mean.x = mean(valoresM1), sigma.x = var(valorM), n.x=200, mean.y = mean(valoresM2), sigma.y = var(valorM2), n.y = 200, conf.level = 0.99)
zsum.test(mean.x = mean(valoresV1), sigma.x = var(valorV), n.x=200, mean.y = mean(valoresV2), sigma.y = var(valorV2), n.y = 200, conf.level = 0.90)
zsum.test(mean.x = mean(valoresV1), sigma.x = var(valorV), n.x=200, mean.y = mean(valoresV2), sigma.y = var(valorV2), n.y = 200, conf.level = 0.95)
zsum.test(mean.x = mean(valoresV1), sigma.x = var(valorV), n.x=200, mean.y = mean(valoresV2), sigma.y = var(valorV2), n.y = 200, conf.level = 0.99)

t.test(valoresM1, valoresM2, var.equal = TRUE, conf.level = 0.90)$conf.int
t.test(valoresM1, valoresM2, var.equal = TRUE, conf.level = 0.95)$conf.int
t.test(valoresM1, valoresM2, var.equal = TRUE, conf.level = 0.99)$conf.int
t.test(valoresV1, valoresV2, var.equal = TRUE, conf.level = 0.99)$conf.int
t.test(valoresV1, valoresV2, var.equal = TRUE, conf.level = 0.99)$conf.int
t.test(valoresV1, valoresV2, var.equal = TRUE, conf.level = 0.99)$conf.int

var.test(valoresM1, valoresM2 conf.level = 0.90)$conf.int
var.test(valoresM1, valoresM2 conf.level = 0.95)$conf.int
var.test(valoresM1, valoresM2 conf.level = 0.99)$conf.int
var.test(valoresV1, valoresV2 conf.level = 0.90)$conf.int
var.test(valoresV1, valoresV2 conf.level = 0.95)$conf.int
var.test(valoresV1, valoresV2 conf.level = 0.99)$conf.int

prop.test(c(valoresM1, ValoresM2), c(valoresV1, valoresV2), conf.level = 0.90)$conf.int
prop.test(c(valoresM1, ValoresM2), c(valoresV1, valoresV2), conf.level = 0.95)$conf.int
prop.test(c(valoresM1, ValoresM2), c(valoresV1, valoresV2), conf.level = 0.99)$conf.int

# Falta estimación por intervalos


# Estimación bayesiana 
#Obtencion de la distribucion a posteriori
set.seed(2022)
muestra <- sample(auto$Nation, size = 200)
pob <- c(0.25, 0.35)
nE <- sum(muestra == "SP")
med <- mean(nE)
moda <- (5 - 1)/(5 + 10 - 1)
dbeta(pob, 5, 10)
dbeta(med, 5, 10)
curve(dbeta(x, 5, 10), main = "Densidad")
curve(dbeta(x, nE + 5, 200 - nE + 10), main = "Distribución a Posteriori")
# Obtenemos IC al 95%
taila <- qbeta(0.025, 5, 10)
tailb <- qbeta(0.025 ,nE + 5,200 - nE + 10, lower.tail = F)
#IC <- [0.1276, 0.4137]
# Estimación altura
set.seed(2022)
nation <- sample(auto$Nation, size = 200)
height <- sample(auto$height, size = 200)
muestra <- data.frame(nation, height)
muestra <- filter(muestra, muestra$nation == "SP"| muestra$nation == "FR" | muestra$nation == "IT")
medh <- mean(mueh)
var <- sqrt(var(muestrah))
npost <- (var^2)/(7^2)
medpost <- (200 * medh + npost * 7)/(200 + npost)
spost <- var/(sqrt(200 + npost))

# Contrastes paramétricos con p-valor
set.seed(2022)
valores <- auto$IMC
muestra <- sample(valores, size = 200)
summary(muestra)
cat("el valor del Q1 es", val <- 24.45)
t.test(muestra, alternative = "greater", mu = val)
cat("p-value < 2.2e-16. Se rechaza la hipótesis nula y
    podemos afirmar que la media muestral es mayor que Q1")
cat("el valor del Q3 es", val <- 25.52)
t.test(muestra, alternative = "less", mu = val)
cat("p-value < 2.2e-16. Se rechaza la hipótesis nula y
    podemos afirmar que la media muestral es menor que Q3")
sigma.test(muestra, sigmasq = 1, alternative = "greater")
cat("p-value = 1. Se acepta la hipótesis nula y 
    podemos afirmar que la varianza muestral es menor que 1")
muestra2 <- sample(valores, size = 200)
t.test(muestra, muestra2, alternative = "two.sided", var.equal = TRUE)
cat("p-value = 0.6244 > 0.2. Se acepta la hipótesis nula y 
    podemos afirmar que la diferencia de medias muestrales
    es aproximademente 0")
var.test(muestra, muestra2)
cat("p-value = 0.3436 > 0.2. Se acepta la hipótesis nula y 
    podemos afirmar que el ratio de las medias muestrales
    es aproximademente 1")

# Contraste no paraméticos con nivel de significación
set.seed(2022)
alpha <- 0.05
valores <- auto$IMC
m <- sample(valores, size = 200)
m <- replace(m, m <= 23.5 , 1)
m <- replace(m, m > 23.5 & m <= 24 , 2)
m <- replace(m, m > 24 & m <= 24.5 , 3)
m <- replace(m, m > 24.5 & m <= 25 , 4)
m <- replace(m, m > 25 & m <= 25.5 , 5)
m <- replace(m, m > 25.5 & m <= 26 , 6)
m <- replace(m, m > 26 & m <= 26.5 , 7)
m <- replace(m, m > 26.5, 8)
frecuencias <- as.data.frame(table(m))
frecuencias <- frecuencias$Freq
n <- sum(frecuencias)
clases <- c(23, 23.5, 24, 24.5, 25, 25.5, 26, 26.5, 27)
prob <- c(1:8)
media <- mean(auto$IMC)
sigma <- sd(auto$IMC)
prob[1] <- pnorm(clases[1], media, sigma)
for (i in 2:7){
    prob[i] <- (pnorm(clases[i + 1], media, sigma) -
        pnorm(clases[i], media, sigma))
}
prob[8] <- 1 - pnorm(clases[7], media, sigma)
probTotal <- sum(prob)
for (i in 1:8){
    prob[i] <- prob[i] / probTotal
}
chisq.test(frecuencias, p = prob, rescale.p = TRUE)