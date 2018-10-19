#!/bin/sh

if test "$#" -ne 2; then
echo ""
echo " CALL "
echo "   sh dnp-compute-composite.sh compute-composite-input.tabular compute-composite-output.tabular"
echo ""
echo " INPUT "
echo "   compute-composite-input.tabular  - dinucleotide frequency profiles containing all 16 dinucleotides"
echo ""
echo " OUTPUT "
echo "   compute-composite-output.tabular - original input with WW SS RR YY columns added to the output"
echo ""
echo " DESCRIPTION"
echo "   Composite dinucleotides weak/weak WW (A or T) , strong/strong SS (G or C), purine/purine RR (A or G), "
echo "   and pyrimidine/pyrimidine YY (C or T) are generalized dinucleotide frequency patterns in nucleosome sequences."
echo "   Given a tabular innput file with all 16 dinucleotides the composite patterns are computed as follows"
echo "   WW=AA+AT+TA+TT, SS=CC+CG+GC+GG, RR=AG+GA+AA+GG, YY=CC+TT+CT+TC and their columns added to the original table."
echo ""
echo "   Example columns of an input table"
echo "   pos    AA      AC      AG      AT      ..."
echo "   -73    0.08616 0.08034 0.07146 0.05934 ..."
echo "   -72    0.11976 0.04966 0.03412 0.07274 ..."
echo "   -71    0.07202 0.08882 0.18912 0.0462  ..."
echo "   ... "
echo "   Example columns of computed composites "
echo "   ...   WW      SS      RR"
echo "   ...   0.27644 0.1614  0.29494"
echo "   ...   0.36788 0.1091  0.29428"
echo "   ...   0.21406 0.12566 0.34432"
echo "   ..."

    exit 1
fi

name=$1
out=$2

## TO DO test that all required nucleotide columns are in file
## if not, stop the execution

# add the column of composite profile at the end
## WW = AA+TT+AT+TA
    i1=`awk '{ for (i=1; i<=NF; i++) if($i=="AA") print i; exit}' ${name}`
    i2=`awk '{ for (i=1; i<=NF; i++) if($i=="AT") print i; exit}' ${name}`
    i3=`awk '{ for (i=1; i<=NF; i++) if($i=="TA") print i; exit}' ${name}`
    i4=`awk '{ for (i=1; i<=NF; i++) if($i=="TT") print i; exit}' ${name}`
echo WW > ww
cut -f${i1},${i2},${i3},${i4} ${name}| tail -n +2 | awk '{print $1+$2+$3+$4}' >> ww

## SS = CC+CG+GC+GG
    i1=`awk '{ for (i=1; i<=NF; i++) if($i=="CC") print i; exit}' ${name}`
    i2=`awk '{ for (i=1; i<=NF; i++) if($i=="CG") print i; exit}' ${name}`
    i3=`awk '{ for (i=1; i<=NF; i++) if($i=="GC") print i; exit}' ${name}`
    i4=`awk '{ for (i=1; i<=NF; i++) if($i=="GG") print i; exit}' ${name}`
echo SS > ss
cut -f${i1},${i2},${i3},${i4} ${name}| tail -n +2 | awk '{print $1+$2+$3+$4}' >> ss
 
## RR = AA+AG+GA+GG
    i1=`awk '{ for (i=1; i<=NF; i++) if($i=="AA") print i; exit}' ${name}`
    i2=`awk '{ for (i=1; i<=NF; i++) if($i=="AG") print i; exit}' ${name}`
    i3=`awk '{ for (i=1; i<=NF; i++) if($i=="GA") print i; exit}' ${name}`
    i4=`awk '{ for (i=1; i<=NF; i++) if($i=="GG") print i; exit}' ${name}`
echo RR > rr
cut -f${i1},${i2},${i3},${i4} ${name}| tail -n +2 | awk '{print $1+$2+$3+$4}' >> rr

## YY = CC+CT+TC+TT
    i1=`awk '{ for (i=1; i<=NF; i++) if($i=="CC") print i; exit}' ${name}`
    i2=`awk '{ for (i=1; i<=NF; i++) if($i=="CT") print i; exit}' ${name}`
    i3=`awk '{ for (i=1; i<=NF; i++) if($i=="TC") print i; exit}' ${name}`
    i4=`awk '{ for (i=1; i<=NF; i++) if($i=="TT") print i; exit}' ${name}`
echo YY > yy
cut -f${i1},${i2},${i3},${i4} ${name}| tail -n +2 |awk '{print $1+$2+$3+$4}' >> yy

paste ${name} ww ss rr yy > ${out}

rm ww ss rr yy
