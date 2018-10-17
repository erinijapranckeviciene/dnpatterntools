#!/usr/bin/sh
export CALLPATH=../tools
export DATAPATH=../tools/test-data

echo ""
echo ""
echo "################################"
echo ""
echo "call dnp-binary-strings.sh"
echo ""
echo "INPUT"
echo ""
head -n2 $DATAPATH/seq4.fasta
echo ""
#
sh $CALLPATH/dnp-binary-strings.sh $DATAPATH/seq4.fasta "AA AC" $DATAPATH/tmp
echo "OUTPUT"
echo ""
head -n2 $DATAPATH/tmp
echo ""
echo "EXPECTED OUTPUT"
echo ""
head -n2 $DATAPATH/seq4.tabular
echo ""
echo "DONE"
echo ""
echo "################################"
echo ""
echo "call dnp-subset-dinuc-profile.sh"
echo ""
echo "INPUT"
echo ""
head -n2 $DATAPATH/diprofile-input.fasta
echo ""
echo "sh $CALLPATH/dnp-subset-dinuc-profile.sh $DATAPATH/diprofile-input.fasta 'AA AC AG AT CA CC CG CT GA GC GG GT TA TC TG TT' $DATAPATH/tmp"
sh $CALLPATH/dnp-subset-dinuc-profile.sh $DATAPATH/diprofile-input.fasta "AA AC AG AT CA CC CG CT GA GC GG GT TA TC TG TT" $DATAPATH/tmp
echo "OUTPUT"
echo ""
head -n3 $DATAPATH/tmp
echo ""
echo "EXPECTED OUTPUT"
echo ""
head -n3 $DATAPATH/diprofile-output.tabular
echo ""
echo "DONE"
echo ""
echo "################################"
echo ""
echo "call dnp-correlation-between-profiles.sh"
echo ""
echo "INPUT"
echo ""
head -n3 $DATAPATH/seq25000.di.freq.profiles
echo ""
#dnp-correlation-between-profiles.sh "$input1" "$input2" "$input3" "$output1"
echo "COMMAND"
echo "sh $CALLPATH/dnp-correlation-between-profiles.sh $DATAPATH/seq25000.di.freq.profiles 146 'AA AC AG AT CA CC CG CT GA GC GG GT TA TC TG TT' $DATAPATH/tmp"
echo ""
sh $CALLPATH/dnp-correlation-between-profiles.sh $DATAPATH/seq25000.di.freq.profiles 146 "AA AC AG AT CA CC CG CT GA GC GG GT TA TC TG TT" $DATAPATH/tmp
echo ""
echo ""
echo "OUTPUT"
echo ""
head -n3 $DATAPATH/tmp
echo ""
echo "EXPECTED OUTPUT"
echo ""
head -n3 $DATAPATH/seq25000.di.corr.profiles
echo ""
echo "DONE"
echo ""
echo "################################"
echo ""
echo "call dnp-select-range.sh"
echo ""
echo "INPUT"
echo ""
head -n3 $DATAPATH/select-range-input.tabular
echo ""
#dnp-select-range.sh "$input1" "$input2" "$input3" "$input4" "$output1"
echo "COMMAND"
echo "sh $CALLPATH/dnp-select-range.sh $DATAPATH/select-range-input.tabular 20 146 'AA AC AG AT CA CC CG CT GA GC GG GT TA TC TG TT' $DATAPATH/tmp"
echo ""
sh $CALLPATH/dnp-select-range.sh $DATAPATH/select-range-input.tabular 20 146 "AA AC AG AT CA CC CG CT GA GC GG GT TA TC TG TT" $DATAPATH/tmp
echo ""
echo ""
echo "OUTPUT"
echo ""
head -n3 $DATAPATH/tmp
echo ""
echo "EXPECTED OUTPUT"
echo ""
head -n3 $DATAPATH/select-range-output.tabular
echo ""
echo "DONE"
echo ""
echo "################################"
echo ""
echo "call dnp-symmetrize.sh"
echo ""
echo "INPUT"
echo ""
head -n3 $DATAPATH/symmetrize-input.tabular
echo ""
#dnp-symmetrize.sh "$input1" "$output1"
echo "COMMAND"
echo "sh $CALLPATH/dnp-symmetrize.sh $DATAPATH/symmetrize-input.tabular $DATAPATH/tmp"
echo ""
sh $CALLPATH/dnp-symmetrize.sh $DATAPATH/symmetrize-input.tabular $DATAPATH/tmp
echo ""
echo ""
echo "OUTPUT"
echo ""
head -n3 $DATAPATH/tmp
echo ""
echo "EXPECTED OUTPUT"
echo ""
head -n3 $DATAPATH/symmetrize-output.tabular
echo ""
echo "DONE"
echo ""
echo "################################"
echo ""
echo "call dnp-compute-composite.sh"
echo ""
echo "INPUT"
echo ""
head -n3 $DATAPATH/compute-composite-input.tabular
echo ""
echo "COMMAND"
echo "sh $CALLPATH/dnp-compute-composite.sh $DATAPATH/compute-composite-input.tabular $DATAPATH/tmp"
echo ""
sh $CALLPATH/dnp-compute-composite.sh $DATAPATH/compute-composite-input.tabular $DATAPATH/tmp
echo ""
echo ""
echo "OUTPUT"
echo ""
head -n3 $DATAPATH/tmp
echo ""
echo "EXPECTED OUTPUT"
echo ""
head -n3 $DATAPATH/compute-composite-output.tabular
echo ""
echo "DONE"
echo ""
echo "################################"
echo ""
echo "call dnp-smooth.sh"
echo ""
echo "INPUT"
echo ""
head -n8 $DATAPATH/smoothing-input.tabular
echo ""
echo "COMMAND"
echo "sh $CALLPATH/dnp-smooth.sh $DATAPATH/smoothing-input.tabular 3 4  $DATAPATH/tmp"
echo ""
sh $CALLPATH/dnp-smooth.sh $DATAPATH/smoothing-input.tabular 3 4  $DATAPATH/tmp
echo ""
echo ""
echo "OUTPUT"
echo ""
head -n3 $DATAPATH/tmp
echo ""
echo "EXPECTED OUTPUT"
echo ""
head -n3 $DATAPATH/smoothed-output.tabular
echo ""
echo "DONE"
echo ""
echo "################################"
echo ""
echo "call dnp-fourier-transform.sh"
echo ""
echo "INPUT"
echo ""
head -n8 $DATAPATH/fourier-input.tabular
echo ""
echo "COMMAND"
echo "sh $CALLPATH/dnp-fourier-transform.sh $DATAPATH/fourier-input.tabular $DATAPATH/tmp 2 3 4"
echo ""
sh $CALLPATH/dnp-fourier-transform.sh $DATAPATH/fourier-input.tabular $DATAPATH/tmp 2 3 4
echo ""
echo ""
echo "OUTPUT"
echo ""
head -n4 $DATAPATH/tmp
echo ""
echo "EXPECTED OUTPUT"
echo ""
head -n4 $DATAPATH/fourier-output.tabular
echo ""
echo "DONE"
echo ""
#
# call shuffle_sequences.sh
