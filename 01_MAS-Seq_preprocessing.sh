
cd /scratch/rr3900/Masseq/Yen_DGRP_L3/CLI_output

# step 01 - skera
skera split /scratch/rr3900/Masseq/Yen_DGRP_L3/2_D09/m64219e_231217_003814.hifi_reads.bam \
/scratch/rr3900/Masseq/MAS-Seq_Adapter_v1/mas16_primers.fasta ./DGRP_LIB01.skera.bam

# step 02 - lima
/scratch/work/public/singularity/run-smrtlink-13.0.0.bash lima \
./DGRP_LIB01.skera.bam /scratch/rr3900/Masseq/10X_3prime_primers.fasta \
./DGRP_LIB01.fl.bam --isoseq

# step 03 - tag removal
isoseq tag ./DGRP_LIB01.fl.5p--3p.bam \
./DGRP_LIB01.flt.bam --design T-12U-16B

# step 04 - refine
isoseq refine ./DGRP_LIB01.flt.bam \
/scratch/rr3900/Masseq/10X_3prime_primers.fasta ./DGRP_LIB01.fltnc.bam --require-polya

# step 05 - barcode correction
isoseq correct --barcodes /scratch/rr3900/Masseq/3M-february-2018-REVERSE-COMPLEMENTED.txt \
./DGRP_LIB01.fltnc.bam \
./DGRP_LIB01.fltnc.corrected.bam

# step 05 - barcode statistics
isoseq bcstats --json ./DGRP_LIB01.fltnc.corrected.report.json \
-o ./DGRP_LIB01.fltnc.corrected.bcstats.tsv \
./DGRP_LIB01.fltnc.corrected.bam

# step 06 - PCR deduplication
module load samtools/intel/1.14

samtools sort -t CB ./DGRP_LIB01.fltnc.corrected.bam \
-o ./DGRP_LIB01.fltnc.corrected.sorted.bam \

isoseq groupdedup ./DGRP_LIB01.fltnc.corrected.sorted.bam \
./DGRP_LIB01.fltnc.corrected.sorted.dedup.bam
