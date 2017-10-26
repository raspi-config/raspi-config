#!/usr/bin/env bash
# Outputs a RaspAP Install log line
function install_log() {
    DATE=$(date +"%d/%m/%y %H:%M")

    echo -e "\033[1;32m$DATE - $*\033[m"
}

# Outputs a RaspAP Install Error log line and exits with status code 1
function install_error() {
    echo -e "\033[1;37;41m[ERROR] : $*\033[m"
    exit 1
}

function done_log(){
  echo -e "done... \n"
}

# Outputs a welcome message
function display_welcome() {
    color='\033[0;35m'

    echo -e "${color}\n"
    echo -e " 888888ba                                888888888                                          "
    echo -e " 88     8b                               88                                                 "
    echo -e "a88aaaa8P' .d8888b. .d8888b. 88d888b. 88 88        888888888 88    88 88888888 88 88888888 "
    echo -e " 88    8b. 88    88 Y8ooooo. 88    88 88 88        88     88 8888  88 88       88 88       "
    echo -e " 88     88 88.  .88       88 88.  .88 88 88        88     88 88 88 88 88888888 88 88    88 "
    echo -e " dP     dP  88888P8  88888P  88Y888P  88 888888888 888888888 88  8888 88       88 88888888 "
    echo -e "                             88                                       88                   "
    echo -e "                             dP                                                             "
    echo -e "\n"
}

function loader() {
    i=1
    sp="/-\|"
    echo -n ' '
    while [ -d /proc/$1 ]
    do
      printf "\b${sp:i++%${#sp}:1}"
      sleep 0.1
    done

echo -e "\ndone..."
}
