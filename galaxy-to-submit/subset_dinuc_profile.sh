#!/bin/sh
#  compute dinucleotide frequency profiles on forward and its complementary sequences in batch
############################################################################################################
# CALL:  sh subset_dinuc_profile.sh file.fasta  dinucleotides file.output
# INPUT: 
#       file.fasta - a batch of nucleosome(or could be any DNA) DNA sequences 
#       dinucleotides - any subset of dinucleotides enclosed by quotes as "AA AC AG AT CA CC"
# OUTPUT:
#      file.output - file name to write the output  in tabular format, columns have names as AA.f AA.r ...
# 
############################################################################################################

if test "$#" -ne 3; then
    echo "Parameters missing in the CALL:  sh subset_dinuc_profile.sh file.fasta  dinucleotides file.output"
    exit 1
fi

name=$1
diset=$2
out=$3


# uncomment for a galaxy tool
dir=`pwd`/../../../../../tools/nuc_tools

# directory of core tools comment for a galaxy tool
#dir=../core/bin/
call=${dir}/diprofile

## the dinucleotide profiles are computed for the subset of dinucleotides listed in $diset
## the profiles are outputs as columns of a table 

#echo ${call}
#echo ${faname}
#echo ${seq}
#echo ${len} 

# prepare fasta, we copy here because
# in galaxy we don't have fa ending which is required by the dinuc
cp ${name} ${name}.fa

# compute length of the fasta sequence
seq=`head -n2 $name | tail -n1`
len=${#seq}
echo "Sequence length = " $len


# for each dinucleotide compute the forward
# and complementary profile and save
# in separate columns that will be merged in the end
for di in ${diset}
do
    #echo ${di}
    echo ${di}.f > ${di}.f
    ${call} ${name}.fa -di ${di} -sl ${len} >> ${di}.f
    echo ${di}.r > ${di}.r
    ${call} ${name}.fa -di ${di} -sl ${len} -c >> ${di}.r
    echo ${di}.f >> names
    echo ${di}.r >> names
done;
paste `cat names` > ${out}
rm names
rm ${name}.fa
rm *.f *.r
