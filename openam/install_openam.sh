#!/bin/bash

. $(pwd)/vars.sh

DOCKER_OPENAM_PARAMETERS="-h $DOMAIN -p 8080:8080 --name $OPENAM_NAME"

dpkg -l | grep docker.io | grep ii > /dev/null
if [ $? -ne 0 ] ; then
    echo Installing docker
    sudo apt update
    sudo apt install docker.io
fi

OUT=$(sudo docker images | grep $DOCKER_OPENAM_IMAGE)
if [ $? -ne 0 ] ; then
    echo Docker image does not exist, importing...
    sudo docker run -d $DOCKER_OPENAM_PARAMETERS $DOCKER_OPENAM_IMAGE
else
    sudo docker ps -a | grep $DOCKER_OPENAM_IMAGE > /dev/null
    if [ $? -eq 0 ] ; then
      echo $OUT | cut -d\  -f1
      echo Docker image exists, starting...
      sudo docker start $OPENAM_NAME
    else
      sudo docker run -d $DOCKER_OPENAM_PARAMETERS $DOCKER_OPENAM_IMAGE
    fi
fi

