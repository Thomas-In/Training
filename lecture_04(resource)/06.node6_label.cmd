kubectl label node cluster3-node01 devtools=on gpupool=on
kubectl label node cluster3-node02 devtools=on gpupool=on
kubectl label node cluster3-node03 devtools=on
kubectl label node cluster3-node04 longhorn=on capacity=high
kubectl label node cluster3-node05 longhorn=on capacity=high
kubectl label node cluster3-node06 longhorn=on capacity=low
k get nodes --show-labels


node01(3)/node02(3) 만 배포 
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: anti-nodeaffinity
  name: anti-nodeaffinity
spec:
  replicas: 3
  selector:
    matchLabels:
      app: anti-nodeaffinity
  template:
    metadata:
      labels:
        app: anti-nodeaffinity
    spec:
      containers:
      - image: nginx
        name: nginx
      tolerations:
      - key: "node-role.kubernetes.io/control-plane"
        operator: "Exists"
        effect: "NoSchedule"
      - key: "node-role.kubernetes.io/etcd"
        operator: "Exists"
        effect: "NoExecute"        
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: gpupool
                operator: In
                values:
                - "on"
          preferredDuringSchedulingIgnoredDuringExecution:
          - weight: 1
            preference:
              matchExpressions:
              - key: devtools
                operator: In
                values:
                - "on"