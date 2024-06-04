# - Customization point for project_options: https://github.com/aminya/project_options
# This module customizes and runs `dynamic_project_options(...)`.
#
# Note that this module should be included this module after `project(...)`.
include_guard()

if(NOT _project_options_POPULATED)
  message(FATAL_ERROR "please `include(fetch_project_options)`")
endif()

# compile_commands.json
set(ENABLE_COMPILE_COMMANDS_SYMLINK_DEFAULT ON)

# hardening
set(ENABLE_CONTROL_FLOW_PROTECTION_DEFAULT ON)
set(ENABLE_ELF_PROTECTION_DEFAULT OFF)
set(ENABLE_OVERFLOW_PROTECTION_DEFAULT ON)
set(ENABLE_RUNTIME_SYMBOLS_RESOLUTION_DEFAULT ON)

if(WIN32 AND CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
  set(ENABLE_STACK_PROTECTION_DEFAULT OFF)
else()
  set(ENABLE_STACK_PROTECTION_DEFAULT ON)
endif()

# optimization
set(ENABLE_INTERPROCEDURAL_OPTIMIZATION_DEFAULT ON)
set(ENABLE_NATIVE_OPTIMIZATION_DEFAULT ON)

# tools
set(ENABLE_CLANG_TIDY_DEFAULT OFF)
set(ENABLE_CPPCHECK_DEFAULT OFF)
set(ENABLE_INCLUDE_WHAT_YOU_USE_DEFAULT OFF)

# FIXME: project_options and project_warnings are not actually used
dynamic_project_options()
