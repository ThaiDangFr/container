#!/bin/bash

echo "1) Stopping containers and pod"
podman stop myetherpad

echo "2) Removing containers and pod"
podman rm myetherpad
