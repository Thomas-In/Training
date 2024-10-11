k apply -f nodeAffnity.yml
k get pod -A -o wide |grep anti-node