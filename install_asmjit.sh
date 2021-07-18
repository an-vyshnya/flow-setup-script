#!/bin/bash
#asmjit and others

cd $FLOW/platforms/common/cpp
git clone http://git@github.com/area9innovation/asmjit.git
cd asmjit
git checkout next
cd $FLOW/platforms/qt
sudo apt install g++ -y
sudo apt install make -y
