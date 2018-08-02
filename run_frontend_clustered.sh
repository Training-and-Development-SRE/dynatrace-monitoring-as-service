#!/bin/bash
# will run 2 frontends with build 1
# You can launch this script with an argument that defines which types of TAGS & METADATA to push to the Containers to be picked up by OneAgent. The script will pass it to frontend-app/run_docker
# Usage ./run_frontend2builds_clustered.sh 0,1 or 2

if [ -f ../setenv.sh ]; then
  source ../setenv.sh
fi

cd frontend-app
bash run_docker.sh 2 8081 1 $1

cd ../backend-service
bash run_docker.sh

cd ../frontend-loadbalancer
bash run_docker.sh 2
