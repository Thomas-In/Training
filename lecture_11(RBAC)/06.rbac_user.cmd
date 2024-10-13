k create ns development
k apply f role.yaml
k apply -f rolebinding.yaml

k get roles -n development
k get rolebindings -n development
k describe role developer -n development
k describe rolebinding developer-role-binding -n development

kubectl auth can-i list pods -n development --as ThomasIn
kubectl auth can-i delete pods -n development --as ThomasIn
kubectl auth can-i list daemonsets -n development --as ThomasIn

https://medium.com/@muppedaanvesh/a-hand-on-guide-to-kubernetes-rbac-with-a-user-creation-%EF%B8%8F-1ad9aa3cafb1