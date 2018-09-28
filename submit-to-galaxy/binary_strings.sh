#!/bin/sh
if test "$#" -ne 3; then
    echo "Parameters missing in the CALL:  sh binary_strings.sh file.input.fasta 'AA CC GG' file.output.fasta.tabular"
    echo "Usage:"
echo "Fasta sequences are converted into 01 representation of odccurences of  given dinucleotides the profiles are outputs as columns of a table "
echo "CALL:  sh binary_strings.sh file.input.fasta dinucleotides file.output.tabular"
echo "INPUT:" 
echo "       file.input.fasta   - input fasta file to shuffle dinucleotides "
echo "       dinucleotides      - 'AA AC AG AT ...'"
echo "OUTPUT:"
echo "       file.output.tabular    - file name to write the shuffled sequences"

    exit 1
fi

name=$1
diset=$2
out=$3
call=./binstrings

## the dinucleotide profiles are computed for the subset of dinucleotides listed in $diset
## the profiles are outputs as columns of a table 

# prepare fasta, we copy here because
# in galaxy we don't have fa ending which is required by the dinuc
cp ${name} ${name}.fa

for di in ${diset}
do
    ${call} ${name}.fa ${di} >> ${out}

done;
rm ${name}.fa
