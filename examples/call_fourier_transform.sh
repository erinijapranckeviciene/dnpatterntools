#!/usr/bin/sh
echo ""
echo "INPUT symmetrized dinucleotide frequency profiles : head -n4 ../data/seq25000.di.freq.selection.symmetrized.composites.profiles"
echo ""
head -n4 ../data/seq25000.di.freq.selection.symmetrized.composites.profiles
echo ""
#
# call fourier_transform.sh
#
echo "Compute periodogram on  symmetrized dinucleotide frequency profiles. Averaging window size=3, trim from both ends by 4 positions apply quadratic normalization"
echo "CALL:  sh ../helper/fourier_transform.sh ../data/seq25000.di.freq.selection.symmetrized.composites.profiles ../data/seq25000.di.freq.selection.symmetrized.composites.smoothed.profile" 2 3 4
echo ""
sh ../helper/fourier_transform.sh ../data/seq25000.di.freq.selection.symmetrized.composites.profiles ../data/seq25000.di.freq.selection.symmetrized.composites.fourier 2 3 4
echo ""
echo "Result:"
echo "CALL: head -n4 ../data/seq25000.di.freq.selection.symmetrized.composites.fourier"
head -n4 ../data/seq25000.di.freq.selection.symmetrized.composites.fourier
echo ""
echo "DONE"
