#!/usr/bin/sh
echo ""
echo "INPUT fasta file : head -n4 ../data/seq25000.fasta"
echo ""
head -n4 ../data/seq25000.fasta
echo ""
#
# call shuffle_sequences.sh
#
echo "Shuffle dinucleotides in fasta sequences. This might be lenghty task."
echo "CALL:  sh ../helper/shuffle_sequences.sh ../data/seq25000.fasta 2 ../data/seq25000.di.shuffled.fasta"
echo ""
sh ../helper/shuffle_sequences.sh ../data/seq25000.fasta 2 ../data/seq25000.di.shuffled.fasta
echo ""
echo "Result:"
echo "CALL: head -n4 ../data/seq25000.di.freq.selection.symmetrized.composites.smoothed.profiles"
head -n4 ../data/seq25000.di.shuffled.fasta
echo ""
echo "DONE"
