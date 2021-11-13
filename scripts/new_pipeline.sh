#!/usr/bin/bash

#download the data - attained locally, this is skipped

# it is important to check some statistics of working dataset for  better understanding
# use seqkit tool for this
seqkit *.gz

#check the data quality using FastQC v0.11.5
# using parallel processing to check all the files once
#check the data quality using FastQC v0.11.5
# using parallel processing to check all the files once

fastqc -t 13 *.fastq.gz # specify the number of files to be processed

#combine the html files into a single file for easier analysis

multiqc .

# Remove low quality reads and adapters using trimmomatic

java -jar /home/user/networks/tools/Trimmomatic-0.39/trimmomatic-0.39.jar PE 1_Ambs_201_S64_R1_001.fastq.gz 1_Ambs_201_S64_R2_001.fastq.gz R1_001.trimmed.fastq.gz R1_001_unpaired.fastq.gz R2_001.trimmed.fastq.gz R2_001_unpaired.fastq.gz ILLUMINACLIP:/home/user/networks/tools/Trimmomatic-0.39/adapters/TruSeq3-PE.fa:2:30:10:2:keepBothReads LEADING:3 TRAILING:3 MINLEN:36

# Align reads to the human  h38 reference genome using bowie2 tool
bowtie2 --very-fast-local -x /home/user/networks/data/ref_NCBI/bowtie2 -1 R1_001.trimmed.fastq.gz -2 R2_001.trimmed.fastq.gz -S sample1.sam

# convert sam file to bam for proper disk space utilization
samtools view -b -S sample1.sam > sample1.bam

# sort the bam file for proper arrangement of reads
samtools sort sample1.bam -o sample1_sorted.bam

# index the sorted bam file
samtools index  sample1_sorted.bam


#!/usr/bin/bash

#download the data - attained locally, this is skipped
#check the data quality using FastQC v0.11.5
# using parallel processing to check all the files once

fastqc -t 13 *.fastq.gz # specify the number of files to be processed

#combine the html files into a single file for easier analysis

multiqc .

# Remove low quality reads and adapters using trimmomatic

java -jar /home/user/networks/tools/Trimmomatic-0.39/trimmomatic-0.39.jar PE 1_Ambs_201_S64_R1_001.fastq.gz 1_Ambs_201_S64_R2_001.fastq.gz R1_001.trimmed.fastq.gz R1_001_unpaired.fastq.gz R2_001.trimmed.fastq.gz R2_001_unpaired.fastq.gz ILLUMINACLIP:/home/user/networks/tools/Trimmomatic-0.39/adapters/TruSeq3-PE.fa:2:30:10:2:keepBothReads LEADING:3 TRAILING:3 MINLEN:36

