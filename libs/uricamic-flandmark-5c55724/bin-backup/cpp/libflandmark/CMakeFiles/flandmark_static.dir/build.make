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

# Include any dependencies generated for this target.
include cpp/libflandmark/CMakeFiles/flandmark_static.dir/depend.make

# Include the progress variables for this target.
include cpp/libflandmark/CMakeFiles/flandmark_static.dir/progress.make

# Include the compile flags for this target's objects.
include cpp/libflandmark/CMakeFiles/flandmark_static.dir/flags.make

cpp/libflandmark/CMakeFiles/flandmark_static.dir/flandmark_detector.cpp.o: cpp/libflandmark/CMakeFiles/flandmark_static.dir/flags.make
cpp/libflandmark/CMakeFiles/flandmark_static.dir/flandmark_detector.cpp.o: ../cpp/libflandmark/flandmark_detector.cpp
	$(CMAKE_COMMAND) -E cmake_progress_report /home/noxx/brigada/uricamic-flandmark-5c55724/bin/CMakeFiles $(CMAKE_PROGRESS_1)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building CXX object cpp/libflandmark/CMakeFiles/flandmark_static.dir/flandmark_detector.cpp.o"
	cd /home/noxx/brigada/uricamic-flandmark-5c55724/bin/cpp/libflandmark && /usr/bin/c++   $(CXX_DEFINES) $(CXX_FLAGS) -fPIC -o CMakeFiles/flandmark_static.dir/flandmark_detector.cpp.o -c /home/noxx/brigada/uricamic-flandmark-5c55724/cpp/libflandmark/flandmark_detector.cpp

cpp/libflandmark/CMakeFiles/flandmark_static.dir/flandmark_detector.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/flandmark_static.dir/flandmark_detector.cpp.i"
	cd /home/noxx/brigada/uricamic-flandmark-5c55724/bin/cpp/libflandmark && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -fPIC -E /home/noxx/brigada/uricamic-flandmark-5c55724/cpp/libflandmark/flandmark_detector.cpp > CMakeFiles/flandmark_static.dir/flandmark_detector.cpp.i

cpp/libflandmark/CMakeFiles/flandmark_static.dir/flandmark_detector.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/flandmark_static.dir/flandmark_detector.cpp.s"
	cd /home/noxx/brigada/uricamic-flandmark-5c55724/bin/cpp/libflandmark && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -fPIC -S /home/noxx/brigada/uricamic-flandmark-5c55724/cpp/libflandmark/flandmark_detector.cpp -o CMakeFiles/flandmark_static.dir/flandmark_detector.cpp.s

cpp/libflandmark/CMakeFiles/flandmark_static.dir/flandmark_detector.cpp.o.requires:
.PHONY : cpp/libflandmark/CMakeFiles/flandmark_static.dir/flandmark_detector.cpp.o.requires

cpp/libflandmark/CMakeFiles/flandmark_static.dir/flandmark_detector.cpp.o.provides: cpp/libflandmark/CMakeFiles/flandmark_static.dir/flandmark_detector.cpp.o.requires
	$(MAKE) -f cpp/libflandmark/CMakeFiles/flandmark_static.dir/build.make cpp/libflandmark/CMakeFiles/flandmark_static.dir/flandmark_detector.cpp.o.provides.build
.PHONY : cpp/libflandmark/CMakeFiles/flandmark_static.dir/flandmark_detector.cpp.o.provides

cpp/libflandmark/CMakeFiles/flandmark_static.dir/flandmark_detector.cpp.o.provides.build: cpp/libflandmark/CMakeFiles/flandmark_static.dir/flandmark_detector.cpp.o

cpp/libflandmark/CMakeFiles/flandmark_static.dir/liblbp.cpp.o: cpp/libflandmark/CMakeFiles/flandmark_static.dir/flags.make
cpp/libflandmark/CMakeFiles/flandmark_static.dir/liblbp.cpp.o: ../cpp/libflandmark/liblbp.cpp
	$(CMAKE_COMMAND) -E cmake_progress_report /home/noxx/brigada/uricamic-flandmark-5c55724/bin/CMakeFiles $(CMAKE_PROGRESS_2)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building CXX object cpp/libflandmark/CMakeFiles/flandmark_static.dir/liblbp.cpp.o"
	cd /home/noxx/brigada/uricamic-flandmark-5c55724/bin/cpp/libflandmark && /usr/bin/c++   $(CXX_DEFINES) $(CXX_FLAGS) -fPIC -o CMakeFiles/flandmark_static.dir/liblbp.cpp.o -c /home/noxx/brigada/uricamic-flandmark-5c55724/cpp/libflandmark/liblbp.cpp

