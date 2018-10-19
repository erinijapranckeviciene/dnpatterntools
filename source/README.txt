################################################################
# dnpatterntools v1.0 core programs
#
# simple programs to analyze dinucleotide patterns in nucleosomes 
# DNA fasta. Written in C/C++ using SeqAn library (www.seqan.de)
# Tested for Linux and MacOs. 
#
################################################################
 
# There are several ways to build the programs
#
#
#    1. Install the programs with conda
#       conda install dnp-binstrings  -c bioconda
#       conda install dnp-diprofile   -c bioconda
#       conda install dnp-corrprofile -c bioconda
#       conda install dnp-fourier     -c bioconda
#
#    2. Use make 
#    
#    These programs depend on SeqAn library. 
#    Therefore, the SeqAn library has to be either installed or made available.
#    One posibility that works with make is to get the SeqAn library headers 
#    into the current directory by svn (although this is not a best practice).
#    The best is to use cmake (the 3rd option). If core programs are to be used with 
#    the tools (shell scripts) than they should be prefixed by dnp-*. 
#
#       cd source
#       svn checkout https://github.com/seqan/seqan/trunk/include
#
#       make all
#       sudo mv binstrings  /some/bin/folder/on/the/PATH/dnp-binstrings
#       sudo mv diprofile   /some/bin/folder/on/the/PATH/dnp-diprofile
#       sudo mv corrprofile /some/bin/folder/on/the/PATH/dnp-corrprofile
#       sudo mv fourier     /some/bin/folder/on/the/PATH/dnp-fourier
#       
#    3. Use cmake (this will work on Linux and MacOs)
#
#    The SeqAn library should be installed. It can also be
#    installed using conda
#
#       conda install seqan-library -c conda-forge 
# 
#    conda installs seqan library in its default environment. 
#    Descend into the source directory and run cmake using 
#    Release type build. This removes debug information from the 
#    binaries. If the debug is present there might be some problems
#    with assertions. This will addressed shortly. When building with
#    cmake you should create a build directory and make your 
#    build within it. The cmake will find all dependences and will create
#    a Makefile which is used to build the programs. 
#    After a build move the binaries to the directory of executables
#    or export the PATH. 
#   
#
#       cd source
#       mkdir build
#       cd build 
#       cmake ../ -DCMAKE_BUILD_TYPE=Release
#       make
#       
#       sudo mv dnp-* /some/bin/folder/on/the/PATH/
#   or
#       export PATH=/your/location/of/the/programs:$PATH
#
#   These programs were created to work with nucleosomes dna. However,
#   they have a wide scope of application. 


