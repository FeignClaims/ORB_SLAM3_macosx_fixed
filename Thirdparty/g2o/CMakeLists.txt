cmake_minimum_required(VERSION 3.25)
set(CMAKE_LEGACY_CYGWIN_WIN32 0)

project(g2o)

# default built type
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release)
endif()

# Generate config.h
set(G2O_CXX_COMPILER "${CMAKE_CXX_COMPILER_ID} ${CMAKE_CXX_COMPILER}")
configure_file(config.h.in ${g2o_SOURCE_DIR}/config.h)

# Set the output directory for the build executables and libraries
if(WIN32)
  set(g2o_LIBRARY_OUTPUT_DIRECTORY ${g2o_SOURCE_DIR}/bin CACHE PATH "Target for the libraries")
else(WIN32)
  set(g2o_LIBRARY_OUTPUT_DIRECTORY ${g2o_SOURCE_DIR}/lib CACHE PATH "Target for the libraries")
endif(WIN32)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${g2o_LIBRARY_OUTPUT_DIRECTORY})
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${g2o_LIBRARY_OUTPUT_DIRECTORY})
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${g2o_RUNTIME_OUTPUT_DIRECTORY})

# Set search directory for looking for our custom CMake scripts to
# look for SuiteSparse, QGLViewer, and Eigen3.
list(APPEND CMAKE_MODULE_PATH ${g2o_SOURCE_DIR}/cmake_modules)

# Include the subdirectories
add_library(g2o SHARED)
target_include_directories(g2o
  PUBLIC
  ${CMAKE_CURRENT_SOURCE_DIR}
)
target_sources(g2o
  PRIVATE
  g2o/types/types_sba.cpp
  g2o/types/types_six_dof_expmap.cpp
  g2o/types/types_seven_dof_expmap.cpp
  g2o/core/hyper_graph_action.cpp
  g2o/core/hyper_graph.cpp
  g2o/core/marginal_covariance_cholesky.cpp
  g2o/core/matrix_structure.cpp
  g2o/core/batch_stats.cpp
  g2o/core/parameter.cpp
  g2o/core/cache.cpp
  g2o/core/optimizable_graph.cpp
  g2o/core/solver.cpp
  g2o/core/optimization_algorithm_factory.cpp
  g2o/core/estimate_propagator.cpp
  g2o/core/factory.cpp
  g2o/core/sparse_optimizer.cpp
  g2o/core/hyper_dijkstra.cpp
  g2o/core/parameter_container.cpp
  g2o/core/optimization_algorithm.cpp
  g2o/core/optimization_algorithm_with_hessian.cpp
  g2o/core/optimization_algorithm_levenberg.cpp
  g2o/core/optimization_algorithm_gauss_newton.cpp
  g2o/core/jacobian_workspace.cpp
  g2o/core/robust_kernel.cpp
  g2o/core/robust_kernel_factory.cpp
  g2o/core/robust_kernel_impl.cpp
  g2o/stuff/timeutil.cpp
  g2o/stuff/os_specific.c
  g2o/stuff/string_tools.cpp
  g2o/stuff/property.cpp
)

# Eigen library parallelise itself, though, presumably due to performance issues
# OPENMP is experimental. We experienced some slowdown with it
find_package(OpenMP)
set(G2O_USE_OPENMP OFF CACHE BOOL "Build g2o with OpenMP support (EXPERIMENTAL)")

if(OPENMP_FOUND AND G2O_USE_OPENMP)
  set(G2O_OPENMP 1)
  target_compile_options(g2o
    PRIVATE
    $<$<COMPILE_LANGUAGE:C>:${OpenMP_C_FLAGS}>
    $<$<COMPILE_LANGUAGE:CXX>:-DEIGEN_DONT_PARALLELIZE ${OpenMP_CXX_FLAGS}>
  )
  message(STATUS "Compiling with OpenMP support")
endif()

find_package(Eigen3 REQUIRED)
target_link_libraries(g2o
  PUBLIC
  Eigen3::Eigen
)

# There seems to be an issue with MSVC8
# see http://eigen.tuxfamily.org/bz/show_bug.cgi?id=83
if(MSVC90)
  target_compile_definitions(g2o
    PUBLIC
    -DEIGEN_DONT_ALIGN_STATICALLY=1
  )
  message(STATUS "Disabling memory alignment for MSVC8")
endif(MSVC90)

# Detect OS and define macros appropriately
if(UNIX)
  target_compile_definitions(g2o
    PUBLIC
    -DUNIX
  )
  message(STATUS "Compiling on Unix")
endif(UNIX)