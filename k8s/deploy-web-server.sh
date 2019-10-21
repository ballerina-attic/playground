#!/bin/bash

if [ -z ${BPG_GCP_PROJECT_ID} ]; then
    echo "Ballerina Playground GCP project ID is not set. Set variable BPG_GCP_PROJECT_ID to the GCP project ID found in the GCP Console."
    exit 1
fi

kubectl create ns ballerina-playground-v2

pushd web-server > /dev/null 2>&1 
    kubectl create -f web-server-service.yaml -n ballerina-playground-v2
    envsubst < web-server-deployment.yaml | kubectl create -n ballerina-playground-v2 -f -
popd > /dev/null 2>&1