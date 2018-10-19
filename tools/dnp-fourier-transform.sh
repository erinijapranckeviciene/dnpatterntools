#!/bin/sh

if test "$#" -ne 5; then

echo ""
echo " CALL "  
echo "   sh dnp-fourier-transform.sh difreq.profiles.tabular difreq.periodogram.tabular normalization winsize trim"
echo ""
echo " INPUT "
echo "   difreq.profiles.tabular  - dinucleotide frequency profiles-patterns"
echo "   normalization            - type of normalization, suggested is quadratic =2"
echo "   winsize                  - size of averaging window, suggested optimal value =3"
echo "   trim                    - how many noisy points to remove from both ends of the profile suggested =4"
echo ""
echo " OUTPUT "
echo "   difreq.periodogram.tabular - periodogram "
echo ""
echo " DESCRIPRION"
echo "    This is a shell wrapper of the call to dnp-fourier which computes a periodogram "
echo "    of a series given as a numerical column and has parameters:"
echo "    dnp-fourier -f input -o output  -n {normalization 0|1|2}  -l length_of_smoothing_window -t {type_of_output 1|2|3}"
echo ""
echo "    The parameters control a type of normalization and output:"
echo "    Normalization"
echo "       0 base normalization  subtracts mean"
echo "       1 linear normalization removes linear trand "
echo "       2 quadratic normalization removes quadratic trend"
echo "    Output  type"
echo "       1 normalization outputs normalized original series"
echo "       2 smoothing outputs smoothed original series"
echo "       3 Fourier transform outputs periofogram"
echo ""
echo "     Fourier transform has to be applied on symmetrized, nonsmoothed data, since it performs"
echo "     smoothing internally. Dinucleotide frequency profiles usually have a quadratic gradient,"
echo "     therefore a quadratic normalization is used by default. Fourier transform is applied to every "
echo "     column of the input table. In the output the first column contains period as a number of base pairs."
echo ""
echo "     Example of input table"
echo "     pos AA      AC      AG      AT      CA      CC      CG      CT      GA      GC      GG      GT      TA      TC      TG      TT      WW      SS      RR      YY"
echo "    -73 0.05664 0.0657  0.06966 0.03644 0.08026 0.09484 0.0362  0.09086 0.07084 0.04032 0.07318 0.06466 0.03862 0.06838 0.05722 0.05602 0.18772 0.24454 0.27032 0.3101"
echo "    -72 0.0668  0.06476 0.0753  0.04282 0.07022 0.08034 0.03534 0.081   0.07222 0.03512 0.06774 0.0598  0.03934 0.07496 0.06628 0.06784 0.2168  0.21854 0.28206 0.30414"
echo "    -71 0.063   0.0621  0.07668 0.04316 0.06926 0.07264 0.03316 0.07992 0.07546 0.03498 0.07306 0.06406 0.04182 0.07374 0.06874 0.06812 0.2161  0.21384 0.2882  0.29442"
echo "    -70 0.0624  0.0643  0.07214 0.04424 0.0642  0.06998 0.03472 0.07718 0.0723  0.03982 0.07472 0.06818 0.04282 0.07674 0.06864 0.06754 0.217   0.21924 0.28156 0.29144"
echo "    -69 0.0622  0.06456 0.074   0.0426  0.0661  0.07114 0.03414 0.08016 0.0703  0.03786 0.07118 0.06754 0.0421  0.07712 0.06988 0.06904 0.21594 0.21432 0.27768 0.29746"
echo "    ..."
echo ""
echo "    Example of output"
echo "    period	AA	        AC	        AG	   ..."
echo "    2.100000	0.055962	0.061351	0.059462   ..."
echo "    2.200000	0.031410	0.027762	0.030298   ..."
echo "    ..."
echo ""
echo " REQUIREMENT"
echo "   dnp-fourier installed"
echo "   conda install -c bioconda dnp-fourier"
echo ""

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

call=dnp-fourier

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
