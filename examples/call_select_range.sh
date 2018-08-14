#!/usr/bin/sh
echo ""
echo "INPUT dinucleotide frequency profiles on forward and complementary sequences : head -n4 ../data/seq25000.di.freq.profiles"
echo ""
head -n4 ../data/seq25000.di.freq.profiles
echo ""
#
# call select_range.sh
#
echo "select rows within the range start : start+length(146bp) from dinucleotide frequency profiles  for given dinucleotide columns"
echo "Additional column is created with the position IDs"
echo  "CALL:  sh ../helper/select_range.sh seq25000.di.freq.profile 25 146 \"AA AC AG AT CA CC CG CT  GA GC GG GT TA TC TG TT\" ../data/seq25000.di.freq.selection.profile"
echo ""
sh ../helper/select_range.sh ../data/seq25000.di.freq.profiles 25 146 "AA AC AG AT CA CC CG CT  GA GC GG GT TA TC TG TT" ../data/seq25000.di.freq.selection.profiles
echo ""
echo "Result:"
echo "CALL: head -n4 ../data/seq25000.di.freq.selection.profiles"
head -n4 ../data/seq25000.di.freq.selection.profiles
echo ""
echo "DONE"
