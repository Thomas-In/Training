helm repo add metallb https://metallb.github.io/metallb
helm install metallb metallb/metallb -n metallb --create-namespace
k get pod -n metallb

cat <<EOF > metallb-config.yaml
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: ip-pool
  namespace: metallb
spec:
  addresses:
  - 192.168.31.54-192.168.31.60
  autoAssign: false
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: l2-network
  namespace: metallb
spec:
  ipAddressPools:
    - ip-pool
EOF

k apply -f metallb-config.yaml
k apply -f nginx_lb.yaml