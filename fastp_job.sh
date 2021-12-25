#!/bin/bash

## Full installation ##########################
##conda create -n FASTP_env -c bioconda fastp
###############################################

export PATH=../Software/anaconda3/bin:$PATH

# Only change these: #####################################################################
export FQ_DIR1="../Elephant_project/novaseq/sf_arantes_wgs_ele758_hvmmmdsx2"
export FQ_DIR2="../Elephant_project/novaseq/sf_arantes_wgs_ele758_hwgljdsx2"
export OUT_DIR="../Elephant_project/novaseq/trimmed"
##########################################################################################
mkdir -p $OUT_DIR

for i in $(ls $FQ_DIR1/*R1*.fastq.gz)
do
        job_time="$(date +%Y%m%d).$(date +%H%M%S)"
        sleep 2
        source activate FASTP_env
        READ_NAME=$(basename $i _R1_001.fastq.gz)
        srun -J "${job_time}_fastp" -o $OUT_DIR/${READ_NAME}.out -e $OUT_DIR/${READ_NAME}.err --partition=begendiv,main --qos=standard --cpus-per-task=3 --mem=9G --time=12:00:00 fastp --in1 $i --in2 $FQ_DIR1/${READ_NAME}_R2_001.fastq.gz --out1 $OUT_DIR/${READ_NAME}_R1.trimmed.fastq.gz --out2 $OUT_DIR/${READ_NAME}_R2.trimmed.fastq.gz -l 50 -h $OUT_DIR/${READ_NAME}.html -j $OUT_DIR/${READ_NAME}.fastp.json &
done

for i in $(ls $FQ_DIR2/*R1*.fastq.gz)
do
        job_time="$(date +%Y%m%d).$(date +%H%M%S)"
        sleep 2
        source activate FASTP_env
        READ_NAME=$(basename $i _R1_001.fastq.gz)
        srun -J "${job_time}_fastp" -o $OUT_DIR/${READ_NAME}.out -e $OUT_DIR/${READ_NAME}.err --partition=begendiv,main --qos=standard --cpus-per-task=3 --mem=9G --time=12:00:00 fastp --in1 $i --in2 $FQ_DIR2/${READ_NAME}_R2_001.fastq.gz --out1 $OUT_DIR/${READ_NAME}_R1.trimmed.fastq.gz --out2 $OUT_DIR/${READ_NAME}_R2.trimmed.fastq.gz -l 50 -h $OUT_DIR/${READ_NAME}.html -j $OUT_DIR/${READ_NAME}.fastp.json &
done
