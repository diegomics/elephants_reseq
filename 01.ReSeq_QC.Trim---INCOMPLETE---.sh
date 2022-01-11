echo ""
echo "=== STEP 1/3: FastQC ======================================"
echo ""

#mkdir -p
#FASTQC_JOB=
#FASTQC_JOB_ID=$(echo $FASTQC_JOB | cut -d ' ' -f4)

echo "=== STEP 2/3: Fastp     ======="
export FQ_DIR="~/Elephant_project/novaseq/sf_arantes_wgs_ele758_hvmmmdsx2"
export OUT_DIR="~/Elephant_project/novaseq/trimmed"
export LENGTH=$(ls $FQ_DIR/*R1*.fastq.gz | wc -l)

mkdir -p $OUT_DIR
FASTP_JOB=$(sbatch --array=1-$LENGTH --output=$OUT_DIR/%x.%A_%a.out --error=$OUT_DIR/%x.%A_%a.err ReSeq_QC.Trim.sh)
FASTP_JOB_ID=$(echo $FASTP_JOB | cut -d ' ' -f4)

#echo "=== STEP 3/3: MultiQC   ======="

#mkdir -p
#sbatch --dependency=afterok:$FASTQC_JOB_ID:$FASTP_JOB_ID --output=$OUTDIR/%x.%j.out --error=$OUTDIR/%x.%j.err test.job
