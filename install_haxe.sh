#!/bin/bash
# haxe

sudo add-apt-repository ppa:haxe/releases -y
sudo apt-get update
sudo apt-get install haxe -y
mkdir ~/haxelib 
haxelib setup ~/haxelib
printf 'export HAXE_STD_PATH=/usr/share/haxe/std
export FLOW=$HOME/area9/flow9
export PATH=$FLOW/bin:$PATH\n' >> ~/.env
source ~/.env
haxelib install format 3.4.2
haxelib install pixijs 4.8.4
printf 'export NEKOPATH=/usr/lib/x86_64-linux-gnu/neko
export PATH=$NEKOPATH:$PATH\n' >> ~/.env
source ~/.env
echo '/usr/bin/neko' | sudo tee -a /etc/ld.so.conf.d/flow.conf
sudo ldconfig
