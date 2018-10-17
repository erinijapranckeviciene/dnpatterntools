#!/usr/bin/sh

# modify paths to point to the tools and test data 
# test script assume that  current directory is test
export CALLPATH=../bin
export DATAPATH=../tools/test-data

echo "TEST  dnp-binstrings"
echo "INPUT fasta : head -n4 $DATAPATH/seq4.fasta "
echo ""
head -n4 $DATAPATH/seq4.fasta 
echo ""
echo ""
echo  "CALL: $CALLPATH/dnp-binstrings $DATAPATH/seq4.fasta AA "
echo ""
$CALLPATH/dnp-binstrings $DATAPATH/seq4.fasta -di AA
echo ""
echo "DONE"
echo ""
echo "TEST  dnp-diprofile"
echo "INPUT fasta : head -n4 $DATAPATH/seq1000.fasta "
echo ""
head -n4 $DATAPATH/seq1000.fasta 
echo ""
#
# call  diprofile  to compute dinucleotide frequency 
# on  original forvard sequence and its complementary sequence
#
echo "Compute dinucleotide frequency profile on original forward sequence"
echo "CALL: $CALLPATH/dnp-diprofile -di TT -sl 219 $DATAPATH/seq1000.fasta > $DATAPATH/TT.f"
$CALLPATH/dnp-diprofile -di TT -sl 219 $DATAPATH/seq1000.fasta > $DATAPATH/TT.f
echo ""
echo "Compute dinucleotide frequency profile on complementary to original sequence"
echo "CALL: $CALLPATH/dnp-diprofile -di TT -sl 219 -c $DATAPATH/seq1000.fasta > $DATAPATH/TT.c"
$CALLPATH/dnp-diprofile -di TT -sl 219 -c $DATAPATH/seq1000.fasta > $DATAPATH/TT.c
echo ""
echo "Save forward and complementary profiles and display a tibble"
echo "CALL: paste $DATAPATH/TT.f $DATAPATH/TT.c > $DATAPATH/TT.fc"
echo "CALL: head -n4 $DATAPATH/data/TT.fc"
echo ""
paste $DATAPATH/TT.f $DATAPATH/TT.c > $DATAPATH/TT.fc
head -n4 $DATAPATH/TT.fc
echo ""
echo "DONE"
echo ""
echo "TEST  dnp-corrprofile"
echo "INPUT dinucleotide frequency profiles on forward (1st col) and its complent (2nd col) sequences : head -n4 $DATAPATH/TT.fc"
echo ""
head -n4 $DATAPATH/TT.fc
echo ""
echo "Compute Pearson correlation coefficient across a dinucleotide frequency profile within 146bp sliding window"
echo  "CALL: $CALLPATH/dnp-corrprofile -w 146 -n 219 $DATAPATH/TT.fc | head "
echo ""
$CALLPATH/dnp-corrprofile -w 146 -n 219 $DATAPATH/TT.fc | head
echo ""
echo "DONE"
echo ""
############################################################### Next
echo "TEST  dnp-fourier smoothing"
echo "INPUT dinucleotide frequency profile column with position information: head -n4 $DATAPATH/TT.fp"
cat -n $DATAPATH/TT.f > $DATAPATH/TT.fp 
head -n4 $DATAPATH/TT.fp
echo ""
echo "CALL: $CALLPATH/dnp-fourier -f $DATAPATH/TT.fp -t 2 -l 3 -o $DATAPATH/TT.fps"
$CALLPATH/dnp-fourier -f $DATAPATH/TT.fp -t 2 -l 3 -o $DATAPATH/TT.fps
head -n4 $DATAPATH/TT.fp
echo ""
echo "DONE"
echo ""
echo "TEST  dnp-fourier periodogram"
echo "INPUT dinucleotide frequency profile column with position information: head -n4 $DATAPATH/TT.fp"
echo ""
head -n4 $DATAPATH/TT.fp
echo ""
echo "CALL: $CALLPATH/dnp-fourier -f $DATAPATH/TT.fp -t 3 -l 3 -n 3 -o $DATAPATH/TT.fperiodogram"
$CALLPATH/dnp-fourier -f $DATAPATH/TT.fp -t 3 -n 2 -l 3 -o $DATAPATH/TT.fperiodogram
echo ""
head -n4 $DATAPATH/TT.fperiodogram
echo ""
echo "DONE"
