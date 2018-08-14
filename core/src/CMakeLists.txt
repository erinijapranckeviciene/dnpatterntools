set (USER_DIR "`pwd`/../../source")
cmake_minimum_required (VERSION 3.0.0)
project (example1 CXX)

find_package (ZLIB)
find_package (SeqAn REQUIRED)

include_directories (${SEQAN_INCLUDE_DIRS})
add_definitions (${SEQAN_DEFINITIONS})

set  (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${SEQAN_CXX_FLAGS}")

add_executable (corrprofile ${USER_DIR}/corrprofile.cpp)
target_link_libraries (corrprofile ${SEQAN_LIBRARIES})

add_executable (diprofile ${USER_DIR}/diprofile.cpp)
target_link_libraries (diprofile ${SEQAN_LIBRARIES})
