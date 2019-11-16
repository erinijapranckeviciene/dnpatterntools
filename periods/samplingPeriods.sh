#!/bin/sh
# nucleosome sequences fasta file
# apoptotic.fa 109
# human.fa 105
# mouse.fa 25
fafile=$1
# start position of the profile 
# for mouse, apoptotic, human we know in advance
start=$2
name=$3

tooldir=/home/erinija/dnpatterntools
if [ ! -d ${name} ]; then
mkdir ${name}
fi

for i in `seq 31`
do
echo "start" 
date
echo $i
seqtk sample -s ${i} ${fafile} 0.5 > ${name}/tmp${i}.fa
# compute profile
echo "diprofile"
sh ${tooldir}/tools/dnp-subset-dinuc-profile.sh ${name}/tmp${i}.fa 'AA AC AG AT CA CC CG CT GA GC GG GT TA TC TG TT' ${name}/tmp${i}.di
# select range
echo "select range"
sh ${tooldir}/tools/dnp-select-range.sh ${name}/tmp${i}.di ${start} 146 'AA AC AG AT CA CC CG CT GA GC GG GT TA TC TG TT' ${name}/tmp${i}.dirange
# symmetrize
echo "symetrize"
sh ${tooldir}/tools/dnp-symmetrize.sh ${name}/tmp${i}.dirange ${name}/tmp${i}.dirangesym
# compute composite
echo "compute composite"
sh ${tooldir}/tools/dnp-compute-composite.sh ${name}/tmp${i}.dirangesym ${name}/tmp${i}.dirangesymcomp
# compute periodogram 
echo "compute periodogram"
sh ${tooldir}/tools/dnp-fourier-transform.sh ${name}/tmp${i}.dirangesymcomp ${name}/tmp${i}.period 2 3 4
echo "put into file"
cat ${name}/tmp${i}.period | awk -v iter=$i -v file=${name} '{if ( ($1>9.4)&&($1<11)) print $1 "\t" $2 "\t" $19 "\t" $7 "\t" $12 "\t" $15 "\t" $20 "\t" $14 "\t" $21 "\t" iter "\t" file }' > fourier2/p.${name}.i${i}
#cat tmp.period | awk -v iter=$i -v file=${name} '{if ( ($1>5)&&($1<20)) print $1 "\t" $2 "\t" $19 "\t" $7 "\t" $12 "\t" $15 "\t" $20 "\t" $14 "\t" $21 "\t" iter "\t" file }' > fourierfull/p.${name}.i${i}
echo "end"
date
done

