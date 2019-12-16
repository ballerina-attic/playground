# Ingress-nginx 

## Ingress-nginx controller Deployment
* In order to deploy Ingress-nginx controller you need to have cluster admin privileges,

```
kubectl create clusterrolebinding cluster-admin-binding \
  --clusterrole cluster-admin \
  --user $(gcloud config get-value account)
```

* Execute the following commands to deploy Ingres-nginx controller,
```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.22.0/deploy/mandatory.yaml

kubectl apply -f ingress-service.yaml
```

## Adding SSL certs to k8s 

```
kubectl create secret tls play-stg-tls-secret --key <key-file-name> --cert <cert-file-name> --namespace=ballerina-playground-v2

```