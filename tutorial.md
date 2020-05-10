
# How to use dnpatterntools in Galaxy
## Introduction
 Nucleosomes provide measures of packaging and stabilize negative supercoiling of DNA in vivo; provide epigenetic layer of information guiding interactions of trans-acting proteins with the genome through their histone modifications; by their positioning they directly regulate access to the functional elements of the genome. Significant information about the occurrence of a nucleosome along DNA is encoded in certain features of the sequence (Lowary and Widom, 1998). Nucleosome-favoring DNA sequences are characterized by specific 10-10.4 base pairs periodical compositions of AA/TT and CC/GG dinucleotides (Ioshikhes et al., 2011 and references therein). The sequence features  together with other factors such as transcription factor binding and remodeling complexes play role in nucleosome positioning in vivo. 

 Nucleosomal DNAs are generally obtained from the puriﬁed chromatin stabilized with formaldehyde and digested with micrococcal nuclease (MNase) which cleaves sequence speciﬁc linker sites (Quintales, et al., 2015). To determine the nucleosome occupancy and positioning information from the MNase-Seq data, it is aligned to the reference genome of the organism under study. Then, nucleosomes positions and occupancy are determined from peaks resulting from the alignment and nucleosome-wrapped (nucleosomal) DNA  sequences can be extracted from those genomic locations.  

 The __dnpatterntools__ provide utilities to compute and analyze patterns of dinucleotide frequency distributions in a stack of nucleosome-wrapped DNA *fasta* sequences .

## Description of workflow
Computation of patterns of dinucleotide frequency distributions from nucleosome sequences consists of :
1. computation of distribution of frequency of dinucleotide occurrences in a stack of aligned sequences; 
2. determination of a statistical dyad position in sequences; 
3. obtaining statistical patterns of dinucleotide frequency of occurrence in the the sequence applying symmetrization  and computing composite dinucleotides WW/SS (W = A or T and S=C or G) and RR/YY (R=A or G and Y=C or T);
4. normalization and smoothing of the patterns and computing their periodograms.

## Data [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3813510.svg)](https://doi.org/10.5281/zenodo.3813510) 

The  sequences of mouse (mm9) nucleosomal DNA that will be used in this demo are available from Zenodo . We will use sequences in [controlm.fa.gz](https://doi.org/10.5281/zenodo.3813510) .

## Hands on demo

### Upload fasta file to your history

text

### Compute frequencies of dinucleotides occurrences in fasta 
Visualize computed frequencies of occurrences of dinucleotides
![Fig1](https://github.com/erinijapranckeviciene/dnpatterntools/blob/master/tools-extra/tutimg/Fig1.PNG "Frequency profiles of dinucleotides")
### Determine a dyad position 
text
### Select pattern interval, symmetrize and compute composite dinucleotide profiles
text
### Smooth and compute periodograms of the patterns 
text

## Conclusion
conlusion
