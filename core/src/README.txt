## How to build diprofile and corrprofile from source

## Instructions for cloned nspipeline, linux os 
## Depends on cmake, it should be installed 
## Depends on SeqAn library (www.seqan.de), necessary part provided with source
## 
## Variable USER_DIR in CMakeLists.txt is set to the path to source .cpp files
## Instructions:
   
   cd source
   mkdir build
   cd build
   cmake ../ -DSeqAn_DIR=`pwd`/../seqan/util/cmake -DSEQAN_INCLUDE_PATH=`pwd`/../seqan/include
   make
   ls
   ./corrprofile --help
   ./diprofile --help
   cp corrprofile diprofile /directory/of/your/choice

## Erinija Pranckeviciene @ OttawaU,FM,BMI 
## April 2017 


