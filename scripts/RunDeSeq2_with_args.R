args = commandArgs(trailingOnly=TRUE)

### Author - Amarinder Singh Thind - # https://github.com/amarinderthind/RNA-seq-tutorial-for-gene-differential-expression-analysis
# modifications by Kerr Wall to get to work with Dec2 dataset
# Rscript --vanilla r_arguments.r arg1 arg2

library(DESeq2)

###################### load the raw count matrix #######################
condition1 <- args[1] # N2 Spin SVIP
condition2 <- args[2] # N2 Spin SVIP
infile <- args[3] # salmon.gene_counts.tsv or *.csv
anno_file <- args[4] # sample_info.txt
outdir <- args[5] # './'

if (grepl("csv", infile)) {
    rawcount<-read.csv(file=infile, header=TRUE, sep=",", row.names=1, check.names=FALSE, stringsAsFactors=FALSE)
} else {
    rawcount<-read.table(file=infile, header=TRUE, sep='\t', row.names=1, check.names=FALSE, stringsAsFactors=FALSE)
}

# quit if rawcount is empty
if (nrow(rawcount) == 0 || ncol(rawcount) == 0) {
    stop("Error: The raw count matrix is empty. Please check the input file.")
}

# convert to integer
rawcount[, 1:ncol(rawcount)] <- sapply(rawcount[, 1:ncol(rawcount)], as.integer)
print(head(rawcount))

###################### Data annotation  #################################
# check if annotation file is csv or tsv ##In this case Two coulmns (a) sample (b) Condition
if (grepl("csv", anno_file)) {
    anno <- read.csv(anno_file, header=TRUE, sep=",")
} else {
    anno <- read.table(anno_file, header=TRUE, sep="\t")
}
print(head(anno))
rownames(anno) <- anno$sample
p.threshold <- 0.05   ##define threshold for filtering
log2FC <- 1.58 # 3 fold change

### subset raw and conditional data for defined pairs
anno <- anno[(anno$condition == condition1 |anno$condition == condition2),]
rawcount <- rawcount[,names(rawcount) %in% anno$sample]

############################### Create DESeq2 datasets #############################
dds <- DESeqDataSetFromMatrix(countData = rawcount, colData = anno, design = ~condition )
## Run DESEQ2
dds <- DESeq(dds)

################# contrast based  comparison ##########################
#In case of multiple comparisons ## we need to change the contrast for every comparision
contrast<- c("condition",condition1,condition2)
res <- results(dds, contrast=contrast)
res$threshold <- as.logical(res$padj < p.threshold)  #Threshold defined earlier
nam <- paste('down_in',condition1, sep = '_')
res[, nam] <- as.logical(res$log2FoldChange < 0)
genes.deseq <- row.names(res)[which(res$threshold)]
genes_deseq2_sig <- res[which(res$threshold),]

file <- paste(outdir, condition1,'.', condition2, '.deseq2_results_padj0.05.csv', sep = '')
all_results <- paste(outdir, condition1, '.', condition2, '.deseq2_results_all.csv', sep = '')
#write.table(genes_deseq2_sig,file,sep = ",")
write.table(res,all_results,sep = ",")