#!/usr/bin/sh
echo ""
echo "INPUT fasta file : head -n4 ../data/seq25000.fasta"
echo ""
head -n4 ../data/seq25000.fasta
echo ""
#
# call binary_sequences.sh
#
echo "Transform the fasta into binary representation of dinucleotide occurrences for these dinucleotides AA CC GG"
echo "CALL:  sh ../helper/binary_strings.sh ../data/seq25000.fasta  \"AA CC CG\" ../data/seq25000.fasta.binary.tabular"
echo ""
sh ../helper/binary_strings.sh ../data/seq25000.fasta  "AA CC CG" ../data/seq25000.fasta.binary.tabular
echo ""
echo "Result:"
echo "CALL: head -n4 ../data/seq25000.fasta.binary.tabular"
head -n4 ../data/seq25000.fasta.binary.tabular
echo ""
echo "DONE"
