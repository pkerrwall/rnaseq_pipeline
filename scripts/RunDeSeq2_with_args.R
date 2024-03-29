args = commandArgs(trailingOnly=TRUE)

### Author - Amarinder Singh Thind - # https://github.com/amarinderthind/RNA-seq-tutorial-for-gene-differential-expression-analysis
# modifications by Kerr Wall to get to work with Dec2 dataset
# Rscript --vanilla r_arguments.r arg1 arg2

library(DESeq2)

###################### load the raw count matrix #######################
firstC <- args[1] # N2 Spin SVIP
SecondC <- args[2] # N2 Spin SVIP
Method <- args[3] # salmon | hisat2
infile <- args[4] # salmon.gene_counts.tsv
anno_file <- args[5] # sample_info.txt
outdir <- './'

# read input file
rawcount<-read.table(file=infile, header=TRUE, sep="\t",  row.names=1, check.names=FALSE, stringsAsFactors=FALSE)
print(head(rawcount))

# convert to integer
rawcount[, 1:ncol(rawcount)] <- sapply(rawcount[, 1:ncol(rawcount)], as.integer)

###################### Data annotation  #################################
anno <-read.table(anno_file,header=TRUE,  sep="\t") ##In this case Two coulmns (a) sample (b) Condition
print(head(anno))
rownames(anno) <- anno$sample
p.threshold <- 0.05   ##define threshold for filtering
log2FC <- 1.58 # 3 fold change

### subset raw and conditional data for defined pairs
anno <- anno[(anno$Condition ==firstC |anno$Condition ==SecondC),]
rawcount <- rawcount[,names(rawcount) %in% anno$sample]

# convert rawcount to numeric * not sure I need this
#rawcount <- as.matrix(rawcount)
#is.numeric(rawcount)
#print(head(rawcount))

############################### Create DESeq2 datasets #############################
dds <- DESeqDataSetFromMatrix(countData = rawcount, colData = anno, design = ~Condition )
## Run DESEQ2
dds <- DESeq(dds)

################# contrast based  comparison ##########################
#In case of multiple comparisons ## we need to change the contrast for every comparision
contrast<- c("Condition",firstC,SecondC)
res <- results(dds, contrast=contrast)
res$threshold <- as.logical(res$padj < p.threshold)  #Threshold defined earlier
nam <- paste('down_in',firstC, sep = '_')
res[, nam] <- as.logical(res$log2FoldChange < 0)
genes.deseq <- row.names(res)[which(res$threshold)]
genes_deseq2_sig <- res[which(res$threshold),]

file <- paste(outdir, firstC,'_', SecondC, '.', Method, '.deseq2_results_padj0.05.csv', sep = '')
all_results <- paste(outdir, firstC, '_', SecondC, '.', Method, '.deseq2_results_all.csv', sep = '')
write.table(genes_deseq2_sig,file,sep = ",")
write.table(res,all_results,sep = ",")