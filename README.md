# RNA-seq Pipeline

## Contents

- [Overview](#overview)
- [Repo Contents](#repo-contents)
- [System Requirements](#system-requirements)
- [Installation Guide](#installation-guide)
- [Demo](#demo)
- [Instructions for use](#instructions-for-use)
- [License](./LICENSE)

# Overview

This is a Package to perform a typical RNA-seq analysis, which includes 1) read cleaning and quality trimming, salmon quantification, and differential expression analysis with DeSeq2.  This package has been used in the following papers:
- A familial natural short sleep mutation promotes healthy aging and extends lifespan in Drosophila (Pandey et al, 2023)  (https://www.biorxiv.org/content/10.1101/2023.04.25.538137v1)
- DAF-16/FOXO and HLH-30/TFEB comprise a cooperative regulatory axis controlling tubular lysosome induction in C. elegans (https://www.ncbi.nlm.nih.gov/bioproject/?term=PRJNA1083209)

# Repo Contents

- [scripts](./scripts): `python` scripts to run various parts of the pipeline.
- [demo](./demo): example input and output data files to be used and generated in the demo section.

# System Requirements

## Hardware Requirements

The rnaseq_pipeline package requires only a standard computer with enough RAM to support the operations defined by a user. However, for large projects with many sample and replicates, a computer with multiple CPUs and 64GB+ RAM will help speed up the process.  Also, depending on the project, you may need 250-500GB of space for fastq, temporary files, and final output. For optimal performance, we recommend a computer with the following specs: RAM: 16+ GB  
CPU: 4+ cores, 3.3+ GHz/core

## Software Requirements

### OS Requirements

The package was tested on a *Linux* operating systems (Ubuntu 22.04). However, this package will easily work on Mac OSX & Windows.  


# Installation Guide

The rnaseq_pipeline uses the following software packages: TrimGalore (frontend for cutadapt), Salmon, Deseq2 (R/Bioconductor), and python for various scripts.  Please see the "Instructions for use" section for detailed instructions on downloading and installing all packages needed for this pipeline.  Downloading and installing will take 15-20 minutes depending on whether you install R from source or use a package manager (apt-get).


# Demo

Once you have cloned or downloaded the package, run the following commands for the demo.  The demo includes one test paired-end dataset with approximately 10,000 fastq reads (input - test_*.fq.gz & ouput - test_*.cleaned.fq.gz/*.trimming_report_*.txt).  The salmon demo command is run on this small dataset and the output is the compressed directory of all of the salmon output (test_salmon_quant.tar.gz).  The input for differential expression is from 2 libraries with 3 replicates each and 10,000 genes with counts (test_count_file.tsv and test_sample_info.txt).  Each of these sections has a log file so you can see the output of each of these commands (log.trimming_galore, log.salmon_output, log.deseq2_output).  The volcano plot R script is provided and you will need to change the intput file to the name of the DeSeq2 output file you generated in the previous step.  Please see the detailed instructions in the next section on setting up the software packatges, python, and R.  Once setup, the demo will take < 1 minute to run.  

## Demo Commands
`cd ~/rnaseq_pipeline/demo`  
`source /home/wallke/rnaseq_pipeline/software/rnaseq_pipeline/bin/activate`  
`python ~/rnaseq_pipeline/scripts/scripts/trim_galore_pipeline_paired.py test /home/wallke/rnaseq_pipeline/software/TrimGalore/trim_galore &> log.trimming_output`  
`~/rnaseq_pipeline/software/salmon-1.9.0_linux_x86_64/bin/salmon quant -l A -p 32 -i ~/rnaseq_pipeline/db/Caenorhabditis_elegans.WBcel235.cdna.all.fa_salmon_index -1 test_1.cleaned.fq.gz -2 test_2.cleaned.fq.gz --validateMappings -o test_salmon_quant -g ~/rnaseq_pipeline/db/Caenorhabditis_elegans.WBcel235.109.gtf &> log.salmon_output`  
`/home/wallke/rnaseq_pipeline/software/R-4.1.2/bin/Rscript /home/wallke/rnaseq_pipeline/scripts/scripts/RunDeSeq2_with_args.R daf-16_SVIP daf-16 salmon test_count_file.tsv test_sample_info.txt &> log.deseq2_output`  
`/home/wallke/rnaseq_pipeline/software/R-4.1.2/bin/Rscript /home/wallke/rnaseq_pipeline/scripts/scripts/volcano_plot_dge_results.r`  


# Instructions for Use

The following instructions for use were generereated "DAF-16/FOXO and HLH-30/TFEB comprise a cooperative regulatory axis controlling tubular lysosome induction in C. elegans" - Perez et al (2024) (https://www.ncbi.nlm.nih.gov/bioproject/?term=PRJNA1083209)


## SOFTWARE INSTALLATION AND SETUP

### Setup directory structure
`cd`  
`mkdir rnaseq_pipeline`  
`mkdir db software 0_fastq 1_quality 2_counts 3_dge logs`  

### Download the scripts directory from github
`git clone git@github.com:pkerrwall/rnaseq_pipeline.git`  
`ln -s rnaseq_pipeline scripts`  

Or download the repository with wget
`wget https://github.com/pkerrwall/rnaseq_pipeline/archive/refs/heads/main.zip`  
`unzip main.zip`  
`ln -s rnaseq_pipeline-main scripts`  

### Install NCBI sratoolkit - https://github.com/ncbi/sra-tools/wiki/01.-Downloading-SRA-Toolkit

The following package can be used to download and extract the fastq files used in this study 
`cd ~/rnaseq_pipeline/software`  
`wget https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/3.1.0/sratoolkit.3.1.0-ubuntu64.tar.gz`  
`tar -zxvf sratoolkit.3.1.0-ubuntu64.tar.gz`  

### Install TrimGalore - https://github.com/FelixKrueger/TrimGalore

Clone with git or download with wget
`cd ~/rnaseq_pipeline/software`  
`git clone git@github.com:FelixKrueger/TrimGalore.git`  

### Download salmon
`cd ~/rnaseq_pipeline/software`  
`wget https://github.com/COMBINE-lab/salmon/releases/download/v1.9.0/salmon-1.9.0_linux_x86_64.tar.gz`  
`tar -zxvf salmon-1.9.0_linux_x86_64.tar.gz`  

### Create python virtual environment and install packages
`cd ~/rnaseq_pipeline/software`  
`python -m venv rnaseq_pipeline`  
`source ./rnaseq_pipeline/bin/activate`  
`pip install cutadapt pyfastx pandas`  

### Install R 

With sudo rights (this will be the easiest installation)
`sudo apt-get install r-base`  

If you don't have sudo access, and need to install from source
`wget https://cran.r-project.org/src/base/R-4/R-4.1.2.tar.gz`  
`tar xzvf R-4.1.2.tar.gz`  
`cd R-4.1.2`  
`./configure --prefix=/home/wallke/rnaseq_pipeline/software/R-4.1.2 --enable-R-shlib --enable-memory-profiling --enable-R-profiling -with-valgrind-instrumentation=2`  
`make`  
`make install`  

### Install DeSeq2
`~/rnaseq_pipeline/software/R-4.1.2/bin/R`  
`install.packages('BiocManager')`  
`BiocManager::install("DESeq2")`  
`BiocManager::install("EnhancedVolcano")`  


## Commands for Pipeline

### Download the data
The data for "DAF-16/FOXO and HLH-30/TFEB comprise a cooperative regulatory axis controlling tubular lysosome induction in C. elegans" is at https://www.ncbi.nlm.nih.gov/bioproject/?term=PRJNA1083209 and includes the following SRR datasets - SRR28206915, SRR28206916, SRR28206917, SRR28206918, SRR28206919, SRR28206920, SRR28206921, SRR28206922, SRR28206923, SRR28206924, SRR28206925, SRR28206926

#### Setup the download
`cd ../0_fastq`  
`mkdir ncbi`  
`cd ncbi`  
`vim srr_list.txt`  
`echo 'SRR28206915\nSRR28206916\nSRR28206917\nSRR28206918\nSRR28206919\nSRR28206920\nSRR28206921\nSRR28206922\nSRR28206923\nSRR28206924\nSRR28206925\nSRR28206926' > srr_list.txt`  

#### Download SRR data
`../../software/sratoolkit.3.1.0-ubuntu64/bin/prefetch --option-file srr_list.txt`  

#### Create fastq files
`for i in */*.sra; do echo $i; ../../software/sratoolkit.3.1.0-ubuntu64/bin/fasterq-dump --split-files $i; done;`  

#### Compress data with gzip
`pigz *.fastq`  

#### Link (or rename) the files to names used in the paper
`cd ..`  
`ln -s ncbi/SRR28206915_1.fastq.gz N2_1_1.fq.gz`  
`ln -s ncbi/SRR28206915_2.fastq.gz N2_1_2.fq.gz`  
`ln -s ncbi/SRR28206924_1.fastq.gz N2_2_1.fq.gz`  
`ln -s ncbi/SRR28206924_2.fastq.gz N2_2_2.fq.gz`  
`ln -s ncbi/SRR28206923_1.fastq.gz N2_3_1.fq.gz`  
`ln -s ncbi/SRR28206923_2.fastq.gz N2_3_2.fq.gz`  
`ln -s ncbi/SRR28206918_1.fastq.gz SVIP-OE_1_1.fq.gz`  
`ln -s ncbi/SRR28206918_2.fastq.gz SVIP-OE_1_2.fq.gz`  
`ln -s ncbi/SRR28206917_1.fastq.gz SVIP-OE_2_1.fq.gz`  
`ln -s ncbi/SRR28206917_2.fastq.gz SVIP-OE_2_2.fq.gz`  
`ln -s ncbi/SRR28206916_1.fastq.gz SVIP-OE_3_1.fq.gz`  
`ln -s ncbi/SRR28206916_2.fastq.gz SVIP-OE_3_2.fq.gz`  
`ln -s ncbi/SRR28206921_1.fastq.gz daf-16_SVIP_1_1.fq.gz`  
`ln -s ncbi/SRR28206921_2.fastq.gz daf-16_SVIP_1_2.fq.gz`  
`ln -s ncbi/SRR28206920_1.fastq.gz daf-16_SVIP_2_1.fq.gz`  
`ln -s ncbi/SRR28206920_2.fastq.gz daf-16_SVIP_2_2.fq.gz`  
`ln -s ncbi/SRR28206919_1.fastq.gz daf-16_SVIP_3_1.fq.gz`  
`ln -s ncbi/SRR28206919_2.fastq.gz daf-16_SVIP_3_2.fq.gz`  
`ln -s ncbi/SRR28206926_1.fastq.gz daf-16_1_1.fq.gz`  
`ln -s ncbi/SRR28206926_2.fastq.gz daf-16_1_2.fq.gz`  
`ln -s ncbi/SRR28206925_1.fastq.gz daf-16_2_1.fq.gz`  
`ln -s ncbi/SRR28206925_2.fastq.gz daf-16_2_2.fq.gz`  
`ln -s ncbi/SRR28206922_1.fastq.gz daf-16_3_1.fq.gz`  
`ln -s ncbi/SRR28206922_2.fastq.gz daf-16_3_2.fq.gz`  

#### Trimming Process with TrimGalore
This step takes approximately 12 minutes for each replicate.  It took approximately 1 hour and 30 minutes to clean 4 samples with 3 replicates each paired-end (24 total files).
`cd ../1_quality`  
`ln -s ../0_fastq/*.gz .`  
`python ~/rnaseq_pipeline/scripts/scripts/trim_galore_pipeline_paired.py daf-16_1 ../software/TrimGalore/trim_galore`  
`for sample in N2_1 N2_2 N2_3 SVIP-OE_1 SVIP-OE_2 SVIP-OE_3 daf-16_SVIP_1 daf-16_SVIP_2 daf-16_SVIP_3 daf-16_1 daf-16_2 daf-16_3; do echo $sample; python ~/rnaseq_pipeline/scripts/scripts/trim_galore_pipeline_paired.py $sample ~/rnaseq_pipeline/software/TrimGalore/trim_galore &> ../logs/1_quality.trim.$sample.log; done` 

#### Counting with Salmon

Download the cdna and gtf datasets from ensemble (release-109) and create salmon index
`cd db`  
`wget https://ftp.ensembl.org/pub/release-109/fasta/caenorhabditis_elegans/cdna/Caenorhabditis_elegans.WBcel235.cdna.all.fa.gz`  
`wget https://ftp.ensembl.org/pub/release-109/gtf/caenorhabditis_elegans/Caenorhabditis_elegans.WBcel235.109.gtf.gz`  
`unpigz *`  

Build salmon index (<1 minute with 32 threads)  
`~/rnaseq_pipeline/software/salmon-1.9.0_linux_x86_64/bin/salmon index -p 32 -t Caenorhabditis_elegans.WBcel235.cdna.all.fa -i Caenorhabditis_elegans.WBcel235.cdna.all.fa_salmon_index`  

Map the reads with salmon (~20 minutes with 32 threads)  
`cd ~/rnaseq_pipeline/2_counts`  
`ln -s ../1_quality/*.cleaned.fq.gz .`  

Command to map 1 dataset  
`../software/salmon-1.9.0_linux_x86_64/bin/salmon quant -l A -p 32 -i ../db/Caenorhabditis_elegans.WBcel235.cdna.all.fa_salmon_index -1 daf-16_1_1.cleaned.fq.gz -2 daf-16_1_2.cleaned.fq.gz --validateMappings -o daf-16_1_salmon_quant -g ../db/Caenorhabditis_elegans.WBcel235.109.gtf`  
`for sample in N2_1 N2_2 N2_3 SVIP-OE_1 SVIP-OE_2 SVIP-OE_3 daf-16_SVIP_1 daf-16_SVIP_2 daf-16_SVIP_3 daf-16_1 daf-16_2 daf-16_3; do echo $sample; ../software/salmon-1.9.0_linux_x86_64/bin/salmon quant -l A -p 32 -i ../db/Caenorhabditis_elegans.WBcel235.cdna.all.fa_salmon_index -1 $sample\_1.cleaned.fq.gz -2 $sample\_2.cleaned.fq.gz --validateMappings -o $sample\_salmon_quant -g ../db/Caenorhabditis_elegans.WBcel235.109.gtf &> ../logs/1_quality.trim.$sample.log; done`  

Generate the count file  
`python ~/rnaseq_pipeline/scripts/scripts/salmon_counts.py .`  

#### Differential Gene Expression Anlaysis with DESeq2
`cd 3_dge`  
`ln -s ../3_counts/salmon.gene_counts.tsv .`  

Create sample_info.txt # tab-delimted with format "sample"\t"Condition"\n  
`echo 'sample\tCondition\ndaf-16_1\tdaf-16\ndaf-16_2\tdaf-16\ndaf-16_3\tdaf-16\ndaf-16_SVIP_1\tdaf-16_SVIP\ndaf-16_SVIP_2\tdaf-16_SVIP\ndaf-16_SVIP_3\tdaf-16_SVIP\nN2_1\tN2\nN2_2\tN2\nN2_3\tN2\nSVIP-OE_1\tSVIP-OE\nSVIP-OE_2\tSVIP-OE\nSVIP-OE_3\tSVIP-OE' > sample_info.txt`  
`../software/R-4.1.2/bin/Rscript ~/rnaseq_pipeline/scripts/scripts/RunDeSeq2_with_args.R SVIP-OE N2 salmon salmon.gene_counts.tsv sample_info.txt`  
`../software/R-4.1.2/bin/Rscript ~/rnaseq_pipeline/scripts/scripts/RunDeSeq2_with_args.R daf-16_SVIP daf-16 salmon salmon.gene_counts.tsv sample_info.txt`  

#### Volcano plots
`../software/R-4.1.2/bin/Rscript  ~/rnaseq_pipeline/scripts/scripts/volcano_plot_dge_results.r`  