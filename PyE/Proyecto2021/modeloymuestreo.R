#source("inicializar.R",local=TRUE);

#PARTE 1
###Ajuste de modelo

#Sleeptime y steps
sink("Resultados 1A_1.txt");
summary(Data$sleeptime)
png(filename = paste(paste("Histograma", "sleeptime", sep="_"), ".png", sep=""));
hist(Data$sleeptime);
dev.off();

summary(Data$steps)
png(filename = paste(paste("Histograma", "steps", sep="_"), ".png", sep=""));
hist(Data$steps);
dev.off();
sink()

sink("Resultados 1A_2.txt")
slptm <- Data$sleeptime
##D.Normal

normal <- fitdistr(slptm, "normal")
    png(filename = paste(paste("1A_2", "Histograma", "D.Normal", "sleeptime", sep="_"), ".png", sep=""))
    #histograma
    hist(Data$sleeptime, pch=20, breaks=35, prob=TRUE, main="")
    curve(dnorm(x, normal$estimate[1], normal$estimate[2]), col="red", lwd=2, add=T)
    dev.off()
    #Test de K-S
    normtest<-ks.test(slptm,"pnorm")
    normtest


##D.Gamma
gamma <- fitdistr(slptm, "gamma",lower = c(0, 0))
    png(filename = paste(paste("1A_2", "Histograma", "D.Gamma", "sleeptime", sep="_"), ".png", sep=""))
    #histograma
    hist(x=Data$sleeptime, breaks=35, prob=TRUE, main="")
    curve(dgamma(x, gamma$estimate[1], gamma$estimate[2]), col="red", lwd=2, add=T)
    dev.off()
    #Test de K-S
    gammatest<-ks.test(slptm,"pgamma",shape=gamma$estimate[1],rate=gamma$estimate[2])
    gammatest
    

##D.Exponencial
expo <- fitdistr(slptm, "exponential")
    png(filename = paste(paste("1A_2", "Histograma", "D.Exponencial", "sleeptime", sep="_"), ".png", sep=""))
    #histograma
    hist(x=Data$sleeptime, breaks=35, prob=TRUE, main="")
    curve(dexp(x, expo$estimate[1]), col="red", lwd=2, add=T)
    dev.off()
    #Test de K-S
    expotest<-ks.test(slptm,"pexp",rate=expo$estimate[1])
    expotest

sink()

###Muestreo
muestreoTipo <- function(n,tipo,method = NA){
  MatrixM = matrix(NA,nrow = n,ncol = 1)
  #Tomamos n muestras
  for(i in 1:n){ 
    if(tipo == "meanAge" | tipo == "varAge"){
      set.seed(2021)
      SampleM <- replicate(n, Data$Age[sample(1:dim(Data)[1],200)],)
      MatrixM[i,] <- method(SampleM[,i])
    } else if(tipo == "propSex"){
      set.seed(2021)
      SampleM <- replicate(n, Data$Sex[sample(1:dim(Data)[1],200)],)
      MatrixM[i,] <- table(SampleM[,i])[1]/200
    }
  }
  normal <- fitdistr(MatrixM, "normal")
  png(filename = paste(paste("1B", tipo, "ajuste", n, sep="_"), ".png", sep=""))
  hist(x=MatrixM, breaks=35, prob=TRUE, main="")
  curve(dnorm(x, normal$estimate[1], normal$estimate[2]), col="red", lwd=2, add=T)
  dev.off()
  png(filename = paste(paste("1B", tipo, "boxplot", n, sep="_"), ".png", sep=""))
  boxplot(MatrixM)
  dev.off()
}

prevwd <- getwd()
setwd(paste(getwd(), "//", "output", sep=""))
#1B
muestreoTipo(30,"meanAge",mean)
muestreoTipo(50,"meanAge",mean)
muestreoTipo(100,"meanAge",mean)
muestreoTipo(30,"varAge",var)
muestreoTipo(50,"varAge",var)
muestreoTipo(100,"varAge",var)
muestreoTipo(30,"propSex")
muestreoTipo(50,"propSex")
muestreoTipo(100,"propSex")

setwd(prevwd)

####################################################################################################################################
####################################################################################################################################

##PARTE 2. Estimacion Clasica
#a
estimacion <- function(){
  for( genero in c("Mujeres", "Varones", "Mujeres y Varones")){
    if(genero == "Mujeres"){
      DataX <- Data[Data[, "Sex"] == "M",]; #Dataframe con solo mujeres de Data
    } else if(genero == "Varones"){
      DataX <- Data[Data[, "Sex"] == "V",]; #Dataframe con solo varones de Data
    } else{
      DataX <- Data;                        
    }
    for(column in c("sleeptime", "steps")){
      cat("Estimacion media ", column, " ", genero, ", con todos los datos: ", mean(DataX$sleeptime), "\n", sep="")
      cat("Estimacion varianza ", column, " ", genero, ", con todos los datos: ", var(DataX$sleeptime), "\n", sep="")
      set.seed(2021)
      SampleM <- DataX[,column][sample(1:dim(DataX)[1],200)];
      cat("Estimacion media ", column, " ", genero, ", con muestra de 200: ", mean(SampleM), "\n", sep="")
      cat("Estimacion varianza ", column, " ", genero, ", con muestra de 200: ", var(SampleM), "\n", sep="")
    }
  }
}

