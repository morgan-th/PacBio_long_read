cd /scratch/rr3900/Masseq/Yen_DGRP_L3/CLI_output

module load samtools/intel/1.14

#align to reference genome
pbmm2 align --preset ISOSEQ --sort ./DGRP_LIB01.fltnc.corrected.sorted.dedup.bam \
/scratch/rr3900/Masseq/reference_genome/Drosophila_melanogaster.BDGP6.46.dna.toplevel.fa \
./DGRP_LIB01_mapped.bam

#collapse redundant transcripts
isoseq collapse ./DGRP_LIB01_mapped.bam \
./DGRP_LIB01_collapsed.gff

#index mapped bam
samtools index ./DGRP_LIB01_mapped.bam
