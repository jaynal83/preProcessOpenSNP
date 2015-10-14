CREATE TABLE genotypeTBL(
rsid,
chromosome,
pos,
genotype,
allele1,
allele2
);
CREATE INDEX chromosome_idx ON genotypeTBL(chromosome);
