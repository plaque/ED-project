
sickness <- read.csv("zachorowania/Zachorowanianowotwory1999-2015powiaty.csv", header = T, sep=";", colClasses = c("numeric", "factor", "factor", "factor", "numeric"))
summary(sickness$powiat)
summary(sickness$icd10)
summary(sickness$plec)
placement <- c()
names(placement) <- c()