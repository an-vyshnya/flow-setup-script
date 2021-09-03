#!/bin/bash

# Dependencies
qtVersion="5.12.0"		# Do not update unless explicitly specified in flow manual. Check line 133 if update is required.
qtVersionShort="5.12"
phpVersion="7.2"		# Do not update unless explicitly specified in flow manual
jdkVersion="11"
haxelibFormatVersion="3.4.2"
haxelibPixiVersion="4.8.4"	# Do not update unless explicitly specified in flow manual


getQtCredentials() {
	read -p "Please provide your email: " qtEmail
	read -s -p "Please provide your password: " qtPassword
	echo ""
}

createQtScript() {
	cat <<- EOF > /home/$USER/non-interactive-install.qs
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
			gui.currentPageWidget().TargetDirectoryLineEdit.setText("/opt/Qt/$qtVersion");
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

# store variables here and source it to other locations
touch /home/$USER/.env
echo "source /home/$USER/.env" | tee -a /home/$USER/.bashrc /home/$USER/.profile

# add specific repositories
sudo add-apt-repository -yu ppa:ondrej/php
sudo add-apt-repository -yu ppa:haxe/releases
sudo add-apt-repository -yu ppa:linuxuprising/libpng12

# install required packages and lfs
sudo apt install -y php$phpVersion php$phpVersion-mysql php$phpVersion-mbstring php-xdebug libapache2-mod-php$phpVersion php$phpVersion-xml php$phpVersion-zip php$phpVersion-mcrypt apache2 git haxe openjdk-$jdkVersion-jdk zlib1g-dev libjpeg-dev libpng-dev libpng12-0 libpulse-dev libglu1-mesa-dev qtchooser g++ make curl
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash

# folders and repos setup
mkdir /home/$USER/area9
cd /home/$USER/area9 && git clone https://github.com/area9innovation/flow9.git
cd /home/$USER/area9/flow9/platforms/common/cpp && git clone http://git@github.com/area9innovation/asmjit.git && git checkout next

# haxe and neko
mkdir /home/$USER/haxelib 
haxelib setup /home/$USER/haxelib
printf 'export HAXE_STD_PATH=/usr/share/haxe/std
export FLOW=/home/$USER/area9/flow9
export PATH=$FLOW/bin:$PATH\n' >> /home/$USER/.env
source /home/$USER/.env
haxelib install format $haxelibFormatVersion
haxelib install pixijs $haxelibPixiVersion
printf 'export NEKOPATH=/usr/lib/x86_64-linux-gnu/neko
export PATH=$NEKOPATH:$PATH\n' >> /home/$USER/.env
source /home/$USER/.env
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
cd /home/$USER/ && wget https://download.qt.io/archive/qt/$qtVersionShort/$qtVersion/qt-opensource-linux-x64-$qtVersion.run
chmod +x qt-opensource-linux-x64-$qtVersion.run
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
	/home/$USER/qt-opensource-linux-x64-$qtVersion.run --script /home/$USER/non-interactive-install.qs
else
	echo "Please proceed with Qt installation manually. Make sure you:"
	echo "- install all components"
	echo "- pick /opt/Qt/$qtVersion as the installation path"
	echo "- do not launch qt creator"
	/home/$USER/qt-opensource-linux-x64-$qtVersion.run
fi
qtchooser -install qt512 /opt/Qt/$qtVersion/$qtVersion/gcc_64/bin/qmake
echo "export QT_SELECT=qt512" >> /home/$USER/.env && source /home/$USER/.env

#build
cd $FLOW/platforms/qt && ./build.sh

#restart
echo "The installation is completed. Please restart your machine to start using flow"
rebootNow=0
while true; do
	read -p "Would you like restart now?[y/n] " yn
	case $yn in
		[Yy]* ) rebootNow=1; break;;
		[Nn]* ) rebootNow=0; break;;
		* ) echo "Please answer yes or no";;
	esac
done
rm -f /home/$USER/qt-opensource-linux-x64-$qtVersion.run
rm -f /home/$USER/non-interactive-install.qs
if [ "${rebootNow}" = 1 ] 
then
	sudo reboot
fi

