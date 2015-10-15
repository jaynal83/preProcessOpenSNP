CREATE TABLE genotypeTBL(
userID,
genotypeID,
rsid,
chromosome,
pos,
genotype,
allele1,
allele2,
filetype
);
CREATE INDEX chromosome_idx ON genotypeTBL(chromosome);
