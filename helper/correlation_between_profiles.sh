#!/bin/sh
# Wrapper to call corrprofile:
#  ./corrprofile aa -n 219 -w 146
#
# Wrapper call : sh correlation.sh infilename  window outfilename
#                sh correlation.sh aa  146 out2
#
# compute correlation between
# forward and complementary dinucleotide profiles
# in order to find the position of higest symmetry
# input file columns: first is a forward profile,
# the second is a profile of the dinucleotide on complementary sequence. 
# Correlation is computed between forward and
# complementary reversed profiles within a sliding window
# across each position of the frequency profiles.
#
# Input file contains two consecutive columns for
# given dinucleotides with headers.
# From headers we retrieve dinucleotide names of the profiles
#############################################################################################################
# CALL:  sh correlation_between_profiles.sh file.di.freq.profiles window  dinucleotides file.output
# INPUT: 
#       file.di.freq.profiles  - a batch of nucleosome(or could be any DNA) DNA sequences 
#       window                 - sliding window size - nucleosome's DNA size 146bp
#       dinucleotides - any subset of dinucleotides enclosed by quotes as "AA AC AG AT CA CC"
# OUTPUT:
#      file.output - file name to write the output  in tabular format, columns have names as AA AC AT ...
# 
# optional output: maximum correlations and their positions are printed for each dunucleotide
#############################################################################################################

if test "$#" -ne 4; then
    echo "Parameters missing in the CALL:  sh correlation_between_profiles.sh file.di.freq.profiles window dinucleotides file.output"
    exit 1
fi


name=$1
#echo ${name}
window=$2
dinucleotides=$3
out=$4
#echo ${out}

# uncomment for a galaxy tool
#dir=`pwd`/../../../../../tools/nuc_tools

# comment for a galaxy tool
dir=../core/bin/
call=${dir}/corrprofile
#echo ${call}

# compute length of the file
len=`wc ${name} |awk '{print $1}'` 
#echo $len
len=$((len-1))
#echo $len

for di in ${dinucleotides}
do
    #extract column numbers of required dinucleotide
    i=`awk -v name=$di'.f' '{ for (i=1; i<=NF; i++) if($i==name) print i; exit}' $name`

    # create a file of two columns in temp
    awk -v k1=${i} -v k2=$((i+1)) '{print $k1 "\t" $k2}' $name | sed -n "2,${len}p" > temp.${di} 

    # put the header of the column
    echo ${di} > cp${i}
    
    # correlation dinucleotide profile along the sequence
    # ./corrprofile aa -n 219 -w 146
    # output in the temp column
    ${call} temp.${di} -n $((len-1)) -w ${window} >> cp${i}
    # print the maximum    
    posval=`cat cp${i} | grep -v ${di} | cat -n | sort -k2,2n | tail -n1`
    echo ${di} ${posval} >> maxpos
    
done

paste cp[1-9]* > temp

# compute average correlation profile
awk 'NR==2{next} 
       {T=0;
         for(N=1; N<=NF; N++) T+=$N;
         T/=NF
         print T "\t" $0}' temp > ${out}

# find a position of the maximum and output it
posval=`cat ${out}| awk '{print $1} ' | cat -n | sort -k2,2n | tail -n1` 
echo "avg " ${posval} >> maxpos
cat maxpos | tr "\n" , 

rm temp*  cp[1-9]* maxpos
