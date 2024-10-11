kubectl label node node1 devtools=on gpupool=on
kubectl label node node2 longhorn=on gpupool=on
kubectl label node node3 longhorn=on
k get nodes --show-labels
k get pod -A -o wide |grep nodeselector

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nodeselector-devtools
  labels:
    app: nodeselector-devtools
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nodeselector-devtools
  template:
    metadata:
      labels:
        app: nodeselector-devtools
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 8080
      nodeSelector:
        devtools: "on"
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nodeselector-longhorn
  labels:
    app: nodeselector-longhorn
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nodeselector-longhorn
  template:
    metadata:
      labels:
        app: nodeselector-longhorn
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 8080
      nodeSelector:
        longhorn: "on"