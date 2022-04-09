#!/usr/bin/env Rscript

require(pheatmap)
pdf(file = "ANI_matrix.pdf", width = 8, height = 7)

ani <- read.delim("All.ARGs.txt", sep="\t", row.names=1, header=T, stringsAsFactors=FALSE, check.names=FALSE)
namecol <- names(ani)
maxlen <- unique(nchar(namecol[nchar(namecol)==max(nchar(namecol))]))

ani[is.na(ani)] <- 60
#wordsize = 4/nrow(ani)*50
cellwidth = 432/nrow(ani)
wordsize = 0.9*cellwidth/maxlen
if (wordsize < 2){
    wordsize = 2
}
miniani <- round(min(ani[ani>min(ani)]))
colorstepup <- 100 - miniani
colorsteplow <- miniani - 60

aa <- pheatmap(ani, cluster_rows = TRUE,fontsize_row = wordsize, fontsize_col = wordsize, silent = TRUE)#added
aa
dev.off()
