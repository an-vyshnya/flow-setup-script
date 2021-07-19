#!/bin/bash

getQtCredentials() {
	read -p "Please provide your email: " qtEmail
	read -s -p "Please provide your password: " qtPassword
	echo ""
}

createQtScript() {
	cat <<- EOF > $HOME/non-interactive-install.qs
		function Controller() {
			installer.autoRejectMessageBoxes();
			installer.installationFinished.connect(function() {
				gui.clickButton(buttons.NextButton);
			})
		}
		Controller.prototype.WelcomePageCallback = function() {
			gui.clickButton(buttons.NextButton, 10000);
		}
		Controller.prototype.CredentialsPageCallback = function() {
			var page = gui.pageWidgetByObjectName("CredentialsPage");
			page.loginWidget.EmailLineEdit.setText("$1");
			page.loginWidget.PasswordLineEdit.setText("$2");
			gui.clickButton(buttons.NextButton);
		}
		Controller.prototype.IntroductionPageCallback = function() {
			gui.clickButton(buttons.NextButton);
		}
		Controller.prototype.LicenseAgreementPageCallback = function() {
			gui.currentPageWidget().AcceptLicenseRadioButton.setChecked(true);
			gui.clickButton(buttons.NextButton);
		}
		Controller.prototype.TargetDirectoryPageCallback = function() {
			gui.currentPageWidget().TargetDirectoryLineEdit.setText("/opt/Qt/5.12.0");
			gui.clickButton(buttons.NextButton);
		}
		Controller.prototype.ComponentSelectionPageCallback = function() {
			var widget = gui.currentPageWidget();
			widget.selectAll();
			gui.clickButton(buttons.NextButton);
		}
		Controller.prototype.ReadyForInstallationPageCallback = function() {
			gui.clickButton(buttons.NextButton);
		}
		Controller.prototype.FinishedPageCallback = function() {
			var checkBoxForm = gui.currentPageWidget().LaunchQtCreatorCheckBoxForm;
			if (checkBoxForm && checkBoxForm.launchQtCreatorCheckBox) {
				checkBoxForm.launchQtCreatorCheckBox.checked = false;
			}
			gui.clickButton(buttons.FinishButton);
		}
	EOF
}

qtEmail=""
qtPassword=""
DIR=pwd

# store variables here and source it to other locations
touch $DIR/.env
echo "source $DIR/.env" | tee -a $DIR/.bashrc $DIR/.profile

# add specific repositories
sudo add-apt-repository -yu ppa:ondrej/php
sudo add-apt-repository -yu ppa:haxe/releases
sudo add-apt-repository -yu ppa:linuxuprising/libpng12

# install required packages and lfs
sudo apt install -y php7.2 php7.2-mysql php7.2-mbstring php-xdebug libapache2-mod-php7.2 php7.2-xml php7.2-zip php7.2-mcrypt apache2 git haxe openjdk-11-jdk zlib1g-dev libjpeg-dev libpng-dev libpng12-0 libpulse-dev libglu1-mesa-dev qtchooser g++ make curl
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash

# folders and repos setup
mkdir $DIR/area9
cd $DIR/area9 && git clone https://github.com/area9innovation/flow9.git
cd $DIR/area9/flow9/platforms/common/cpp && git clone http://git@github.com/area9innovation/asmjit.git && git checkout next

# haxe and neko
mkdir $DIR/haxelib 
haxelib setup $DIR/haxelib
printf 'export HAXE_STD_PATH=/usr/share/haxe/std
export FLOW=$DIR/area9/flow9
export PATH=$FLOW/bin:$PATH\n' >> $DIR/.env
source $DIR/.env
haxelib install format 3.4.2
haxelib install pixijs 4.8.4
printf 'export NEKOPATH=/usr/lib/x86_64-linux-gnu/neko
export PATH=$NEKOPATH:$PATH\n' >> $DIR/.env
source $DIR/.env
echo '/usr/bin/neko' | sudo tee -a /etc/ld.so.conf.d/flow.conf
sudo ldconfig

# apache
printf 'Alias "/flow" "/home/'$USER'/area9/flow9/www/"
<Directory /home/'$USER'/area9/flow9/www/>
     AllowOverride All
     Require local
</Directory>\n' | sudo tee /etc/apache2/conf-available/area9.conf
sudo a2enconf area9
sudo service apache2 restart

#qt
cd $DIR && wget https://download.qt.io/archive/qt/5.12/5.12.0/qt-opensource-linux-x64-5.12.0.run
chmod +x qt-opensource-linux-x64-5.12.0.run
echo "To proceed you need to have a Qt account. If you don't have it, please create it beforehand (recommended) or complete the Qt installation manually"
while true; do
	read -p "Would you like to provide your Qt accout credentials?[y/n] " yn
	case $yn in
		[Yy]* ) qtAccount=1; break;;
		[Nn]* ) qtAccount=0; break;;
		* ) echo "Please answer yes or no";;
	esac
done
if [ "${qtAccount}" = 1 ] 
then
	getQtCredentials
	createQtScript ${qtEmail} ${qtPassword}
	$DIR/qt-opensource-linux-x64-5.12.0.run --script $DIR/non-interactive-install.qs
else
	$DIR/qt-opensource-linux-x64-5.12.0.run
fi
qtchooser -install qt512 /opt/Qt/5.12.0/5.12.0/gcc_64/bin/qmake
echo "export QT_SELECT=qt512" >> $DIR/.env && source $HOME/.env

#build
cd $FLOW/platforms/qt && ./build.sh
