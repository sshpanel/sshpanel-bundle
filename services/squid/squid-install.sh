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

clear
info "This script will install Squid3 into your system!"
enter


if [[ "$OS" = "debian" ]]; then
	apt-get -y install squid sed curl
	
	MYIP=`curl -s ifconfig.me`;
	MYIP2="s/xxxxxxxxx/$MYIP/g";

	mkdir /etc/squid3
	mkdir /etc/squid
	cp ~/sshpanel-bundle/services/squid/deb.conf /etc/squid3/squid.conf
	cp ~/sshpanel-bundle/services/squid/deb.conf /etc/squid/squid.conf
	sed -i $MYIP2 /etc/squid3/squid.conf;
	sed -i $MYIP2 /etc/squid/squid.conf;
	service squid3 restart
	service squid restart

fi

if [[ "$OS" = "centos" ]]; then
	yum -y install squid curl sed

	MYIP=`curl -s ifconfig.me`;
	MYIP2="s/xxxxxxxxx/$MYIP/g";

	mkdir /etc/squid
	cp ~/sshpanel-bundle/services/squid/deb.conf /etc/squid/squid.conf
	sed -i $MYIP2 /etc/squid/squid.conf;
	service squid restart
	chkconfig squid on
fi

success "Squid3 Successfully installed!"
info "Running on port: 8080"