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

# Escaping for special characters.
EQUALS = =

# The program to use to edit the cache.
CMAKE_EDIT_COMMAND = /usr/bin/ccmake

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/noxx/Dropbox/PavelCerny/libs/uricamic-flandmark-5c55724

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/noxx/Dropbox/PavelCerny/libs/uricamic-flandmark-5c55724-build

# Include any dependencies generated for this target.
include cpp/CMakeFiles/flandmark_2.dir/depend.make

# Include the progress variables for this target.
include cpp/CMakeFiles/flandmark_2.dir/progress.make

# Include the compile flags for this target's objects.
include cpp/CMakeFiles/flandmark_2.dir/flags.make

cpp/CMakeFiles/flandmark_2.dir/example2.cpp.o: cpp/CMakeFiles/flandmark_2.dir/flags.make
cpp/CMakeFiles/flandmark_2.dir/example2.cpp.o: /home/noxx/Dropbox/PavelCerny/libs/uricamic-flandmark-5c55724/cpp/example2.cpp
	$(CMAKE_COMMAND) -E cmake_progress_report /home/noxx/Dropbox/PavelCerny/libs/uricamic-flandmark-5c55724-build/CMakeFiles $(CMAKE_PROGRESS_1)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building CXX object cpp/CMakeFiles/flandmark_2.dir/example2.cpp.o"
	cd /home/noxx/Dropbox/PavelCerny/libs/uricamic-flandmark-5c55724-build/cpp && /usr/bin/c++   $(CXX_DEFINES) $(CXX_FLAGS) -o CMakeFiles/flandmark_2.dir/example2.cpp.o -c /home/noxx/Dropbox/PavelCerny/libs/uricamic-flandmark-5c55724/cpp/example2.cpp

cpp/CMakeFiles/flandmark_2.dir/example2.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/flandmark_2.dir/example2.cpp.i"
	cd /home/noxx/Dropbox/PavelCerny/libs/uricamic-flandmark-5c55724-build/cpp && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -E /home/noxx/Dropbox/PavelCerny/libs/uricamic-flandmark-5c55724/cpp/example2.cpp > CMakeFiles/flandmark_2.dir/example2.cpp.i

cpp/CMakeFiles/flandmark_2.dir/example2.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/flandmark_2.dir/example2.cpp.s"
	cd /home/noxx/Dropbox/PavelCerny/libs/uricamic-flandmark-5c55724-build/cpp && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -S /home/noxx/Dropbox/PavelCerny/libs/uricamic-flandmark-5c55724/cpp/example2.cpp -o CMakeFiles/flandmark_2.dir/example2.cpp.s

cpp/CMakeFiles/flandmark_2.dir/example2.cpp.o.requires:
.PHONY : cpp/CMakeFiles/flandmark_2.dir/example2.cpp.o.requires

cpp/CMakeFiles/flandmark_2.dir/example2.cpp.o.provides: cpp/CMakeFiles/flandmark_2.dir/example2.cpp.o.requires
	$(MAKE) -f cpp/CMakeFiles/flandmark_2.dir/build.make cpp/CMakeFiles/flandmark_2.dir/example2.cpp.o.provides.build
.PHONY : cpp/CMakeFiles/flandmark_2.dir/example2.cpp.o.provides

cpp/CMakeFiles/flandmark_2.dir/example2.cpp.o.provides.build: cpp/CMakeFiles/flandmark_2.dir/example2.cpp.o

# Object files for target flandmark_2
flandmark_2_OBJECTS = \
"CMakeFiles/flandmark_2.dir/example2.cpp.o"

# External object files for target flandmark_2
flandmark_2_EXTERNAL_OBJECTS =

cpp/flandmark_2: cpp/CMakeFiles/flandmark_2.dir/example2.cpp.o
cpp/flandmark_2: cpp/CMakeFiles/flandmark_2.dir/build.make
cpp/flandmark_2: cpp/libflandmark/libflandmark_static.a
cpp/flandmark_2: cpp/CMakeFiles/flandmark_2.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --red --bold "Linking CXX executable flandmark_2"
	cd /home/noxx/Dropbox/PavelCerny/libs/uricamic-flandmark-5c55724-build/cpp && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/flandmark_2.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
cpp/CMakeFiles/flandmark_2.dir/build: cpp/flandmark_2
.PHONY : cpp/CMakeFiles/flandmark_2.dir/build

cpp/CMakeFiles/flandmark_2.dir/requires: cpp/CMakeFiles/flandmark_2.dir/example2.cpp.o.requires
.PHONY : cpp/CMakeFiles/flandmark_2.dir/requires

cpp/CMakeFiles/flandmark_2.dir/clean:
	cd /home/noxx/Dropbox/PavelCerny/libs/uricamic-flandmark-5c55724-build/cpp && $(CMAKE_COMMAND) -P CMakeFiles/flandmark_2.dir/cmake_clean.cmake
.PHONY : cpp/CMakeFiles/flandmark_2.dir/clean

cpp/CMakeFiles/flandmark_2.dir/depend:
	cd /home/noxx/Dropbox/PavelCerny/libs/uricamic-flandmark-5c55724-build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/noxx/Dropbox/PavelCerny/libs/uricamic-flandmark-5c55724 /home/noxx/Dropbox/PavelCerny/libs/uricamic-flandmark-5c55724/cpp /home/noxx/Dropbox/PavelCerny/libs/uricamic-flandmark-5c55724-build /home/noxx/Dropbox/PavelCerny/libs/uricamic-flandmark-5c55724-build/cpp /home/noxx/Dropbox/PavelCerny/libs/uricamic-flandmark-5c55724-build/cpp/CMakeFiles/flandmark_2.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : cpp/CMakeFiles/flandmark_2.dir/depend

