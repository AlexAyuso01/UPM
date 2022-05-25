source(inicializar.R, local = TRUE);

###Ajuste de modelo
slptm <- Data$sleeptime
##D.Normal

normal <- fitdistr(slptm, "normal")

    #histograma
    hist(Data$sleeptime, pch = 20, breaks = 35, prob = TRUE, main = "")
    curve(dnorm(x, normal$estimate[1], normal$estimate[2]), 
    col = "red", lwd = 2, add = T)
    #Test de K-S
    normtest <- ks.test(slptm, "pnorm")
    normtest


##D.Gamma
gamma <- fitdistr(slptm, "gamma", lower = c(0, 0))

    #histograma
    hist(x = Data$sleeptime, breaks = 35, prob = TRUE, main = "")
    curve(dgamma(x, gamma$estimate[1],
     gamma$estimate[2]), col = "red", lwd = 2, add = T)
    #Test de K-S
    gammatest <- ks.test(slptm, "pgamma",
    shape=gamma$estimate[1], rate = gamma$estimate[2])
    gammatest
    

##D.Exponencial
expo <- fitdistr(slptm, "exponential")

    #histograma
    hist(x = Data$sleeptime, breaks= 35, prob = TRUE, main = "")
    curve(dexp(x, expo$estimate[1]), col = "red", lwd = 2, add = T)
    #Test de K-S
    expotest <- ks.test(slptm, "pexp", rate = expo$estimate[1])
    expotest


###Muestreo
muestreo_tipo <- function(n, tipo, method = NA) {
  matrix_m <- matrix(NA, nrow = n, ncol = 1)
  for (i in 1:n) {
    if (tipo == "meanAge" | tipo == "varAge") {
      sample_m <- replicate(n, data$Age[sample(1:dim(data)[1], 200)],)
      matrix_m[i, ] <- method(sample_m[, i])
    } else if (tipo == "propSex"){
      sample_m <- replicate(n, data$Sex[sample(1:dim(data)[1], 200)],)
      matrix_m[i, ] <- table(sample_m[, i])[1] / 200
    }
  }
  normal <- fitdistr(matrix_m, "normal")
  png(filename = paste(paste(tipo, "ajuste", n, sep = "_"), ".png", sep = ""))
  hist(x = matrix_m, breaks = 35, prob = TRUE, main = "")
  curve(dnorm(x, normal$estimate[1], normal$estimate[2]),
   col = "red", lwd = 2, add = T)
  dev.off()
  png(filename = paste(paste(tipo, "boxplot", n, sep = "_"), ".png", sep = ""))
  boxplot(matrix_m)
  dev.off()
}

prevwd <- getwd()
setwd(paste(getwd(), "//", "output", sep = ""))
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