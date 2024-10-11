k create ns hello-rancher
k apply -f . -n hello-rancher
k get pod -n hello-rancher
kubetail hello-rancher -n hello-rancher
k scale deployment hello-rancher --replicas 5 -n hello-rancher
k get pod -n hello-rancher