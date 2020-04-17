#!/bin/bash

EMAIL=$1
PASSWORD=$2

if [[ -z $EMAIL || -z $PASSWORD ]];then
  echo "$0 <EMAIL> <PASSWORD>"
  exit 0
fi

source ./vars.sh

mkdir -p $HOME/run/jdownloader/cfg
chmod 755 $HOME/run/jdownloader/cfg
chown 1000:1000 $HOME/run/jdownloader $HOME/run/jdownloader/cfg

podman run -d --name myjdownloader --hostname=myjdownloader --ip $JDOWNLOADER_IP -e EMAIL=$EMAIL -e PASSWORD=$PASSWORD -e UID=1000 -e GID=1000 -v $HOME/run/jdownloader/cfg:/opt/JDownloader/cfg:z -v $HOME/shared/videos:/opt/JDownloader/Downloads docker.io/plusminus/jdownloader2-headless:alpine
