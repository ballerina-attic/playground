kubectl delete svc nfs-server -n ballerina-playground-v2
kubectl delete deployment nfs-server -n ballerina-playground-v2
kubectl delete pvc pvc-build-cache-rw -n ballerina-playground-v2
kubectl delete pv pv-build-cache -n ballerina-playground-v2
