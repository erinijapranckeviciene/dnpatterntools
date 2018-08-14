#!/usr/bin/sh
echo ""
echo "INPUT symmetrized dinucleotide frequency profiles : head -n4 ../data/seq25000.di.freq.selection.symmetrized.profiles"
echo ""
head -n4 ../data/seq25000.di.freq.selection.symmetrized.profiles
echo ""
#
# call compute_composites.sh
#
echo "Compute composite WW SS RR and YY profiles from symmetrized dinucleotide frequency profiles. Add columns to the original file."
echo "CALL:  sh ../helper/compute_composite.sh ../data/seq25000.di.freq.selection.symmetrized.profiles ../data/seq25000.di.freq.selection.symmetrized.composites.profile"
echo ""
sh ../helper/compute_composite.sh ../data/seq25000.di.freq.selection.symmetrized.profiles ../data/seq25000.di.freq.selection.symmetrized.composites.profiles
echo ""
echo "Result:"
echo "CALL: head -n4 ../data/seq25000.di.freq.selection.symmetrized.composites.profiles"
head -n4 ../data/seq25000.di.freq.selection.symmetrized.composites.profiles
echo ""
echo "DONE"
