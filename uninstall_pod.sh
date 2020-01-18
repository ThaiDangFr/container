#!/bin/bash

echo "Removing pod"
podman pod stop mypod
podman pod rm mypod
