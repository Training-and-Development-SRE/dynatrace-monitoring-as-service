#!/bin/bash
# This script will start 1 or more instances of the frontend-app. It will launch it with a specific BUILD_NUMBER and starts mapping these instances to a certain port range
# You can pass these input values as arguments:
# $1: Number of Instances, Default: 1
# $2: Base Port, Default: 8081
# $3: Build Number, Default: 1
# $4: Tagging Type (0=no DT TAGS, 1=DT_TAGS&DT_CUSTOM_PROP, 2=DT_NODE_ID), Default=0
if [ -z "$1" ]; then
  export NO_INSTANCES=1
else
  export NO_INSTANCES=$1
fi
if [ -z "$2" ]; then
  export BASE_PORT=8081
else
  export BASE_PORT=$2
fi
if [ -z "$3" ]; then
  export BUILD_NUMBER=1
else
  export BUILD_NUMBER=$3
fi
if [ -z "$4" ]; then
  export TAG_TYPE=0
else
  export TAG_TYPE=$4
fi

echo "NO_INSTANCES: $NO_INSTANCES"
echo "BASE_PORT: $BASE_PORT"
echo "BUILD_NUMBER: $BUILD_NUMBER"
echo "TAG_TYPE: $TAG_TYPE"

BIND_PORT=$BASE_PORT
for (( i=1; i<=$NO_INSTANCES; i++ ))
do
  INSTANCE_NAME=frontend-app-instance-$BIND_PORT
  echo "$INSTANCE_NAME:$BIND_PORT - BUILD: $BUILD_NUMBER"

  # 0: This is the "plain" regular launch of a container - nothing specific to Dynatrace OneAgent
  if [ $TAG_TYPE = "0" ]; then
    sudo docker run --name $INSTANCE_NAME -p $BIND_PORT:80 -e PROCESS_NAME=FRONTEND_$Environment -e BUILD_NUMBER=$BUILD_NUMBER -d frontend-app:latest
  fi

  # 1: the following line is to ENABLE Dynatrace OneAgent Custom Tagging and Custom Meta Data Passing
  if [ $TAG_TYPE = "1" ]; then
    sudo docker run --name $INSTANCE_NAME -p $BIND_PORT:80 -e PROCESS_NAME=FRONTEND_$Environment -e BUILD_NUMBER=$BUILD_NUMBER -e DT_TAGS="SERVICE_TYPE=FRONTEND" -e DT_CUSTOM_PROP="SERVICE_TYPE=FRONTEND BUILD_NUMBER=$BUILD_NUMBER BIND_PORT=$BIND_PORT ENVIRONMENT=$Environment" -d frontend-app:latest
  fi

  # 2: the following line leverages DT_NODE_ID to differentiate each individual container instance as its own Process Group Instance
  if [ $TAG_TYPE = "2" ]; then
    sudo docker run --name $INSTANCE_NAME -p $BIND_PORT:80 -e PROCESS_NAME=FRONTEND_$Environment -e BUILD_NUMBER=$BUILD_NUMBER -e DT_NODE_ID=$BUILD_NUMBER -e DT_TAGS="SERVICE_TYPE=FRONTEND" -e DT_CUSTOM_PROP="SERVICE_TYPE=FRONTEND BUILD_NUMBER=$BUILD_NUMBER BIND_PORT=$BIND_PORT ENVIRONMENT=$Environment" -d frontend-app:latest
  fi

  BIND_PORT=$(($BIND_PORT+1))
done