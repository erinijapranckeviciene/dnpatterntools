#!/bin/sh
# Wrapper for ushuffle program which shuffles dinucleotides in the sequence sequences preserving frequency information 
# Created by M Jiang. Reference:
##############################################################################################################################
# CALL:  sh shuffle_sequences.sh file.input.fasta number_of_letters file.output.fasta 
# INPUT: 
#       file.input.fasta   - input fasta file to shuffle dinucleotides 
#       number_of_letters  - it is dinucleotide =2
# OUTPUT:
#      file.output.fasta    - file name to write the shuffled sequences
# 
###############################################################################################################################

if test "$#" -ne 3; then
    echo "Parameters missing in the CALL:  sh shuffle_sequences.sh file.input.fasta 2 file.output.fasta"
    exit 1
fi

name=$1
diset=$2
out=$3
# uncomment for a galaxy tool
#dir=`pwd`/../../../../../tools/nuc_tools

# comment for a galaxy tool
dir=../core/extras
call=${dir}/ushuffle

## given fasta file the sequences are shuffled preserving  $diset n-mer  frequency
##  output is fasta file

#echo ${call}
#echo ${name}
#echo ${diset}
#echo ${out} 

# prepare fasta into tabular
cat ${name} | awk 'BEGIN{RS=">";OFS="\t"}NR>1{print ">"$1,$2}' > temp.tab.fa


# read the tab file and create shuffled fasta
while read -r line; 
do 
   seq=`echo $line | tr " " "\t" | cut -f2` 
   useq=`${call} -s ${seq} -k ${diset} -n 1`; 
   echo $line
   echo $useq 
done <  temp.tab.fa > ${out}
rm *.tab.fa

