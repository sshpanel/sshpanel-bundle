#!/bin/bash
# Author: Rizal Fakhri <rizal@codehub.id>

. $HOME/helpers/support/app-check.sh
. $HOME/helpers/support/os-detector.sh
. $HOME/helpers/support/string-helper.sh
. $HOME/helpers/support/welcome-screen.sh

apt-get update -y
clear

info "Welcome to SSHPanel & VPNPanel configuration scripts."
enter
echo ""
echo "--------"
echo "Checking required software..."
app_check sudo
app_check_bool sudo 
__SUDO__=$?

app_check git
app_check_bool git
__GIT__=$?

app_check curl
app_check_bool curl
__CURL__=$?

app_check wget
app_check_bool wget
__WGET__=$?

app_check unzip
app_check_bool unzip 
__UNZIP__=$?

app_check sed
app_check_bool sed
__SED__=$?

app_check apache2
app_check_bool apache2
__APACHE2__=$?

app_check php
app_check_bool php
__PHP__=$?

app_check mysql
app_check_bool mysql
__MYSQL__=$?

sleep 3


if [ ${__SUDO__} -eq 1 ]; then
    danger "Installing [SUDO]..."
    apt-get install sudo -y
fi

if [ ${__UNZIP__} -eq 1 ]; then
    danger "Installing [UNZIP]..."
    sudo apt-get install unzip -y
fi

if [ ${__UNZIP__} -eq 1 ]; then
    danger "Installing [WGET]..."
    sudo apt-get install wget -y
fi

if [ ${__GIT__} -eq 1 ]; then
    danger "Installing [GIT]..."
    sudo apt-get install git -y
fi

if [ ${__SED__} -eq 1 ]; then
    danger "Installing [SED]..."
    sudo apt-get install sed -y
fi

if [ ${__CURL__} -eq 1 ]; then 
    danger "Installing [CURL]..."
    sudo apt-get install curl -y
fi

if [ ${__APACHE2__} -eq 1 ]; then
    danger "Installing [APACHE]..."
    sudo apt-get install apache2 -y
fi

__CODENAME__=`grep "VERSION=" /etc/os-release |awk -F= {' print $2'}|sed s/\"//g |sed s/[0-9]//g | sed s/\)$//g |sed s/\(//g`

if [ ${__PHP__} -eq 1 ]; then
    danger "Installing [PHP]..."
    if [ ${__CODENAME__} = 'stretch' ]; then 
        sudo sudo apt-get install php7.0 php7.0-xml php7.0-zip libapache2-mod-php7.0 -y
    else
        sudo sudo apt-get install php5 libapache2-mod-php5 -y
    fi
fi

if [ ${__MYSQL__} -eq 1 ]; then
    danger "Installing [MYSQL]..."
    sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password lMC09Xh2uJm0QQx6v2'
    sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password lMC09Xh2uJm0QQx6v2'
    sudo apt-get -y install mysql-server
fi

if [ ${__CODENAME__} = 'wheezy' ]; then 
    __WEB__DIR__='/var/www'
else
    __WEB__DIR__='/var/www/html'
fi

danger "Installing PHPSysInfo..."
cd ${__WEB__DIR__}
rm -rf *
wget https://github.com/phpsysinfo/phpsysinfo/archive/master.zip
unzip master.zip 
mv phpsysinfo-master/* ./
mv phpsysinfo.ini.new phpsysinfo.ini 

danger "Changing Apache Port onto 4210"
replace "Listen 80" "Listen 4210" -- /etc/apache2/ports.conf

danger "Restarting Apache2 Server..."
service apache2 restart 

clear
display_sshpanel_screen
echo ""
echo "-------"
success "Done! Server has been configured!"
echo "Test the installation at http://`curl -s icanhazip.com`:4210"