sink("Resultados 2A.txt");
estimacion()
sink();

#b
#Estimacion de intervalo de confianza para media, varianza, proporcion
# al nvl de confianza 90, 95, 99
# para las variables sleeptime y steps
# segun sex Mujeres y Varones

# Primero suponer normalidad y segundo usar Bootstrap para
# el caso de poblaciones de distribucion general o arbitraria. 
# Para la media suponer primero varianza conocida y segundo desconocida.



estimacionConf <- function(){
  for( genero in c("Mujeres", "Varones", "Mujeres y Varones")){
    if(genero == "Mujeres"){
      DataX <- Data[Data[, "Sex"] == "M",];
    } else if(genero == "Varones"){
      DataX <- Data[Data[, "Sex"] == "V",];
    } else{ 
      DataX <- Data;
    }
    #checkseed();
    set.seed(2021)
    SampleM <- DataX[sample(1:dim(DataX)[1],200),];
    bootR <- 1000
    for(column in c("sleeptime", "steps")){
      for(conflvl in c(0.90,0.95,0.99)){

        #Media
        # Varianza conocida
        intervals <- z.test(SampleM[,column], sd = sd(Data[,column]), conf.level = conflvl)$conf.int
        cat("Estimacion intervalo ", column, " ", genero, " de la media, con varianza conocida, al nvl de confianza ", conflvl*100, 
        "% : [", intervals[1], ",", intervals[2], "]", "\n", sep="")
          #bootstrap
        Mboot = boot(SampleM[,column],function(x,i) mean(x[i]),R=bootR) 
        #print(mean(Mboot$t[,1]))
        bci200 <- boot.ci(Mboot,conf = conflvl,type=c("norm","basic"))$normal
        cat("Estimacion intervalo ", column, " ", genero, " de la media, mediante Bootstrap, al nvl de confianza ", conflvl*100, 
        "% : [", bci200[2], ",", bci200[3], "]", "\n", sep="")

        # Varianza desconocida
        intervals <- t.test(x=SampleM[,column], conf.level=conflvl)$conf.int
        cat("Estimacion intervalo ", column, " ", genero, " de la media, con varianza desconocida, al nvl de confianza ", conflvl*100, 
        "% : [", intervals[1], ",", intervals[2], "]", "\n", sep="")
          #bootstrap


        #Varianza
        df <- length(SampleM[,column]) - 1
        varSample <- var(SampleM[,column])
        lower = varSample * df / qchisq((1-conflvl)/2, df, lower.tail = FALSE)
        upper = varSample * df / qchisq(conflvl/2, df, lower.tail = FALSE)
        cat("Estimacion intervalo ", column, " ", genero, " de la varianza al nvl de confianza ", conflvl*100, 
        "% : [", lower, ",", upper, "]", "\n", sep="")
          #bootstrap
        Mboot = boot(SampleM[,column],function(x,i) var(x[i]),R=bootR) 
        #print(mean(Mboot$t[,1]))
        bci200 <- boot.ci(Mboot,conf = conflvl,type=c("norm","basic"))$normal
        cat("Estimacion intervalo ", column, " ", genero, " de la varianza, mediante Bootstrap, al nvl de confianza ", conflvl*100, 
        "% : [", bci200[2], ",", bci200[3], "]", "\n", sep="")

        if(genero == "Mujeres y Varones"){
          #Proporcion
          numMujeres <- table(SampleM$Sex)[1]
          intervals <- prop.test(numMujeres,200, conf.level = conflvl)$conf.int
          cat("Estimacion intervalo ", column, " ", genero, " de la proporcion, al nvl de confianza ", conflvl*100, 
          "% : [", intervals[1], ",", intervals[2], "]", "\n", sep="")
        }
        cat("\n",sep="")
      }
    }
  }
}

sink("Resultados 2B.txt");
estimacionConf()
sink();

####################################################################################################################################
####################################################################################################################################

#3
set.seed(2021)
SampleM = sample(Data$Nation,200)

r0 <- 5
n0 <- 10
r  <- table(SampleM)[["SP"]] #52
n  <- 200

aux1 <- r+r0
aux2 <- (n+n0)-(r+r0)

#Aproximaciones
#A posteriori antes de ajustar
post1 <- function(theta) {
  theta^(aux1)*(1-theta)^aux2 #57, 153
}
post2 <- function(theta) {
  theta^(aux1)*(1-theta)^aux2/k
}

k <- integrate(post1,lower=0,upper=1)$value
round(integrate(post2,lower=0,upper=1)$value,2)
#IC
qbeta(c(0.025,0.975),shape1=r+r0,shape2=(n+n0)-(r+r0)) 
png(filename = paste(paste("3", "densidad", sep="_"), ".png", sep=""))
curve(post2, col = 2,xlab = "p",ylab = "densidad")
dev.off()

