#!/bin/bash
# minimum example for fast demo
# grep ^chr19 SRR1138261.bed | head -n 100000 > SRR1138261.chr19.bed

# compute coverage zero covered bases included
echo "Compute coverage"
genomeCoverageBed -bga -i SRR1138261.chr19.bed -g mm9.chrom.sizes  > SRR1138261.chr19.coverage.bed
head -n4 SRR1138261.chr19.coverage.bed

# create input for gaussian smooting and summit computation
echo "Create input for gaussian smooting and summit position"
cat SRR1138261.chr19.coverage.bed | sed 's/.*0$/;/' |  tr "\n" ";" | tr "\t" "-" | sed 's/;;/\n/g' | sed 's/^;//' > SRR1138261.chr19.ginput.bed

## perform gaussian smooting  , identify summit position
echo "Smooting and summit position"
while read -r l
do 
  echo $l ;  sed 's/;/\n/g'| sed 's/-/\t/g'| cut -f2-4 | gawk -f gauss/profile_gausian.awk av=70 sig=3 buffer=100000 | tr "\n" "=" | sed 's/=$/\n/' | tr "=" "\n" | gawk -f gauss/chr_max_pos.awk window=70 buffer=100000 | awk -v chrom="chr19" -v file="SRR1138261" '{print chrom "\t" $1 "\t" $1+1 "\t" file "\t" $2 }'; 
done < SRR1138261.chr19.ginput.bed > SRR1138261.chr19.pos

bedtools sort -i SRR1138261.chr19.pos | uniq > SRR1138261.chr19.psorted.bed
head SRR1138261.chr19.psorted.bed

#echo "Compute coverage at the summits / for statistics"
#cat SRR1138261.chr19.bed | coverageBed -counts -a SRR1138261.chr19.pos -b -  > coverage.stat
#head coverage.stat

## find summits closest to TSS
echo "Find summits closest to TSS"
bedtools closest -D "ref" -b SRR1138261.chr19.psorted.bed -a mm9.chr19.RefSeq.bed  > t.bed
head -n 4 t.bed
echo "Summits height 10 closest to TSS by their associated dyad position"
## find summits of no less 10 height whose associated dyad position 
## is closest to TSS within 1000 base pairs
cat t.bed | grep "+" | awk '{if($11>10) print }' | awk '{ if (($8+74-$2) > 0) print $0 "\t" $8+74-$2 }' > tplus.bed
cat t.bed | grep "-" | awk '{if($11>10) print }' | awk '{ if (($3-($8-74)) > 0) print $0 "\t" $3-($8-74) }' > tminus.bed
cat tplus.bed tminus.bed | awk '{if ($13 <1000) print $7 "\t" $8 "\t" $9 "\t" $0}' > SRR1138261.chr19.summits.bed
head SRR1138261.chr19.summits.bed

echo "Reads overlapping summits no less than 30 from the end"
## find reads overlapping the summits, extend their coordinates and get fasta
bedtools intersect -wo -a SRR1138261.chr19.bed -b SRR1138261.chr19.summits.bed | awk '{if (($8-$2)>30) print $0 }' > t.bed
echo "Extend reads"
cat t.bed | awk '{print $1 "\t" $2 "\t" $3 "\t" $0}' | bedtools slop -r 100 -l 20 -g mm9.chrom.sizes > tplus.bed

## put the columns in order
cat tplus.bed | awk '{print $1 "\t" $2 "\t" $3 "\t" $13 "\t" $14 "\t" $15 "\t" $16 "\t" $10 "\t" $11 "\t" $11 "\t" $4 "\t" $5 "\t" $6 "\t" $7 "\t" $11 "\t" $23 "\t" $8 "\t" $25 }' | sed 's/\t/,/g4' | bedtools getfasta -name+ -fi chr19.fa -bed - > SRR1138261.chr19.nuc.fa

## apply to obtain a plain fasta without gene info to remove duplicated sequences
## awk 'BEGIN{RS=">";OFS="\t"}NR>1{print $1,$2}' SRR1138261.chr19.nuc.fa | uniq | awk '{print ">"$0}' | tr "\t" "\n" > SRR1138261.chr19.nuc.plain.fa 

#rm t.bed tplus.bed tminus.bed

