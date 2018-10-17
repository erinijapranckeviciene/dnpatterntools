#!/bin/sh
if test "$#" -ne 3; then

echo ""
echo " CALL  "
echo "   sh binary_strings.sh input.fasta dinucleotides output.file"
echo ""
echo " INPUT" 
echo "   input.fasta   - input fasta file "
echo "   dinucleotides - 'AA AC AG AT ...'"
echo ""
echo " OUTPUT"
echo "   output.file   - name of tabular format output file "
echo ""
echo " DESCRIPTION"
echo "   Convert fasta sequences to a binary sequence of 01 "
echo "   in which 1(ones) indicate a presence of a given" 
echo "   dinucleotide at that position and 0 everywhere else." 
echo "   Each fasta sequence in the input file has a "
echo "   corresponding row with four tab separated columns" 
echo "   binary_string dinucleotide fasta_string times_occurred"
echo ""
echo " REQUIREMENT"
echo "   dnp-binstrings installed"
echo "   conda install -c bioconda dnp-binstrings"
echo ""
  exit 1
fi

name=$1
diset=$2
out=$3

call=dnp-binstrings

cp ${name} ${name}.fa

for di in ${diset}
do
    ${call} ${name}.fa -di ${di} >> ${out}
done;
rm ${name}.fa
exit 0
