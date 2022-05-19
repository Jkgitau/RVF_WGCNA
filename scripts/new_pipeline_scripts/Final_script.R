# Development of rvf GCN pipeline 
# Guiding tutorial: https://github.com/Lindseynicer/WGCNA_tutorial/blob/main/WGCNA_tutorial_Rscript

# load required packages
library(WGCNA)
library(DESeq2)

# The following setting is important, do not omit.
options(stringsAsFactors = FALSE)

# ===============================================================================
  #
  #  Read the gene counts table and plot the sample tree
  #
#===============================================================================
# Read the gene counts table 
data0=read.csv("gene_counts_table_WGCNA_LC.txt")
data0 <- read.csv("final_counts.csv")

# Read in sample metadata
sample_metadata = read.csv(file = "sample_info.csv")
sample_metadata = read.csv(file = "metadata_RVF.csv")

# Normalization with log2(FPKM+1)
dataExpr_deseq <- DESeqDataSetFromMatrix(countData = data0,colData = sample_metadata,design = ~ Day)
mcols(dataExpr_deseq)$basepairs = data0$geneLengt1
fpkm_matrix = fpkm(dataExpr_deseq)
datExpr = t(log2(fpkm_matrix+1))

head(datExpr[1:5,1:5]) # samples in row, genes in column
match(sample_metadata$sample_ID, colnames(data0))
datExpr <- datExpr[,1:5000]



