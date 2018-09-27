#!/bin/sh
#
# Smoothing of symmetrized profiles. may contain composites or may not.
# This operation is to enhance representation of the profiles by reducing noise in signal.
# Smoothing is performed by moving average with chosen window size. It was observed that
# for dinucleotide frequency profiles the optinmal window size is 3.  Sometimes the profile ends 
# contain noisy signals, therefore it is a posibility to trim the profile from both ends.
# We observed that trimming by 4 points from both ends usually improve representation. 
#
#############################################################################################################
# CALL:  sh smooth.sh file.di.freq.selection.symmetrized.composites.profiles window trim file.output
# INPUT: 
#       file.di.freq.selection.symmetrized.composites.profiles  -  fully prepared dinucleotide frequency profiles-patterns
#       window  - size of averaging window - 3 is suggested optimal value
#       trim    - number of position to remove from both ends of the nucleosome dinucleotide frequency profile to improve visualization
# OUTPUT:
#      file.output - file name to write the  smoothed patterns 
# 
#############################################################################################################

if test "$#" -ne 4; then
    echo "Parameters missing in the CALL:  sh smooth.sh file.di.freq.selected.symmetrized.composites.profiles window trim file.output"
    exit 1
fi

# input file name
name=$1
#echo ${name}
#
# smoothing window
swindow=$2
#
# trim xrange in plotting
trim=$3
#
# output file
out=$4
#echo ${out}

dir=../programs/bin

call=${dir}/fourier
#echo ${call}

# compute centerd sequence position

## here the data already has  positions
## get the nucleotides from the header
dinucleotides=`head -n1 ${name} | sed 's/pos//'`


## save the position information
posi=`awk '{ for (i=1; i<=NF; i++) if($i=="pos") print i; exit}' ${name}`
awk -v k=${posi} '{print $k}' $name  | grep -v pos > posfile


for di in ${dinucleotides}
do
    # column number of dinucleotide
    i1=`awk -v name=$di '{ for (i=1; i<=NF; i++) if($i==name) print i; exit}' ${name}`
    awk -v k=${i1} '{print $k}' $name | grep -v ${di} > temp.${di}

   # add centered sequence position 
   paste posfile temp.${di} | tr "\t" " " > smoothprep

   # perform smoothing
   ${call} -f smoothprep -t 2 -l ${swindow} -o cps.${di}


#   echo ${di} > cp.${di}
   cat cps.${di} | tail -n +$(($trim+1)) | head -n -$(($trim+1)) > temp.${di} 

   echo "pos" > positions
   cat temp.${di} | awk '{print $1}' >> positions 
   echo ${di} > cp.${di}
   cat temp.${di} | awk '{print $2}' >> cp.${di}
   
done

#echo  "pos" ${dinucleotides} | tr " " "\t" > ${out}
paste positions cp.* > ${out}

rm temp.* cp.* cps.* posfile smoothprep positions
