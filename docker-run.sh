#!/bin/bash 
SCRIPT_DIR="$(readlink -f "$(dirname "$0")")"

# Use this only for running individual containers locally
# On cpouta use docker-compose

# Usage
usage() {
    echo "Usage $0 [-p <port>]"
}

# Process opts
while getopts ":p:" opt; do
  case $opt in
    p)
        PORT="$OPTARG"
        ;;
    *)
        usage
        exit 1
        ;;
  esac
done
shift $((OPTIND-1))

# Parameters
IMAGE_NAME="tomcat-7-varnish"
CONTAINER_NAME="$IMAGE_NAME"
IP="172.30.23.14"
CONTAINER_PORT="80"
PORT="${PORT:-"8080"}"
NETWORK="seco"
NETWORK_CIDR="172.30.20.0/22"
CONTAINER_USER="$UID"
VOLUME_SOURCE="${1:-$SCRIPT_DIR/vol-www-museosuomi}"
VOLUME_TARGET="/var/lib/tomcat7/webapps/ROOT"

# Convert to absolute paths
VOLUME_SOURCE="$(readlink -f "$VOLUME_SOURCE")"

# Create volume source if not exist
if [ ! -d "$VOLUME_SOURCE" ]; then
    mkdir -p "$VOLUME_SOURCE"
fi

# Create docker network if it does not exist
docker network inspect "$NETWORK" > /dev/null 2>&1
if [ $? != 0 ]; then
	set -x # print the next comand
	docker network create --subnet $NETWORK_CIDR $NETWORK
    { set +x; } 2> /dev/null
fi 

# Run the container
set -x # print the next command
docker run -it --rm \
	-u $CONTAINER_USER \
	--name $CONTAINER_NAME \
	--network $NETWORK \
	--ip $IP \
	--publish $PORT:$CONTAINER_PORT \
	--expose $CONTAINER_PORT \
    --mount type=bind,source="$VOLUME_SOURCE",target="$VOLUME_TARGET" \
	$IMAGE_NAME	
{ set +x; } 2> /dev/null
