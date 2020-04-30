#!/bin/sh

if test "$#" -ne 3; then

echo ""
echo ""
echo " CALL  "
echo "   sh shuffle_sequences.sh input.fasta k output.fasta"
echo ""
echo " INPUT" 
echo "   input.fasta   - input fasta file "
echo "   k             - 'preserve frequency of k letters (dinucleotide k=2)'"
echo ""
echo " OUTPUT"
echo "   output.fasta   - shuffle fasta file "
echo ""
echo " DESCRIPTION"
echo "   Wrapper for ushuffle program Created by M Jiang. Reference PMID: 18405375 ."
echo "   The ushuffle shuffles nucleotides in fasta sequence preserving frequency" 
echo "   of k-mers, a positional order is changed. By default  k=2." 
echo "   A sequence in fasta file is shuffled only once. The output fasta"
echo "   in the identifier >line contains the original sequence; a shuffled sequence "
echo "   is output on the second line."   
echo ""
echo " REQUIREMENT"
echo "   ushuffle installed"
echo "   conda install -c bioconda ushuffle"
echo ""

    exit 1
fi

name=$1
diset=$2
out=$3

# comment for a galaxy tool
call=ushuffle

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
rm temp.tab.fa

