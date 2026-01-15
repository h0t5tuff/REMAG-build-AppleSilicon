---------------DEPENDENCY---------
# build BxDecay0 (needed for REMAGE)
mkdir BXDECAY0 && cd BXDECAY0 
git clone https://github.com/BxCppDev/bxdecay0.git
cd bxdecay0
git lfs install && git lfs pull
cd ..
rm -rf build && mkdir build && cd build
cmake -S ../bxdecay0 \
  -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX="$HOME/BXDECAY0/install" \
  -DCMAKE_OSX_ARCHITECTURES=arm64 \
  -DBUILD_SHARED_LIBS=ON \
  -DBXDECAY0_WITH_GEANT4_EXTENSION=ON \
  -DBXDECAY0_INSTALL_DBD_GA_DATA=ON \
  -DGeant4_DIR="$Geant4_DIR" 
cmake --build . -j"$(sysctl -n hw.ncpu)"
ctest --output-on-failure
cmake --install .
---------------BUILD---------
mkdir REMAGE && cd REMAGE
git clone https://github.com/legend-exp/remage.git
rm -rf build && mkdir build && cd build
cmake -S ../remage \
  -G "Unix Makefiles" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX="$REMAGE_PREFIX/remage" \
  -DCMAKE_OSX_ARCHITECTURES=arm64 \
  -DPython3_EXECUTABLE="$Python3_EXECUTABLE" \
  -DCMAKE_PREFIX_PATH="$Geant4_DIR;$ROOT_DIR;$BXDECAY0_PREFIX;$GEANT4_BASE;/opt/homebrew"
cmake --build . -j"$(sysctl -n hw.ncpu)"
ctest --output-on-failure
cmake --install .

-----------examples------------
rm -f *.root *.hdf5
rm -rf build
cmake -S . -B build -G Ninja \
  -DCMAKE_BUILD_TYPE=RelWithDebInfo \
  -DCMAKE_OSX_ARCHITECTURES=arm64 \
  -DCMAKE_PREFIX_PATH="$CMAKE_PREFIX_PATH"
cmake --build build -j"$(sysctl -n hw.ncpu)"
UI-mode: ./build/<sim> ---> /control/execute <mac> 
batch-mode: ./build/<sim> -m <mac>










# tests/bxdecay0:
remage -g gdml/geometry.gdml \
       -o decay0_0vbb_250k.root \
       -s MODE="0vbb 0" \
       -- macros/template.mac
  #Use macro TensorsMacros_sum_edep.C to plot





# examples/07-my-legend-study:





remage-systematically:
Step 1 — Geometry sanity + reproducibility
	•	Always run a batch macro first (no UI) and confirm:
	    •	overlap check is clean enough for tracking
	    •	event rate is stable
	•	Fix geometry before physics. Otherwise you chase ghosts.
Step 2 — Single-process intuition (HPGe)
    Run monoenergetic gammas and electrons and build intuition:
    	•	Photopeak vs Compton continuum (gamma)
	    •	Bremsstrahlung + MCS + range (electron)
	    •	Sensitivity to dead layer / holder material
Step 3 — Add realistic sources (decays, chains)
	•	Use BxDecay0 / built-in decay machinery where appropriate
	•	Compare “truth-level emission” vs “detected deposition”
Step 4 — Add correlated handles (tracks, timing, veto)
	•	Turn on track output schemes where available
	•	For LAr optics: treat “light yield → veto” as a physics handle

LEGEND-200:
  What backgrounds survive all cuts near Q_ββ?
    In simulation lingo:
	  •	Generate backgrounds in the correct place (materials and surfaces).
	  •	Transport them through the real geometry.
	  •	Record observables used in analysis: energy in detectors, multiplicity, distances, timing/veto flags.
  What is the signal efficiency?
	  •	Generate 0νββ decays in active volume.
	  •	Track energy depositions and topology proxies (multi-site vs single-site).
	  •	Include detector effects later (resolution, thresholds).



