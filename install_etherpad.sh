#!/bin/bash

source ./vars.sh

mkdir -p $HOME/run/etherpad/var $HOME/run/etherpad/cfg
chmod 755 $HOME/run/etherpad/var $HOME/run/etherpad/cfg
cp etherpad/settings.json $HOME/run/etherpad/cfg
chown -R 5001:5001 $HOME/run/etherpad
podman pull docker.io/etherpad/etherpad:1.8.0

# etherpad port is 9001
podman run -d --name myetherpad --hostname myetherpad --ip $ETHERPAD_IP -v $HOME/run/etherpad/var:/opt/etherpad-lite/var:z -v $HOME/run/etherpad/cfg/settings.json:/opt/etherpad-lite/settings.json:z -e NODE_ENV=production etherpad/etherpad:1.8.0
