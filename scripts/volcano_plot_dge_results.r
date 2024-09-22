# https://github.com/amarinderthind/RNA-seq-tutorial-for-gene-differential-expression-analysis

# get the first agrument as the filename
filename <- commandArgs(trailingOnly = TRUE)[1]
#filename <- 'daf-16_SVIP_daf-16.salmon.deseq2_results_padj0.05.csv'
print(filename)

# get the second argument as the comparison
comparison <- commandArgs(trailingOnly = TRUE)[2]
df <- read.table(filename, header=TRUE, fill=TRUE, sep=",")
res <- df[c("log2FoldChange","padj")]

# get the xlim_list based on the 3rd and 4th arguments
#xlim_list <- c(as.numeric(commandArgs(trailingOnly = TRUE)[3]), as.numeric(commandArgs(trailingOnly = TRUE)[4]))
xlim_list <- c(-15, 15)

### add volcano plot ###
library(EnhancedVolcano)
EnhancedVolcano(res,
                lab = rownames(res),
                x = 'log2FoldChange',
                y = 'padj',
                pCutoff = 0.05,
                FCcutoff = 0.58,
                pointSize = 1,
                labSize = 2.5,
                xlim = xlim_list,
                #max.overlaps = 10,
                #title = '',
                subtitle = comparison, 
                caption = 'log2FC > 1; paj < 1e-5',
                legendPosition = "bottom",
                legendLabSize = 14,
                col = c('grey30', 'forestgreen', 'royalblue', 'red2'),
                colAlpha = 0.9,
                drawConnectors = TRUE,
                widthConnectors = 0.5
)

# rename the Rplots.pdf to the same name as the input file with .pdf extension
#pdf_file <- gsub(".csv", ".csv.pdf", filename)
pdf_file <- gsub(".csv", ".csv.with_names.pdf", filename)
print(pdf_file)
file.rename("Rplots.pdf", pdf_file)