#!/usr/bin/bash

DATA_DIR='/media/sf_G_DRIVE/Network_analysis/topup'
TRIMMED_DIR='/media/sf_G_DRIVE/Network_analysis/trimmed/new'

mkdir -p ${TRIMMED_DIR}
#for fastq in `ls -1 ${DATA_DIR}/*_R1_001.fastq.gz | sed 's/_R1_001.fastq.gz//'`;
for i in ${DATA_DIR}/*R1_001.fastq.gz
do
  fqname=$(basename "$i" _R1_001.fastq.gz)
 
 SAMPLE=$(echo ${i} | sed "s/R1_001\.fastq.gz//")
  echo ${SAMPLE}R1.fastq.gz ${SAMPLE}R2.fastq.gz
  cutadapt \
        -j 8 \
        -a AGATCGGAAGAG \
        -A AGATCGGAAGAG \
        -q 20 \
	-m 75 \
        -o ${TRIMMED_DIR}/${fqname}_R1_001_trimmed.fastq.gz \
        -p ${TRIMMED_DIR}/${fqname}_R2_001_trimmed.fastq.gz \
        ${SAMPLE}R1_001.fastq.gz \
        ${SAMPLE}R2_001.fastq.gz

  echo ${SAMPLE} trimmed

done
