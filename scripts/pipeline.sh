#!/bin/bash

# Analysis pipeline for analysis of kenya breast cancer patients, 23 PE RNA-Seq samples

# odd  numbered samples represent tumor samples while even numbered samples are for normal samples. 

#sequencing was done for normal and tumor samples in each patient

# The working data is in fastq.gz format in raw_data directory

# First, check the quality of the datasets using fastqc tool

# To print err in stdoutput if it occurs
set -e 

# change directory to where the raw sequence files are located
#cd /media/sf_G_DRIVE/Network_analysis

#echo "Running FastQC . . . . ."

#fastqc *.fastq.gz

#mkdir -p ~/networks/original_data/results/

#echo "saving FastQC Results. . . ."

#mv *.zip ~/networks/original_data/results/

#mv *.html ~/networks/original_data/results/

#cd ~/networks/original_data/results/

#echo "combining QC reports to a single HTML page for easier analysis"

#multiqc .

# Visualize the html page on a web page

# firefox multiqc_report.html

# Running trimmomatic to remove adapters

#echo "Removing adapters and low quality reads from files"

cd ~/networks/original_data/

for infile in *_R1_001.fastq.gz
 do
   base=$(basename ${infile} _R1_001.fastq.gz)
   java -jar /home/user/networks/tools/Trimmomatic-0.39/trimmomatic-0.39.jar PE ${infile} ${base}_R2_001.fastq.gz \
                ${base}_R1_001.trimmed.fastq.gz ${base}_R1_001.untrimmed.fastq.gz \
                ${base}_R2_001.trimmed.fastq.gz ${base}_R2_001.untrimmed.fastg.gz \
                ILLUMINACLIP:/home/user/networks/tools/Trimmomatic-0.39/adapters/TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36

mkdir -p ~/networks/original_data/results/Trimmomatic_results/

echo "saving Trimmomatic Results . . . ."

mv *_R1_001.trimmed.fastq.gz ~/networks/original_data/results/Trimmomatic_results/

mv *_R2_001.trimmed.fastq.gz ~/networks/original_data/results/Trimmomatic_results/

cd ~/networks/original_data/results/Trimmomatic_results/

echo "Trimmomatic analysis completed"

# Redirect the results to Trimmomatic_FatQC directory

mkdir -p ~/networks/original_data/results/Trimmomatic_results/Trimmomatic_FatQC/

echo "saving Trimmomatic FastQC Results . . . ."

mv *_R1_001.trimmed.fastq.gz ~/networks/original_data/results/Trimmomatic_results/Trimmomatic_FatQC/

mv *_R2_001.trimmed.fastq.gz ~/networks/original_data/results/Trimmomatic_results/Trimmomatic_FatQC/

cd ~/networks/original_data/results/Trimmomatic_results/Trimmomatic_FatQC/

fastqc *.fastq.gz

# combine the fastQC results into a single output file

multiqc .

# Visualize the html page of trimmed reads to see whether the adapters are removed

#firefox multiqc_report.html

# Align reads to the human h38 reference genome using bowie2 tool

# move the clean fastq files to a different directory to continue with the analysis

mkdir -p ~/networks/original_data/results/Trimmomatic_results/Trimmomatic_FatQC/clean_data/

mv *.gz ~/networks/original_data/results/Trimmomatic_results/Trimmomatic_FatQC/clean_data/

cd ~/networks/original_data/results/Trimmomatic_results/Trimmomatic_FatQC/clean_data/

for infile in *_R1_001.trimmed.fastq.gz
 do
   base=$(basename ${infile} _R1_001.trimmed.fastq.gz)
   bowtie2 --very-fast-local -x /home/user/networks/data/ref_NCBI/bowtie2 -1 ${base}_R1_001.trimmed.fastq.gz -2 ${base}_R2_001.trimmed.fastq.gz

# move the generated sam files to their own directory  for further analysis

mkdir -p ~/networks/original_data/results/Trimmomatic_results/Trimmomatic_FatQC/clean_data/sam_files/

# change file path to the directory containing sam files

cd ~/networks/original_data/results/Trimmomatic_results/Trimmomatic_FatQC/clean_data/sam_files/

# make a directory containing all the bam files

mkdir -p ~/networks/original_data/results/Trimmomatic_results/Trimmomatic_FatQC/clean_data/sam_files/bam_files/

#cd ~/networks/original_data/results/Trimmomatic_results/Trimmomatic_FatQC/clean_data/sam_files/bam_files/

# convert sam files to bam for proper disk space utilization, sort them and generate indixes
samtools view -b -S ${base}.sam > ${base}.bam

mv *.bam ~/networks/original_data/results/Trimmomatic_results/Trimmomatic_FatQC/clean_data/sam_files/bam_files/

# change the file path to the directory containing bam files

cd ~/networks/original_data/results/Trimmomatic_results/Trimmomatic_FatQC/clean_data/sam_files/bam_files/

# make a directory containing all the bam files

#mkdir -p ~/networks/data/Trimmomatic_results/Trimmomatic_FatQC/sam_files/bam_files/

# move all sorted bam files to the newly created bam directory

mv *.sorted.bam ~/networks/data/Trimmomatic_results/Trimmomatic_FatQC/bam_files/

cd ~/networks/data/Trimmomatic_results/Trimmomatic_FatQC/sam_files/bam_files/

# generate counts for each sample associated with each gene using htseq count software

htseq-count -f bam -t gene -i gene_id -s no ${base}_sorted.bam /home/user/networks/data/GTF/GCF_000001405.39_GRCh38.p13_genomic.gtf

# make a directory to contain all the txt files

mkdir -p ~/networks/data/Trimmomatic_results/Trimmomatic_FatQC/bam_files/txt_files/

# move all txt files to one directory for easier combining to forma a single data frame to export to R Environment.

mv *.txt ~/networks/data/Trimmomatic_results/Trimmomatic_FatQC/bam_files/txt_files/

done
