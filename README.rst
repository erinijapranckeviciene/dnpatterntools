
dnpatterntools v1.0 
---------------------

   This repository contains tools to analyze patterns of dinucleotide distributions
   in nucleosomal DNA sequences in fasta file. Most often, computation of these features
   are implemented individually which makes difficult to compare and reproduce results 
   produced by different groups. The repository contains binaries, source code,
   shell scripts of our tools and optional Galaxy wrappers for our tools. The core utilities
   are written in C++ using the SeqAn library. 

   Download or *git clone*. Build from source instructions in a *source* folder. If core programs 
   were installed by conda, then descend into test directory and run *test-dependencies.sh* and
   *test_tools.sh* . Standard use is described in a workflow. However, the tools may also be useful 
   for the different tasks. 


Structure of dnpatterntools repository represented in a tree diagram::


   dnpatterntools/
   ├── bin
   ├── source
   │   └── help
   ├── test
   ├── tools
   │   ├── docu
   │   ├── extra
   │   └── test-data
   └── tools-extra
       ├── bioconda-recipes
       │   ├── dnp-binstrings
       │   ├── dnp-corrprofile
       │   ├── dnp-diprofile
       │   └── dnp-fourier
       └── ggplot-scripts
           └── R


The *bin* and *source* folders contain the binaries and CPP source of core programs:

   * binstrings.CPP
      - computes binary representation of dinucleotide occurrences in a fasta sequences.
   * diprofile.CPP
      - computes frequency of occurrence of dinucleotide at each position of a fasta sequence given a batch of aligned fasta sequences either in original sequence or in its complement.
   * corrprofile.CPP
      - computes Pearson correlation coefficient between dinucleotide frequency profiles (original and complement) along each position of fasta sequence within a sliding window.
   * Fourier_Transform.CPP 
      - computes either smoothed and normalized dinucleotide frequency profile or its periodogram.

The *test* folder contains shell scripts of test calls to the core programs and *dnp* tools. 

The *tools* folder contains tools that implement complete workflow to obtain and characterize dinucleotide patterns in a batch of fasta sequences. 
The tools are written in shell and depends on the core tools. Each tool has an associated functional galaxy xml wrapper that was tested and served 
using Planemo and is being submitted to the Galaxy ToolShed. The *docu* subfolder contains tools usage explanation in Galaxy. The *test-data* subfolder 
contains inputs and output of tools. The data in the *test-data* is used by test scripts in the *test* folder. 
The tools are summarized in a following table and a workflow figure.

===================================== ========================== =======================================================================================================
Script name                           Galaxy tool name           Description 
===================================== ========================== =======================================================================================================
dnp-subset-dinuc-profile.sh           Dinucleotide frequencies   Computes frequencies of occurrence of a subset of dinucleotides in a batch of fasta
dnp-correlation-between-profiles.sh   Correlations               Computes Pearson correlation between a forward and reversed complement dinucleotide frequency profiles
dnp-select-range.sh                   Select interval            Selects rows from the dinucleotide frequency profiles matrix within a give range
dnp-symmetrize.sh                     Symmetrize                 Applies symmetrization operation on forward and complement dinucleotide profiles 
dnp-compute-composite.sh              Composite profiles         Computes composite dinucleotide frequency profiles 
dnp-smooth.sh                         Smooth                     Applies smoothing and normalization on a given dinucleotide frequency profile
dnp-fourier-transform.sh              Periodogram                Computes periodogram for a give dinucleotide profile
===================================== ========================== =======================================================================================================

The *tools-extra* folder contains bioconda-recipes for the core tools. The ggplot-scripts contains *R* functions to visualize some of the tools outputs offline. 

Workflow description
------------------------

Computation patterns of dinucleotide frequency distributions from nucleosome sequences consists of:
   
   1. computation of distribution of frequency of dinucleotide occurrences in a batch of aligned sequences; 
      
   2. determination of nucleosome's position in sequences; 
      
   3. obtaining patterns of dinucleotide frequency profiles of the determined nucleosome by applying
      a symmetrization and computation of composite dinucleotides WW/SS (W = A or T and S=C or G) 
      and RR/YY (R=A or G and Y=C or T) ; 4) normalization and smoothing of the patterns and computing their periodograms. 

A following figure illustrates steps in this workflow and lists tools used in each step. 

.. figure:: workflow-to-compute-patterns.jpg
    :width: 700px
    :align: center
    :height: 350px
    :alt: workflow figure
    :figclass: align-center

    The workflow of dinucleotide frequency pattern computation from a batch of nucleosomes fasta sequences. 

