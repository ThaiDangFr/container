#!/bin/bash

podman pull docker.io/etherpad/etherpad:1.8.0
podman run -d --name myetherpad -p 1002:9001 -v etherpad_data:/opt/etherpad-lite/var etherpad/etherpad:1.8.0
