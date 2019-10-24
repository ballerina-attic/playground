#!/bin/bash

if [ -z ${BPG_GCP_PROJECT_ID} ]; then
    echo "Ballerina Playground GCP project ID is not set. Set variable BPG_GCP_PROJECT_ID to the GCP project ID found in the GCP Console."
    exit 1
fi

pushd ingress > /dev/null 2>&1
    kubectl delete -f ingress-resources.yaml -n ballerina-playground-v2 
popd > /dev/null 2>&1