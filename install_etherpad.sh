#!/bin/bash

mkdir -p /root/run/etherpad/var /root/run/etherpad/cfg
chmod 777 /root/run/etherpad/var /root/run/etherpad/cfg
cp etherpad/settings.json /root/run/etherpad/cfg
podman pull docker.io/etherpad/etherpad:1.8.0
podman run -d --name myetherpad -p 1002:9001 -v /root/run/etherpad/var:/opt/etherpad-lite/var -v /root/run/etherpad/cfg/settings.json:/opt/etherpad-lite/settings.json -e NODE_ENV=production etherpad/etherpad:1.8.0
