#!/usr/bin/env bash

DIR="/home/pi/tests/raspi-config"
USER=pi
IP=192.168.15.10

SSH="$USER@$IP"

ssh $SSH "sudo rm -rf $DIR/*"
scp -r . "$SSH:$DIR"
ssh $SSH "chmod +x $DIR/*.sh"
