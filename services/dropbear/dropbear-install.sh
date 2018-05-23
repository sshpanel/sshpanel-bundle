#!/bin/bash
# Autoscript dropbear by: VPN Panel & SSH Panel.

. $HOME/sshpanel-bundle/support/app-check.sh
. $HOME/sshpanel-bundle/support/os-detector.sh
. $HOME/sshpanel-bundle/support/string-helper.sh
. $HOME/sshpanel-bundle/support/welcome-screen.sh


# Detect Debian users running the script with "sh" instead of bash
if readlink /proc/$$/exe | grep -q "dash"; then
	danger "This script needs to be run with bash!, not sh"
	exit
fi

if [[ "$EUID" -ne 0 ]]; then
	danger "Sorry, you need to run this as root!"
	exit
fi

if [[ -e /etc/debian_version ]]; then
	OS=debian
	GROUPNAME=nogroup
	RCLOCAL='/etc/rc.local'
elif [[ -e /etc/centos-release || -e /etc/redhat-release ]]; then
	OS=centos
	GROUPNAME=nobody
	RCLOCAL='/etc/rc.d/rc.local'
else
	danger "You aren't running this installer on Debian, Ubuntu or CentOS, Aborting!"
	exit
fi


info "This script will install dropbear into your system!"
enter

# install required package

if [[ "$OS" = "debian" ]]; then
	apt-get install sed -y
	apt-get -y install dropbear
	sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
	sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=443/g' /etc/default/dropbear
	sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 443 -p 143 -p 109 -p 110"/g' /etc/default/dropbear
	echo "/bin/false" >> /etc/shells
	echo "/usr/sbin/nologin" >> /etc/shells
	service ssh restart
	service dropbear restart
fi

if [[ "$OS" = "centos" ]]; then
	yum install sed -y
	yum -y install dropbear
	echo "OPTIONS=\"-p 109 -p 110 -p 443 -p 143\"" > /etc/sysconfig/dropbear
	echo "/bin/false" >> /etc/shells
	sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
	sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=443/g' /etc/default/dropbear
	sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 443 -p 143 -p 109 -p 110"/g' /etc/default/dropbear

	service ssh stop
	systemctl stop sshd.service

	service dropbear start
	systemctl start dropbear.service

	chkconfig dropbear on
fi

success "Dropbear successfully installed!"
echo "-----------------------------------"
echo "TCP Port: 443"
echo "Extra Port: 143, 110, 109"
echo "-----------------------------------"


