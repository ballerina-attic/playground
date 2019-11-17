kubectl delete svc redis-master -n $BPG_NAMESPACE
kubectl delete svc redis-slave -n $BPG_NAMESPACE
kubectl delete deployment redis-master -n $BPG_NAMESPACE
kubectl delete deployment redis-slave -n $BPG_NAMESPACE