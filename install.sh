touch ~/.env
echo "source ~/.env" | tee -a ~/.bashrc ~/.profile
wget https://dev.mysql.com/get/mysql-apt-config_0.8.17-1_all.deb
sudo dpkg -i mysql-apt-config_0.8.17-1_all.deb
sudo apt update
# TODO check how to avoid dialogs
# TODO remove mysql...deb
sudo apt install -y mysql-server mysql-client
sudo mysql --user="root" --execute="ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY ''; FLUSH PRIVILEGES;"
printf '[mysqld]
sql-mode=STRICT_ALL_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER\n' | sudo tee -a /etc/mysql/my.cnf
# TODO add '-y' or alike
sudo add-apt-repository ppa:ondrej/php
sudo apt update
# php-gettext
sudo apt install -y php7.2 php7.2-mysql php7.2-mbstring php-xdebug libapache2-mod-php7.2 php7.2-xml php7.2-zip php7.2-mcrypt
# might be redundant
sudo update-alternatives --config php
sudo apt install apache2
# changed to neutral paths
printf 'Alias "/flow" "/home/'$USER'/area9/flow9/www/"
<Directory /home/'$USER'/area9/flow9/www/>
     AllowOverride All
     Require local
</Directory>\n' | sudo tee /etc/apache2/conf-available/area9.conf
sudo a2enconf area9
sudo service apache2 restart
sudo apt install -y git
git config --global user.email "an.vyshnya@gmail.com"
git config --global user.name "Andrii"
git config --global alias.hist "log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=format:'%Y-%m-%d %H:%M:%S'"
git config --global push.default simple
git config --global pull.rebase true
mkdir -p ~/area9 && cd ~/area9
git clone https://github.com/area9innovation/flow9.git
sudo apt install curl
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
rm -rf flow9
git clone https://github.com/area9innovation/flow9.git
sudo add-apt-repository ppa:haxe/releases -y
sudo apt-get update
sudo apt-get install haxe -y
mkdir ~/haxelib && haxelib setup ~/haxelib
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
# skipped neko compilation
# TODO add -y
sudo apt-get install openjdk-11-jdk
sudo apt-get install zlib1g-dev libjpeg-dev libpng-dev -y
wget -q -O /tmp/libpng12.deb http://mirrors.kernel.org/ubuntu/pool/main/libp/libpng/libpng12-0_1.2.54-1ubuntu1_amd64.deb \
  && sudo dpkg -i /tmp/libpng12.deb \
  && rm /tmp/libpng12.deb
# questionable
sudo add-apt-repository ppa:linuxuprising/libpng12
sudo apt update
sudo apt install libpng12-0
wget https://download.qt.io/archive/qt/5.12/5.12.0/qt-opensource-linux-x64-5.12.0.run
chmod +x qt-opensource-linux-x64-5.12.0.run
./qt-opensource-linux-x64-5.12.0.run
rm qt-opensource-linux-x64-5.12.0.run
sudo apt install libpulse-dev libglu1-mesa-dev qtchooser -y
# changed to opt
qtchooser -install qt512 /opt/Qt/5.12.0/5.12.0/gcc_64/bin/qmake
echo "export QT_SELECT=qt512" >> ~/.env && source ~/.env
cd $FLOW/platforms/common/cpp
# changed to http
git clone http://git@github.com/area9innovation/asmjit.git
cd asmjit
git checkout next
cd $FLOW/platforms/qt
# added
sudo apt install g++
sudo apt install make
./build.sh
