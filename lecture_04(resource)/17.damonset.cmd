cat <<EOF | kubectl create -f -
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: ds-one
  labels:
    system: DaemonSetOne
spec:
  selector:
    matchLabels:
      system: DaemonSetOne
  template:
    metadata:
      labels:
        system: DaemonSetOne
    spec:
      containers:
      - name: nginx
        image: nginx:1.15.1
        ports:
        - containerPort: 80
EOF

# DaemonSet 및  Pod 확인 
kubectl get ds,pod -l system=DaemonSetOne -o wide

# 생성된 Pod의 컨테이너 이미지 확인 
kubectl get pod -l system=DaemonSetOne \
-o=custom-columns=NAME:.metadata.name,IMAGE:.spec.containers[*].image

# DaemonSet의 updateStrategy 확인 
kubectl get ds ds-one -o jsonpath='{.spec.updateStrategy}' | jq

# RollingUpdate -> OnDelete로 변경, 확인
kubectl patch ds ds-one --patch '{"spec":{"updateStrategy":{"type":"OnDelete"}}}'
kubectl get ds ds-one -o jsonpath='{.spec.updateStrategy}' | jq

# DaemonSet 이미지를 변경 
kubectl set image ds ds-one nginx=nginx:1.16.1-alpine

# Pod의 컨테이너 이미지 변경됐는지 확인 
kubectl get pod -l system=DaemonSetOne \
-o=custom-columns=NAME:.metadata.name,IMAGE:.spec.containers[*].image

# Pod를 삭제 (DaemonSet으로 생성된 3개의 Pod 중에서 한개만 삭제) 
kubectl delete pod $(kubectl get pod -l system=DaemonSetOne -o=jsonpath='{.items[0].metadata.name}')

# Pod의 컨테이너 이미지 변경됐는지 확인
kubectl get pod -l system=DaemonSetOne \
-o=custom-columns=NAME:.metadata.name,IMAGE:.spec.containers[*].image,TIMESTAMP:.metadata.creationTimestamp

# 새로운 Pod가 생성됐는지 확인 
kubectl get pod -l system=DaemonSetOne

# Revision 1과 Revision 2를 비교 
diff <(kubectl rollout history ds ds-one --revision=1) \
<(kubectl rollout history ds ds-one --revision=2) -y

# Revision 1으로 롤백 
kubectl rollout undo ds ds-one --to-revision=1

# Pod의 컨테이너 이미지 변경됐는지 확인
kubectl get pod -l system=DaemonSetOne \
-o=custom-columns=NAME:.metadata.name,IMAGE:.spec.containers[*].image,TIMESTAMP:.metadata.creationTimestamp

# Pod를 삭제 (위에서 새로 생성된 Pod) 
kubectl delete pod \
$(kubectl get pod -l system=DaemonSetOne --sort-by='.metadata.creationTimestamp' -o=jsonpath='{.items[-1].metadata.name}')

(or) kubectl delete pod {POD_NAME}

# 새로운 Pod가 생성됐는지 확인 
kubectl get pod -l system=DaemonSetOne