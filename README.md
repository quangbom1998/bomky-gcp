# bomky-gcp

## Domain
[`dev.bomky.shop`](https://dev.bomky.shop)

## Skaffold
1. Build and deploy
```
    skaffold --kubeconfig=../kubeconfig-{env} run
```

2. Deploy
```
    skaffold --kubeconfig=../kubeconfig-{env} deploy --images `IMAGE:TAG`
```

## K8s
1. Get all
```
    kubectl --kubeconfig=kubeconfig-{env} get all 
```

2. Describe managed cert
```
    kubectl --kubeconfig=kubeconfig-dev describe managedcertificate managed-cert
```

## GKE Architecture
![GKE Architecture](/images/GKE.png "GKE")
