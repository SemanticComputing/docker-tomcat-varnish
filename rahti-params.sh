#!/bin/bash

# OpenShift server, project and template to use
SERVER="https://rahti.csc.fi:8443"
PROJECT_NAME="seco"
TEMPLATE_NAME="seco-image-from"

# These are parameters that will be fed to the template. Make sure to comment out parameters not supported by the template. Otherwise you will get an error
APP_NAME="tomcat-7-varnish" # Name for the application
ENVIRONMENT="production" # Environment, will be used as a name prefix <ENVIRONMENT>-<APP_NAME> for resources. Remember to change IP etc. along with the environment to avoid collisions.
GIT_URL="git@version.aalto.fi:seco/docker-tomcat-varnish.git" # git repository with dockerfile
GIT_REF="tomcat-7" # branch name. empty for master
GIT_DIR="" # directory where Dockerfile is. empty for repository root.
GIT_SECRET="seco-git" # OpenShift secret (ssh key) used to git clone
FROM="production-varnish" # Base image name in OpenShift (without tag)
WEBHOOK_SECRET="JOacMuKpbvKh" # Token that will be a part of the build trigger webhook
#PVC_NAME="volume-name" # Name of the Persistent Volume Claim (PVC) to be mounted within the container
#PVC_TARGET="/m/" # Mount point of the PVC within the container

# Define up to 8 environment variables for the container. If you need more, create custom yaml/template/scripts instead
#ENV1_NAME=""
#ENV1_VALUE=""
#ENV2_NAME=""
#ENV2_VALUE=""
#ENV3_NAME=""
#ENV3_VALUE=""
#ENV4_NAME=""
#ENV4_VALUE=""
#ENV5_NAME=""
#ENV5_VALUE=""
#ENV6_NAME=""
#ENV6_VALUE=""
#ENV7_NAME=""
#ENV7_VALUE=""
#ENV8_NAME=""
#ENV8_VALUE=""

# Not supported yet
#CORES="1"
#MEM="2g"
