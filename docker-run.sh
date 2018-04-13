#!/bin/bash 

# Use this only for running individual containers locally
# On cpouta use docker-compose

IMAGE_NAME="tomcat-7-varnish"
CONTAINER_NAME="$IMAGE_NAME"
IP="172.30.23.14"
CONTAINER_PORT="80"
PORT="8080"
NETWORK="seco"
NETWORK_CIDR="172.30.20.0/22"
CONTAINER_USER="$UID"
CONTAINER_PATH_TOMCAT="/var/lib/tomcat8"

# DOCKER

# Create docker network if it does not exist
docker network inspect "$NETWORK" > /dev/null 2>&1
if [ $? != 0 ]; then
	set -x # print the next comand
	docker network create --subnet $NETWORK_CIDR $NETWORK
    { set +x; } 2> /dev/null
fi 

mkdir -p vol-tomcat
chmod ug+rwX vol-tomcat

#Run the container
set -x # print the next command
docker run -it --rm \
	-u $CONTAINER_USER \
	--name $CONTAINER_NAME \
	--network $NETWORK \
	--ip $IP \
	--publish $PORT:$CONTAINER_PORT \
	--expose $CONTAINER_PORT \
	$IMAGE_NAME	
{ set +x; } 2> /dev/null
