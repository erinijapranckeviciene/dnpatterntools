#!/bin/sh

if test "$#" -ne 5; then
echo ""
echo " CALL "  
echo "   sh dnp-select-range.sh select-range-input.tabular start length  dinucleotides select-range-output.tabular"
echo ""
echo " INPUT "
echo "   select-range-input.tabular  - full length dinucleotide frequency profiles"
echo "   start                       - start position of selection - identified start position of nucleosome's sequence"
echo "   length                      - length of selection; default =146 nucleosome's length in base pairs"
echo "   dinucleotides               - any subset of dinucleotides enclosed by quotes 'AA AC AG AT CA CC ...'"
echo ""
echo " OUTPUT "
echo "   select-range-output.tabular - rows of input file selected at a given position spanning a length"
echo ""
echo " DESCRIPTION"
echo "   Selects rows from input table within a given range and adds a column with positional information"
echo ""
echo "   Example of an input table"
echo "   AA.f	        AA.r	        AC.f	        AC.r	        AG.f	        AG.r	        AT.f	        AT.r       ..."
echo "   0.0763         0.067920	0.057800	0.078120	0.081600	0.061960	0.055600	0.044080"
echo "   0.077160	0.073760	0.056000	0.072160	0.079400	0.060720	0.055960	0.047040"
echo "   0.083320	0.071200	0.053840	0.080760	0.084560	0.064880	0.050440	0.048720"
echo "   0.077960	0.068200	0.056040	0.075520	0.080120	0.061680	0.053160	0.047400"
echo "   0.078200	0.069120	0.056880	0.074000	0.084360	0.060840	0.053520	0.046280"
echo "   ... "
echo ""
echo "   Example of an output table where start=20"
echo "   pos	AA.f	        AC.f	        AG.f	        AT.f	        CA.f	        CC.f	        CG.f	        CT.f     ..."
echo "   20	0.100200	0.084720	0.077200	0.072480	0.066160	0.044160	0.004560	0.060720"
echo "   21	0.172440	0.024800	0.002080	0.101240	0.131840	0.007200	0.000320	0.095920"
echo "   22	0.077160	0.096240	0.314320	0.047360	0.012040	0.028560	0.011840	0.013680"
echo "   ..."

    exit 1
fi


# input file name
name=$1

# start position
startpos=$2

# length of selection (146bp)
length=$3

# list of dinucleotides
dinucleotides=$4

# output file
out=$5

# compute length of the file
len=`wc ${name} |awk '{print $1}'` 
#echo $len

len=$((len-1))

# endpos 
endpos=$((startpos+length))

cnum=1
# TO DO:should scheck if endpos is within the range
for di in ${dinucleotides}
do
    # column number for forward and complementary profile
    i1=`awk -v name=$di'.f' '{ for (i=1; i<=NF; i++) if($i==name) print i; exit}' ${name}`
    i2=`awk -v name=$di'.r' '{ for (i=1; i<=NF; i++) if($i==name) print i; exit}' ${name}`

    echo "$di.f" > forward.${di}
    awk -v k=${i1} '{print $k}' $name | sed -n "${startpos},${endpos}p" >> forward.${di}
    echo "$di.r"> complement.${di}
    awk -v k=${i2} '{print $k}' $name | sed -n "${startpos},${endpos}p" >> complement.${di}
cnum=$((cnum+1))
done

# sequence positions within range
echo "pos" > seq.pos
seq ${startpos} 1 ${endpos} >> seq.pos

# paste forward
paste seq.pos forward.* > forward
paste complement.* > complement

# create output
paste forward complement > ${out}
rm seq.pos forward* complement*
