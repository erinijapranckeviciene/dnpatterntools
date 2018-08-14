#!/bin/sh
# Shell wrapper of the call to Fourier Transform
# call : ./Fourier_Transform -f input -o output  -n {normalization 0|1|2}  -l length_of_smoothing_window -t {type_of_output 1|2|3}

# normalization
#    0 basis normalization
#    1 linear normalization
#    2 quadratic normalization
# type of output table
#    1 normalization
#    2 smoothing
#    3 Fourier transform

# Apply operation to the vector of data 
# Wrapper call : sh fourier_transform.sh input output normalization smoothingw outputtype  
# Fourier_Transform has to be applied on symmetrized, nonsmoothed data, since it performs smoothing internally.
# Dinucleotide frequency profiles usually have a quadratic gradient, 
# therefor e in Fourier_Transform the quadratic normalization is applied.
# Fourier transform is applied to every column in the table. Additional column x=period in bp is added to the result
##############################################################################################################################
# CALL:  sh fourier_transform.sh file.di.freq.selection.symmetrized.composites.profiles file.output normalization swindow trim
# INPUT: 
#       file.di.freq.selection.symmetrized.composites.profiles  -  fully prepared dinucleotide frequency profiles-patterns
#       normalization  - type of normalization, suggested is quadratic =2
#       swindow        - size of averaging window -suggested optimal value =3
#       trim           - number of position to remove from both ends  of the profile to reduce noise suggested =4
# OUTPUT:
#      file.output - file name to write the Fourier_Transform results
# 
###############################################################################################################################

if test "$#" -ne 5; then
    echo "Parameters missing in the CALL:  sh smooth.sh file.di.freq.selected.symmetrized.composites.profiles file.output normalization swindow trim" 
    exit 1
fi

# column comes with the header which we have to remove

input=$1
output=$2

#normalization=2
normalization=$3

#smoothingw=3
smoothingw=$4

#trim=2
trim=$5
trim1=$((trim+1))
outputtype=3

# uncomment for a galaxy tool
#dir=`pwd`/../../../../../tools/nuc_tools

# comment for a galaxy tool
dir=../core/extras
call=${dir}/Fourier_Transform

## here the data already has  positions
## get the nucleotides from the header
dinucleotides=`head -n1 ${input} | sed 's/pos//'`

for di in ${dinucleotides}
do
    # column number of dinucleotide
    i1=`awk -v name=$di '{ for (i=1; i<=NF; i++) if($i==name) print i; exit}' ${input}`
    awk -v k=${i1} '{print $k}' $input | grep -v ${di} | tail -n +${trim1} | head -n -${trim}| cat -n > temp.${di}

# Submit the call and parameters
${call} -f temp.${di} -o ft_output.${di} -n ${normalization} -l ${smoothingw} -t ${outputtype} 

echo "period" > period
awk '{print $1}' ft_output.${di} >> period

echo ${di} > ft.${di}
awk '{print $2}' ft_output.${di} >> ft.${di}

done
paste period ft.* > ${output}

rm temp.* ft.* period ft_output.*
