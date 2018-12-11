#!/bin/bash
# Autoscript dropbear by: VPN Panel & SSH Panel.

sudo apt install python apt-show-versions libapt-pkg-perl libauthen-pam-perl libio-pty-perl libnet-ssleay-perl -y

cd /tmp && curl -L -O http://www.webmin.com/download/deb/webmin-current.deb

sudo dpkg -i webmin-current.deb 

