#!/bin/bash
# Will Run 4 Frontends - 2 with Build 1 and 2 with Build 2
# You can launch this script with an argument that defines which types of TAGS & METADATA to push to the Containers to be picked up by OneAgent. The script will pass it to frontend-app/run_docker
# Usage ./run_frontend2builds_clustered.sh 0,1 or 2

if [ -f ../setenv.sh ]; then
  source ../setenv.sh
fi

cd frontend-app
bash run_docker.sh 2 8081 1 $1
bash run_docker.sh 2 8083 2 $1

cd ../backend-service
bash run_docker.sh

cd ../frontend-loadbalancer
bash run_docker.sh 4