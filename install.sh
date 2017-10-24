#!/usr/bin/env bash
source ./common.sh

RASPICONFIG_DIR="/etc/raspi-config"

APP_BASE_DIR="/home/pi/raspi-config"
API_DIR="$APP_BASE_DIR/server"
FRONTEND_DIR="$APP_BASE_DIR/client"

RASPICONFIG_USER="www-data"

function config_installation(){
    install_log "[ RaspiConfig ]"

    blue="\e[94m"
    white="\e[39m"

    echo -e "\n"
    echo -e " $white Config directory    $blue $RASPICONFIG_DIR"
    echo -e " $white Fron-end directory  $blue $FRONTEND_DIR"
    echo -e " $white API directory       $blue $API_DIR"
    echo -e "\n"
    echo -e "$white"
    echo "Complete the installation? [y/N]: "

    read anwser
    if [[ $anwser != "y" ]]; then
        echo "Installation aborted."
        exit 0
    fi

}

function create_directories() {
    install_log "[CREATE] Creating directories..."

    sudo mkdir -p $RASPICONFIG_DIR || install_error "Unable to create directory ${$RASPICONFIG_DIR}"
    sudo mkdir -p "$RASPICONFIG_DIR/backups"

    sudo mkdir -p $APP_BASE_DIR || install_error "[FAILED] $APP_BASE_DIR"

    echo -e "done... \n"

}

function download_files() {
    install_log "[DOWNLOAD] Dowloading the project files."

    echo -e "done... \n"
}

function install_api() {
    install_log "[INSTALL] Installing the API service."

    echo -e "done... \n"
}

function install_front_end(){
    install_log "[INSTALL] Installing the front-end service."

    echo -e "done... \n"
}

function install_systemctl_service()
{
    install_log "[INSTALL] Installing the SystemCTL service."

    sudo cp "./systemctl/raspiconfig.service" "/lib/systemctl/system/"

    sudo systemctl enable raspiconfig.service
    sudo systemctl start raspiconfig.service

    echo -e "done... \n"
}


function change_permissions() {
    install_log "Changing directories and file permissions/ownerships"

    sudo chown -R $RASPICONFIG_USER:$RASPICONFIG_USER "$RASPICONFIG_DIR" || install_error "[FAILED] Change permissions on $RASPICONFIG_DIR."

    sudo chown -R $RASPICONFIG_USER:$RASPICONFIG_USER "$APP_BASE_DIR" || install_error "[FAILED]] Change permissions on $APP_BASE_DIR."
}

function add_permissions() {
    echo ""
}

function install_complete() {
    echo ""
}

function install_raspi_config() {
    display_welcome
    config_installation
    update_repositories
    install_depedencies
    create_directories

    download_files
    install_front_end
    install_api

    #install_systemctl_service

    #change_permissions

}
