# Script to download and create SQLite database after some initial pre-processing
# Jaynal Abedin <joystatru@gmail.com>
# Date: 14 Oct 2015
library(RSQLite)

preProcessOpenSNP <- function(snpURL,db)
{
 rawSNP <- read.table(snpURL,stringsAsFactors=FALSE,comment.char="#",header=F,colClasses=c("character","character","numeric","character"))
 colnames(rawSNP) <- c("rsid","chromosome","pos","genotype")
 rawSNP$allel1 <- substring(rawSNP$genotype,1,1)
 rawSNP$allel2 <- substring(rawSNP$genotype,2,2)
 dbWriteTable(db,"genotypeTBL",rawSNP,append=T)
}

library(RSQLite)
setwd("D:/gitRepos/preProcessOpenSNP/db")
db=dbConnect(dbDriver("SQLite"),dbname = "openSNPgenotypeDB")

preProcessOpenSNP(snpURL="https://opensnp.org/data/1996.23andme.1182",db=db)
dbGetQuery(db,"select count (*) from genotypeTBL")
dbDisconnect(db)
