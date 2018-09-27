#!/usr/bin/sh
echo ""
echo "INPUT fasta : head -n4 ../data/toymousenucseq.fasta "
echo ""
head -n4 ../data/toymousenucseq.fasta 
echo ""
#
# expected output:
#
#>chr9:42475963-42476182
#CCAGGCAGACCCCATATTCAAGCTGCTGCCCCAGGGTGGTGTACAGATCTGGGGAGAAGAAGGATGAGACACTGAGCAGTAAGCCCCAGACTGAGCTAGGAGGACCCGAAGAAGAGTCCTGGCTTTGCCATGATAAGTACTTTATGTCCCTTaaaacaaaacaaaacaaacaaaacaaaacacatcaaaacaaaacaTACCCAATGCTGTTTTCTGCAC
#>chr9:42476175-42476394
#TCTGCACTCCAGCATGCCTGAGGAGAGGAGGGAATGCAGGATCCTAGTGGAAAGAGTACCAAGCTGGGAGGCTGCAGTACCCATCAAAGTACTGAGTGTAGAGACTCGATGTTTCACATACACCCAAGCCACAGACCTCCCCAAGccccataagagctaaaggagagaaagaggctcagattatatgcaagatgaccatggcttagatacaaggaagaa
#
# call  diprofile  to compute dinucleotide frequency 
# on  original forvard sequence and its complementary sequence
#
echo "Compute dinucleotide frequency profile on original forward sequence"
echo  "CALL: ../programs/bin/diprofile -di TT -sl 219 ../data/toymousenucseq.fasta > ../data/TT.f"
../programs/bin/diprofile -di TT -sl 219 ../data/toymousenucseq.fasta > ../data/TT.f
echo ""
echo "Compute dinucleotide frequency profile on complementary to original sequence"
echo  "CALL: ../programs/bin/diprofile -di TT -sl 219 -c ../data/toymousenucseq.fasta > ../data/TT.c"
../programs/bin/diprofile -di TT -sl 219 ../data/toymousenucseq.fasta > ../data/TT.f
echo ""
echo "Save forward and complementary profiles and display a tibble"
echo "CALL: paste ../data/TT.f ../data/TT.c > ../data/TT.fc"
echo "CALL: head -n4 ../data/TT.fc"
echo ""
paste ../data/TT.f ../data/TT.c > ../data/TT.fc
head -n4 ../data/TT.fc
echo ""
echo "DONE"
#
# expected output
#
# 0.084453	0.085520
# 0.084381	0.085891
# 0.084032	0.086133
# 0.082731	0.087037
