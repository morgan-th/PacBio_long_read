
cd /scratch/rr3900/Masseq/Yen_DGRP_L3/CLI_output/

#remove features without "gene_name" column
grep "gene_name" /scratch/rr3900/Masseq/reference_genome/Drosophila_melanogaster.BDGP6.46.57.gtf \
> /scratch/rr3900/Masseq/reference_genome/Drosophila_melanogaster.BDGP6.46.57.filtered.gtf

pigeon prepare /scratch/rr3900/Masseq/reference_genome/Drosophila_melanogaster.BDGP6.46.57.filtered.gtf \
/scratch/rr3900/Masseq/reference_genome/Drosophila_melanogaster.BDGP6.46.dna.toplevel.fa

pigeon prepare ./DGRP_LIB01_collapsed.gff

echo "pigeon prepare done"

pigeon classify ./DGRP_LIB01_collapsed.sorted.gff \
/scratch/rr3900/Masseq/reference_genome/Drosophila_melanogaster.BDGP6.46.57.filtered.sorted.gtf \
/scratch/rr3900/Masseq/reference_genome/Drosophila_melanogaster.BDGP6.46.dna.toplevel.fa \
--fl ./DGRP_LIB01_collapsed.abundance.txt -j 4

echo "pigeon classify done"

pigeon filter ./DGRP_LIB01_collapsed_classification.txt \
--isoforms ./DGRP_LIB01_collapsed.sorted.gff -j 4

echo "pigeon filter done"

pigeon report ./DGRP_LIB01_collapsed_classification.filtered_lite_classification.txt \
./DGRP_LIB01_saturation.txt

echo "pigeon report done"

mkdir Seurat
cd Seurat
mkdir with_novel_genes
mkdir no_novel_genes

cd with_novel_genes
pigeon make-seurat --keep-novel-genes --keep-ribo-mito-genes \
--dedup ../../DGRP_LIB01.fltnc.corrected.sorted.dedup.fasta \
--group ../../DGRP_LIB01_collapsed.group.txt ../../DGRP_LIB01_collapsed_classification.filtered_lite_classification.txt \
-j 4

cd ../no_novel_genes
pigeon make-seurat --keep-ribo-mito-genes \
--dedup ../../DGRP_LIB01.fltnc.corrected.sorted.dedup.fasta \
--group ../../DGRP_LIB01_collapsed.group.txt ../../DGRP_LIB01_collapsed_classification.filtered_lite_classification.txt \
-j 4
