#!/bin/bash
#qt script

getQtCredentials() {
	read -p "Please provide your email: " qtEmail
	read -s -p "Please provide your password: " qtPassword
	echo ""
}

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

qtEmail=""
qtPassword=""

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
fi
