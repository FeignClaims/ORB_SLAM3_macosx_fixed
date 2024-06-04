cmake_minimum_required(VERSION 3.25)
project(DBoW2)

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release)
endif()

set(LIBRARY_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/lib)

add_library(DBoW2 SHARED)
target_include_directories(DBoW2
  PUBLIC
  ${CMAKE_CURRENT_SOURCE_DIR}
)
target_sources(DBoW2
  PRIVATE
  DBoW2/BowVector.cpp
  DBoW2/FORB.cpp
  DBoW2/FeatureVector.cpp
  DBoW2/ScoringObject.cpp
  DUtils/Random.cpp
  DUtils/Timestamp.cpp
)

find_package(OpenCV QUIET REQUIRED)
find_package(Boost REQUIRED COMPONENTS serialization)
target_link_libraries(DBoW2
  PUBLIC
  ${OpenCV_LIBS}
  Boost::serialization
)