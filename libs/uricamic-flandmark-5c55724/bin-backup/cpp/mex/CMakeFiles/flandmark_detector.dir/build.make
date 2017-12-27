# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 2.8

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list

# Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# The program to use to edit the cache.
CMAKE_EDIT_COMMAND = /usr/bin/ccmake

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/noxx/brigada/uricamic-flandmark-5c55724

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/noxx/brigada/uricamic-flandmark-5c55724/bin

# Utility rule file for flandmark_detector.

# Include the progress variables for this target.
include cpp/mex/CMakeFiles/flandmark_detector.dir/progress.make

cpp/mex/CMakeFiles/flandmark_detector: cpp/mex/flandmark_detector.mexa64

cpp/mex/flandmark_detector.mexa64: cpp/libflandmark/libflandmark_static.a
cpp/mex/flandmark_detector.mexa64: ../cpp/mex/flandmark_detector_mex.cpp
	$(CMAKE_COMMAND) -E cmake_progress_report /home/noxx/brigada/uricamic-flandmark-5c55724/bin/CMakeFiles $(CMAKE_PROGRESS_1)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --blue --bold "Building MEX extension /home/noxx/brigada/uricamic-flandmark-5c55724/bin/cpp/mex/flandmark_detector.mexa64"
	cd /home/noxx/brigada/uricamic-flandmark-5c55724/bin/cpp/mex && /usr/local/MATLAB/R2011b/bin/mex -largeArrayDims /home/noxx/brigada/uricamic-flandmark-5c55724/cpp/mex/flandmark_detector_mex.cpp -I/home/noxx/brigada/uricamic-flandmark-5c55724/cpp/libflandmark -I/usr/include/opencv -L/home/noxx/brigada/uricamic-flandmark-5c55724/bin/cpp/libflandmark -lflandmark_static -lopencv_core -lopencv_imgproc -o flandmark_detector

flandmark_detector: cpp/mex/CMakeFiles/flandmark_detector
flandmark_detector: cpp/mex/flandmark_detector.mexa64
flandmark_detector: cpp/mex/CMakeFiles/flandmark_detector.dir/build.make
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --blue --bold "Copying /home/noxx/brigada/uricamic-flandmark-5c55724/bin/cpp/mex/flandmark_detector.mexa64"
	cd /home/noxx/brigada/uricamic-flandmark-5c55724/bin/cpp/mex && /usr/bin/cmake -E copy /home/noxx/brigada/uricamic-flandmark-5c55724/bin/cpp/mex/flandmark_detector.mexa64 /home/noxx/brigada/uricamic-flandmark-5c55724/learning/flandmark_data/libocas/mex
.PHONY : flandmark_detector

# Rule to build all files generated by this target.
cpp/mex/CMakeFiles/flandmark_detector.dir/build: flandmark_detector
.PHONY : cpp/mex/CMakeFiles/flandmark_detector.dir/build

cpp/mex/CMakeFiles/flandmark_detector.dir/clean:
	cd /home/noxx/brigada/uricamic-flandmark-5c55724/bin/cpp/mex && $(CMAKE_COMMAND) -P CMakeFiles/flandmark_detector.dir/cmake_clean.cmake
.PHONY : cpp/mex/CMakeFiles/flandmark_detector.dir/clean

cpp/mex/CMakeFiles/flandmark_detector.dir/depend:
	cd /home/noxx/brigada/uricamic-flandmark-5c55724/bin && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/noxx/brigada/uricamic-flandmark-5c55724 /home/noxx/brigada/uricamic-flandmark-5c55724/cpp/mex /home/noxx/brigada/uricamic-flandmark-5c55724/bin /home/noxx/brigada/uricamic-flandmark-5c55724/bin/cpp/mex /home/noxx/brigada/uricamic-flandmark-5c55724/bin/cpp/mex/CMakeFiles/flandmark_detector.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : cpp/mex/CMakeFiles/flandmark_detector.dir/depend
