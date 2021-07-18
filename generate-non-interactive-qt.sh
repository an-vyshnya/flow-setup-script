#!/bin/bash

createQtScript() {
	cat <<- EOF > non-interactive-install.qs
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

username="";
password="";
while getopts "u:p:" opt
do 
case $opt in 
	u) username=${OPTARG};;
	p) password=${OPTARG};;
esac
done
echo ${username}
echo ${password}
if [ "${username}" != "" ] && [ "${password}" != "" ]
then
	createQtScript ${username} ${password}
else
	echo "You will have to create QtAccount to proceed. Quit the installation and create in on your own or proceed and follow the instructions in the wizard"
	echo "Important: if you choose proceeding with the wizard put /opt/Qt/5.12.0 as an installation path"
	while true; do
		read -p "Would you like to proceed? " yn
		case $yn in
			[Yy]* ) echo "proceed"; break;;
			[Nn]* ) exit;;
			* ) echo "Please provide y/n answer";;
		esac
	done
fi
