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
	EOF
	if [ $3 != 1 ]
	then
		cat <<- EOF >> non-interactive-install.qs
				page.loginWidget.EmailLineEdit.setText("$1");
				page.loginWidget.PasswordLineEdit.setText("$2");
		EOF
	else
		cat <<- EOF >> non-interactive-install.qs
				page.signUpWidget.EmailLineEdit.setText("$1");
				page.signUpWidget.PasswordLineEdit.setText("$2");
				page.signUpWidget.PasswordConfirmLineEdit.setText("$2");
				page.signUpWidget.serviceTermsCheckBox.checked = true;
		EOF
	fi
	cat <<- EOF >> non-interactive-install.qs
			gui.clickButton(buttons.NextButton);
		}
	EOF
}

createQtAccount=0
while getopts "u:p:c" opt
do 
case $opt in 
	u) username=${OPTARG};;
	p) password=${OPTARG};;
	c) createQtAccount=1;;
esac
done
echo ${username}
echo ${password}
echo ${createQtAccount}
createQtScript ${username} ${password} ${createQtAccount}
