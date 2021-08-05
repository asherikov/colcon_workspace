set(CMAKE_VERBOSE_MAKEFILE      ON      CACHE STRING "" FORCE)

set(CMAKE_C_COMPILER_LAUNCHER   ccache  CACHE STRING "" FORCE)
set(CMAKE_CXX_COMPILER_LAUNCHER ccache  CACHE STRING "" FORCE)

set(CCWS_BUILD_PROFILE   "$ENV{CCWS_PROFILE}"     CACHE STRING "" FORCE)

# skip some cmake checks
# TODO https://github.com/cristianadam/cmake-checks-cache
set(CMAKE_C_COMPILER_WORKS      TRUE    CACHE BOOL "" FORCE)
set(CMAKE_CXX_COMPILER_WORKS    TRUE    CACHE BOOL "" FORCE)

# override install prefix provided by colcon: colcon uses host directory
# structure, cmake -- target directory structure, in general they do not match
set(CMAKE_INSTALL_PREFIX        $ENV{CCWS_INSTALL_DIR_TARGET} CACHE STRING "" FORCE)

# some packages expect CATKIN_DEVEL_PREFIX to be set when compiling in 'catkin'
# environment, colcon skips devel phase and does not set it
# https://github.com/colcon/colcon-ros/issues/119
set(CATKIN_DEVEL_PREFIX         "${CMAKE_BINARY_DIR}/devel" CACHE STRING "" FORCE)


###############################################################################
# cmake debug
###

#set(CMAKE_FIND_DEBUG_MODE ON)
