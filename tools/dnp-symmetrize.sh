#!/bin/sh

if test "$#" -ne 2; then

echo ""
echo " CALL "  
echo "   sh dnp-symmetrize.sh symmetrize-input.tabular symmetrize-output.tabular"
echo ""
echo " INPUT "
echo "   symmetrize-input.tabular  - selected length dinucleotide frequency profiles from forward and complementary sequences"
echo ""
echo " OUTPUT "
echo "   symmetrize-output.tabular - symmetrized output"
echo ""
echo " DESCRIPTION"
echo "   Symmetrization of the dinucleotide profiles enhances the patterns with respect to the nucleosome's dyad position."
echo "   For each dinucleotide its frequency profiles derived from forward and complementary sequences are superimposed "
echo "   with respect to the dyad center. This entails averaging forward and reversed complement profiles "
echo "   of the identified nucleosome position ( selected by dnp-select-range tool) . A column with the position relative to "
echo "   the dyad center is added as a first column."
echo ""
echo "   Example of an input table"
echo "   pos    AA.f            AC.f            AG.f            AT.f            CA.f            CC.f            CG.f            CT.f     ..."
echo "   20     0.100200        0.084720        0.077200        0.072480        0.066160        0.044160        0.004560        0.060720"
echo "   21     0.172440        0.024800        0.002080        0.101240        0.131840        0.007200        0.000320        0.095920"
echo "   22     0.077160        0.096240        0.314320        0.047360        0.012040        0.028560        0.011840        0.013680"
echo "   ..."
echo ""
echo "   Example of a few columns of an output table"
echo "   pos	AA	AC	AG	AT      ..."
echo "   -73	0.08616	0.08034	0.07146	0.05934 ..."
echo "   -72	0.11976	0.04966	0.03412	0.07274 ..."
echo "   -71	0.07202	0.08882	0.18912	0.0462  ..."
echo "   ... "

    exit 1
fi

#
# input file name
name=$1
# symmetrize all dinucleotides that are in the table

# output file
out=$2

# compute centerd sequence position
posi=`awk -v name=pos '{ for (i=1; i<=NF; i++) if($i==name) print i; exit}' ${name}`
posnum=`awk -v k=${posi} '{print $k}' $name |head -n2| tail -n1`

echo "pos" > positions
awk -v k=${posi} '{print $k}' $name | tail -n +2 | awk -v offset=$((posnum-1)) '{print $1-offset-74}'>> positions


# get the dinucleotides from the first line 
dinucleotides=`head -n1 ${name} | sed 's/pos//' | sed 's/.f//g' | sed 's/.r//g'`  

#cnum=1
for di in ${dinucleotides}
do
    # column number for forward and complementary profile
    i1=`awk -v name=$di'.f' '{ for (i=1; i<=NF; i++) if($i==name) print i; exit}' ${name}`
    i2=`awk -v name=$di'.r' '{ for (i=1; i<=NF; i++) if($i==name) print i; exit}' ${name}`
    awk -v k=${i1} '{print $k}' $name | grep -v ".f" > temp.${i1}
    awk -v k=${i2} '{print $k}' $name | grep -v ".r" | tac > temp.${i2}
    echo ${di} > cp.${di}
   paste temp.${i1} temp.${i2} | awk '{print ($1+$2)/2 }' >> cp.${di}

   #cnum=$((cnum+1))
   
done

paste positions cp.* > ${out}
rm temp* cp*  positions
