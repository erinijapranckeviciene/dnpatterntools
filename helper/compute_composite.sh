#!/bin/sh
# compute composite dinucleotides WW, SS, RR, YY. Add their columns to the original table
#############################################################################################################
# CALL:  sh compute_composites.sh file.di.freq.selection.symmetrized.profiles file.output
# INPUT: 
#       file.di.freq.selection.symmetrized.profiles  - symmetrized dinucleotide frequency profiles
# OUTPUT:
#      file.output - file name to write the output  in tabular format, columns have names as AA AC AT ... WW SS RR YY
# 
#############################################################################################################

if test "$#" -ne 2; then
    echo "Parameters missing in the CALL:  sh symmetrize.sh file.di.freq.selection.profiles file.output"
    exit 1
fi

name=$1
out=$2

## Here we should implement test that all required nucleotide columns are in file
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
