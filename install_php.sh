#!/bin/bash
# php & apache

sudo add-apt-repository ppa:ondrej/php -y
sudo apt update
sudo apt install -y php7.2 php7.2-mysql php7.2-mbstring php-xdebug libapache2-mod-php7.2 php7.2-xml php7.2-zip php7.2-mcrypt apache2
printf 'Alias "/flow" "/home/'$USER'/area9/flow9/www/"
<Directory /home/'$USER'/area9/flow9/www/>
     AllowOverride All
     Require local
</Directory>\n' | sudo tee /etc/apache2/conf-available/area9.conf
sudo a2enconf area9
sudo service apache2 restart
