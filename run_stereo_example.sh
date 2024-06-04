#!/bin/bash
pathDatasetEuroc='/Users/feignclaims/Downloads' #Example, it is necesary to change it by the dataset path


#------------------------------------
# Stereo-Inertial Examples
echo "Launching MH01 with Stereo-Inertial sensor"
./Examples/Stereo/stereo_euroc \
  ./Vocabulary/ORBvoc.txt \
  ./Examples/Stereo/EuRoC.yaml \
  "$pathDatasetEuroc"/MH01 \
  ./Examples/Stereo/EuRoC_TimeStamps/MH01.txt \
  dataset-MH01_mono