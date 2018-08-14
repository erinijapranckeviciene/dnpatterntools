#!/bin/sh
#
# Select rows within the given range
#############################################################################################################
# CALL:  sh select_range.sh file.di.freq.profiles start length  dinucleotides file.output
# INPUT: 
#       file.di.freq.profiles  - a batch of nucleosome(or could be any DNA) DNA sequences 
#       start                  - start position
#       length                 - length of selection nucleosome's DNA size 146bp
#       dinucleotides - any subset of dinucleotides enclosed by quotes as "AA AC AG AT CA CC"
# OUTPUT:
#      file.output - file name to write the output  in tabular format, columns have names as AA AC AT ...
# 
#############################################################################################################

if test "$#" -ne 5; then
    echo "Parameters missing in the CALL:  sh select_range.sh file.di.freq.profiles start length dinucleotides file.output"
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
