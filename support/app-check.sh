#!/bin/bash
# Application Checker
# Author: Rizal Fakhri <rizal@codehub.id>


app_check() 
{
    hash $1 &> /dev/null
    if [ $? -eq 1 ]; then
        echo >&2 -e "[$1] => \e[41m NOT INSTALLED!\e[0m"
    else
        echo >&2 -e "[$1] => \e[45m INSTALLED!\e[0m"
    fi
}

app_check_bool() {
    hash $1 &> /dev/null
    return $?
}

