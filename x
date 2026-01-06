# REMAGE

mkdir REMAGE && cd REMAGE
git clone https://github.com/legend-exp/remage.git
rm -rf build && mkdir build && cd build
cmake -S ../remage \
  -G "Unix Makefiles" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX="$REMAGE_PREFIX" \
  -DCMAKE_OSX_ARCHITECTURES=arm64 \
  -DGeant4_DIR="$Geant4_DIR" \
  -DROOT_DIR="$ROOT_DIR" \
  -DPython3_EXECUTABLE="$Python3_EXECUTABLE" \
  -DCMAKE_PREFIX_PATH="$BXDECAY0_PREFIX;$GEANT4_BASE;/opt/homebrew"
cmake --build . -j"$(sysctl -n hw.ncpu)"
ctest --output-on-failure
cmake --install .
-----------examples------------
#ex1:
cd ~/REMAGE/remage/tests/output
remage \
  -g gdml/geometry.gdml \
  -o test.root \
  -- macros/ntuple-single-table.mac
# ex2:
cd ~/REMAGE/remage/tests/bxdecay0
rm -f *.root
remage -g gdml/geometry.gdml \
       -o decay0_0vbb_250k.root \
       -s MODE="0vbb 0" \
       -- macros/template.mac
Use macro to plot:
TensorsMacros_sum_edep.C
# ex3:
cd ~/REMAGE/remage/examples/03-optics
rm -rf build && mkdir build && cd build
cmake -S . -B build -DCMAKE_PREFIX_PATH="$REMAGE_PREFIX"
cmake --build build --parallel "$(sysctl -n hw.ncpu)"



# BxDecay0 (needed for REMAGE)

mkdir BXDECAY0 && cd BXDECAY0 
git clone https://github.com/BxCppDev/bxdecay0.git
cd bxdecay0
git lfs install && git lfs pull
cd ../
rm -rf build && mkdir build && cd build
cmake -S ../bxdecay0 \
  -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX="$BXDECAY0_PREFIX" \
  -DCMAKE_OSX_ARCHITECTURES=arm64 \
  -DBUILD_SHARED_LIBS=ON \
  -DBXDECAY0_WITH_GEANT4_EXTENSION=ON \
  -DGeant4_DIR="$Geant4_DIR" \
  -DBXDECAY0_INSTALL_DBD_GA_DATA=ON
cmake --build . -j"$(sysctl -n hw.ncpu)"
ctest --output-on-failure
cmake --install .
-------------examples------------
rm -rf build && mkdir build && cd build
ctest
./bxdecay0-test_decay0_generator
./bxdecay0-run -s 42 -n 1000 -c dbd -N "Ge76" -m 1 -b "./genGe76"
