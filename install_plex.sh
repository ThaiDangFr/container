#!/bin/bash

PLEX_CLAIM=$1
if [ -z $PLEX_CLAIM ];then
  echo "$0 <plex token : to obtain go to https://plex.tv/claim>"
  exit 0
fi

source ./vars.sh

mkdir -p $HOME/run/plex/config $HOME/run/plex/transcode
chmod 755 $HOME/run/plex/config $HOME/run/plex/transcode
chown -R 1000:1000 $HOME/run/plex

podman run -d --name myplex --hostname=myplex --ip $PLEX_IP -e TZ="FR" -e ADVERTISE_IP="http://$MINIS_IP:32400/" -e PLEX_CLAIM="$PLEX_CLAIM" -v $HOME/run/plex/config:/config:z -v $HOME/run/plex/transcode:/transcode:z -v $HOME/shared:/data --systemd=false -p 32400:32400/tcp docker.io/plexinc/pms-docker:1.18.4.2171-ac2afe5f8
