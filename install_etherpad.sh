#!/bin/bash

mkdir -p $HOME/run/etherpad/var $HOME/run/etherpad/cfg
chmod 755 $HOME/run/etherpad/var $HOME/run/etherpad/cfg
cp etherpad/settings.json $HOME/run/etherpad/cfg
chown -R 5001:5001 $HOME/run/etherpad
podman pull docker.io/etherpad/etherpad:1.8.0
podman run -d --name myetherpad -p 2003:9001 -v $HOME/run/etherpad/var:/opt/etherpad-lite/var:z -v $HOME/run/etherpad/cfg/settings.json:/opt/etherpad-lite/settings.json:z -e NODE_ENV=production etherpad/etherpad:1.8.0
