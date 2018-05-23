#!/bin/bash
# String Notification Helper
# Author: Rizal Fakhri <rizal@codehub.id>

info()
{
    echo -e "\e[46m $1 \e[0m"
}

warning() 
{
    echo -e "\e[43m $1 \e[0m"
}

danger() 
{
    echo -e "\e[41m $1 \e[0m"
}

success() 
{
    echo -e "\e[42m $1 \e[0m"
}

enter()
{
    read -sp "Press [ENTER] To Continue";
}

text_info() 
{
    echo -e "\e[95m $1 \e[0m"
}

text_danger() 
{
    echo -e "\e[91m $1 \e[0m"
}