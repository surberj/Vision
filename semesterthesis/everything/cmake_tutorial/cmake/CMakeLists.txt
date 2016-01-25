cmake_minimum_required(VERSION 2.6)
project(CMAKEDEMO)

#There are lots of scripts with cmake
#for finding external libraries. 
#see /usr/local/share/cmake-2.6/Modules/Find*.cmake for more examples
find_package(GLUT)
find_package(OpenGL)

set(CMAKE_CXX_FLAGS "-g -Wall")
add_subdirectory(w01-cpp)
