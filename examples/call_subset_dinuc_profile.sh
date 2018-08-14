#!/usr/bin/sh
echo ""
echo "INPUT fasta : head -n4 ../data/seq25000.fasta "
echo ""
head -n4 ../data/seq25000.fasta 
echo ""
#
# expected output:
#
#>chr9:42475963-42476182
#CCAGGCAGACCCCATATTCAAGCTGCTGCCCCAGGGTGGTGTACAGATCTGGGGAGAAGAAGGATGAGACACTGAGCAGTAAGCCCCAGACTGAGCTAGGAGGACCCGAAGAAGAGTCCTGGCTTTGCCATGATAAGTACTTTATGTCCCTTaaaacaaaacaaaacaaacaaaacaaaacacatcaaaacaaaacaTACCCAATGCTGTTTTCTGCAC
#>chr9:42476175-42476394
#TCTGCACTCCAGCATGCCTGAGGAGAGGAGGGAATGCAGGATCCTAGTGGAAAGAGTACCAAGCTGGGAGGCTGCAGTACCCATCAAAGTACTGAGTGTAGAGACTCGATGTTTCACATACACCCAAGCCACAGACCTCCCCAAGccccataagagctaaaggagagaaagaggctcagattatatgcaagatgaccatggcttagatacaaggaagaa
#
# call  subset_dinuc_profile  to compute dinucleotide frequency for a subset of dinucleotides
# on  original forvard sequence and its complementary sequence
#
echo "Compute dinucleotide frequency profile on original forward sequence for all 16 dinucleotides"
echo "Warning: takes time"
echo  "CALL: sh ../helper/subset_dinuc_profile.sh ../data/seq25000.fasta \"AA AC AG AT CA CC CG CT GA GC GG GT TA TC TG TT\" ../data/seq25000.di.freq.profiles"
sh ../helper/subset_dinuc_profile.sh ../data/seq25000.fasta "AA AC AG AT CA CC CG CT GA GC GG GT TA TC TG TT" ../data/seq25000.di.freq.profiles
echo ""
echo "Check the result"
echo "CALL: head -n3 ../data/seq25000.di.freq.profiles "
head -n3 ../data/seq25000.di.freq.profiles 
echo ""
echo "DONE"
# expected output
#AA.f	AA.r	AC.f	AC.r	AG.f	AG.r	AT.f	AT.r	CA.f	CA.r	CC.f	CC.r	CG.f	CG.r	CT.f	CT.r	GA.f	GA.r	GC.f	GC.r	GG.f	GG.r	GT.f	GT.r	TA.f	TA.r	TC.f	TC.r	TG.f	TG.r	TT.f	TT.r
#0.076320	0.067920	0.057800	0.078120	0.081600	0.061960	0.055600	0.044080	0.081600	0.051760	0.067360	0.068960	0.010960	0.051040	0.078400	0.066520	0.066520	0.078400	0.051040	0.010960	0.068960	0.067360	0.051760	0.081600	0.044080	0.055600	0.061960	0.081600	0.078120	0.057800	0.067920	0.076320
#0.077160	0.073760	0.056000	0.072160	0.079400	0.060720	0.055960	0.047040	0.079840	0.053160	0.063280	0.067280	0.012360	0.051080	0.082680	0.068120	0.068120	0.082680	0.051080	0.012360	0.067280	0.063280	0.053160	0.079840	0.047040	0.055960	0.060720	0.079400	0.072160	0.056000	0.073760	0.077160
