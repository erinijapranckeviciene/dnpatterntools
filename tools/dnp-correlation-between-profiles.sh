#!/bin/sh

if test "$#" -ne 4; then

echo ""
echo " CALL  "
echo "   sh dnp-correlation-between-profiles.sh difreq.tabular winsize  dinucleotides correlations.tabular"
echo ""
echo " INPUT"
echo "   difreq.tabular - tabular file of dinucleotide frequencies on forward and complementary fasta sequences "
echo "   winsize        - size of sliding window within which correlation is computed (default 146)"
echo "   dinucleotides  - 'AA AC AG AT ...'"
echo ""
echo " OUTPUT"
echo "   correlations.tabular - tabular file of Pearson correlations at each position for given dinucleotides"
echo ""
echo " DESCRIPTION"
echo "   To find a position of highest symmetry between the"
echo "   dinucleotides positional frequency profiles on"
echo "   forward and complementary sequences  a Pearson" 
echo "   correlation coefficient is computed at each position"
echo "   between forward and complementary dinucleotide profiles"
echo "   within a sliding window."
echo "   Input file contains dinucleotide frequencies arranged in columns"
echo "   for input dinucleotides named by *.f and *.r corresponding to"
echo "   forward and complementary profiles as for example:"
echo ""
echo " AA.f      AA.r      AC.f      AC.r      AG.f      AG.r"
echo " 0.076320  0.067920  0.057800  0.078120  0.081600   0.061960"
echo " 0.072540  0.069520  0.041800  0.079820  0.076300   0.055190"
echo " ...       ...       ...       ...       ...        ..."
echo ""
echo "   The input.tabular file is obtained as output of a dnp-subset-dinuc-profile.sh." 
echo "   A tabular output file contains columns of correlation coefficients "
echo "   along the positions of the frequency profile. A first column contains average of all"
echo "   correlations at each position as shown:"
echo ""
echo " 0        AA        AC       AG"
echo " 0.042205 0.0882716 0.030175 0.126967 "
echo " ...      ...       ...      ..."
echo ""
echo "   Position and value of maximum correlations"
echo "   of each dinucleotide are printed to a standard output."
echo ""
echo " REQUIREMENT"
echo "   dnp-corrprofile installed"
echo "   conda install -c bioconda dnp-corrprofile"
echo ""
  exit 1

fi

name=$1
window=$2
dinucleotides=$3
out=$4

call=dnp-corrprofile

# compute length of the file
len=`wc ${name} |awk '{print $1}'` 
len=$((len-1))

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
