#!/bin/bash

if [ -z ${BPG_GCP_PROJECT_ID} ]; then
    echo "Ballerina Playground GCP project ID is not set. Set variable BPG_GCP_PROJECT_ID to the GCP project ID found in the GCP Console."
    exit 1
fi

pushd redis > /dev/null 2>&1
    kubectl create -f redis-master-service.yaml -n $BPG_NAMESPACE
    kubectl create -f redis-slave-service.yaml -n $BPG_NAMESPACE
    kubectl create -f redis-master-deployment.yaml -n $BPG_NAMESPACE
    envsubst < redis-slave-deployment.yaml | kubectl create -n $BPG_NAMESPACE -f -
popd > /dev/null 2>&1