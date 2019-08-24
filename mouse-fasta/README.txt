The fasta files contain sequences of nucleosomes DNA from nucleus accumbens cells 
of control (Con_H3), stress-susceptible (Sus_H3) and stress-resilient (Res_H3) mouse brain.
The sequences represent genomic locations of the first well phased nucleosome downstream 
gene transcription start site (TSS) in mm9 mouse genome reference.
The mouse gene TSS coordinates were obtained from UCSC Table Browser. 

These sequences were obtained from the NCBI GEO archive GSE54263 series
https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE54263

GSM1311267 Con_H3
GSM1311268 Res_H3
GSM1311269 Sus_H3

Reference:
Sun H, Damez-Werno DM, Scobie KN, Shao NY et al. 
ACF chromatin-remodeling complex mediates stress-induced depressive-like behavior. 
Nat Med 2015 Oct;21(10):1146-53. PMID: 26390241

Each condition has three replicates identified by their SRRxxxxx accessions:
Con_H3 : SRR1138261, SRR1138262, SRR1138263 
Res_H3 : SRR1138264, SRR1138265, SRR1138266 
Sus_H3 : SRR1138267, SRR1138268, SRR1138269 

The fasta sequences are in tabular format in which the fasta header cotains following:
- Gene chromosome, start, RefSeq gene ID, 
- Summit genomic coordinates,
- Genomic coordinates of the aligned read, read SRR ID, summit coordinate that this read
overlaps, summit height resulting from gaussian smoothing, mapping quality of the read
- The genomic location of the sequence which is computed from the location of aligned 99bp
log read extending its 5' end by 20bp upstream and 3' end by 100bp downstream and
the last number is a distance of the summit from the RefSeq gene TSS.  
   
     1	>chr10			chromosome
     2	3495968			TSS start coordinate of a Refseq gene (mm9)
     3	3495968			same as 2
     4	NM_001302794		RefSeq gene accession (mm9)
     5	chr10			chromosome
     6	3496871			summit genomic coordinate
     7	3496871			same as 6
     8	chr10			read chromosome
     9	3496799			read start 
    10	3496898			read end
    11	SRR1138261.60241970	read name
    12	3496871			summit genomic coordinate
    13	20.459500		summit height from gaussian smoothing
    14	60			read mapping quality
    15  ::chr10:3496779-3496998	sequence coordinates (read start -20, read end +150)
    16	902			downstream distance of the summit from TSS start
