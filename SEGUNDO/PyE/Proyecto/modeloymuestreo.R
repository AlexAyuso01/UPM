 #nolint start,  #nolint end

source("inicializar.R", local = TRUE);

#PARTE 1
###Ajuste de modelo

#Sleeptime y steps
sink("Resultados 1A_1.txt");
summary(Data$sleeptime)
png(filename = paste(paste("Histograma", "sleeptime", sep = "_"), ".png", sep = "")); # nolint
hist(Data$sleeptime);
dev.off();

summary(Data$steps)
png(filename = paste(paste("Histograma", "steps", sep = "_"),
 ".png", sep = ""));
hist(Data$steps);
dev.off();
sink()

sink("Resultados 1A_2.txt")
slptm <- Data$sleeptime
##D.Normal

normal <- fitdistr(slptm, "normal")
    png(filename = paste(paste("1A_2", "Histograma",
    "D.Normal", "sleeptime", sep = "_"), ".png", sep = ""))
    #histograma
    hist(Data$sleeptime, pch = 20, breaks = 35, prob = TRUE, main = "")
    curve(dnorm(x, normal$estimate[1], normal$estimate[2]),
     col = "red", lwd = 2, add = T)
    dev.off()
    #Test de K-S
    normtest <- ks.test(slptm, "pnorm")
    normtest


##D.Gamma
gamma <- fitdistr(slptm, "gamma", lower = c(0, 0))
    png(filename = paste(paste("1A_2", "Histograma",
    "D.Gamma", "sleeptime", sep = "_"), ".png", sep = ""))
    #histograma
    hist(x = Data$sleeptime, breaks = 35, prob = TRUE, main = "")
    curve(dgamma(x, gamma$estimate[1], gamma$estimate[2]),
     col = "red", lwd = 2, add = T)
    dev.off()
    #Test de K-S
    gammatest <- ks.test(slptm, "pgamma", shape = gamma$estimate[1],
     rate = gamma$estimate[2])
    gammatest
    

##D.Exponencial
expo <- fitdistr(slptm, "exponential")
    png(filename = paste(paste("1A_2", "Histograma", "D.Exponencial",
    "sleeptime", sep = "_"), ".png", sep = ""))
    #histograma
    hist(x = Data$sleeptime, breaks = 35, prob = TRUE, main = "")
    curve(dexp(x, expo$estimate[1]), col = "red", lwd = 2, add = T)
    dev.off()
    #Test de K-S
    expotest <- ks.test(slptm, "pexp", rate = expo$estimate[1])
    expotest

sink()

###Muestreo
muestreo_tipo <- function(n, tipo, method = NA) {
  matrix_m <- matrix(NA, nrow = n, ncol = 1)
  #Tomamos n muestras
  for (i in 1:n) {
    if (tipo == "meanAge" | tipo == "varAge") {
      set.seed(2022)
      sample_m <- replicate(n, data$Age[sample(1:dim(data)[1], 200)], )
      matrix_m[i, ] <- method(sample_m[, i])
    } else if (tipo == "propSex") {
      set.seed(2022)
      sample_m <- replicate(n, data$Sex[sample(1:dim(data)[1], 200)], )
      matrix_m[i, ] <- table(sample_m[, i])[1] / 200
    }
  }
  normal <- fitdistr(matrix_m, "normal")
  png(filename = paste(paste("1B", tipo, "ajuste",
  n, sep = "_"), ".png", sep = ""))
  hist(x = matrix_m, breaks = 35, prob = TRUE, main = "")
  curve(dnorm(x, normal$estimate[1], normal$estimate[2]),
  col = "red", lwd = 2, add = T)
  dev.off()
  png(filename = paste(paste("1B", tipo, "boxplot",
  n, sep = "_"), ".png", sep = ""))
  boxplot(matrix_m)
  dev.off()
}

prevwd <- getwd()
setwd(paste(getwd(), "//", "output", sep = ""))
#1B
muestreo_tipo(30, "meanAge", mean)
muestreo_tipo(50, "meanAge", mean)
muestreo_tipo(100, "meanAge", mean)
muestreo_tipo(30, "varAge", var)
muestreo_tipo(50, "varAge", var)
muestreo_tipo(100, "varAge", var)
muestreo_tipo(30, "propSex")
muestreo_tipo(50, "propSex")
muestreo_tipo(100, "propSex")

setwd(prevwd)

##################################################################
##################################################################

