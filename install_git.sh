#!/bin/bash
# git and folders

sudo apt install -y git curl
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
mkdir -p ~/area9 
cd ~/area9
git clone https://github.com/area9innovation/flow9.git
