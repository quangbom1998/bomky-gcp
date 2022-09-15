# bomky-gcp

## Saffold
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
