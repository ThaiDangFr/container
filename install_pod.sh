#!/bin/bash

echo "Creating pod"
podman pod create -p 2000:2000 -p 2001:2001 -p 2002:2002 -p 2003:2003 -p 2004:2004 --name mypod
