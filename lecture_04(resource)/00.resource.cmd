k apply -f same_selector_rs.yml
k get pod -A |grep manual
k get replicaset 
k apply -f replicaset.yml
k get pod -A | egrep 'manual|ubuntu'
k get replicaset ubuntu


# 노드에 부여된 Label  확인 
kubectl get node --show-labels

# 노드에 부여된 Taint 확인
kubectl get nodes \
-o=custom-columns=NodeName:.metadata.name,TaintKey:.spec.taints[*].key,TaintValue:.spec.taints[*].value,TaintEffect:.spec.taints[*].effect

# 클러스터에 생성된 모든 Pod 확인 
kubectl get pod --all-namespaces -o wide

# Node별로 배포된 Pod 갯수 확인
kubectl describe node | grep -E "(^Name:|^Non-terminated)"

# Worker 노드(node3)에 Taint 부여 
kubectl taint nodes worker node3 status=unstable:PreferNoSchedule

# Replicas(6) deployment
cat <<EOF | kubectl create -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: taint-deployment
spec:
  replicas: 6
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name:  nginx
        image: nginx:1.20.1
        ports:
        - containerPort: 80
        resources:
          requests:
            cpu: 100m
EOF

# Deployment를 통해서 생성된 Pod가 어떤 노드에 배포 됐는지 확인 
kubectl get pod -l app=nginx -o wide

# Deployment 삭제 
kubectl delete deployment taint-deployment

# Worker 노드(node3)에 부여한 Taint 삭제 및 확인
kubectl taint nodes node3 status-
kubectl get nodes \
-o=custom-columns=NodeName:.metadata.name,TaintKey:.spec.taints[*].key,TaintValue:.spec.taints[*].value,TaintEffect:.spec.taints[*].effect