##PARTE 2. Estimacion Clasica
#a
estimacion <- function() {
  for (genero in c("Mujeres", "Varones", "Mujeres y Varones")) {
    if (genero == "Mujeres") {
      #Dataframe con solo mujeres de Data
      data_x <- data[data[, "Sex"] == "M", ];
    } else if (genero == "Varones") {
      #Dataframe con solo varones de Data
      data_x <- data[data[, "Sex"] == "V", ];
    } else{
      data_x <- data;
    }
    for (column in c("sleeptime", "steps")) {
      cat("Estimacion media ", column, " ", genero,
      ", con todos los datos: ", mean(data_x$sleeptime), "\n", sep = "")
      cat("Estimacion varianza ", column, " ", genero,
      ", con todos los datos: ", var(data_x$sleeptime), "\n", sep = "")
      set.seed(2022)
      sample_m <- data_x[,column][sample(1:dim(data_x)[1], 200)];
      cat("Estimacion media ", column, " ", genero,
      ", con muestra de 200: ", mean(sample_m), "\n", sep = "")
      cat("Estimacion varianza ", column, " ", genero,
      ", con muestra de 200: ", var(sample_m), "\n", sep = "")
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



estimacion_conf <- function() {
  for (genero in c("Mujeres", "Varones", "Mujeres y Varones")) {
    if (genero == "Mujeres") {
      data_x <- data[data[, "Sex"] == "M", ];
    } else if (genero == "Varones") {
      data_x <- data[data[, "Sex"] == "V", ];
    } else {
      data_x <- data;
    }
    #checkseed();
    set.seed(2022)
    sample_m <- data_x[sample(1:dim(data_x)[1], 200), ];
    boot_r <- 1000
    for (column in c("sleeptime", "steps")) {
      for (conflvl in c(0.90, 0.95, 0.99)) {

        #Media
        # Varianza conocida
        intervals <- z.test(sample_m[,column], sd = sd(Data[,column]),
        conf.level = conflvl)$conf.int
        cat("Estimacion intervalo ", column, " ", genero,
" de la media, con varianza conocida, al nvl de confianza ", conflvl * 100,
        "% : [", intervals[1], ",", intervals[2], "]", "\n", sep = "")
          #bootstrap
        m_boot = boot(sample_m[, column], function(x, i) mean(x[i]), R = boot_r)
        #print(mean(m_boot$t[,1]))
        bci200 <- boot.ci(m_boot, conf = conflvl,
        type = c("norm", "basic"))$normal
        cat("Estimacion intervalo ", column, " ", genero,
" de la media, mediante Bootstrap, al nvl de confianza ", conflvl * 100,
        "% : [", bci200[2], ",", bci200[3], "]", "\n", sep = "")

        # Varianza desconocida
        intervals <- t.test(x=sample_m[, column], conf.level = conflvl)$conf.int
        cat("Estimacion intervalo ", column, " ", genero,
" de la media, con varianza desconocida, al nvl de confianza ", conflvl * 100,
        "% : [", intervals[1], ",", intervals[2], "]", "\n", sep = "")
          #bootstrap


        #Varianza
        df <- length(sample_m[, column]) - 1
        var_sample <- var(sample_m[, column])
        lower <- var_sample * df / qchisq((1 - conflvl) / 2,
        df, lower.tail = FALSE)
        upper <- var_sample * df / qchisq(conflvl / 2, df, lower.tail = FALSE)
        cat("Estimacion intervalo ", column, " ", genero,
        " de la varianza al nvl de confianza ", conflvl * 100,
        "% : [", lower, ",", upper, "]", "\n", sep = "")
          #bootstrap
        m_boot <- boot(sample_m[, column], function(x, i) var(x[i]), R = boot_r)
        #print(mean(m_boot$t[,1])) # nolint
        bci200 <- boot.ci(m_boot, conf = conflvl,
        type = c("norm", "basic"))$normal
        cat("Estimacion intervalo ", column, " ", genero,
" de la varianza, mediante Bootstrap, al nvl de confianza ", conflvl * 100,
        "% : [", bci200[2], ",", bci200[3], "]", "\n", sep = "")

        if (genero == "Mujeres y Varones") {
          #Proporcion
          num_mujeres <- table(sample_m$Sex)[1]
          intervals <- prop.test(num_mujeres, 200,
           conf.level = conflvl)$conf.int
          cat("Estimacion intervalo ", column, " ", genero,
          " de la proporcion, al nvl de confianza ", conflvl * 100,
          "% : [", intervals[1], ",", intervals[2], "]", "\n", sep = "")
        }
        cat("\n", sep = "")
      }
    }
  }
}

sink("Resultados 2B.txt");
estimacion_conf()
sink();

#########################################################
#########################################################

#3
set.seed(2022)
sample_m <- sample(Data$Nation, 200)

r0 <- 5
n0 <- 10
r  <- table(sample_m)[["SP"]] #52
n  <- 200

aux1 <- r + r0
aux2 <- (n + n0) - (r + r0)

#Aproximaciones
#A posteriori antes de ajustar
post1 <- function(theta) {
  theta^ (aux1) * (1 - theta)^aux2 #57, 153
}
post2 <- function(theta) {
  theta^ (aux1) * (1 - theta)^aux2 / k
}

k <- integrate(post1, lower = 0, upper = 1)$value
round(integrate(post2, lower = 0, upper = 1)$value, 2)
#IC
qbeta(c(0.025, 0.975), shape1 = r + r0, shape2 = (n + n0) - (r + r0))
png(filename = paste(paste("3", "densidad", sep = "_"), ".png", sep = ""))
curve(post2, col = 2, xlab = "p", ylab = "densidad")
dev.off()

sample_nations <- subset(Data, Nation == sample_m,
 select = c("Nation", "height"))
sample_spfrit <- subset(sample_nations, Nation == "SP" |
 Nation == "FR" | Nation == "IT", select = c("Nation", "height"))

sample_mean <- mean(sample_spfrit$height)
n0 <- (sd(sample_spfrit$height)^2) / (7^2)
mean_post <- (200 * sample_mean + n0 * 170) / (200 + n0)
cat("Estatura media:", mean_post)



#######################################################
#######################################################

#PARTE 4A
set.seed(2022)
sample4_1 <- sample(Data$IMC, 200)
sample4_2 <- sample(Data$IMC, 200)


quantile(sample4_1, prob = c(.25, .5, .75))
#Cuartil 1 media = 24.14895
t.test(sample4_1, alternative = "greater", mu = 23.61980)
# One Sample t-test
# data:  sample4_1
# t = 19.14, df = 199, p-value < 2.2e-16
# alternative hypothesis: true mean is greater than 23.6198
# 95 percent confidence interval:
#   24.56217      Inf
# sample estimates:
#   mean of x
# 24.65122

#Rechazamos la hipotesis nula ya que pvalor es menos de 0.01.
#Concluimos que la media de la muestra es mayor que la media de Q1

t.test(sample4_1, alternative = "less", mu = 25.17701)

# One Sample t-test
# data:  sample4_1
# t = -9.757, df = 199, p-value < 2.2e-16
# alternative hypothesis: true mean is less than 25.17701
# 95 percent confidence interval:
#   -Inf 24.74028
# sample estimates:
#   mean of x
# 24.65122

#Rechazamos la hipotesis nula ya que pvalor es menos de 0.01.
#Concluimos que la media de la muestra es menor que la media de Q3

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
# data:  sample4_1 and sample4_2
# t = 1.0592, df = 199, p-value = 0.2908
# alternative hypothesis: true difference in means is not equal to 0
# 95 percent confidence interval:
#   -0.06861783  0.22787214
# sample estimates:
#   mean of the differences
# 0.07962715

#No rechazamos que las medias son iguales (hipotesis nula)
# con una confianza del 95% ya que el pvalor es mayor que 0.2.
#Se estima que la diferencia de las medias es 0.07962715

var.test(sample4_1, sample4_2)

# F test to compare two variances
# data:  sample4_1 and sample4_2
# F = 0.97357, num df = 199, denom df = 199, p-value = 0.8503
# alternative hypothesis: true ratio of variances is not equal to 1
# 95 percent confidence interval:
#   0.7367862 1.2864551
# sample estimates:
#   ratio of variances
# 0.973572

#No rechazamos que las varianzas son iguales (hipotesis nula)
# con una confianza del 95% ya que el pvalor es mayor que 0.2.
#Se estima que la ratio de las varianzas es 0.973572 (casi 1)


#PARTE 4B
library(nortest)
pearson.test(sample4_1)

# Pearson chi-square normality test
# data:  sample4_1
# P = 9.27, p-value = 0.8134

#No rechamos la hipotesis nula, es decir, no rechazamos que sea normal

library(stats)
ks.test(sample4_1, "pnorm", mean = mean(sample4_1), sd = sd(sample4_1))

# One-sample Kolmogorov-Smirnov test
# data:  sample4_1
# D = 0.035058, p-value = 0.9666
# alternative hypothesis: two-sided

#No rechamos la hipotesis nula, es decir, no rechazamos que sea normal

library(lmtest)

sample4_imc <- sample(Data$IMC, 200)
sample4_sleeptime <- sample(Data$sleeptime, 200)
sample4_steps <- sample(Data$steps, 200)

sample4_1_frame <- data.frame(sample4_imc, sample4_sleeptime, sample4_steps)
sample_dw <- lm(formula = sample4_imc ~ sample4_sleeptime + sample4_steps,
 data = sample4_1_frame)
dwtest(sample_dw)

# Durbin-Watson test
# data:  sample_dw
# DW = 1.9871, p-value = 0.4642
# alternative hypothesis: true autocorrelation is greater than 0

#No rechazamos la hipotesis nula, es decir,
#existe una dependencia entre el IMC con sleeptime+steps+weight

wilcox.test(sample4_1, sample4_2)

# Wilcoxon rank sum test with continuity correction
# data:  sample4_1 and sample4_2
# W = 19199, p-value = 0.4887
# alternative hypothesis: true location shift is not equal to 0

#No rechazamos la hipotesis nula, es decir, las dos muestras son homogeneas

#######################################################
#######################################################

#PARTE 5
## CREO QUE HAY QUE USAR lm(Data$height, Data$width)
set.seed(2022)
sample_lm <- Data[sample(Data$X, 20), ]
height <- sample_lm$height
weight <- sample_lm$weight
typeof(height)
mod1 <- lm(height ~ weight,data = sample_lm)
summary(mod1) #devielve los valores de la funcion
plot(mod1)
anova(mod1)  # pueba homocedasticidad (creo)
intercept <- mod1$coefficients[1]
weight <- mod1$coefficients[2]
mod1$residuals
mod1$fitted.values
#Predicciones segun recta del modelo
# de regresion lineal: recta
#conf_int = p +/- z*(sqrt(p*(1-p) / n))
# p = sample data / data.size => 20/data.size
# z <- qnorm(1 - (1 - 0.95) / 2)
library(glue)
n <- dim(sample_lm[2])
p <- n / 1000
err <- qnorm(0.975) * sqrt(p * (1 - p) / n)

##max(height)
pred_max <- intercept + (weight * max(height))
pred_max
low_int_max <- pred_max - err
low_int_max
upp_int_max <- pred_max + err
upp_int_max
glue("{low_int_max}, {upp_int_max}")

##min(height)
pred_min <- intercept + (weight * min(height))
pred_min
low_int_min <- pred_min - err
low_int_min
upp_int_min <- pred_min + err
upp_int_min
glue("{low_int_min}, {upp_int_min}")

##media(height)
pred_med <- intercept + (weight * mean(height))
pred_med
low_int_med <- pred_med - err
low_int_med
upp_int_med <- pred_med + err
upp_int_med
glue("{low_int_med}, {upp_int_med}")

#mismo proceso pero para mujeres
library(dplyr)
mujeres_alt <- data.frame(sample_lm$Sex == "M", sample_lm$height)
height_m <- mujeres_alt$sample_lm.height[mujeres_alt$sample_lm.Sex.....M==TRUE]
df2 <- data.frame(mujeres_alt$sample_lm.height[mujeres_alt$sample_lm.Sex.....M==TRUE])
height_m

mujeres_pes <- data.frame(sample_lm$Sex == "M", sample_lm$weight)
weight_m <- mujeres_pes$sample_lm.weight[mujeres_pes$sample_lm.Sex.....M==TRUE]
weight_m

mod2 <- lm(height_m ~ weight_m, data = df2)
summary(mod2) #devielve los valores de la funcion
plot(mod2)
abline(mod2, col="red")
anova(mod2)  # pueba homocedasticidad (creo)
plot(mod2$residuals)

intercept_m <- mod2$coefficients[1]
interceptss
weight <- mod2$coefficients[2]
weight

n <- length(mujeres_pes)
n
p <- n / 1000
err <- qnorm(0.975) * sqrt(p * (1 - p) / n)
err

##max(height)
pred_max <- intercept_m + (weight * max(height_m))
pred_max
low_int_max <- pred_max - err
low_int_max
upp_int_max <- pred_max + err
upp_int_max
glue("{low_int_max}, {upp_int_max}")

##min(height)
pred_min <- intercept_m + (weight * min(height_m))
pred_min
low_int_min <- pred_min - err
low_int_min
upp_int_min <- pred_min + err
upp_int_min
glue("{low_int_min}, {upp_int_min}")

##media(height)
pred_med <- intercept_m + (weight * mean(height_m))
pred_med
low_int_med <- pred_med - err
low_int_med
upp_int_med <- pred_med + err
upp_int_med
glue("{low_int_med}, {upp_int_med}")

# mismo proceso pero para vaornes
hombres_alt <- data.frame(sample_lm$Sex == "V", sample_lm$height)
height_v <- hombres_alt$sample_lm.height[hombres_alt$sample_lm.Sex.....V==TRUE]
df3 <- data.frame(hombres_alt$sample_lm.height[hombres_alt$sample_lm.Sex.....V==TRUE])
height_v

hombres_pes <- data.frame(sample_lm$Sex == "V", sample_lm$weight)
weight_v <- hombres_pes$sample_lm.weight[hombres_pes$sample_lm.Sex.....V==TRUE]
weight_v

mod3 <- lm(height_v ~ weight_v, data = df3)
summary(mod3) #devielve los valores de la funcion
plot(mod3)
anova(mod3)  # pueba homocedasticidad (creo)
intercept_v <- mod2$coefficients[1]
interceptss
weight <- mod2$coefficients[2]
weight
n <- length(hombres_pes)
n
p <- n / 1000
err <- qnorm(0.975) * sqrt(p * (1 - p) / n)
err

##max(height)
pred_max <- intercept_v + (weight * max(height_v))
pred_max
low_int_max <- pred_max - err
low_int_max
upp_int_max <- pred_max + err
upp_int_max
glue("{low_int_max}, {upp_int_max}")

##min(height)
pred_min <- intercept_v + (weight * min(height_v))
pred_min
low_int_min <- pred_min - err
low_int_min
upp_int_min <- pred_min + err
upp_int_min
glue("{low_int_min}, {upp_int_min}")

##media(height)
pred_med <- intercept_v + (weight * mean(height_v))
pred_med
low_int_med <- pred_med - err
low_int_med
upp_int_med <- pred_med + err
upp_int_med
glue("{low_int_med}, {upp_int_med}")

#Hacer lo mismo pero para age <= 30 
ed_alt <- data.frame(sample_lm$Age>30, sample_lm$height)
height_ed <- ed_alt$sample_lm.height[ed_alt$sample_lm.Age...30==FALSE]
df4 <- data.frame(ed_alt$sample_lm.height[ed_alt$sample_lm.Age...30==FALSE])
height_ed
typeof(height_ed)
ed_pes <- data.frame(sample_lm$Age>30, sample_lm$weight)
weight_ed <- ed_pes$sample_lm.weight[ed_pes$sample_lm.Age...30==FALSE]
weight_ed

mod4 <- lm(height_ed ~ weight_ed, data = df4)
summary(mod4) #devielve los valores de la funcion
plot(mod4)
anova(mod4)  # pueba homocedasticidad (creo)
intercept_ed <- mod2$coefficients[1]
interceptss
weight <- mod2$coefficients[2]
weight
n <- length(ed_pes)
n
p <- n / 1000
err <- qnorm(0.975) * sqrt(p * (1 - p) / n)
err

##max(height)
pred_max <- intercept_ed + (weight * max(height_ed))
pred_max
low_int_max <- pred_max - err
low_int_max
upp_int_max <- pred_max + err
upp_int_max
glue("{low_int_max}, {upp_int_max}")

##min(height)
pred_min <- intercept_ed + (weight * min(height_ed))
pred_min
low_int_min <- pred_min - err
low_int_min
upp_int_min <- pred_min + err
upp_int_min
glue("{low_int_min}, {upp_int_min}")

##media(height)
pred_med <- intercept_ed + (weight * mean(height_ed))
pred_med
low_int_med <- pred_med - err
low_int_med
upp_int_med <- pred_med + err
upp_int_med
glue("{low_int_med}, {upp_int_med}")


##b 
#General
anova(mod1)[5]
#Mujeres
anova(mod2)[5]
#Varones
anova(mod3)[5]
#<=30
anova(mod4)[5]

