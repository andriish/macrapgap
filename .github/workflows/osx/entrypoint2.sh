#!/bin/sh -l
set -x
#exit
export TOP=$(pwd)
mkdir LOCAL
cd LOCAL
brew tap davidchall/hep
#brew install hepmc lhapdf  
brew install wget coreutils  
brew install gnu-sed
brew install gcc
brew install cmake
brew install autoconf 
brew install automake 
brew install libtool 
brew install pkg-config
brew install --cask basictex
eval "$(/usr/libexec/path_helper)"
export PATH=$PATH:/usr/local/bin:/usr/local//Cellar/gcc/11.1.0_1/libexec/gcc/x86_64-apple-darwin19/11.1.0/:/Library/TeX/texbin/
sudo tlmgr update --self
sudo tlmgr install sectsty collection-fontsrecommended
#####

which gfortran-11
if [ "$?" = "0" ]; then 
   export CXX=g++-11
   export CC=gcc-11
   export FC=gfortran-11
   export F77=gfortran-11
   export LD=gfortran-11
else
   export CXX=g++
   export CC=gcc
   export FC=gfortran
   export F77=gfortran
   export LD=gfortran
fi
cp /usr/local/bin/gfortran-11 /usr/local/bin/gfortran
###########
#wget https://gitlab.cern.ch/hepmc/HepMC3/-/archive/3.2.4/HepMC3-3.2.4.tar.gz
#tar zxfv HepMC3-3.2.4.tar.gz
#cmake -SHepMC3-3.2.4 -BbuildHepMC3-3.2.4 -DHEPMC3_ENABLE_ROOTIO=OFF  -DCMAKE_INSTALL_PREFIX=/usr/local -DHEPMC3_ENABLE_PYTHON:BOOL=OFF
#make -j 2 -C buildHepMC3-3.2.4
#sudo make install -C buildHepMC3-3.2.4
#cd ..
#find /usr | grep HepMC3
########
wget  https://www.hepforge.org/archive/lhapdf/LHAPDF-6.3.0.tar.gz
tar zxvf LHAPDF-6.3.0.tar.gz
cd LHAPDF-6.3.0
./configure --prefix=/usr/local
make -j 2  install
export PYTHONPATH=$PYTHONPATH:/usr/local/lib/python2.7/site-packages
lhapdf --source=http://lhapdfsets.web.cern.ch/lhapdfsets/current/ install cteq6l1  CT10
cd ..
###########
wget https://gitlab.cern.ch/hepmc/HepMC/-/archive/2.06.11/HepMC-2.06.11.tar.gz
tar zxfv HepMC-2.06.11.tar.gz
cmake -SHepMC-2.06.11 -BbuildHepMC-2.06.11 -Dmomentum=GEV -Dlength=MM
make -j 2 -C buildHepMC-2.06.11
make install -C buildHepMC-2.06.11
#cd HepMC-2.06.11
#autoreconf -fisv
#./configure --prefix=/usr/local  --with-momentum=GEV  --with-length=CM 
#make -j 2
#make install
#cd ..
#
git clone https://gitlab.cern.ch/averbyts/rapgap
cd rapgap
git checkout hepmc3norivet
#autoreconf -fisv
#this will enable hepmc3 only if it is present
#./configure --prefix=$(pwd)/TESTINSTALLDIR --with-hepmc=/usr/local --with-hepmc3=/usr/local  --with-tmdlib=/usr/local --with-lhapdf=/usr/local 

cmake -S. -Bbuild -DCMAKE_INSTALL_PREFIX=$(pwd)/TESTINSTALLDIR -DRAPGAP_HEPMC2=ON -DRAPGAP_HEPMC3=OFF   -DHepMC_DIR=/usr/local -DHEPMC_DIR=/usr/local
make -j 2 -C build
make install -C build

export HEPMCOUT=output.hepmc
export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:$(pwd)/TESTINSTALLDIR/lib
ls -lah TESTINSTALLDIR/bin/rapgap_hepmc
xattr  TESTINSTALLDIR/bin/rapgap_hepmc
TESTINSTALLDIR/bin/rapgap_hepmc  < TESTINSTALLDIR//share/rapgap/steer-ep
head -n 40 output.hepmc*
