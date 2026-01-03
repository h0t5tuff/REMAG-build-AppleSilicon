# REMAGE
git clone https://github.com/legend-exp/remage.git
cd REMAGE
mkdir build && cd build

cmake .. \
  -DCMAKE_INSTALL_PREFIX="$HOME/opt/remage" \
  -DGeant4_DIR="$HOME/GEANT4/install-11.4/lib/cmake/Geant4" \
  -DROOT_DIR="/opt/homebrew/Cellar/root/6.36.06_1" \
  -DCMAKE_PREFIX_PATH="$HOME/opt/bxdecay0/1.2.1;/opt/homebrew;$HOME/GEANT4/install-11.4" \
  -DPython3_EXECUTABLE="/opt/homebrew/opt/python@3.12/bin/python3.12"
cmake --build . -j 8
cmake --build . --target install


cd ~/REMAGE/tests/output
remage \
  -g gdml/geometry.gdml \
  -o test.root \
  -- macros/ntuple-single-table.mac









# BxDecay0
git clone https://github.com/BxCppDev/bxdecay0.git
cd bxdecay0
git lfs install
git lfs pull

export BXDECAY0_PREFIX="$HOME/opt/bxdecay0/1.2.1"

mkdir build && cd build
cmake .. \
  -DCMAKE_BUILD_TYPE=Release \
  -DBXDECAY0_WITH_GEANT4_EXTENSION=ON \
  -DCMAKE_INSTALL_PREFIX="$BXDECAY0_PREFIX"cmake --build . -- -j$(sysctl -n hw.ncpu)
sudo cmake --install .

cd build
ctest
./bxdecay0-test_decay0_generator
./bxdecay0-run -s 42 -n 1000 -c dbd -N "Ge76" -m 1 -b "./genGe76"








# EXAMPLES

REMAGE bxdecay0 test:

cd ~/REMAGE/tests/bxdecay0
rm -f *.root
remage -g gdml/geometry.gdml \
       -o decay0_0vbb_250k.root \
       -s MODE="0vbb 0" \
       -- macros/template.mac

Smoke test with reduced statistics for testing:
sed 's#/run/beamOn 250000#/run/beamOn 1000#' macros/template.mac > /tmp/template_1k.mac

Use a macro to plot:
sum_edep.C
