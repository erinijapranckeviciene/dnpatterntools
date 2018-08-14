#!/bin/sh
#
# On selected dinucleotide frequency profiles apply symmetrization 
#############################################################################################################
# CALL:  sh symmetrize.sh file.di.freq.selection.profiles file.output
# INPUT: 
#       file.di.freq.selection.profiles  - selected dinucleotide frequency profiles with forward and complement columns
# OUTPUT:
#      file.output - file name to write the output  in tabular format, columns have names as AA AC AT ...
# 
#############################################################################################################

if test "$#" -ne 2; then
    echo "Parameters missing in the CALL:  sh symmetrize.sh file.di.freq.selection.profiles file.output"
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
