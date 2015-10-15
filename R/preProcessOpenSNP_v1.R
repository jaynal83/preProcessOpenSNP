# Script to download and create SQLite database after some initial pre-processing
# Jaynal Abedin <joystatru@gmail.com>
# Date: 14 Oct 2015

# loading necessary libraries
library(RSQLite)
library(rsnps)

# Defining function to process raw genotype data 
preProcessOpenSNP <- function(userInfo,db)
{
 for(i in 1:nrow(userInfo))
 {
  print(paste("Iteration Index ", paste(i), paste(" out of "), paste(nrow(userInfo)),sep=""))
  snpURL <- userInfo$genotypes.download_url[i]
  rawSNP <- read.table(snpURL,stringsAsFactors=FALSE,comment.char="#",header=F,colClasses=c("character","character","numeric","character"))
  colnames(rawSNP) <- c("rsid","chromosome","pos","genotype")
  rawSNP$allel1 <- substring(rawSNP$genotype,1,1)
  rawSNP$allel2 <- substring(rawSNP$genotype,2,2)
  rawSNP$userID <- userInfo$id[i]
  rawSNP$genotypeID <- userInfo$genotypes.id[i]
  rawSNP$filetype <- userInfo$genotypes.filetype[i]
  rawSNP <- rawSNP[c("userID", "genotypeID","rsid","chromosome","pos","genotype", "allel1", "allel2", "filetype")]
  dbWriteTable(db,"genotypeTBL",rawSNP,append=T)
 }
}

# locating database folder to store processed data
setwd("D:/gitRepos/preProcessOpenSNP/db")

# Getting all user ids with genotype data with genotype links
allusers <- users(df=TRUE)
userWithSNP <- allusers[[1]]

db=dbConnect(dbDriver("SQLite"),dbname = "openSNPgenotypeDB")
preProcessOpenSNP(userInfo=userWithSNP[11:40,],db=db)
dbGetQuery(db,"select count (*) from genotypeTBL")
#as.vector(dbGetQuery(db,"select distinct userID from genotypeTBL")[,1])
dbDisconnect(db)
