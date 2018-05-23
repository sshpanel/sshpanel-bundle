#!/bin/bash
# Author: Rizal Fakhri <rizal@codehub.id>

. $HOME/helpers/support/app-check.sh
. $HOME/helpers/support/os-detector.sh
. $HOME/helpers/support/string-helper.sh
. $HOME/helpers/support/welcome-screen.sh

apt update -y
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

app_check add-apt-repository
app_check_bool add-apt-repository
__SOFTWARE_PROPERTIES__=$?

echo "Preparing....."
sleep 3

__CODENAME__=`grep "VERSION=" /etc/os-release |awk -F= {' print $2'}|sed s/\"//g |sed s/[0-9]//g | sed s/\)$//g |sed s/\(//g`

if [ ${__SUDO__} -eq 1 ]; then
    warning "Installing [SUDO]..."
    apt install sudo -y
fi

if [ ${__UNZIP__} -eq 1 ]; then
    warning "Installing [UNZIP]..."
    sudo apt install unzip -y
fi

if [ ${__UNZIP__} -eq 1 ]; then
    warning "Installing [WGET]..."
    sudo apt install wget -y
fi

if [ ${__GIT__} -eq 1 ]; then
    warning "Installing [GIT]..."
    sudo apt install git -y
fi

if [ ${__SED__} -eq 1 ]; then
    warning "Installing [SED]..."
    sudo apt install sed -y
fi

if [ ${__CURL__} -eq 1 ]; then 
    warning "Installing [CURL]..."
    sudo apt install curl -y
fi

if [ ${__SOFTWARE_PROPERTIES__} -eq 1 ]; then 
    warning "Installing [SOFTWARE PROPERTIES]..."
    sudo apt-get install software-properties-common -y
    sudo apt-get install python3-software-properties -y
    sudo apt-get install python-software-properties -y
fi

if [ ${__APACHE2__} -eq 1 ]; then
    warning "Installing [APACHE]..."
    sudo apt install apache2 -y
fi

if [ ${__PHP__} -eq 1 ]; then
    warning "Installing [PHP]..."
    yes "" | sudo add-apt-repository ppa:ondrej/php
    apt update -y 
    apt install php7.1 php7.1-xml php7.1-zip libapache2-mod-php7.1 -y
fi

if [ ${__MYSQL__} -eq 1 ]; then
    warning "Installing [MYSQL]..."
    sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password lMC09Xh2uJm0QQx6v2'
    sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password lMC09Xh2uJm0QQx6v2'
    sudo apt -y install mysql-server
fi

warning "Installing PHPSysInfo..."
cd /var/www/html
rm -rf *
wget https://github.com/phpsysinfo/phpsysinfo/archive/master.zip
unzip master.zip 
mv phpsysinfo-master/* .
mv phpsysinfo.ini.new phpsysinfo.ini 

cd /var/www
wget https://github.com/phpsysinfo/phpsysinfo/archive/master.zip
unzip master.zip 
mv phpsysinfo-master/* .
mv phpsysinfo.ini.new phpsysinfo.ini 



warning "Changing Apache Port onto 4210"
replace "Listen 80" "Listen 4210" -- /etc/apache2/ports.conf

warning "Restarting Apache2 Server..."
service apache2 restart 

clear
display_sshpanel_screen
echo ""
echo "-------"
success "Done! Server has been configured!"
echo "Test the installation at http://`curl -s icanhazip.com`:4210"
