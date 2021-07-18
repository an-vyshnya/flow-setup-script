#!/bash/bin

touch ~/.env
echo "source ~/.env" | tee -a ~/.bashrc ~/.profile

sudo ./install_php.sh
sudo ./install_git.sh
sudo ./install_haxe.sh
sudo ./install_java.sh
sudo ./install_asmjit.sh
sudo ./generate_qt_script.sh
# sudo ./install_qt.sh
