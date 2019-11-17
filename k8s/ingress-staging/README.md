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
kubectl apply -f ingress-controller.yaml

kubectl apply -f ingress-service.yaml
```

## Adding SSL certs to k8s 

To create a self signed cert
```
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout certs/key -out certs/cert.pem -subj "/CN=stg.play.ballerina.io/O=stg.play.ballerina.io"
```

```
kubectl create secret tls play-stg-tls-secret --key certs/key --cert certs/cert.pem --namespace=ballerina-playground-v2

```

Disable HSTS

```
kubectl create configmap nginx-configuration --from-file nginx.properties -o yaml --dry-run | kubectl replace -n ingress-nginx -f -
```




