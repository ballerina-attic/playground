## If the persistent disk is a newly created one, set permissions to 777 on cache folder.

## How to delete Persistent Volume and Persistent Volume Claims

Disable PV Protection 

```
kubectl patch pvc pvc_name -p '{"metadata":{"finalizers":null}}'
kubectl patch pv pv_name -p '{"metadata":{"finalizers":null}}'
kubectl patch pod pod_name -p '{"metadata":{"finalizers":null}}'

```

### If there are any pods which still cannot terminate, forcefully kill 

``` kubectl delete pod <PODNAME> --grace-period=0 --force --namespace <NAMESPACE> ```