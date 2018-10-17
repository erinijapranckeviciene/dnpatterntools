#  CMakeLists.txt for dnpatterntools core programs
#
cmake_minimum_required (VERSION 3.0.0)
project (diprofile CXX)
project (binstrings CXX)
project (corrprofile CXX)
project (Fourier_Transform CXX)
find_package (ZLIB)
find_package (SeqAn REQUIRED)

# Build 

include_directories (${SEQAN_INCLUDE_DIRS}) 
add_definitions (${SEQAN_DEFINITIONS})
set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${SEQAN_CXX_FLAGS}")

add_executable (dnp-diprofile diprofile.cpp)
add_executable (dnp-binstrings binstrings.cpp)
add_executable (dnp-corrprofile corrprofile.cpp)
add_executable (dnp-fourier Fourier_Transform.cpp)

target_link_libraries (dnp-diprofile
pthread
${SEQAN_LIBRARIES}
)

target_link_libraries (dnp-binstrings
pthread
${SEQAN_LIBRARIES}
)

target_link_libraries (dnp-corrprofile
pthread
${SEQAN_LIBRARIES}
)

