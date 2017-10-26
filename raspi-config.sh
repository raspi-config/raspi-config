#!/usr/bin/env bash

SCRIPT_NAME="install.sh"
REPO="https://github.com/raspi-config/raspi-config.git"

git clone --quiet $REPO /tmp/raspi-config > /dev/null

cd /tmp/raspi-config

source ./common.sh
source ./install.sh

cd

function update_repositories() {
    install_log "[APT] Updating repositories..."

    sudo apt-get update > /dev/null || install_error "[APT] Failed download!"

    echo -e "done... \n"
}

function install_dependencies() {
    install_log "[APT] Installing dependencies..."

    curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash - > /dev/null
    sudo apt-get -y install nodejs nginx git htop vim > /dev/null || install_error "[APT] Failed install"

    echo -e "done... \n"
}

install_raspi_config
