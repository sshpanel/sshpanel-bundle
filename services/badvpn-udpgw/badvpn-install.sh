#!/bin/bash
# Autoscript badvpn by: VPN Panel & SSH Panel.

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
info "This script will install badvpn-udpgw into your system!"
enter

if [[ "$OS" = "debian" ]]; then
	apt-get install screen sed -y
fi

if [[ "$OS" = "centos" ]]; then
	yum install screen sed -y
fi

cp badvpn-udpgw /usr/bin/badvpn-udpgw

sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300' /etc/rc.local
chmod +x /usr/bin/badvpn-udpgw
screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300

success "BadVPN Successfully installed!"
info "Running on port: 7300"


