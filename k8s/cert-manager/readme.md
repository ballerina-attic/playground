```
kubectl create namespace cert-manager
kubectl label namespace cert-manager certmanager.k8s.io/disable-validation=true
kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v0.10.0/cert-manager.yaml
kubectl apply -f issuer.yaml
```

```
kubectl delete -f https://github.com/jetstack/cert-manager/releases/download/v0.10.0/cert-manager.yaml

kubectl delete crd \
    certificates.certmanager.k8s.io \
    issuers.certmanager.k8s.io \
    clusterissuers.certmanager.k8s.io

```
