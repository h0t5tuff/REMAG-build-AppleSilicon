---------------REMAGE---------
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
# tests/bxdecay0:
rm -f *.root
remage -g gdml/geometry.gdml \
       -o decay0_0vbb_250k.root \
       -s MODE="0vbb 0" \
       -- macros/template.mac
  #Use macro TensorsMacros_sum_edep.C to plot

# examples/01-gdml:
cmake -S .. -B . -G Ninja \
  -DCMAKE_BUILD_TYPE=RelWithDebInfo \
  -DCMAKE_OSX_ARCHITECTURES=arm64 \
  -DCMAKE_PREFIX_PATH="$CMAKE_PREFIX_PATH"
cmake --build . -j"$(sysctl -n hw.ncpu)"
  #run from /01-gdml dir (i.e. ./build/01-gdml)
  #rewrote main.cc to have UI

# examples/02-hpge:

# examples/03-optics: 
  #Optical photons and scintillation/absorption processes.
  # Optical photon tracking + PMT/SiPM or optical surfaces / Storing optical observables into ROOT
  # How optical transport depends on surface definitions (polish, reflectivity).
	# Why optical simulation is expensive and requires careful reduction/observables.
  # LEGEND uses LAr veto concepts; optical response matters when you interpret veto performance, light yield, and veto coincidence rates
rm -rf build && mkdir build && cd build
rm -f *.root
cmake -S . -B build -DCMAKE_PREFIX_PATH="$REMAGE_PREFIX"
cmake --build build --parallel "$(sysctl -n hw.ncpu)"
# examples/04-cosmogenics:
  #Cosmogenic production/activation (likely in Ge, Cu, etc.) and/or cosmogenic event generation.
  # Activate isotopes, or simulate cosmogenic-induced decays in/near HPGe.
  # Why exposure histories matter.
	# How delayed backgrounds arise from activation products.
  # Cosmogenic isotopes (in Ge and surrounding materials) drive background models and time-dependent analyses.

# examples/05-MUSUN: 
  #Realistic underground muon distributions.
	#•	muons are sampled from a precomputed distribution (energy, angle, position)
	#•	remage generator reads and injects muons accordingly
	#•	Muon-induced backgrounds are geometry-dependent and rare but high-impact.
	#•	The workflow: external muon spectrum → event injection → secondaries → detector response.
	#•	Muon-induced neutrons and showers can produce captures/activation; modeling muon flux and angular distribution is essential for background budgets.

# examples/06-NeutronCapture:
  #neutron capture physics and gamma cascade bookkeeping.
	#•	simulating n-capture
	#•	recording which isotopes captured
	#•	recording gamma cascade properties
	#•	Capture gamma cascades are a major background mechanism.
	#•	How to implement a custom output scheme for specific physics questions (isotope accounting).
	#•	Neutron capture in materials (Cu, SS, Ar, etc.) creates gamma lines and Compton continua near ROI. This is directly relevant to the 0\nu\beta\beta background model.






# run
UI mode: ./<sim> ---> /control/execute <mac> 
batch mode: ./<sim> -m <mac>










# BxDecay0 (needed for REMAGE)
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


