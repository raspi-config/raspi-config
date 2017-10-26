#!/usr/bin/env bash

REPO="https://github.com/raspi-config/raspi-config.git"

git clone --quiet $REPO /tmp/raspi-config > /dev/null

cd /tmp/raspi-config

source scripts/install.sh

install_raspi_config
