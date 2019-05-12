library("rBLAST", lib.loc="~/R/win-library/3.5")
download.file("ftp://ftp.ncbi.nlm.nih.gov/blast/db/16SMicrobial.tar.gz",
              "16SMicrobial.tar.gz", mode='wb')
untar("16SMicrobial.tar.gz", exdir="16SMicrobialDB")
seq <- readAAStringSet(system.file("examples", "exampleAA.fasta", package="msa"))
names(seq) <-  sapply(strsplit(names(seq), " "), "[", 1)

bl <- blast(db="./16SMicrobialDB/16SMicrobial",type = "blastp")

cl <- predict(bl, seq[1,])
