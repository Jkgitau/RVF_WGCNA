#!/usr/bin/bash
 
DATA_DIR='/media/john/New Volume/datasets'

#TRIMMED_DIR='/media/john/New Volume/datasets/trimmed'

#mkdir -p ${TRIMMED_DIR}

for i in ${DATA_DIR}/*R1_001.fastq.gz ;

do

SAMPLE=$(echo ${i} | sed "s/R1_001\.fastq.gz//")

#  echo ${SAMPLE}R1.fastq.gz ${SAMPLE}R2.fastq.gz
  cutadapt \
        -j 4 \
        -a AGATCGGAAGAG \
        -A AGATCGGAAGAG \
        -q 20 \
	-m 75 \
        -o ${SAMPLE}R1_001_trimmed.fastq.gz \
        -p ${SAMPLE}R2_001_trimmed.fastq.gz \
        ${SAMPLE}R1_001.fastq.gz \
        ${SAMPLE}R2_001.fastq.gz
  echo ${SAMPLE} trimmed
#mv *_trimmed.fastq.gz trimmed
done
