#!/bin/bash

mkdir -p $HOME/run/etherpad/var $HOME/run/etherpad/cfg
chmod 777 $HOME/run/etherpad/var $HOME/run/etherpad/cfg
cp etherpad/settings.json $HOME/run/etherpad/cfg
podman pull docker.io/etherpad/etherpad:1.8.0
podman run -d --name myetherpad -p 2003:9001 -v $HOME/run/etherpad/var:/opt/etherpad-lite/var -v $HOME/run/etherpad/cfg/settings.json:/opt/etherpad-lite/settings.json -e NODE_ENV=production etherpad/etherpad:1.8.0
