#!/bin/sh

if test "$#" -ne 4; then

echo ""
echo " CALL "  
echo "   sh dnp-smooth.sh smoothing-input.tabular winsize trim smoothed-output.tabular"
echo ""
echo " INPUT "
echo "   smoothing-input.tabular  - dinucleotide frequency profiles-patterns to smooth"
echo "   winsize                  - size of averaging window, suggested optimal value =3"
echo "   trim                     - how many noisy points to remove from both ends of the profile suggested =4"
echo ""
echo " OUTPUT "
echo "   smoothed-output.tabular - original series smoothed "
echo ""
echo " DESCRIPRION"
echo "   Applies smoothing on dinucleotide profiles. Smoothing reduces noise and enhances"
echo "   representation of the dinucleotide frequency  profiles. Smoothing is performed by"
echo "   moving average with chosen window size (optimal winsize=3). Smoothing script is based on"
echo "   a shell wrapper of the call to dnp-fourier tool which computes a periodogram"
echo "   of a series given as a numerical column and it is called as follows"
echo "   dnp-fourier -f input -o output  -n {normalization 0|1|2}  -l length_of_smoothing_window -t {type_of_output 1|2|3}"
echo "   The parameters control a type of normalization and output."
echo "   Normalization"
echo "       0 base normalization  subtracts mean"
echo "       1 linear normalization removes linear trand "
echo "       2 quadratic normalization removes quadratic trend"
echo "   Output  type"
echo "       1 normalization outputs normalized original series"
echo "       2 smoothing outputs smoothed original series"
echo "       3 Fourier transform outputs periofogram"
echo ""
echo "    Example of input table"
echo "    pos AA      AC      AG      AT      CA      CC      CG      CT      GA      GC      GG      GT      TA      TC      TG      TT      WW      SS      RR      YY"
echo "    -73 0.05664 0.0657  0.06966 0.03644 0.08026 0.09484 0.0362  0.09086 0.07084 0.04032 0.07318 0.06466 0.03862 0.06838 0.05722 0.05602 0.18772 0.24454 0.27032 0.3101"
echo "    -72 0.0668  0.06476 0.0753  0.04282 0.07022 0.08034 0.03534 0.081   0.07222 0.03512 0.06774 0.0598  0.03934 0.07496 0.06628 0.06784 0.2168  0.21854 0.28206 0.30414"
echo "    -71 0.063   0.0621  0.07668 0.04316 0.06926 0.07264 0.03316 0.07992 0.07546 0.03498 0.07306 0.06406 0.04182 0.07374 0.06874 0.06812 0.2161  0.21384 0.2882  0.29442"
echo "    -70 0.0624  0.0643  0.07214 0.04424 0.0642  0.06998 0.03472 0.07718 0.0723  0.03982 0.07472 0.06818 0.04282 0.07674 0.06864 0.06754 0.217   0.21924 0.28156 0.29144"
echo "    -69 0.0622  0.06456 0.074   0.0426  0.0661  0.07114 0.03414 0.08016 0.0703  0.03786 0.07118 0.06754 0.0421  0.07712 0.06988 0.06904 0.21594 0.21432 0.27768 0.29746"
echo "    ..."
echo ""
echo "    Output table is an original input table but smoothed by moving average with given window size."
echo ""
echo " REQUIREMENT"
echo "   dnp-fourier installed"
echo "   conda install -c bioconda dnp-fourier"
echo ""


    exit 1
fi

# input file name
name=$1
swindow=$2
trim=$3
out=$4

call=dnp-fourier

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
