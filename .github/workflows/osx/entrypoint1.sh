#!/bin/sh -l
set -x
export TOP=$(pwd)
mkdir LOCAL
cd LOCAL
brew tap davidchall/hep
brew install wget coreutils  
brew install gsl
brew install gnu-sed
brew install gcc
brew install cmake
brew install zlib 
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
export CXXFLAGS=-std=c++14
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
wget  https://www.hepforge.org/archive/lhapdf/LHAPDF-6.2.1.tar.gz
tar zxvf LHAPDF-6.2.1.tar.gz
cd LHAPDF-6.2.1
./configure --prefix=/usr/local
make -j 2  install
cd ..
###########
#wget https://gitlab.cern.ch/hepmc/HepMC/-/archive/2.06.11/HepMC-2.06.11.tar.gz
#tar zxfv HepMC-2.06.11.tar.gz
#cmake -SHepMC-2.06.11 -BbuildHepMC-2.06.11 -Dmomentum=GEV -Dlength=MM
#make -j 2 -C buildHepMC-2.06.11
#make install -C buildHepMC-2.06.11
#cd ..
#################
git clone https://gitlab.cern.ch/averbyts/rapgap
cd rapgap
git checkout cmake
autoreconf -fisv
#this will enable hepmc3 only if it is present
./configure --disable-shared --prefix=$(pwd)/TESTINSTALLDIR --with-hepmc=/usr/local  --with-lhapdf6=/usr/local
make -j 2 
make install 
export HEPMCOUT=output.hepmc
TESTINSTALLDIR/bin/rapgap_hepmc < TESTINSTALLDIR/share/steer-ep
head -n 40 output.hepmc*

