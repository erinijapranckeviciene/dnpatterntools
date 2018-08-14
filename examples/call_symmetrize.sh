#!/usr/bin/sh
echo ""
echo "INPUT selected dinucleotide frequency profiles on forward and complementary sequences : head -n4 ../data/seq25000.di.freq.selection.profiles"
echo ""
head -n4 ../data/seq25000.di.freq.selection.profiles
echo ""
#
# call symmetrize.sh
#
echo "Symmetrize selected dinucleotide frequency profiles"
echo  "CALL:  sh ../helper/symmetrize.sh ../data/seq25000.di.freq.selection.profiles ../data/seq25000.di.freq.selection.symmetrized.profile"
echo ""
sh ../helper/symmetrize.sh ../data/seq25000.di.freq.selection.profiles ../data/seq25000.di.freq.selection.symmetrized.profiles
echo ""
echo "Result:"
echo "CALL: head -n4 ../data/seq25000.di.freq.selection.symmetrized.profiles"
head -n4 ../data/seq25000.di.freq.selection.symmetrized.profiles
echo ""
echo "DONE"
