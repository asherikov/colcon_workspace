include("${CMAKE_CURRENT_LIST_DIR}/../vendor/toolchain_prefix.cmake" OPTIONAL)

set(CMAKE_VERBOSE_MAKEFILE      ON      CACHE STRING "" FORCE)

set(CMAKE_C_COMPILER_LAUNCHER   ccache  CACHE STRING "" FORCE)
set(CMAKE_CXX_COMPILER_LAUNCHER ccache  CACHE STRING "" FORCE)

set(CCWS_BUILD_PROFILE  "$ENV{BUILD_PROFILE}"   CACHE STRING "" FORCE)

set(CTEST_BUILD_NAME    "${CCWS_BUILD_PROFILE}" CACHE STRING "" FORCE)
# controls testing of CCWS-aware packages
set(CCWS_ENABLE_TESTING ON                     CACHE STRING "" FORCE)
# debug level
set(CCWS_DEBUG          "0"                    CACHE STRING "" FORCE)

# skip some cmake checks
# TODO https://github.com/cristianadam/cmake-checks-cache
set(CMAKE_C_COMPILER_WORKS      TRUE    CACHE BOOL "" FORCE)
set(CMAKE_CXX_COMPILER_WORKS    TRUE    CACHE BOOL "" FORCE)

# override install prefix provided by colcon: colcon uses host directory
# structure, cmake -- target directory structure, in general they do not match
set(CMAKE_INSTALL_PREFIX        $ENV{CCWS_INSTALL_DIR_HOST} CACHE STRING "" FORCE)

# some packages expect CATKIN_DEVEL_PREFIX to be set when compiling in 'catkin'
# environment, colcon skips devel phase and does not set it
# https://github.com/colcon/colcon-ros/issues/119
set(CATKIN_DEVEL_PREFIX         "${CMAKE_BINARY_DIR}/devel" CACHE STRING "" FORCE)


###############################################################################
# compilation flags
###
set(CMAKE_CXX_FLAGS     "-fdiagnostics-color -fPIC" CACHE STRING "" FORCE)
set(CCWS_CXX_FLAGS
    "-Wall -Wextra -Wshadow -Werror -Werror=return-type -Werror=pedantic -pedantic-errors -fPIC -fstack-protector-strong -std=c++14"
    CACHE STRING "" FORCE)

add_definitions(-DCCWS_BUILD_PROFILE="${CCWS_BUILD_PROFILE}")
add_definitions(-DCCWS_DEBUG=${CCWS_DEBUG})

# -flto
# performance gain seems to be marginal in general, but the main limiting
# factor currently (gcc7) is:
# "Link-time optimization does not work well with generation of debugging
# information. Combining -flto with -g is currently experimental and
# expected to produce unexpected results."


###############################################################################
# cmake debug
###

#set(CMAKE_FIND_DEBUG_MODE ON)

# Find*.cmake debug output
#set(Boost_DEBUG ON CACHE STRING "" FORCE)
#set(Protobuf_DEBUG ON CACHE STRING "" FORCE)

