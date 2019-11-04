#!/bin/bash

if [ -z ${BPG_GCP_PROJECT_ID} ]; then
    echo "Ballerina Playground GCP project ID is not set. Set variable BPG_GCP_PROJECT_ID to the GCP project ID found in the GCP Console."
    exit 1
fi

pushd nfs > /dev/null 2>&1 
    export BPG_NAMESPACE=ballerina-playground-v2
    kubectl create -f nfs-deployment.yaml -n $BPG_NAMESPACE
    kubectl create -f nfs-service.yaml -n $BPG_NAMESPACE
    envsubst < pv-and-pvc.yaml | kubectl create -n $BPG_NAMESPACE -f -
popd > /dev/null 2>&1