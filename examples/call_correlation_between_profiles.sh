#!/usr/bin/sh
echo ""
echo "INPUT dinucleotide frequency profiles file : head -n4 ../data/seq25000.di.freq.profiles "
echo ""
head -n4 ../data/seq25000.di.freq.profiles 
echo ""
#
# expected output:
#
#AA.f	AA.r	AC.f	AC.r	AG.f	AG.r	AT.f	AT.r	CA.f	CA.r	CC.f	CC.r	CG.f	CG.r	CT.f	CT.r	GA.f	GA.r	GC.f	GC.r	GG.f	GG.r	GT.f	GT.r	TA.f	TA.r	TC.f	TC.r	TG.f	TG.r	TT.f	TT.r
#0.076320	0.067920	0.057800	0.078120	0.081600	0.061960	0.055600	0.044080	0.081600	0.051760	0.067360	0.068960	0.010960	0.051040	0.078400	0.066520	0.066520	0.078400	0.051040	0.010960	0.068960	0.067360	0.051760	0.081600	0.044080	0.055600	0.061960	0.081600	0.078120	0.057800	0.067920	0.076320
#0.077160	0.073760	0.056000	0.072160	0.079400	0.060720	0.055960	0.047040	0.079840	0.053160	0.063280	0.067280	0.012360	0.051080	0.082680	0.068120	0.068120	0.082680	0.051080	0.012360	0.067280	0.063280	0.053160	0.079840	0.047040	0.055960	0.060720	0.079400	0.072160	0.056000	0.073760	0.077160
#
# call correlation_between_profiles  to compute  correlations between 
# forvard  and complementary  dinucleotide frequency profiles to determine dyad position
#
echo "Compute correlation profiles for all 16 dinucleotides within 146 bp sliding window"
echo " Maximum correlation and its position in the  sequence is printed to the standard output in the form:"
echo ""
echo "AA 25 0.302845,AC 43 0.194612,AG 36 0.250541,AT 16 0.147822,CA 14 0.0792241,CC 31 0.13694,CG 5 0.145501,CT 11 2.78121e-05,GA 11 2.78121e-05,GC 5 0.145501,GG 31 0.13694,GT 14 0.0792241,TA 16 0.147822,TC 36 0.250541,TG 43 0.194612,TT 25 0.302845,avg  6 0.0615543"
echo ""
echo  "CALL: sh ../helper/correlation_between_profiles.sh ../data/seq25000.di.freq.profiles 146 \"AA AC AG AT CA CC CG CT GA GC GG GT TA TC TG TT\" ../data/seq25000.di.corr.profiles"
echo ""
sh ../helper/correlation_between_profiles.sh ../data/seq25000.di.freq.profiles 146 "AA AC AG AT CA CC CG CT GA GC GG GT TA TC TG TT" ../data/seq25000.di.corr.profiles 
echo ""
echo ""
echo "Print result "
echo ""
echo "CALL: head -n3 ../data/seq25000.di.cor.profiles "
head -n3 ../data/seq25000.di.corr.profiles 
echo ""
echo "DONE"
# expected output
