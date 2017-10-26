#!/usr/bin/env bash

REPO="https://github.com/raspi-config/raspi-config.git"

rm -rf /tmp/raspi-config

git clone --quiet $REPO /tmp/raspi-config > /dev/null

cd /tmp/raspi-config

source ./scripts/common.sh
source ./scripts/install.sh

install_raspi_config