SampleNations <- subset(Data, Nation == SampleM, select = c("Nation","height"))
SampleSPFRIT <- subset(SampleNations,Nation == "SP" | Nation == "FR" | Nation == "IT",select = c("Nation","height"))

SampleMean = mean(SampleSPFRIT$height)
n0 = (sd(SampleSPFRIT$height)^2)/(7^2)
meanPost = (200*SampleMean + n0*170)/(200 + n0)
cat("Estatura media:", meanPost)



####################################################################################################################################
####################################################################################################################################

#PARTE 4A
set.seed(2021)
sample4_1 <- sample(Data$IMC, 200)
sample4_2 <- sample(Data$IMC, 200)


quantile(sample4_1, prob=c(.25,.5,.75))
#Cuartil 1 media = 24.14895
t.test(sample4_1, alternative = "greater",mu = 23.61980)
# One Sample t-test
# 
# data:  sample4_1
# t = 19.14, df = 199, p-value < 2.2e-16
# alternative hypothesis: true mean is greater than 23.6198
# 95 percent confidence interval:
#   24.56217      Inf
# sample estimates:
#   mean of x 
# 24.65122 

#Rechazamos la hipotesis nula ya que pvalor es menos de 0.01. Concluimos que la media de la muestra es mayor que la media de Q1

t.test(sample4_1, alternative = "less",mu = 25.17701)

# One Sample t-test
# 
# data:  sample4_1
# t = -9.757, df = 199, p-value < 2.2e-16
# alternative hypothesis: true mean is less than 25.17701
# 95 percent confidence interval:
#   -Inf 24.74028
# sample estimates:
#   mean of x 
# 24.65122 

#Rechazamos la hipotesis nula ya que pvalor es menos de 0.01. Concluimos que la media de la muestra es menor que la media de Q3

library(TeachingDemos)
sigma.test(sample4_1, 1, alternative = "greater")

# data:  sample4_1
# X-squared = 115.58, df = 199, p-value = 1
# alternative hypothesis: true variance is greater than 1
# 95 percent confidence interval:
#   0.4962185       Inf
# sample estimates:
#   var of sample4_1 
# 0.5807797 

#No rechazamos la hipotesis nula ya que pvalor es mayor que 0.2


t.test(sample4_1, sample4_2, paired = TRUE, var.equal = TRUE)

# Paired t-test
# 
# data:  sample4_1 and sample4_2
# t = 1.0592, df = 199, p-value = 0.2908
# alternative hypothesis: true difference in means is not equal to 0
# 95 percent confidence interval:
#   -0.06861783  0.22787214
# sample estimates:
#   mean of the differences 
# 0.07962715 

#No rechazamos que las medias son iguales (hipotesis nula) con una confianza del 95% ya que el pvalor es mayor que 0.2.
#Se estima que la diferencia de las medias es 0.07962715

var.test(sample4_1, sample4_2)

# F test to compare two variances
# 
# data:  sample4_1 and sample4_2
# F = 0.97357, num df = 199, denom df = 199, p-value = 0.8503
# alternative hypothesis: true ratio of variances is not equal to 1
# 95 percent confidence interval:
#   0.7367862 1.2864551
# sample estimates:
#   ratio of variances 
# 0.973572 

#No rechazamos que las varianzas son iguales (hipotesis nula) con una confianza del 95% ya que el pvalor es mayor que 0.2.
#Se estima que la ratio de las varianzas es 0.973572 (casi 1)


#PARTE 4B
library(nortest)
pearson.test(sample4_1)

# Pearson chi-square normality test
# 
# data:  sample4_1
# P = 9.27, p-value = 0.8134

#No rechamos la hipotesis nula, es decir, no rechazamos que sea normal

library(stats)
ks.test(sample4_1, "pnorm", mean = mean(sample4_1), sd = sd(sample4_1))

# One-sample Kolmogorov-Smirnov test
# 
# data:  sample4_1
# D = 0.035058, p-value = 0.9666
# alternative hypothesis: two-sided

#No rechamos la hipotesis nula, es decir, no rechazamos que sea normal

library(lmtest)

sample4_IMC <- sample(Data$IMC, 200)
sample4_sleeptime <- sample(Data$sleeptime, 200)
sample4_steps <- sample(Data$steps, 200)

sample4_1_frame <- data.frame (sample4_IMC,sample4_sleeptime,sample4_steps)
sample_dw <- lm(formula = sample4_IMC~sample4_sleeptime+sample4_steps, data = sample4_1_frame)
dwtest(sample_dw)

# Durbin-Watson test
# 
# data:  sample_dw
# DW = 1.9871, p-value = 0.4642
# alternative hypothesis: true autocorrelation is greater than 0

#No rechazamos la hipotesis nula, es decir, existe una dependencia entre el IMC con sleeptime+steps+weight

wilcox.test(sample4_1,sample4_2)

# Wilcoxon rank sum test with continuity correction
# 
# data:  sample4_1 and sample4_2
# W = 19199, p-value = 0.4887
# alternative hypothesis: true location shift is not equal to 0

#No rechazamos la hipotesis nula, es decir, las dos muestras son homogeneas

