#!/bin/usr/R
library(data.table)
library(dplyr)

argv = commandArgs(trailingOnly =T)

a = argv[1]

b <- c("/BiO/Hyein/90Traits/BT/QT_BT/2nd_validation_GWAS/phase3_44_GWAS_BT_in_GWASset/input_plink/QC3.")

c <- paste(b,a,sep="")

pheno <- fread(c)

pheno <- data.frame(pheno)

tmp <- data.frame(table(pheno$case))

d <- c("/BiO/Hyein/90Traits/BT/QT_BT/2nd_validation_GWAS/phase3_44_GWAS_BT_in_GWASset/outcome/1st_230524/result.")

e <- c(".assoc.logistic")

f <- paste(d,a,e,sep="")

GWAS_result <- fread(f)

GWAS_result <- data.frame(GWAS_result)

n_eff <- 4/((1/tmp[1,2])+(1/tmp[2,2]))

GWAS_result["n_eff"] <- n_eff

hm3 <- fread("/BiO/Hyein/90Traits/BT/QT_BT/2nd_validation_GWAS/phase3_44_GWAS_BT_in_GWASset/bedbimfam/mer_hm3_unr_exc_missnp.bim")

hm3 <- data.frame(hm3)

names(hm3) <- c("CHR","SNP","NULL","BP","A1","A2")

m <- left_join(GWAS_result,hm3,by="SNP")

m2 <- na.omit(m)

m2["BETA"] <- log(m2$OR)

input_GPS <- m2 [,c(1,2,3,4,18,19,8,12,13)]

names(input_GPS) <- c("chr","rsid","pos","a0","a1","beta","beta_se","p","n_eff")

input_ldsc <- input_GPS

names(input_ldsc) <- c("CHR","SNP","BP","A1","A2","BETA","SE","P","N")

g <- c("/BiO/Hyein/90Traits/BT/QT_BT/2nd_validation_GWAS/phase3_44_GWAS_BT_in_GWASset/input_GPS/")

h <- c(".csv")

i <- paste(g,a,h,sep="")

write.csv(input_GPS,i,quote=FALSE,row.names=FALSE)

j <- c("/BiO/Hyein/90Traits/BT/QT_BT/2nd_validation_GWAS/phase3_44_GWAS_BT_in_GWASset/input_ldsc/")

k <- paste(j,a,sep="")

write.csv(input_ldsc,k,quote=FALSE,row.names=FALSE)

print(a)
print("Done")
