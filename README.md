# REMAGE
>git clone https://github.com/legend-exp/remage.git
>
>cd REMAGE
>
>mkdir build && cd build
>
>cmake .. \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX="$HOME/opt/remage" \
  -DGeant4_DIR="$HOME/GEANT4/install-11.4/lib/cmake/Geant4" \
  -DROOT_DIR="/opt/homebrew/Cellar/root/6.36.06_1" \
  -DCMAKE_PREFIX_PATH="$HOME/BXDECAY0/install/bxdecay0/1.2.1;/opt/homebrew;$HOME/GEANT4/install-11.4" \
  -DPython3_EXECUTABLE="/opt/homebrew/opt/python@3.12/bin/python3.12"
>
>cmake --build . -j 8
>
>cmake --build . --target install


## examples

ex1:

>cd ~/REMAGE/tests/output
>
>remage \
  -g gdml/geometry.gdml \
  -o test.root \
  -- macros/ntuple-single-table.mac



ex2:

>cd ~/REMAGE/tests/bxdecay0
>
>rm -f *.root
>
>remage -g gdml/geometry.gdml \
       -o decay0_0vbb_250k.root \
       -s MODE="0vbb 0" \
       -- macros/template.mac
>
>< Use a macro to plot: >
>
>sum_edep.C











# BxDecay0
build BxDecay0 before building REMAGE

>mkdir -p "$HOME/BXDECAY0"
>
>cd "$HOME/BXDECAY0
>
>git clone https://github.com/BxCppDev/bxdecay0.git
>
>cd bxdecay0
>
>git lfs install && git lfs pull

>mkdir -p "$HOME/BXDECAY0/build" && cd "$HOME/BXDECAY0/build"
>
>cmake -S ../bxdecay0 \
  -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX="$BXDECAY0_PREFIX" \
  -DCMAKE_OSX_ARCHITECTURES=arm64 \
  -DBUILD_SHARED_LIBS=ON \
  -DBXDECAY0_WITH_GEANT4_EXTENSION=ON \
  -DGeant4_DIR="$Geant4_DIR" \
  -DBXDECAY0_INSTALL_DBD_GA_DATA=ON
>
>cmake --build . -j"$(sysctl -n hw.ncpu)"
>
>ctest --output-on-failure
>
>cmake --install .





## examples
>cd build
>
>ctest
>
>./bxdecay0-test_decay0_generator
>
>./bxdecay0-run -s 42 -n 1000 -c dbd -N "Ge76" -m 1 -b "./genGe76"








