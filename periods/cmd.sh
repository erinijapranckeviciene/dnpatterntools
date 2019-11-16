#!/bin/sh
# note- this computation takes time approx 6 hours on large instance
sh samplingPeriods.sh  /var/www/html/nucseq/apoptotic.fa 109 apoptotic 
sh samplingPeriods.sh  /var/www/html/nucseq/shones.fa 105 shones
sh samplingPeriods.sh  /var/www/html/nucseq/conmouse.fa 25 conmouse 
cat header fourier2/* >  p10bp.csv
