#!/bin/bash
# java and libs

sudo apt-get install openjdk-11-jdk -y
sudo apt-get install zlib1g-dev libjpeg-dev libpng-dev -y
sudo add-apt-repository ppa:linuxuprising/libpng12 -y
sudo apt update
sudo apt install libpng12-0
