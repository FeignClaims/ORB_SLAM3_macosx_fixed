set -eax

echo "Configuring and building ORB_SLAM3..."

cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build -j
