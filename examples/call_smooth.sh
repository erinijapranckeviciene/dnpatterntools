#!/usr/bin/sh
echo ""
echo "INPUT symmetrized dinucleotide frequency profiles : head -n4 ../data/seq25000.di.freq.selection.symmetrized.composites.profiles"
echo ""
head -n4 ../data/seq25000.di.freq.selection.symmetrized.composites.profiles
echo ""
#
# call smooth.sh
#
echo "Compute composite WW SS RR and YY profiles from symmetrized dinucleotide frequency profiles. Averaging window size=3, trim from both ends by 4 positions"
echo "CALL:  sh ../helper/smooth.sh ../data/seq25000.di.freq.selection.symmetrized.composites.profiles 3 4 ../data/seq25000.di.freq.selection.symmetrized.composites.smoothed.profile"
echo ""
sh ../helper/smooth.sh ../data/seq25000.di.freq.selection.symmetrized.composites.profiles 3 4 ../data/seq25000.di.freq.selection.symmetrized.composites.smoothed.profiles
echo ""
echo "Result:"
echo "CALL: head -n4 ../data/seq25000.di.freq.selection.symmetrized.composites.smoothed.profiles"
head -n4 ../data/seq25000.di.freq.selection.symmetrized.composites.smoothed.profiles
echo ""
echo "DONE"
