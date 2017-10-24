#!/usr/bin/env bash
source ./common.sh

SCRIPT_NAME="install.sh"
SCRIPT_URL="https://raw.githubusercontent.com/raspi-config/raspi-config/master/$SCRIPT_NAME"

TMP_FILE="/tmp/$SCRIPT_NAME"

# wget -q $SCRIPT_URL -O $TMP_FILE
cp $SCRIPT_NAME $TMP_FILE

source $TMP_FILE && rm -f $TMP_FILE

function update_repositories() {
    install_log "[APT] Update repositories"

    sudo apt-get update > /dev/null || install_error "[APT] Failed download!"
    PID=$!
    loader $PID
}

function install_depedencies() {
    install_log "[APT] Installing depedencies"

    curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash - > /dev/null

    sudo apt-get -y install nginx git htop vim > /dev/null || install_error "[APT] Failed install"
    PID=$!
    loader $PID
}

install_raspi_config
