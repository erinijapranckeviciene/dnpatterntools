#!/usr/bin/sh
echo ""
echo "INPUT dinucleotide frequency profiles on forward (1st col) and its complent (2nd col) sequences : head -n4 ../data/TT.fc"
echo ""
head -n4 ../data/TT.fc
echo ""
#
# expected output
#
# 0.084453	0.085520
# 0.084381	0.085891
# 0.084032	0.086133
# 0.082731	0.087037
#
# call corrprofile
#
echo "Compute Pearson correlation coefficient across a dinucleotide frequency profile within 146bp sliding window"
echo  "CALL: ../programs/bin/corrprofile --w 146 -n 219  ../data/TT.fc | head "
echo ""
../programs/bin/corrprofile --w 146 -n 219  ../data/TT.fc | head 
echo ""
echo "DONE"
#
# expected output
#
#0.0851549
#0.0877861
#0.0895787
#0.124168
#0.145482
#0.147387
#0.152661
#0.149426
#0.144475
#0.158685
