#!/bin/sh
if test "$#" -ne 3; then

echo  " CALL "
echo  "   sh subset_dinuc_profile.sh input.fasta  dinucleotides output"
echo  ""
echo  " INPUT"
echo  "   input.fasta - a batch of nucleosome (or any DNA) DNA sequences "
echo  "   dinucleotides - any subset of dinucleotides enclosed by quotes as 'AA AC AG AT CA CC' "
echo  ""
echo  " OUTPUT"
echo  "   output - file name to write the output  in tabular format, columns have names as AA.f AA.r ..."
echo  ""
echo  " DESCRIPTION"
echo  "   Compute dinucleotide frequency profiles on forward and its complementary "
echo  "   sequences from a batch of fasta sequences. Output columns are labelled by AA.f, AA.r ... "
echo  ""
echo  " Example of input fasta lines"
echo  "  >chr9:42475963-42476182"
echo  "  CCAGGCAGACCCCATATTCAAGCTGCTGCCCCAGGGTGGTGTACAGATCTGGGGAGAAGAAGGATGA"
echo  "  >chr9:42476175-42476394"
echo  "  TCTGCACTCCAGCATGCCTGAGGAGAGGAGGGAATGCAGGATCCTAGTGGAAAGAGTACCAAGCTGG"
echo ""
echo  " Example of output  table"
echo  "  AA.f            AA.r            AC.f            AC.r   ..."
echo  "  0.076000        0.059000        0.065000        0.078000 ..."
echo  "  0.082000        0.060000        0.057000        0.076000 ..."
echo  "  0.067000        0.075000        0.049000        0.071000 ..."
echo  ""
echo ""
echo " REQUIREMENT"
echo "   dnp-diprofile installed"
echo "   conda install -c bioconda dnp-diprofile"

    exit 0
fi

name=$1
diset=$2
out=$3

call=dnp-diprofile

## the dinucleotide profiles are computed for the subset of dinucleotides listed in $diset
## the profiles are outputs as columns of a table 

# prepare fasta, we copy here because
# in galaxy we don't have fa ending which is required by the dinuc
cp ${name} ${name}.fa

# compute length of the fasta sequence
seq=`head -n2 $name | tail -n1`
len=${#seq}
#echo "Sequence length = " $len


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
exit 0
