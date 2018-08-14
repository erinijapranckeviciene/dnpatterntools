#!/bin/sh

input=$1
output=$2
title=$3
# columns should be separated by , : 1,2,4,5
columns=$4

cut -f${columns} ${input} > input.tmp

# calculate numberof columns
cnum=`head -n1 input.tmp | tr "\t" "\n" | wc | awk '{print $1}'`

# plot the data with gnuplot in one line
gnuplot -e "set key outside; set terminal png; set output '${output}'; set title '${title}';  plot for [col=1:'${cnum}'] 'input.tmp' using 0:col with lines title columnheader;"

rm input.tmp