cpp/libflandmark/CMakeFiles/flandmark_static.dir/liblbp.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/flandmark_static.dir/liblbp.cpp.i"
	cd /home/noxx/brigada/uricamic-flandmark-5c55724/bin/cpp/libflandmark && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -fPIC -E /home/noxx/brigada/uricamic-flandmark-5c55724/cpp/libflandmark/liblbp.cpp > CMakeFiles/flandmark_static.dir/liblbp.cpp.i

cpp/libflandmark/CMakeFiles/flandmark_static.dir/liblbp.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/flandmark_static.dir/liblbp.cpp.s"
	cd /home/noxx/brigada/uricamic-flandmark-5c55724/bin/cpp/libflandmark && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -fPIC -S /home/noxx/brigada/uricamic-flandmark-5c55724/cpp/libflandmark/liblbp.cpp -o CMakeFiles/flandmark_static.dir/liblbp.cpp.s

cpp/libflandmark/CMakeFiles/flandmark_static.dir/liblbp.cpp.o.requires:
.PHONY : cpp/libflandmark/CMakeFiles/flandmark_static.dir/liblbp.cpp.o.requires

cpp/libflandmark/CMakeFiles/flandmark_static.dir/liblbp.cpp.o.provides: cpp/libflandmark/CMakeFiles/flandmark_static.dir/liblbp.cpp.o.requires
	$(MAKE) -f cpp/libflandmark/CMakeFiles/flandmark_static.dir/build.make cpp/libflandmark/CMakeFiles/flandmark_static.dir/liblbp.cpp.o.provides.build
.PHONY : cpp/libflandmark/CMakeFiles/flandmark_static.dir/liblbp.cpp.o.provides

cpp/libflandmark/CMakeFiles/flandmark_static.dir/liblbp.cpp.o.provides.build: cpp/libflandmark/CMakeFiles/flandmark_static.dir/liblbp.cpp.o

# Object files for target flandmark_static
flandmark_static_OBJECTS = \
"CMakeFiles/flandmark_static.dir/flandmark_detector.cpp.o" \
"CMakeFiles/flandmark_static.dir/liblbp.cpp.o"

# External object files for target flandmark_static
flandmark_static_EXTERNAL_OBJECTS =

cpp/libflandmark/libflandmark_static.a: cpp/libflandmark/CMakeFiles/flandmark_static.dir/flandmark_detector.cpp.o
cpp/libflandmark/libflandmark_static.a: cpp/libflandmark/CMakeFiles/flandmark_static.dir/liblbp.cpp.o
cpp/libflandmark/libflandmark_static.a: cpp/libflandmark/CMakeFiles/flandmark_static.dir/build.make
cpp/libflandmark/libflandmark_static.a: cpp/libflandmark/CMakeFiles/flandmark_static.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --red --bold "Linking CXX static library libflandmark_static.a"
	cd /home/noxx/brigada/uricamic-flandmark-5c55724/bin/cpp/libflandmark && $(CMAKE_COMMAND) -P CMakeFiles/flandmark_static.dir/cmake_clean_target.cmake
	cd /home/noxx/brigada/uricamic-flandmark-5c55724/bin/cpp/libflandmark && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/flandmark_static.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
cpp/libflandmark/CMakeFiles/flandmark_static.dir/build: cpp/libflandmark/libflandmark_static.a
.PHONY : cpp/libflandmark/CMakeFiles/flandmark_static.dir/build

cpp/libflandmark/CMakeFiles/flandmark_static.dir/requires: cpp/libflandmark/CMakeFiles/flandmark_static.dir/flandmark_detector.cpp.o.requires
cpp/libflandmark/CMakeFiles/flandmark_static.dir/requires: cpp/libflandmark/CMakeFiles/flandmark_static.dir/liblbp.cpp.o.requires
.PHONY : cpp/libflandmark/CMakeFiles/flandmark_static.dir/requires

cpp/libflandmark/CMakeFiles/flandmark_static.dir/clean:
	cd /home/noxx/brigada/uricamic-flandmark-5c55724/bin/cpp/libflandmark && $(CMAKE_COMMAND) -P CMakeFiles/flandmark_static.dir/cmake_clean.cmake
.PHONY : cpp/libflandmark/CMakeFiles/flandmark_static.dir/clean

cpp/libflandmark/CMakeFiles/flandmark_static.dir/depend:
	cd /home/noxx/brigada/uricamic-flandmark-5c55724/bin && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/noxx/brigada/uricamic-flandmark-5c55724 /home/noxx/brigada/uricamic-flandmark-5c55724/cpp/libflandmark /home/noxx/brigada/uricamic-flandmark-5c55724/bin /home/noxx/brigada/uricamic-flandmark-5c55724/bin/cpp/libflandmark /home/noxx/brigada/uricamic-flandmark-5c55724/bin/cpp/libflandmark/CMakeFiles/flandmark_static.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : cpp/libflandmark/CMakeFiles/flandmark_static.dir/depend

