################################################################
# dnpatterntools v1.0
#
# simple programs to analyze dinucleotide patterns in DNA fasta
# written in C/C++ using SeqAn library (www.seqan.de)
#
################################################################
 
# To build:
cd programs/src

# download SeqAn library headers and make

svn checkout https://github.com/seqan/seqan/trunk/include
make all

# or make individual programs

make binstrings
make corrprofile
make diprofile
make fourier

# move to a bin folder of your choice and test
# here the bin filder is in the current directory

BIN=`pwd`/bin
mkdir ${BIN}
mv binstrings corrprofile diprofile fourier ${BIN}

# call to test

${BIN}/binstrings
${BIN}/coorprofile
${BIN}/diprofile
${BIN}/fourier
