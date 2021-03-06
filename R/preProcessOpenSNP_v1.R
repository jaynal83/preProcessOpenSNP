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
  ftype <- userInfo$genotypes.filetype[i]
  if(ftype!="23andme" & ftype!="ftdna-illumina")
   next
  if(ftype=="23andme") 
   rawSNP <- read.table(snpURL,stringsAsFactors=FALSE,comment.char="#",header=F,colClasses=c("character","character","numeric","character"))
  if(ftype=="ftdna-illumina")
  {
   rawSNP <- read.csv(snpURL,stringsAsFactors=FALSE,comment.char="#",colClasses=c("character","character","character","character"))
   rawSNP[,3] <- as.numeric(rawSNP[,3])
  }
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
setwd("D:/AllSync/Drive/Datasets/openSNPdb")

# Getting all user ids with genotype data with genotype links
allusers <- users(df=TRUE)
userWithSNP <- allusers[[1]]

db=dbConnect(dbDriver("SQLite"),dbname = "openSNPgenotypeDB")
preProcessOpenSNP(userInfo=userWithSNP[1193:1200,],db=db)  # upto 1200 done
dbGetQuery(db,"select count (*) from genotypeTBL")
# There is problem in user serial 60 and 129, 180 213 225 356 400 401 454 459 493 500 509 525 549 558 700 755 778 834  925 1014 1021 1027  1028  1050 1057 1101  1129 1132
# 1139 1146 1150 1183 1191 1192 
#user22=dbGetQuery(db,paste("select * from genotypeTBL where userID='",22,"'",sep=""))
# rs4477212=dbGetQuery(db,paste("select * from genotypeTBL where rsid='",'rs4477212',"'",sep=""))
#as.vector(dbGetQuery(db,"select distinct userID from genotypeTBL")[,1])
dbDisconnect(db)
# http://www.jopm.org/evidence/research/2010/12/23/citizen-science-genomics-as-a-model-for-crowdsourced-preventive-medicine-research/
#http://www.diygenomics.org/contact.php

