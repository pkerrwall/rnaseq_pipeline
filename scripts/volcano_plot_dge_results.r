# https://github.com/amarinderthind/RNA-seq-tutorial-for-gene-differential-expression-analysis

filename <- 'daf-16_SVIP_daf-16.salmon.deseq2_results_padj0.05.csv'
comparison <- ''
dir <- './' # current directory
file <- paste(dir, filename, sep='')
df<-read.table(file,header=TRUE, fill=TRUE, sep=",")
res<-df[c("log2FoldChange","padj")]


### add volcano plot ###
library(EnhancedVolcano)
EnhancedVolcano(res,
                lab = NA,
                x = 'log2FoldChange',
                y = 'padj',
                pCutoff = 0.05,
                FCcutoff = 0.58,
                pointSize = 1,
                labSize = 2.5,
                #max.overlaps = 10,
                title = '',
                subtitle = comparison, 
                caption = 'log2FC > 1; paj < 1e-5',
                legendPosition = "bottom",
                legendLabSize = 14,
                col = c('grey30', 'forestgreen', 'royalblue', 'red2'),
                colAlpha = 0.9,
                drawConnectors = TRUE,
                widthConnectors = 0.5
)
