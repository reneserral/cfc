#!/bin/bash

. $(pwd)/vars.sh

DOCKER_APACHE_PARAMETERS="--name apache_agent -p 80:80 -h www.acme.cat --shm-size 2G --link=$OPENAM_NAME"

dpkg -l | grep docker.io | grep ii > /dev/null
if [ $? -ne 0 ] ; then
    echo Installing docker
    sudo apt update
    sudo apt install docker.io
fi

echo Careful, this can only be done when you have specified the Application Web Agent with the proper password
echo Press Ctrl-C if you didn\'t
read

OUT=$(sudo docker images | grep $DOCKER_APACHE_IMAGE)
if [ $? -ne 0 ] ; then
    echo Docker image does not exist, creating...
    sudo docker build --network=host -t $APACHE_NAME -f $(pwd)/apache/Dockerfile $(pwd)/apache
    sudo docker run -idt $DOCKER_APACHE_PARAMETERS $DOCKER_APACHE_IMAGE
else
    sudo docker ps -a | grep $DOCKER_APACHE_IMAGE > /dev/null
    if [ $? -eq 0 ] ; then
      echo $OUT | cut -d\  -f1
      echo Docker image exists, starting...
      sudo docker start $APACHE_NAME
    else
      sudo docker run -d $DOCKER_APACHE_PARAMETERS $DOCKER_APACHE_IMAGE
    fi
fi
