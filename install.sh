#!/usr/bin/env bash
source ./common.sh

RASPICONFIG_USER="www-data"

RASPICONFIG_DIR="/etc/raspi-config"

APP_BASE_DIR="/home/pi/raspi-config"
API_DIR="$APP_BASE_DIR/node-api"
FRONTEND_DIR="$APP_BASE_DIR/vue-client"

BASE_GITHUB="https://github.com/raspi-config"
API_GITHUB_REPO="$BASE_GITHUB/node-api"
CLIENT_GITHUB_REPO="$BASE_GITHUB/vue-client"

function detect_operational_system(){
   source /etc/os-release
   install_log "[OS]: $PRETTY_NAME"
   if [[ $ID != "raspbian" ]]; then
      install_error "Rasbpian not detected! Aborting..."
      exit 0
   fi
   echo -e "\n"
}

function config_installation(){
    install_log "[DIRECTORIES] Default configs"

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
    install_log "[CREATE] Creating project directories..."

    sudo mkdir -p $RASPICONFIG_DIR || install_error "Unable to create directory $RASPICONFIG_DIR"
    sudo mkdir -p "$RASPICONFIG_DIR/backups"

    sudo mkdir -p $APP_BASE_DIR || install_error "[FAILED] $APP_BASE_DIR"

    done_log

}

function download_files() {
    install_log "[DOWNLOAD] Dowloading the project files..."

    sudo chown -R pi:pi "$APP_BASE_DIR" || install_error "[FAILED]] Change permissions on $APP_BASE_DIR."
    rm -rf $API_DIR #&& rm -rf $FRONTEND_DIR

    install_log "[API] download successful"
    git clone --quiet $API_GITHUB_REPO $API_DIR > /dev/null
    done_log

    install_log "[CLIENT] download successful"
    #git clone --quiet $CLIENT_GITHUB_REPO $FRONTEND_DIR > /dev/null
    done_log

}

function install_api() {
    install_log "[INSTALL] Installing the API service..."

    cd $API_DIR
    install_log "installing project dependencies..."
    npm install > /dev/null

    done_log
}

function install_front_end(){
    install_log "[INSTALL] Installing the front-end service."

    cd $FRONTEND_DIR
    install_log "installing project dependencies..."
    npm install > /dev/null
    install_log "building the front-end application"
    npm run build > /dev/null

    done_log
}

function install_systemctl_service()
{
    install_log "[INSTALL] Installing the SystemCTL service."

    sudo systemctl daemon-reload

    SYSTEMCTL_SCRIPT="https://raw.githubusercontent.com/raspi-config/raspi-config/master/systemctl/raspiconfig.service"
    sudo wget -O /lib/systemd/system/raspiconfig.service -q $SYSTEMCTL_SCRIPT

    sudo systemctl enable raspiconfig.service
    sudo systemctl start raspiconfig.service
    install_log "starting the service"

    done_log
}


function change_permissions() {
    install_log "Changing directories and file permissions/ownerships"

    sudo chown -R $RASPICONFIG_USER:$RASPICONFIG_USER "$RASPICONFIG_DIR" || install_error "[FAILED] Change permissions on $RASPICONFIG_DIR."
    sudo chown -R $RASPICONFIG_USER:$RASPICONFIG_USER "$APP_BASE_DIR" || install_error "[FAILED]] Change permissions on $APP_BASE_DIR."
}

function add_permissions() {
    echo ""
}

function configure_nginx(){
    install_log "[NGINX] Installing the virtualhost for application"

    if [ -f "/etc/nginx/sites-enabled/default" ]; then
        sudo rm /etc/nginx/sites-enabled/default
    fi

    if [ -f "/etc/nginx/sites-available/raspiconfig" ]; then
        sudo rm /etc/nginx/sites-available/raspiconfig
    fi

    sudo cp /home/pi/tests/raspi-config/config/nginx.conf /etc/nginx/sites-available/raspiconfig

    if [ -f "/etc/nginx/sites-enabled/raspiconfig" ]; then
        sudo rm /etc/nginx/sites-enabled/raspiconfig
    fi

    sudo ln -s /etc/nginx/sites-available/raspiconfig /etc/nginx/sites-enabled/raspiconfig
    sudo systemctl restart nginx.service

    done_log
}

function install_complete() {
    install_log "Installation has successful :)"
    echo -e "\n"

    IP=$(ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')
    echo -e "\e[94mOpen Web application on http://$IP\n"
}

function install_raspi_config() {
    display_welcome
    detect_operational_system
    config_installation
    #update_repositories
    #install_dependencies
    create_directories

    download_files
    install_api
    #install_front_end

    install_systemctl_service
    change_permissions
    configure_nginx
    install_complete

}
