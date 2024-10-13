k create ns development
k apply f role.yaml
k apply -f rolebinding.yaml

k get roles -n development
k get rolebindings -n development
k describe role developer -n development
k describe rolebinding developer-role-binding -n development

kubectl auth can-i list pods -n development --as thomasin
kubectl auth can-i delete pods -n development --as thomasin
kubectl auth can-i list daemonsets -n development --as thomasin

[deploy sample pod]
# kubectl run busybox --image=busybox --command --restart=Never -n development

[crete a new user in k8s cluster]
1. Generate a private key using RSA algorithm (4096 bits):
# openssl genrsa -out thomasin.pem

2. Create a Certificate Signing Request (CSR)
# openssl req -new -key thomasin.pem -out thomasin.csr -subj "/CN=thomasin"

3. Obtain the base64-encoded representation of the CSR
# cat thomasin.csr | base64 | tr -d "\n"

4. Use the output to create a CertificateSigningRequest resource
# cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: thomasin
spec:
  request: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURSBSRVFVRVNULS0tLS0KTUlJQ1dEQ0NBVUFDQVFBd0V6RVJNQThHQTFVRUF3d0lkR2h2YldGemFXNHdnZ0VpTUEwR0NTcUdTSWIzRFFFQgpBUVVBQTRJQkR3QXdnZ0VLQW9JQkFRQ2lDY1h2eXEzaTdMUTJob0VOWVZ0emdKZFhvc0Fid0dXeDVpdlp5WlVpCm5vbGdKS21vZno0OEdrZkNjWmFwQWtQWEhkZTYvVjFTWXVJWnRlUlBpMERhSStueU1zWFBPang0dXcyTERZRVcKQWcvTjlXN3pqWmJ5YytFQjJMaFg1ZUZoZm1kQWRaSWwyRzIySzZkRUhtaGxyRXYvTVdwZjVIdUVXZ1JXWnFhTgo4YmcxYW5lOFJ6ZmhZY2FMS2szWVp2S0k1Y251WDFUYnFnemVzT1h5Q05wcE90R1ptSUloRU4wdHdxWFZlVXU3Ci9VTFV2cFlmWm5qMGhCMHVpRGxXZVRTanpjQkd0alVwaVkyWWlnVkMyUUNYdWFiTEFqR01sRFNPK2pCWHlXN3gKTm4xN05LUWg2YXp1R1hrT29vZkd3R2lzS0FObFNhNTY5a0t5eFc0c0VJZTNBZ01CQUFHZ0FEQU5CZ2txaGtpRwo5dzBCQVFzRkFBT0NBUUVBRDdNci9reU4vdWdva3VZTllTdjQ2YnlIWGg5Y0J6NWRMekxoc0VWek5zd01lTXNnClFVWFZJTnJHNE9EOGFDdlJpS1ZHUEhGYUhYY0htWEQzVitUY3BacjhabW82d0pOVE02aThOS1J3UkhDVUtEYksKeWZOZ0JzSzkzdko0a2J2N3pWTFRyQ3htdUs5NkZZenZ3Y3FIZk04b3VXR2xiNkRIa3ZBMkVTeEtKWkNtbXBragozOHVTcko4RUV5OEdlT1drTTVhOGFIaGlzRFcyYkt6TDNNUnpTa25SYVhSV2g2WUdXUWxyZEFvOE1qUmFVWkRGCk9Udkl6QVQxSlE5QWVETy9wNm52VFI1M2d1Q0Z0RE5qRVBwM1JLSG90NzJJeVpQTWEwRDBTZXI3YnJIZlJjc2YKVHFmV1gxMmI4R2JUSGtTcnJzSGlhUFl0MGNUMDVSc3d3NXFYR0E9PQotLS0tLUVORCBDRVJUSUZJQ0FURSBSRVFVRVNULS0tLS0K
  signerName: kubernetes.io/kube-apiserver-client
  expirationSeconds: 86400  # one day
  usages:
  - digital signature
  - key encipherment
  - client auth
EOF

5. CSR Status
# kubectl get csr
NAME       AGE   SIGNERNAME                            REQUESTOR      REQUESTEDDURATION   CONDITION
thomasin   30s   kubernetes.io/kube-apiserver-client   system:admin   24h                 Pending

6. Sign the Certificate Using the Cluster Certificate Authority
# kubectl get csr
NAME       AGE   SIGNERNAME                            REQUESTOR      REQUESTEDDURATION   CONDITION
thomasin   30s   kubernetes.io/kube-apiserver-client   system:admin   24h                 Pending
# kubectl certificate approve thomasin
certificatesigningrequest.certificates.k8s.io/thomasin approved
# kubectl get csr
NAME       AGE   SIGNERNAME                            REQUESTOR      REQUESTEDDURATION   CONDITION
thomasin   73s   kubernetes.io/kube-apiserver-client   system:admin   24h                 Approved,Issued

7. Create a Configuration Specific to the User
# kubectl get csr/thomasin -o jsonpath="{.status.certificate}" | base64 -d > thomasin.crt

8. Create new user config file
# kubectl --kubeconfig ~/.kube/config-thomasin config set-cluster default --insecure-skip-tls-verify=true --server=https://127.0.0.1:6443

9. Set user credentials
# kubectl --kubeconfig ~/.kube/config-thomasin config set-credentials thomasin --client-certificate=thomasin.crt --client-key=thomasin.pem --embed-certs=true

10. set context information
# kubectl --kubeconfig ~/.kube/config-thomasin config set-context default --cluster=default --user=thomasin

11. Use the context
# kubectl --kubeconfig ~/.kube/config-thomasin config use-context default

12. Test RBAC
# kubectl --kubeconfig ~/.kube/config-thomasin get pods -n default
Error from server (Forbidden): pods is forbidden: User "thomasin" cannot list resource "pods" in API group "" in the namespace "default"
# kubectl --kubeconfig ~/.kube/config-thomasin get pods -n development
NAME      READY   STATUS      RESTARTS   AGE
busybox   0/1     Completed   0          99s